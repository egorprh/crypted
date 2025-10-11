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

# Импорты для unified режима
try:
    from telegram_bot.bot import main as bot_main
    from main import app as fastapi_app
    UNIFIED_IMPORTS_AVAILABLE = True
except ImportError:
    UNIFIED_IMPORTS_AVAILABLE = False

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
        self.fastapi_app = fastapi_app  # FastAPI приложение
        self.bot_main = bot_main  # Функция запуска бота
        self.fastapi_server = None  # Экземпляр uvicorn сервера
        self.shutdown_event = asyncio.Event()  # Событие для корректного завершения
        
    async def start_fastapi(self):
        """
        Запуск FastAPI сервера в async режиме.
        
        Использует uvicorn.Server вместо uvicorn.run() для возможности
        параллельного запуска с telegram bot.
        """
        logger.info("Запуск FastAPI сервера...")
        
        # Получаем параметры из переменных окружения
        host = os.getenv('HOST', '0.0.0.0')
        port = int(os.getenv('PORT', '8000'))
        
        # Создаем конфигурацию uvicorn
        config = uvicorn.Config(
            self.fastapi_app,
            host=host,
            port=port,
            log_level="info"
        )
        
        # Создаем и запускаем сервер
        self.fastapi_server = uvicorn.Server(config)
        await self.fastapi_server.serve()
        
    async def start_bot(self):
        """
        Запуск Telegram бота.
        
        Вызывает main() функцию из telegram_bot/bot.py,
        которая инициализирует бота и начинает polling.
        """
        logger.info("Запуск Telegram бота...")
        await self.bot_main()
        
    async def run(self):
        """
        Запуск обоих сервисов параллельно.
        
        Использует asyncio.wait() для ожидания завершения любого из сервисов.
        Если один сервис падает, корректно останавливает второй.
        """
        try:
            # Создаем задачи для параллельного запуска FastAPI и Telegram bot
            fastapi_task = asyncio.create_task(self.start_fastapi())
            bot_task = asyncio.create_task(self.start_bot())
            
            # Ждем завершения любого из сервисов (первый завершившийся)
            # Это позволяет корректно обработать ситуацию, когда один сервис падает
            done, pending = await asyncio.wait(
                [fastapi_task, bot_task],
                return_when=asyncio.FIRST_COMPLETED
            )
            
            # Отменяем оставшиеся задачи (graceful shutdown)
            for task in pending:
                task.cancel()
                try:
                    await task
                except asyncio.CancelledError:
                    # Ожидаемое исключение при отмене задачи
                    pass
                    
        except Exception as e:
            logger.error(f"Ошибка в unified runner: {e}")
        finally:
            # Всегда вызываем shutdown для корректного завершения
            await self.shutdown()
            
    async def shutdown(self):
        """
        Корректное завершение работы unified runner.
        
        Останавливает FastAPI сервер и освобождает ресурсы.
        """
        logger.info("Завершение работы unified runner...")
        
        # Останавливаем FastAPI сервер, если он был запущен
        if self.fastapi_server:
            self.fastapi_server.should_exit = True


async def start_unified():
    """Запуск unified режима (backend + telegram bot в одном процессе)"""
    if not UNIFIED_IMPORTS_AVAILABLE:
        raise RuntimeError("Unified режим недоступен: отсутствуют необходимые модули")
    
    runner = UnifiedRunner(fastapi_app, bot_main)
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
        logger.error(f"Ошибка запуска сервера: {e}")
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
        
        if unified_mode and UNIFIED_IMPORTS_AVAILABLE:
            asyncio.run(start_unified())
        else:
            if unified_mode:
                logger.warning("Unified режим запрошен, но недоступен. Переключаемся на обычный режим.")
            start_server()
        
    except Exception as e:
        logger.error(f"Критическая ошибка: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
