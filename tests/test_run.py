"""
Юнит-тесты для модуля run.
Тестирует проверку переменных окружения с опциональными Telegram переменными.
"""

import os
import sys
import pytest
from unittest.mock import patch, MagicMock
from run import check_environment


class TestCheckEnvironment:
    """Тесты для функции check_environment."""
    
    @patch('run.load_environment')
    def test_check_environment_with_all_required_variables(self, mock_load_env):
        """Тест проверки окружения со всеми обязательными переменными."""
        with patch.dict(os.environ, {
            'DB_HOST': 'localhost',
            'DB_PORT': '5432',
            'DB_NAME': 'database',
            'DB_USER': 'user',
            'DB_PASS': 'password',
            'BOT_TOKEN': 'test_token',
            'ADMINS': '1,2,3',
            'PRIVATE_CHANNEL_ID': 'test_channel'
        }):
            # Функция должна выполниться без исключений
            check_environment()
            mock_load_env.assert_called_once()
    
    @patch('run.load_environment')
    def test_check_environment_without_telegram_variables(self, mock_load_env):
        """Тест проверки окружения без Telegram переменных."""
        with patch.dict(os.environ, {
            'DB_HOST': 'localhost',
            'DB_PORT': '5432',
            'DB_NAME': 'database',
            'DB_USER': 'user',
            'DB_PASS': 'password'
        }, clear=True):
            # Функция должна выполниться без исключений
            check_environment()
            mock_load_env.assert_called_once()
    
    @patch('run.load_environment')
    def test_check_environment_missing_required_variables(self, mock_load_env):
        """Тест проверки окружения с отсутствующими обязательными переменными."""
        with patch.dict(os.environ, {
            'DB_HOST': 'localhost',
            'DB_PORT': '5432',
            # Отсутствуют DB_NAME, DB_USER, DB_PASS
            'BOT_TOKEN': 'test_token',
            'PRIVATE_CHANNEL_ID': 'test_channel'
        }):
            # Функция должна выбросить SystemExit
            with pytest.raises(SystemExit):
                check_environment()
            mock_load_env.assert_called_once()
    
    @patch('run.load_environment')
    def test_check_environment_missing_some_required_variables(self, mock_load_env):
        """Тест проверки окружения с частично отсутствующими обязательными переменными."""
        with patch.dict(os.environ, {
            'DB_HOST': 'localhost',
            'DB_PORT': '5432',
            'DB_NAME': 'database',
            # Отсутствуют DB_USER, DB_PASS
            'BOT_TOKEN': 'test_token',
            'PRIVATE_CHANNEL_ID': 'test_channel'
        }):
            # Функция должна выбросить SystemExit
            with pytest.raises(SystemExit):
                check_environment()
            mock_load_env.assert_called_once()
    
    @patch('run.load_environment')
    def test_check_environment_with_empty_telegram_variables(self, mock_load_env):
        """Тест проверки окружения с пустыми Telegram переменными."""
        with patch.dict(os.environ, {
            'DB_HOST': 'localhost',
            'DB_PORT': '5432',
            'DB_NAME': 'database',
            'DB_USER': 'user',
            'DB_PASS': 'password',
            'BOT_TOKEN': '',  # Пустой токен
            'PRIVATE_CHANNEL_ID': ''  # Пустой канал
        }):
            # Функция должна выполниться без исключений
            check_environment()
            mock_load_env.assert_called_once()
    
    @patch('run.load_environment')
    def test_check_environment_with_partial_telegram_variables(self, mock_load_env):
        """Тест проверки окружения с частично заполненными Telegram переменными."""
        with patch.dict(os.environ, {
            'DB_HOST': 'localhost',
            'DB_PORT': '5432',
            'DB_NAME': 'database',
            'DB_USER': 'user',
            'DB_PASS': 'password',
            'BOT_TOKEN': 'test_token',  # Есть токен
            # Отсутствует PRIVATE_CHANNEL_ID
        }):
            # Функция должна выполниться без исключений
            check_environment()
            mock_load_env.assert_called_once()
    
    @patch('run.load_environment')
    def test_check_environment_with_only_channel_id(self, mock_load_env):
        """Тест проверки окружения только с ID канала."""
        with patch.dict(os.environ, {
            'DB_HOST': 'localhost',
            'DB_PORT': '5432',
            'DB_NAME': 'database',
            'DB_USER': 'user',
            'DB_PASS': 'password',
            # Отсутствует BOT_TOKEN
            'PRIVATE_CHANNEL_ID': 'test_channel'  # Есть канал
        }):
            # Функция должна выполниться без исключений
            check_environment()
            mock_load_env.assert_called_once()


if __name__ == "__main__":
    pytest.main([__file__])
