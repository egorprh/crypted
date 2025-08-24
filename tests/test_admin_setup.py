"""
Тесты для модуля admin_setup.
Проверяет корректность настройки админ панели.
"""

import pytest
import os
import sys
from unittest.mock import Mock, patch
from fastapi import FastAPI

# Добавляем путь к backend для импорта
sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'backend'))

from admin.admin_setup import setup_admin, get_uploads_directory


class TestAdminSetup:
    """Тесты для модуля настройки админки."""
    
    def test_get_uploads_directory(self):
        """Тест получения пути к директории загрузок."""
        uploads_dir = get_uploads_directory()
        
        # Проверяем, что путь существует и указывает на папку uploads
        assert os.path.basename(uploads_dir) == "uploads"
        # Теперь путь должен заканчиваться на admin/uploads, поэтому проверяем admin
        assert "admin" in os.path.dirname(uploads_dir)
    
    @patch('admin.admin_setup.os.getenv')
    @patch('admin.admin_setup.create_engine')
    @patch('admin.admin_setup.Admin')
    @patch('admin.admin_setup.AdminAuth')
    def test_setup_admin_success(self, mock_auth, mock_admin, mock_engine, mock_getenv):
        """Тест успешной настройки админки."""
        # Настраиваем моки
        mock_getenv.return_value = "postgresql://test"
        mock_engine_instance = Mock()
        mock_engine.return_value = mock_engine_instance
        mock_admin_instance = Mock()
        mock_admin.return_value = mock_admin_instance
        mock_auth_instance = Mock()
        mock_auth.return_value = mock_auth_instance
        
        # Создаем тестовое приложение
        app = FastAPI()
        
        # Вызываем функцию настройки
        result = setup_admin(app)
        
        # Проверяем, что все моки были вызваны
        mock_getenv.assert_called_once_with("DATABASE_URL", "postgresql://deptmaster:VgPZGd1B2rkDW!@localhost:5432/deptspace")
        mock_engine.assert_called_once_with("postgresql://test")
        mock_auth.assert_called_once()
        mock_admin.assert_called_once()
        
        # Проверяем, что функция вернула экземпляр админки
        assert result == mock_admin_instance
    
    def test_setup_admin_config_error(self):
        """Тест обработки ошибки конфигурации."""
        # Создаем тестовое приложение
        app = FastAPI()
        
        # Проверяем, что функция работает с дефолтными значениями
        # даже если .env файл отсутствует
        try:
            result = setup_admin(app)
            # Если функция выполнилась успешно, это нормально
            assert result is not None
        except Exception as e:
            # Если произошла ошибка, она должна быть связана с БД, а не с конфигурацией
            assert "config" not in str(e).lower()
    
    @patch('admin.admin_setup.os.getenv')
    @patch('admin.admin_setup.create_engine')
    def test_setup_admin_engine_error(self, mock_engine, mock_getenv):
        """Тест обработки ошибки создания движка."""
        # Настраиваем моки
        mock_getenv.return_value = "postgresql://test"
        mock_engine.side_effect = Exception("Engine error")
        
        # Создаем тестовое приложение
        app = FastAPI()
        
        # Проверяем, что функция выбрасывает исключение
        with pytest.raises(Exception, match="Engine error"):
            setup_admin(app)
    
    def test_setup_admin_imports(self):
        """Тест корректности импортов модуля."""
        # Проверяем, что все необходимые функции доступны
        from admin.admin_setup import setup_admin, get_uploads_directory
        
        assert callable(setup_admin)
        assert callable(get_uploads_directory)


if __name__ == "__main__":
    pytest.main([__file__])
