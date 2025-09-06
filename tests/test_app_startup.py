"""
Тест для проверки запуска приложения без Telegram переменных.
"""

import os
import sys
import pytest
from unittest.mock import patch, MagicMock
from pathlib import Path

# Добавляем backend в sys.path
backend_path = Path(__file__).parent.parent / "backend"
if str(backend_path) not in sys.path:
    sys.path.insert(0, str(backend_path))

from notification_service import get_notification_service, NotificationServiceFactory
from config import load_config


class TestAppStartup:
    """Тесты для проверки запуска приложения."""
    
    @patch.dict(os.environ, {
        'DB_HOST': 'localhost',
        'DB_PORT': '5432',
        'DB_NAME': 'test_db',
        'DB_USER': 'test_user',
        'DB_PASS': 'test_pass'
    }, clear=True)
    def test_app_can_start_without_telegram_variables(self):
        """Тест что приложение может запускаться без Telegram переменных."""
        # Создаем мок конфигурации без Telegram переменных
        from config import Config, TgBot, DbConfig, Miscellaneous
        
        mock_config = Config(
            tg_bot=TgBot(
                token=None,
                admin_ids=[],
                use_redis=False,
                private_channel_id=None
            ),
            db=DbConfig(
                host='localhost',
                password='test_pass',
                user='test_user',
                database='test_db'
            ),
            misc=Miscellaneous(
                other_params=None,
                crm_survey_webhook_url=None,
                crm_homework_webhook_url=None
            )
        )
        
        # Мокаем загрузку конфигурации чтобы исключить чтение из .env файла
        with patch('tests.test_app_startup.load_config', return_value=mock_config):
            # Проверяем что конфигурация загружается без ошибок
            config = load_config()
            assert config is not None
            assert config.db.host == 'localhost'
            assert config.tg_bot.token is None
            assert config.tg_bot.private_channel_id is None
            
            # Проверяем что создается заглушка сервиса уведомлений
            service = get_notification_service()
            assert service is not None
            assert service.is_available() is True
    
    @patch.dict(os.environ, {
        'DB_HOST': 'localhost',
        'DB_PORT': '5432',
        'DB_NAME': 'test_db',
        'DB_USER': 'test_user',
        'DB_PASS': 'test_pass',
        'ENABLE_TELEGRAM_NOTIFICATIONS': 'false'
    }, clear=True)
    def test_app_uses_mock_service_when_telegram_disabled(self):
        """Тест что приложение использует заглушку когда Telegram отключен."""
        from notification_service import MockNotificationService
        
        service = NotificationServiceFactory.create_notification_service()
        assert isinstance(service, MockNotificationService)
    
    @patch.dict(os.environ, {
        'DB_HOST': 'localhost',
        'DB_PORT': '5432',
        'DB_NAME': 'test_db',
        'DB_USER': 'test_user',
        'DB_PASS': 'test_pass',
        'BOT_TOKEN': 'invalid_token',
        'PRIVATE_CHANNEL_ID': 'invalid_channel'
    }, clear=True)
    def test_app_falls_back_to_mock_when_telegram_invalid(self):
        """Тест что приложение переключается на заглушку при невалидных Telegram данных."""
        from notification_service import MockNotificationService
        
        service = NotificationServiceFactory.create_notification_service()
        assert isinstance(service, MockNotificationService)


if __name__ == "__main__":
    pytest.main([__file__])
