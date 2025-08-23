"""
Юнит-тесты для модуля notification_service.
Тестирует абстрактный интерфейс и реализации сервисов уведомлений.
"""

import os
import pytest
import asyncio
from unittest.mock import Mock, patch, AsyncMock
from notification_service import (
    NotificationService,
    TelegramNotificationService,
    MockNotificationService,
    NotificationServiceFactory,
    get_notification_service,
    send_service_message,
    send_service_document
)


class TestNotificationService:
    """Тесты для абстрактного базового класса NotificationService."""
    
    def test_abstract_class_cannot_be_instantiated(self):
        """Тест что абстрактный класс нельзя инстанцировать."""
        with pytest.raises(TypeError):
            NotificationService()


class TestMockNotificationService:
    """Тесты для заглушки сервиса уведомлений."""
    
    def test_mock_service_initialization(self):
        """Тест инициализации заглушки сервиса."""
        service = MockNotificationService()
        assert service is not None
    
    def test_mock_service_is_always_available(self):
        """Тест что заглушка всегда доступна."""
        service = MockNotificationService()
        assert service.is_available() is True
    
    @pytest.mark.asyncio
    async def test_mock_service_send_message(self):
        """Тест отправки сообщения через заглушку."""
        service = MockNotificationService()
        result = await service.send_message("Тестовое сообщение")
        assert result is True
    
    @pytest.mark.asyncio
    async def test_mock_service_send_document(self):
        """Тест отправки документа через заглушку."""
        service = MockNotificationService()
        result = await service.send_document("/path/to/file.txt", "Тестовый документ")
        assert result is True


class TestTelegramNotificationService:
    """Тесты для Telegram сервиса уведомлений."""
    
    def test_telegram_service_initialization_with_valid_credentials(self):
        """Тест инициализации Telegram сервиса с валидными данными."""
        with patch('notification_service.Bot') as mock_bot:
            mock_bot.return_value = Mock()
            service = TelegramNotificationService("valid_token", "valid_channel_id")
            assert service.bot_token == "valid_token"
            assert service.channel_id == "valid_channel_id"
            assert service._initialized is True
    
    def test_telegram_service_initialization_with_invalid_credentials(self):
        """Тест инициализации Telegram сервиса с невалидными данными."""
        with patch('notification_service.Bot') as mock_bot:
            mock_bot.side_effect = Exception("Invalid token")
            service = TelegramNotificationService("invalid_token", "valid_channel_id")
            assert service._initialized is False
    
    def test_telegram_service_initialization_with_empty_credentials(self):
        """Тест инициализации Telegram сервиса с пустыми данными."""
        service = TelegramNotificationService("", "")
        assert service._initialized is False
        assert service.is_available() is False
    
    def test_telegram_service_availability_with_valid_credentials(self):
        """Тест доступности Telegram сервиса с валидными данными."""
        with patch('notification_service.Bot') as mock_bot:
            mock_bot.return_value = Mock()
            service = TelegramNotificationService("valid_token", "valid_channel_id")
            assert service.is_available() is True
    
    def test_telegram_service_availability_with_invalid_credentials(self):
        """Тест доступности Telegram сервиса с невалидными данными."""
        service = TelegramNotificationService("", "")
        assert service.is_available() is False
    
    @pytest.mark.asyncio
    async def test_telegram_service_send_message_success(self):
        """Тест успешной отправки сообщения через Telegram."""
        with patch('notification_service.Bot') as mock_bot_class:
            mock_bot = AsyncMock()
            mock_bot_class.return_value = mock_bot
            
            service = TelegramNotificationService("valid_token", "valid_channel_id")
            result = await service.send_message("Тестовое сообщение")
            
            assert result is True
            mock_bot.send_message.assert_called_once_with(
                chat_id="valid_channel_id",
                text="Тестовое сообщение"
            )
    
    @pytest.mark.asyncio
    async def test_telegram_service_send_message_failure(self):
        """Тест неудачной отправки сообщения через Telegram."""
        with patch('notification_service.Bot') as mock_bot_class:
            mock_bot = AsyncMock()
            mock_bot.send_message.side_effect = Exception("Network error")
            mock_bot_class.return_value = mock_bot
            
            service = TelegramNotificationService("valid_token", "valid_channel_id")
            result = await service.send_message("Тестовое сообщение")
            
            assert result is False
    
    @pytest.mark.asyncio
    async def test_telegram_service_send_message_when_unavailable(self):
        """Тест отправки сообщения когда сервис недоступен."""
        service = TelegramNotificationService("", "")
        result = await service.send_message("Тестовое сообщение")
        assert result is False
    
    @pytest.mark.asyncio
    async def test_telegram_service_send_document_success(self):
        """Тест успешной отправки документа через Telegram."""
        with patch('notification_service.Bot') as mock_bot_class:
            mock_bot = AsyncMock()
            mock_bot_class.return_value = mock_bot
            
            service = TelegramNotificationService("valid_token", "valid_channel_id")
            
            # Создаем временный файл для теста
            test_file_path = "/tmp/test_file.txt"
            with open(test_file_path, 'w') as f:
                f.write("test content")
            
            try:
                result = await service.send_document(test_file_path, "Тестовый документ")
                
                assert result is True
                mock_bot.send_document.assert_called_once()
                call_args = mock_bot.send_document.call_args
                assert call_args[1]['chat_id'] == "valid_channel_id"
                assert call_args[1]['caption'] == "Тестовый документ"
            finally:
                # Очищаем временный файл
                if os.path.exists(test_file_path):
                    os.remove(test_file_path)
    
    @pytest.mark.asyncio
    async def test_telegram_service_send_document_file_not_found(self):
        """Тест отправки несуществующего документа."""
        with patch('notification_service.Bot') as mock_bot_class:
            mock_bot = AsyncMock()
            mock_bot_class.return_value = mock_bot
            
            service = TelegramNotificationService("valid_token", "valid_channel_id")
            result = await service.send_document("/nonexistent/file.txt", "Тестовый документ")
            
            assert result is False
            mock_bot.send_document.assert_not_called()


class TestNotificationServiceFactory:
    """Тесты для фабрики сервисов уведомлений."""
    
    @patch.dict(os.environ, {
        'BOT_TOKEN': 'test_token',
        'PRIVATE_CHANNEL_ID': 'test_channel',
        'ENABLE_TELEGRAM_NOTIFICATIONS': 'true'
    })
    @patch('notification_service.TelegramNotificationService')
    def test_factory_creates_telegram_service_when_configured(self, mock_telegram_class):
        """Тест создания Telegram сервиса когда он настроен."""
        mock_service = Mock()
        mock_service.is_available.return_value = True
        mock_telegram_class.return_value = mock_service
        
        service = NotificationServiceFactory.create_notification_service()
        
        assert isinstance(service, Mock)  # Это наш mock
        mock_telegram_class.assert_called_once_with('test_token', 'test_channel')
    
    @patch.dict(os.environ, {
        'BOT_TOKEN': 'test_token',
        'PRIVATE_CHANNEL_ID': 'test_channel',
        'ENABLE_TELEGRAM_NOTIFICATIONS': 'false'
    })
    def test_factory_creates_mock_service_when_telegram_disabled(self):
        """Тест создания заглушки когда Telegram отключен."""
        service = NotificationServiceFactory.create_notification_service()
        assert isinstance(service, MockNotificationService)
    
    @patch.dict(os.environ, {
        'ENABLE_TELEGRAM_NOTIFICATIONS': 'true'
    }, clear=True)
    def test_factory_creates_mock_service_when_telegram_not_configured(self):
        """Тест создания заглушки когда Telegram не настроен."""
        service = NotificationServiceFactory.create_notification_service()
        assert isinstance(service, MockNotificationService)
    
    @patch.dict(os.environ, {
        'BOT_TOKEN': 'test_token',
        'PRIVATE_CHANNEL_ID': 'test_channel',
        'ENABLE_TELEGRAM_NOTIFICATIONS': 'true'
    })
    @patch('notification_service.TelegramNotificationService')
    def test_factory_creates_mock_service_when_telegram_unavailable(self, mock_telegram_class):
        """Тест создания заглушки когда Telegram недоступен."""
        mock_service = Mock()
        mock_service.is_available.return_value = False
        mock_telegram_class.return_value = mock_service
        
        service = NotificationServiceFactory.create_notification_service()
        assert isinstance(service, MockNotificationService)


class TestGlobalFunctions:
    """Тесты для глобальных функций модуля."""
    
    @patch('notification_service.get_notification_service')
    @pytest.mark.asyncio
    async def test_send_service_message(self, mock_get_service):
        """Тест функции send_service_message."""
        mock_service = AsyncMock()
        mock_service.send_message.return_value = True
        mock_get_service.return_value = mock_service
        
        result = await send_service_message("Тестовое сообщение")
        
        assert result is True
        mock_service.send_message.assert_called_once_with("Тестовое сообщение")
    
    @patch('notification_service.get_notification_service')
    @pytest.mark.asyncio
    async def test_send_service_document(self, mock_get_service):
        """Тест функции send_service_document."""
        mock_service = AsyncMock()
        mock_service.send_document.return_value = True
        mock_get_service.return_value = mock_service
        
        result = await send_service_document("/path/to/file.txt", "Тестовый документ")
        
        assert result is True
        mock_service.send_document.assert_called_once_with("/path/to/file.txt", "Тестовый документ")
    
    @patch('notification_service.NotificationServiceFactory')
    def test_get_notification_service_creates_service_once(self, mock_factory):
        """Тест что get_notification_service создает сервис только один раз."""
        mock_service = Mock()
        mock_factory.create_notification_service.return_value = mock_service
        
        # Первый вызов должен создать сервис
        service1 = get_notification_service()
        assert service1 is mock_service
        mock_factory.create_notification_service.assert_called_once()
        
        # Второй вызов должен вернуть тот же сервис
        service2 = get_notification_service()
        assert service2 is mock_service
        # Количество вызовов не должно увеличиться
        assert mock_factory.create_notification_service.call_count == 1


if __name__ == "__main__":
    pytest.main([__file__])
