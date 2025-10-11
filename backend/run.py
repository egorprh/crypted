#!/usr/bin/env python3
"""
Скрипт для запуска бэкенда DeptSpace с поддержкой unified режима.

Поддерживает два режима запуска:
1. Обычный режим (UNIFIED_MODE=false) - запуск только FastAPI сервера
2. Unified режим (UNIFIED_MODE=true) - запуск FastAPI + Telegram bot в одном процессе

Unified режим позволяет:
- Запускать backend и telegram bot в одном Docker контейнере
- Использовать общий доступ к PGAPI
- Упростить деплой и управление
- Получать единые логи для отладки

Архитектура unified режима:
- UnifiedRunner класс управляет жизненным циклом двух сервисов
- FastAPI и Telegram bot запускаются параллельно через asyncio
- Graceful shutdown при падении любого из сервисов
"""

import os
import sys
import subprocess
import asyncio
import signal
import uvicorn
from pathlib import Path
from dotenv import load_dotenv
from logger import logger  # Используем логгер из logger.py

# === ИМПОРТЫ ДЛЯ UNIFIED РЕЖИМА ===
# Пытаемся импортировать модули для unified режима
# Если импорт не удается - unified режим недоступен
try:
    from telegram_bot.bot import main as bot_main  # Функция запуска Telegram бота
    from main import app as fastapi_app            # FastAPI приложение
    UNIFIED_IMPORTS_AVAILABLE = True
    logger.info("Unified режим: все модули успешно импортированы")
except ImportError as e:
    UNIFIED_IMPORTS_AVAILABLE = False
    logger.warning(f"Unified режим недоступен: {e}")

def check_python_version():
    """Проверка версии Python"""
    if sys.version_info < (3, 8):
        logger.error("Требуется Python 3.8 или выше")
        sys.exit(1)
    logger.info(f"Python версия: {sys.version}")

def load_environment():
    """Загрузка переменных окружения из .env файла"""
    env_path = Path(__file__).parent / ".env"
    if env_path.exists():
        load_dotenv(env_path)
        logger.info(f"Загружены переменные окружения из {env_path}")
    else:
        logger.warning(f"Файл .env не найден по пути {env_path}")

def check_environment():
    """Проверка переменных окружения"""
    # Сначала загружаем переменные из .env файла
    load_environment()
    
    # Обязательные переменные для работы приложения
    required_vars = [
        'DB_HOST', 'DB_PORT', 'DB_NAME', 'DB_USER', 'DB_PASS'
    ]
    
    # Опциональные переменные для Telegram уведомлений
    optional_vars = [
        'BOT_TOKEN', 'ADMINS', 'PRIVATE_CHANNEL_ID'
    ]
    
    missing_required_vars = []
    for var in required_vars:
        if not os.getenv(var):
            missing_required_vars.append(var)
    
    if missing_required_vars:
        logger.error(f"Отсутствуют обязательные переменные окружения: {', '.join(missing_required_vars)}")
        logger.info("Проверьте файл backend/.env")
        sys.exit(1)
    
    # Проверяем опциональные переменные
    missing_optional_vars = []
    for var in optional_vars:
        if not os.getenv(var):
            missing_optional_vars.append(var)
    
    if missing_optional_vars:
        logger.warning(f"Отсутствуют опциональные переменные для Telegram уведомлений: {', '.join(missing_optional_vars)}")
        logger.info("Приложение будет работать без Telegram уведомлений")
    else:
        logger.info("Telegram уведомления настроены")
    
    logger.info("Переменные окружения настроены корректно")

def check_dependencies():
    """Проверка установленных зависимостей"""
    required_packages = [
        'fastapi', 'uvicorn'
    ]
    
    missing_packages = []
    for package in required_packages:
        try:
            __import__(package.replace('-', '_'))
        except ImportError:
            missing_packages.append(package)
    
    if missing_packages:
        logger.error(f"Отсутствуют зависимости: {', '.join(missing_packages)}")
        logger.info("Установите зависимости: pip install -r requirements.txt")
        sys.exit(1)
    
    logger.info("Все зависимости установлены")

def check_frontend_build():
    """Проверка наличия собранного фронтенда"""
    frontend_dist = Path("frontend/dist")
    if not frontend_dist.exists():
        logger.warning("Папка frontend/dist не найдена")
        logger.info("Соберите фронтенд: cd frontend && npm run build")
        return False
    
    index_html = frontend_dist / "index.html"
    if not index_html.exists():
        logger.warning("Файл frontend/dist/index.html не найден")
        logger.info("Соберите фронтенд: cd frontend && npm run build")
        return False
    
    logger.info("Фронтенд собран корректно")
    return True


class UnifiedRunner:
    """
    Класс для управления жизненным циклом двух сервисов в unified режиме.
    
    Преимущества использования класса:
    - Управление жизненным циклом (запуск/остановка)
    - Graceful shutdown (если один сервис падает, корректно останавливается второй)
    - Изоляция состояния (каждый запуск создает новый экземпляр)
    - Чистый код (логика управления сервисами отделена)
    """
    
    def __init__(self, fastapi_app, bot_main):
        """
        Инициализация UnifiedRunner.
        
        Args:
            fastapi_app: FastAPI приложение (экземпляр FastAPI)
            bot_main: Функция main() из telegram_bot.bot (async функция)
        """
        self.fastapi_app = fastapi_app  # FastAPI приложение
        self.bot_main = bot_main  # Функция запуска бота
        self.fastapi_server = None  # Экземпляр uvicorn сервера (создается при запуске)
        self.shutdown_event = asyncio.Event()  # Событие для корректного завершения
        
    async def start_fastapi(self):
        """
        Запуск FastAPI сервера в async режиме.
        
        Использует uvicorn.Server вместо uvicorn.run() для возможности
        параллельного запуска с telegram bot.
        
        Returns:
            None (функция блокируется до завершения сервера)
            
        Raises:
            Exception: При ошибках конфигурации или запуска сервера
        """
        try:
            logger.info("Запуск FastAPI сервера...")
            
            # Получаем параметры из переменных окружения
            host = os.getenv('HOST', '0.0.0.0')
            port = int(os.getenv('PORT', '8000'))
            
            logger.info(f"FastAPI конфигурация: host={host}, port={port}")
            
            # Создаем конфигурацию uvicorn
            config = uvicorn.Config(
                self.fastapi_app,
                host=host,
                port=port,
                log_level="info"
            )
            
            # Создаем и запускаем сервер
            self.fastapi_server = uvicorn.Server(config)
            logger.info("FastAPI сервер создан, начинаем serve()...")
            
            # БЛОКИРУЮЩИЙ ВЫЗОВ: сервер работает до завершения
            await self.fastapi_server.serve()
            
        except Exception as e:
            logger.error(f"Критическая ошибка FastAPI сервера: {e}")
            logger.error(f"Тип ошибки: {type(e).__name__}")
            raise
        
    async def start_bot(self):
        """
        Запуск Telegram бота.
        
        Вызывает main() функцию из telegram_bot/bot.py,
        которая инициализирует бота и начинает polling.
        
        Returns:
            None (функция блокируется до завершения бота)
            
        Raises:
            Exception: При ошибках инициализации или работы бота
        """
        try:
            logger.info("Запуск Telegram бота...")
            
            # БЛОКИРУЮЩИЙ ВЫЗОВ: бот работает до завершения
            await self.bot_main()
            
        except Exception as e:
            logger.error(f"Критическая ошибка Telegram бота: {e}")
            logger.error(f"Тип ошибки: {type(e).__name__}")
            raise
        
    async def run(self):
        """
        Главный метод запуска unified режима.
        
        Создает задачи для параллельного запуска FastAPI и Telegram bot,
        затем запускает мониторинг для автоматического перезапуска упавших сервисов.
        
        Ключевые особенности:
        - Создание asyncio задач для параллельного выполнения
        - Независимая работа сервисов
        - Автоматический перезапуск упавших сервисов
        - Graceful shutdown при завершении
        """
        try:
            logger.info("Инициализация unified режима...")
            
            # СОЗДАНИЕ ЗАДАЧ: создаем asyncio задачи, но не запускаем их
            # asyncio.create_task() планирует выполнение, но не блокирует код
            fastapi_task = asyncio.create_task(self.start_fastapi())
            bot_task = asyncio.create_task(self.start_bot())
            
            logger.info("Задачи созданы, запускаем мониторинг...")
            
            # ЗАПУСК МОНИТОРИНГА: блокирующий вызов до завершения мониторинга
            await self.monitor_tasks(fastapi_task, bot_task)
                    
        except Exception as e:
            logger.error(f"Критическая ошибка в unified runner: {e}")
            logger.error(f"Тип ошибки: {type(e).__name__}")
            logger.error(f"Traceback: {e.__traceback__}")
        finally:
            # Всегда вызываем shutdown для корректного завершения
            logger.info("Выполняем graceful shutdown...")
            await self.shutdown()
    
    async def monitor_tasks(self, fastapi_task, bot_task):
        """
        Мониторинг задач: если одна падает, перезапускаем её.
        
        Ключевая логика:
        1. Проверяем статус каждой задачи через task.done()
        2. Если задача завершилась - получаем исключение через await task
        3. При ошибке - перезапускаем задачу (до max_restarts раз)
        4. При нормальном завершении - помечаем как остановленную
        5. Мониторинг продолжается до остановки всех сервисов
        
        Args:
            fastapi_task: asyncio.Task для FastAPI сервера
            bot_task: asyncio.Task для Telegram бота
        """
        logger.info("Запуск мониторинга сервисов...")
        
        # Счетчики перезапусков для предотвращения бесконечных циклов
        fastapi_restarts = 0
        bot_restarts = 0
        max_restarts = 5  # Максимум 5 перезапусков подряд
        
        # Флаги для отслеживания остановленных сервисов
        fastapi_stopped = False
        bot_stopped = False
        
        logger.info(f"Настройки мониторинга: max_restarts={max_restarts}")
        
        while True:
            # === МОНИТОРИНГ FASTAPI ЗАДАЧИ ===
            if not fastapi_stopped and fastapi_task.done():
                try:
                    # Получаем результат/исключение завершившейся задачи
                    await fastapi_task
                except Exception as e:
                    fastapi_restarts += 1
                    logger.error(f"FastAPI сервис упал (перезапуск #{fastapi_restarts}): {e}")
                    logger.error(f"Тип ошибки FastAPI: {type(e).__name__}")
                    
                    if fastapi_restarts <= max_restarts:
                        logger.info("Перезапускаем FastAPI сервис...")
                        # СОЗДАЕМ НОВУЮ ЗАДАЧУ: старый объект задачи больше не используется
                        fastapi_task = asyncio.create_task(self.start_fastapi())
                    else:
                        logger.error(f"FastAPI сервис упал {max_restarts} раз подряд. Останавливаем перезапуски.")
                        fastapi_stopped = True
                else:
                    logger.info("FastAPI сервис завершился нормально")
                    fastapi_stopped = True
            
            # === МОНИТОРИНГ BOT ЗАДАЧИ ===
            if not bot_stopped and bot_task.done():
                try:
                    # Получаем результат/исключение завершившейся задачи
                    await bot_task
                except Exception as e:
                    bot_restarts += 1
                    logger.error(f"Telegram bot упал (перезапуск #{bot_restarts}): {e}")
                    logger.error(f"Тип ошибки Bot: {type(e).__name__}")
                    
                    if bot_restarts <= max_restarts:
                        logger.info("Перезапускаем Telegram bot...")
                        # СОЗДАЕМ НОВУЮ ЗАДАЧУ: старый объект задачи больше не используется
                        bot_task = asyncio.create_task(self.start_bot())
                    else:
                        logger.error(f"Telegram bot упал {max_restarts} раз подряд. Останавливаем перезапуски.")
                        bot_stopped = True
                else:
                    logger.info("Telegram bot завершился нормально")
                    bot_stopped = True
            
            # === ПРОВЕРКА УСЛОВИЯ ВЫХОДА ===
            if fastapi_stopped and bot_stopped:
                logger.info("Оба сервиса остановлены. Завершаем мониторинг.")
                break
            
            # === ПАУЗА МЕЖДУ ПРОВЕРКАМИ ===
            # Ждем 5 секунд перед следующей проверкой
            # Это предотвращает излишнюю нагрузку на CPU
            await asyncio.sleep(5)
            
    async def shutdown(self):
        """
        Корректное завершение работы unified runner.
        
        Выполняет graceful shutdown всех компонентов:
        1. Останавливает FastAPI сервер
        2. Освобождает ресурсы
        3. Логирует процесс завершения
        
        Этот метод вызывается в блоке finally для гарантированного
        выполнения даже при ошибках.
        """
        try:
            logger.info("Начинаем graceful shutdown unified runner...")
            
            # Останавливаем FastAPI сервер, если он был запущен
            if self.fastapi_server:
                logger.info("Останавливаем FastAPI сервер...")
                self.fastapi_server.should_exit = True
                logger.info("FastAPI сервер остановлен")
            else:
                logger.info("FastAPI сервер не был запущен")
                
            logger.info("Graceful shutdown завершен успешно")
            
        except Exception as e:
            logger.error(f"Ошибка при graceful shutdown: {e}")
            logger.error(f"Тип ошибки: {type(e).__name__}")


async def start_unified():
    """
    Запуск unified режима (backend + telegram bot в одном процессе).
    
    Проверяет доступность необходимых модулей и создает UnifiedRunner
    для управления обоими сервисами.
    
    Raises:
        RuntimeError: Если unified режим недоступен (отсутствуют модули)
    """
    if not UNIFIED_IMPORTS_AVAILABLE:
        logger.error("Unified режим недоступен: отсутствуют необходимые модули")
        raise RuntimeError("Unified режим недоступен: отсутствуют необходимые модули")
    
    logger.info("Создаем UnifiedRunner...")
    runner = UnifiedRunner(fastapi_app, bot_main)
    
    logger.info("Запускаем unified режим...")
    await runner.run()

def start_server():
    """
    Запуск только FastAPI сервера (обычный режим).
    
    Использует uvicorn.run() который сам управляет event loop.
    Это стандартный способ запуска FastAPI приложений.
    """
    logger.info("Запуск FastAPI сервера...")
    
    # Получаем параметры из переменных окружения
    host = os.getenv('HOST', '0.0.0.0')
    port = int(os.getenv('PORT', '8000'))
    reload = os.getenv('RELOAD', 'false').lower() == 'true'  # В Docker отключаем reload
    
    logger.info(f"Сервер будет доступен по адресу: http://{host}:{port}")
    logger.info(f"Режим перезагрузки: {'включен' if reload else 'выключен'}")
    
    try:
        # Добавляем backend в sys.path для импорта модулей
        backend_path = Path(__file__).parent
        if str(backend_path) not in sys.path:
            sys.path.insert(0, str(backend_path))
        
        # Запускаем uvicorn сервер
        uvicorn.run(
            "main:app",
            host=host,
            port=port,
            reload=reload,
            log_level="info"
        )
    except KeyboardInterrupt:
        logger.info("Сервер остановлен пользователем")
    except Exception as e:
        logger.error(f"Критическая ошибка при запуске FastAPI сервера: {e}")
        logger.error(f"Тип ошибки: {type(e).__name__}")
        sys.exit(1)

def main():
    """
    Основная функция запуска приложения.
    
    Выполняет все необходимые проверки и запускает приложение
    в зависимости от режима (unified или обычный).
    """
    logger.info("=== Запуск DeptSpace Backend ===")
    
    try:
        # Выполняем все необходимые проверки
        check_python_version()
        check_environment()
        check_dependencies()
        check_frontend_build()
        
        # Проверяем режим запуска из переменной окружения
        # UNIFIED_MODE=true - запуск backend + telegram bot
        # UNIFIED_MODE=false - запуск только backend (по умолчанию)
        unified_mode = os.getenv('UNIFIED_MODE', 'false').lower() == 'true'
        
        # === ВЫБОР РЕЖИМА ЗАПУСКА ===
        if unified_mode and UNIFIED_IMPORTS_AVAILABLE:
            logger.info("Выбран unified режим (Backend + Telegram Bot)")
            # Запуск в unified режиме через asyncio.run()
            asyncio.run(start_unified())
        else:
            if unified_mode:
                logger.warning("Unified режим запрошен, но недоступен. Переключаемся на обычный режим.")
                logger.warning("Убедитесь, что telegram_bot директория доступна и все зависимости установлены.")
            else:
                logger.info("Выбран обычный режим (только Backend)")
            
            # Запуск в обычном режиме (только FastAPI)
            start_server()
        
    except Exception as e:
        logger.error(f"Критическая ошибка при запуске приложения: {e}")
        logger.error(f"Тип ошибки: {type(e).__name__}")
        logger.error(f"Traceback: {e.__traceback__}")
        sys.exit(1)

if __name__ == "__main__":
    main()
