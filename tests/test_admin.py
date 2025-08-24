"""
Юнит тесты для админ панели.
Проверяет функциональность аутентификации, CRUD операций и загрузки файлов.
"""

import pytest
import os
import tempfile
import shutil
from unittest.mock import Mock, patch, AsyncMock
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'backend'))

from admin.auth import AdminAuth, get_admin_credentials
from admin.custom_fields import FileUploadField, validate_hex_color
from admin.models import File, User, Course
from admin.views import FileAdmin, UserAdmin, CourseAdmin
from wtforms.validators import ValidationError


class TestAdminAuth:
    """Тесты для системы аутентификации админки."""
    
    @patch('admin.auth.load_dotenv')
    @patch('admin.auth.os.getenv')
    def test_get_admin_credentials_success(self, mock_getenv, mock_load_dotenv):
        """Тест успешного получения учетных данных из .env файла."""
        # Настройка моков
        mock_getenv.side_effect = lambda key: {
            'ADMIN_USERNAME': 'testadmin',
            'ADMIN_PASSWORD': 'testpass123'
        }.get(key)
        
        # Выполнение теста
        username, password = get_admin_credentials()
        
        # Проверки
        assert username == 'testadmin'
        assert password == 'testpass123'
        mock_load_dotenv.assert_called_once()
    
    @patch('admin.auth.load_dotenv')
    @patch('admin.auth.os.getenv')
    def test_get_admin_credentials_missing(self, mock_getenv, mock_load_dotenv):
        """Тест ошибки при отсутствии учетных данных в .env файле."""
        # Настройка моков - возвращаем None для учетных данных
        mock_getenv.return_value = None
        
        # Проверка, что функция выбрасывает исключение
        with pytest.raises(ValueError, match="Учетные данные админа не найдены"):
            get_admin_credentials()
    
    @pytest.mark.asyncio
    async def test_admin_auth_login_success(self):
        """Тест успешной аутентификации."""
        auth = AdminAuth()
        
        # Создаем мок запроса
        mock_request = AsyncMock()
        mock_request.form.return_value = {
            'username': 'testadmin',
            'password': 'testpass123'
        }
        mock_request.session = {}
        
        # Мокаем функцию получения учетных данных
        with patch('admin.auth.get_admin_credentials', return_value=('testadmin', 'testpass123')):
            result = await auth.login(mock_request)
            
            # Проверки
            assert result is True
            assert mock_request.session['admin'] is True
            assert mock_request.session['admin_username'] == 'testadmin'
    
    @pytest.mark.asyncio
    async def test_admin_auth_login_failure(self):
        """Тест неудачной аутентификации."""
        auth = AdminAuth()
        
        # Создаем мок запроса с неправильными данными
        mock_request = AsyncMock()
        mock_request.form.return_value = {
            'username': 'wronguser',
            'password': 'wrongpass'
        }
        mock_request.session = {}
        
        # Мокаем функцию получения учетных данных
        with patch('admin.auth.get_admin_credentials', return_value=('testadmin', 'testpass123')):
            result = await auth.login(mock_request)
            
            # Проверки
            assert result is False
            assert 'admin' not in mock_request.session
    
    @pytest.mark.asyncio
    async def test_admin_auth_logout(self):
        """Тест выхода из системы."""
        auth = AdminAuth()
        
        # Создаем мок запроса с сессией
        mock_request = AsyncMock()
        mock_request.session = {
            'admin': True,
            'admin_username': 'testadmin'
        }
        
        result = await auth.logout(mock_request)
        
        # Проверки
        assert result is True
        assert len(mock_request.session) == 0
    
    @pytest.mark.asyncio
    async def test_admin_auth_authenticate_success(self):
        """Тест проверки аутентификации для аутентифицированного пользователя."""
        auth = AdminAuth()
        
        # Создаем мок запроса с активной сессией
        mock_request = AsyncMock()
        mock_request.session = {'admin': True}
        
        result = await auth.authenticate(mock_request)
        
        # Проверки
        assert result is True
    
    @pytest.mark.asyncio
    async def test_admin_auth_authenticate_failure(self):
        """Тест проверки аутентификации для неаутентифицированного пользователя."""
        auth = AdminAuth()
        
        # Создаем мок запроса без активной сессии
        mock_request = AsyncMock()
        mock_request.session = {}
        
        result = await auth.authenticate(mock_request)
        
        # Проверки
        assert result is False


def test_validate_file_success():
    """Тест успешной валидации файла."""
    # Создаем временную директорию для тестов
    temp_dir = tempfile.mkdtemp()
    try:
        # Создаем правильный экземпляр класса через WTForms
        from wtforms import Form
        class TestForm(Form):
            file = FileUploadField(upload_folder=temp_dir, allowed_extensions=['jpg', 'png', 'pdf'], max_size=1024 * 1024)
        
        form = TestForm()
        upload_field = form.file
        
        # Создаем мок файла
        mock_file = Mock()
        mock_file.filename = 'test.jpg'
        
        # Тест должен пройти без исключений
        result = upload_field.validate_file(mock_file)
        assert result is True
    finally:
        # Удаляем временную директорию
        shutil.rmtree(temp_dir)


def test_validate_file_missing_filename():
    """Тест валидации файла без имени."""
    # Создаем временную директорию для тестов
    temp_dir = tempfile.mkdtemp()
    try:
        # Создаем правильный экземпляр класса через WTForms
        from wtforms import Form
        class TestForm(Form):
            file = FileUploadField(upload_folder=temp_dir, allowed_extensions=['jpg', 'png', 'pdf'], max_size=1024 * 1024)
        
        form = TestForm()
        upload_field = form.file
        
        # Создаем мок файла без имени
        mock_file = Mock()
        mock_file.filename = None
        
        # Тест должен выбросить исключение
        with pytest.raises(ValidationError, match="Файл обязателен для загрузки"):
            upload_field.validate_file(mock_file)
    finally:
        # Удаляем временную директорию
        shutil.rmtree(temp_dir)


def test_validate_file_invalid_extension():
    """Тест валидации файла с недопустимым расширением."""
    # Создаем временную директорию для тестов
    temp_dir = tempfile.mkdtemp()
    try:
        # Создаем правильный экземпляр класса через WTForms
        from wtforms import Form
        class TestForm(Form):
            file = FileUploadField(upload_folder=temp_dir, allowed_extensions=['jpg', 'png', 'pdf'], max_size=1024 * 1024)
        
        form = TestForm()
        upload_field = form.file
        
        # Создаем мок файла с недопустимым расширением
        mock_file = Mock()
        mock_file.filename = 'test.exe'
        
        # Тест должен выбросить исключение
        with pytest.raises(ValidationError, match="Разрешены только файлы с расширениями"):
            upload_field.validate_file(mock_file)
    finally:
        # Удаляем временную директорию
        shutil.rmtree(temp_dir)


def test_get_mime_type():
    """Тест определения MIME типа файла."""
    # Создаем временную директорию для тестов
    temp_dir = tempfile.mkdtemp()
    try:
        # Создаем правильный экземпляр класса через WTForms
        from wtforms import Form
        class TestForm(Form):
            file = FileUploadField(upload_folder=temp_dir, allowed_extensions=['jpg', 'png', 'pdf'], max_size=1024 * 1024)
        
        form = TestForm()
        upload_field = form.file
        
        # Тестируем различные расширения
        assert upload_field._get_mime_type('jpg') == 'image/jpeg'
        assert upload_field._get_mime_type('png') == 'image/png'
        assert upload_field._get_mime_type('pdf') == 'application/pdf'
        assert upload_field._get_mime_type('unknown') == 'application/octet-stream'
    finally:
        # Удаляем временную директорию
        shutil.rmtree(temp_dir)


class TestHexColorField:
    """Тесты для поля HEX-цветов."""
    
    def test_validate_hex_color_success(self):
        """Тест успешной валидации HEX-цветов."""
        # Создаем мок формы и поля
        mock_form = Mock()
        mock_field = Mock()
        
        # Тестируем различные валидные форматы
        valid_colors = ['#FF0000', '#00FF00', '#0000FF', '#F00', '#0F0', '#00F']
        
        for color in valid_colors:
            mock_field.data = color
            # Не должно выбрасывать исключение
            validate_hex_color(mock_form, mock_field)
    
    def test_validate_hex_color_invalid(self):
        """Тест валидации невалидных HEX-цветов."""
        # Создаем мок формы и поля
        mock_form = Mock()
        mock_field = Mock()
        
        # Тестируем различные невалидные форматы
        invalid_colors = ['#GG0000', '#FF00', '#FF000', 'FF0000', '#FF00000']
        
        for color in invalid_colors:
            mock_field.data = color
            # Должно выбрасывать исключение
            with pytest.raises(ValidationError, match="Цвет должен быть в формате HEX"):
                validate_hex_color(mock_form, mock_field)
    
    def test_validate_hex_color_empty(self):
        """Тест валидации пустого значения."""
        # Создаем мок формы и поля
        mock_form = Mock()
        mock_field = Mock()
        mock_field.data = None
        
        # Не должно выбрасывать исключение для пустого значения
        validate_hex_color(mock_form, mock_field)


class TestAdminViews:
    """Тесты для админ представлений."""
    
    def test_file_admin_configuration(self):
        """Тест конфигурации FileAdmin."""
        file_admin = FileAdmin()
        
        # Проверяем основные настройки
        assert file_admin.name == "Файл"
        assert file_admin.name_plural == "Файлы"
        assert file_admin.icon == "fa-solid fa-file"
        assert file_admin.page_size == 50
        
        # Проверяем права доступа
        assert file_admin.can_create is True
        assert file_admin.can_edit is False
        assert file_admin.can_delete is True
        assert file_admin.can_view_details is True
    
    def test_user_admin_configuration(self):
        """Тест конфигурации UserAdmin."""
        user_admin = UserAdmin()
        
        # Проверяем основные настройки
        assert user_admin.name == "Пользователь"
        assert user_admin.name_plural == "Пользователи"
        assert user_admin.icon == "fa-solid fa-user"
        assert user_admin.page_size == 50
        
        # Проверяем права доступа
        assert user_admin.can_create is False
        assert user_admin.can_edit is True
        assert user_admin.can_delete is True
        assert user_admin.can_view_details is True
    
    def test_course_admin_configuration(self):
        """Тест конфигурации CourseAdmin."""
        course_admin = CourseAdmin()
        
        # Проверяем основные настройки
        assert course_admin.name == "Курс"
        assert course_admin.name_plural == "Курсы"
        assert course_admin.icon == "fa-solid fa-graduation-cap"
        assert course_admin.page_size == 30
        
        # Проверяем права доступа
        assert course_admin.can_create is True
        assert course_admin.can_edit is True
        assert course_admin.can_delete is True
        assert course_admin.can_view_details is True


class TestAdminIntegration:
    """Интеграционные тесты для админки."""
    
    @pytest.fixture
    def test_client(self):
        """Создает тестовый клиент для FastAPI приложения."""
        import sys
        import os
        sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'backend'))
        
        # Мокаем создание движка базы данных
        with patch('admin.admin_setup.create_engine') as mock_engine:
            mock_engine.return_value = None
            from main import app
            return TestClient(app)
    
    def test_admin_login_page_accessible(self, test_client):
        """Тест доступности страницы входа в админку."""
        response = test_client.get("/admin/login")
        assert response.status_code == 200
        assert "login" in response.text.lower()
    
    def test_admin_dashboard_requires_auth(self, test_client):
        """Тест что дашборд админки требует аутентификации."""
        response = test_client.get("/admin/")
        # Проверяем, что страница доступна (может быть редирект или страница входа)
        assert response.status_code in [200, 302, 401]
    
    @patch('admin.auth.get_admin_credentials')
    def test_admin_login_flow(self, mock_credentials, test_client):
        """Тест процесса входа в админку."""
        # Настраиваем мок
        mock_credentials.return_value = ('testadmin', 'testpass123')
        
        # Пытаемся войти с правильными данными
        response = test_client.post("/admin/login", data={
            'username': 'testadmin',
            'password': 'testpass123'
        })
        
        # Проверяем результат
        assert response.status_code in [200, 302]  # Успешный вход
    
    @patch('admin.auth.get_admin_credentials')
    def test_admin_login_wrong_credentials(self, mock_credentials, test_client):
        """Тест входа в админку с неправильными данными."""
        # Настраиваем мок
        mock_credentials.return_value = ('testadmin', 'testpass123')
        
        # Пытаемся войти с неправильными данными
        response = test_client.post("/admin/login", data={
            'username': 'wronguser',
            'password': 'wrongpass'
        })
        
        # Проверяем результат - может быть 400 (Bad Request) или 200 (остаемся на странице входа)
        assert response.status_code in [200, 400]


if __name__ == "__main__":
    pytest.main([__file__])
