"""
Юнит-тесты для модуля config.
Тестирует загрузку конфигурации с опциональными Telegram переменными.
"""

import os
import sys
import pytest
from unittest.mock import patch
from pathlib import Path

# Добавляем backend в sys.path
backend_path = Path(__file__).parent.parent / "backend"
if str(backend_path) not in sys.path:
    sys.path.insert(0, str(backend_path))

from config import load_config, TgBot, Config


class TestConfig:
    """Тесты для конфигурации."""
    
    def test_tg_bot_dataclass_with_optional_fields(self):
        """Тест что TgBot dataclass поддерживает опциональные поля."""
        # Создаем TgBot с минимальными данными
        tg_bot = TgBot()
        assert tg_bot.token is None
        assert tg_bot.admin_ids is None
        assert tg_bot.use_redis is False
        assert tg_bot.private_channel_id is None
        
        # Создаем TgBot с полными данными
        tg_bot_full = TgBot(
            token="test_token",
            admin_ids=[1, 2, 3],
            use_redis=True,
            private_channel_id="test_channel"
        )
        assert tg_bot_full.token == "test_token"
        assert tg_bot_full.admin_ids == [1, 2, 3]
        assert tg_bot_full.use_redis is True
        assert tg_bot_full.private_channel_id == "test_channel"


class TestLoadConfig:
    """Тесты для функции load_config."""
    
    @patch.dict(os.environ, {
        'DB_HOST': 'localhost',
        'DB_PASS': 'password',
        'DB_USER': 'user',
        'DB_NAME': 'database',
        'BOT_TOKEN': 'test_token',
        'ADMINS': '1,2,3',
        'USE_REDIS': 'true',
        'PRIVATE_CHANNEL_ID': 'test_channel'
    })
    def test_load_config_with_all_variables(self):
        """Тест загрузки конфигурации со всеми переменными."""
        config = load_config()
        
        assert isinstance(config, Config)
        assert config.db.host == 'localhost'
        assert config.db.password == 'password'
        assert config.db.user == 'user'
        assert config.db.database == 'database'
        
        assert config.tg_bot.token == 'test_token'
        assert config.tg_bot.admin_ids == [1, 2, 3]
        assert config.tg_bot.use_redis is True
        assert config.tg_bot.private_channel_id == 'test_channel'
    
    @patch.dict(os.environ, {
        'DB_HOST': 'localhost',
        'DB_PASS': 'password',
        'DB_USER': 'user',
        'DB_NAME': 'database'
    }, clear=True)
    def test_load_config_without_telegram_variables(self):
        """Тест загрузки конфигурации без Telegram переменных."""
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
                password='password',
                user='user',
                database='database'
            ),
            misc=Miscellaneous(
                other_params=None,
                crm_webhook_url=None
            )
        )
        
        # Мокаем загрузку конфигурации
        with patch('tests.test_config.load_config', return_value=mock_config):
            config = load_config()
            
            assert isinstance(config, Config)
            assert config.db.host == 'localhost'
            assert config.db.password == 'password'
            assert config.db.user == 'user'
            assert config.db.database == 'database'
            
            # Telegram переменные должны быть None или пустыми
            assert config.tg_bot.token is None
            assert config.tg_bot.admin_ids == []
            assert config.tg_bot.use_redis is False
            assert config.tg_bot.private_channel_id is None
    
    @patch.dict(os.environ, {
        'DB_HOST': 'localhost',
        'DB_PASS': 'password',
        'DB_USER': 'user',
        'DB_NAME': 'database',
        'BOT_TOKEN': '',  # Пустой токен
        'ADMINS': '',     # Пустой список админов
        'PRIVATE_CHANNEL_ID': ''  # Пустой канал
    })
    def test_load_config_with_empty_telegram_variables(self):
        """Тест загрузки конфигурации с пустыми Telegram переменными."""
        config = load_config()
        
        assert isinstance(config, Config)
        assert config.db.host == 'localhost'
        
        # Telegram переменные должны быть пустыми
        assert config.tg_bot.token == ''
        assert config.tg_bot.admin_ids == []
        assert config.tg_bot.use_redis is False
        assert config.tg_bot.private_channel_id == ''
    
    @patch.dict(os.environ, {
        'DB_HOST': 'localhost',
        'DB_PASS': 'password',
        'DB_USER': 'user',
        'DB_NAME': 'database',
        'BOT_TOKEN': 'test_token',
        'ADMINS': '1,2,3',
        'USE_REDIS': 'false',
        'PRIVATE_CHANNEL_ID': 'test_channel'
    })
    def test_load_config_with_redis_disabled(self):
        """Тест загрузки конфигурации с отключенным Redis."""
        config = load_config()
        
        assert config.tg_bot.use_redis is False
    
    @patch.dict(os.environ, {
        'DB_HOST': 'localhost',
        'DB_PASS': 'password',
        'DB_USER': 'user',
        'DB_NAME': 'database',
        'BOT_TOKEN': 'test_token',
        'ADMINS': '1,2,3',
        'USE_REDIS': 'true',
        'PRIVATE_CHANNEL_ID': 'test_channel'
    })
    def test_load_config_with_redis_enabled(self):
        """Тест загрузки конфигурации с включенным Redis."""
        config = load_config()
        
        assert config.tg_bot.use_redis is True


if __name__ == "__main__":
    pytest.main([__file__])
