#!/usr/bin/env python3
"""
Скрипт для запуска бэкенда DeptSpace
"""

import os
import sys
import subprocess
import uvicorn
from pathlib import Path
from dotenv import load_dotenv
from logger import logger  # Используем логгер из logger.py

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

def start_server():
    """Запуск FastAPI сервера"""
    logger.info("Запуск FastAPI сервера...")
    
    # Параметры запуска
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
    """Основная функция"""
    logger.info("=== Запуск DeptSpace Backend ===")
    
    try:
        # Проверки
        check_python_version()
        check_environment()
        check_dependencies()
        check_frontend_build()
        
        # Запуск сервера
        start_server()
        
    except Exception as e:
        logger.error(f"Критическая ошибка: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
