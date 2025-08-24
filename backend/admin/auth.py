"""
Модуль аутентификации для админ панели.
Обеспечивает безопасный доступ к админке через учетные данные из .env файла.
"""

from sqladmin.authentication import AuthenticationBackend
from starlette.requests import Request
from starlette.responses import RedirectResponse
import os
from dotenv import load_dotenv
from logger import logger


def get_admin_credentials():
    """
    Получает учетные данные админа из .env файла.
    
    Returns:
        tuple: (username, password) - логин и пароль для входа в админку
        
    Raises:
        ValueError: Если учетные данные не найдены в .env файле
    """
    # Получаем абсолютный путь к .env файлу
    env_path = os.path.join(os.path.dirname(__file__), '..', '.env')
    
    # Загружаем .env файл
    load_dotenv(env_path)
    
    # Получаем значения
    username = os.getenv('ADMIN_USERNAME')
    password = os.getenv('ADMIN_PASSWORD')
    
    # Проверяем, что учетные данные заданы
    if not username or not password:
        raise ValueError(
            "Учетные данные админа не найдены в .env файле. "
            "Добавьте ADMIN_USERNAME и ADMIN_PASSWORD в .env файл."
        )
    
    logger.info(f"Загружены учетные данные админа: пользователь {username}")
    return username, password


class AdminAuth(AuthenticationBackend):
    """
    Аутентификация для админки SQLAdmin.
    Проверяет учетные данные пользователя и управляет сессиями.
    """
    
    def __init__(self, secret_key: str = "deptspace-secret-key"):
        """
        Инициализация аутентификации.
        
        Args:
            secret_key: Секретный ключ для сессий
        """
        super().__init__(secret_key)
    
    async def login(self, request: Request) -> bool:
        """
        Проверка логина и пароля при входе в админку.
        
        Args:
            request: HTTP запрос с данными формы
            
        Returns:
            bool: True если аутентификация успешна, False в противном случае
        """
        try:
            # Получаем данные формы
            form = await request.form()
            username = form.get("username", "")
            password = form.get("password", "")
            
            # Получаем ожидаемые значения из .env
            expected_username, expected_password = get_admin_credentials()
            
            # Проверяем учетные данные
            if username == expected_username and password == expected_password:
                # Сохраняем информацию о входе в сессии
                request.session.update({"admin": True, "admin_username": username})
                logger.info(f"Успешный вход в админку: {username}")
                return True
            else:
                logger.warning(f"Неудачная попытка входа в админку: {username}")
                return False
                
        except Exception as e:
            logger.error(f"Ошибка при аутентификации: {e}")
            return False

    async def logout(self, request: Request) -> bool:
        """
        Выход из системы админки.
        
        Args:
            request: HTTP запрос
            
        Returns:
            bool: True если выход выполнен успешно
        """
        try:
            # Очищаем сессию
            username = request.session.get("admin_username", "unknown")
            request.session.clear()
            logger.info(f"Выход из админки: {username}")
            return True
        except Exception as e:
            logger.error(f"Ошибка при выходе из админки: {e}")
            return False

    async def authenticate(self, request: Request) -> bool:
        """
        Проверка аутентификации для защищенных страниц админки.
        
        Args:
            request: HTTP запрос
            
        Returns:
            bool: True если пользователь аутентифицирован
        """
        try:
            # Проверяем наличие флага админа в сессии
            is_admin = request.session.get("admin", False)
            if is_admin:
                logger.debug("Пользователь аутентифицирован в админке")
            return is_admin
        except Exception as e:
            logger.error(f"Ошибка при проверке аутентификации: {e}")
            return False
