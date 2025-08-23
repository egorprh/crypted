"""
Модуль для работы с уведомлениями.
Содержит абстрактный интерфейс и реализации для различных сервисов уведомлений.
"""

import os
import asyncio
from abc import ABC, abstractmethod
from typing import Optional, Dict, Any
from aiogram import Bot, types
from aiogram.client.default import DefaultBotProperties
from aiogram.enums import ParseMode
from logger import logger


class NotificationService(ABC):
    """
    Абстрактный базовый класс для сервисов уведомлений.
    Определяет интерфейс для отправки сообщений и файлов.
    """
    
    @abstractmethod
    async def send_message(self, text: str) -> bool:
        """
        Отправляет текстовое сообщение.
        
        Args:
            text: Текст сообщения для отправки
            
        Returns:
            bool: True если сообщение отправлено успешно, False в противном случае
        """
        pass
    
    @abstractmethod
    async def send_document(self, file_path: str, caption: str) -> bool:
        """
        Отправляет документ с подписью.
        
        Args:
            file_path: Путь к файлу для отправки
            caption: Подпись к документу
            
        Returns:
            bool: True если документ отправлен успешно, False в противном случае
        """
        pass
    
    @abstractmethod
    def is_available(self) -> bool:
        """
        Проверяет доступность сервиса уведомлений.
        
        Returns:
            bool: True если сервис доступен, False в противном случае
        """
        pass


class TelegramNotificationService(NotificationService):
    """
    Реализация сервиса уведомлений через Telegram Bot API.
    """
    
    def __init__(self, bot_token: str, channel_id: str):
        """
        Инициализирует Telegram сервис уведомлений.
        
        Args:
            bot_token: Токен Telegram бота
            channel_id: ID канала для отправки сообщений
        """
        self.bot_token = bot_token
        self.channel_id = channel_id
        self.bot = None
        self._initialized = False
        
        # Инициализируем бота если токен предоставлен
        if bot_token and channel_id:
            try:
                self.bot = Bot(token=bot_token, default=DefaultBotProperties(parse_mode=ParseMode.HTML))
                self._initialized = True
                logger.info("Telegram уведомления инициализированы")
            except Exception as e:
                logger.error(f"Ошибка инициализации Telegram бота: {e}")
                self._initialized = False
    
    def is_available(self) -> bool:
        """
        Проверяет доступность Telegram сервиса.
        
        Returns:
            bool: True если бот инициализирован и токен/канал настроены
        """
        return self._initialized and bool(self.bot_token and self.channel_id)
    
    async def send_message(self, text: str) -> bool:
        """
        Отправляет текстовое сообщение в Telegram канал.
        
        Args:
            text: Текст сообщения для отправки
            
        Returns:
            bool: True если сообщение отправлено успешно, False в противном случае
        """
        if not self.is_available():
            logger.warning("Telegram уведомления недоступны, сообщение не отправлено")
            return False
        
        try:
            await self.bot.send_message(chat_id=self.channel_id, text=text)
            logger.info("Сообщение отправлено в Telegram канал")
            return True
        except Exception as e:
            logger.error(f"Ошибка отправки сообщения в Telegram: {e}")
            return False
    
    async def send_document(self, file_path: str, caption: str) -> bool:
        """
        Отправляет документ в Telegram канал.
        
        Args:
            file_path: Путь к файлу для отправки
            caption: Подпись к документу
            
        Returns:
            bool: True если документ отправлен успешно, False в противном случае
        """
        if not self.is_available():
            logger.warning("Telegram уведомления недоступны, документ не отправлен")
            return False
        
        if not os.path.exists(file_path):
            logger.error(f"Файл не найден: {file_path}")
            return False
        
        try:
            with open(file_path, 'rb') as file:
                await self.bot.send_document(
                    chat_id=self.channel_id,
                    document=types.BufferedInputFile(
                        file.read(),
                        filename=os.path.basename(file_path)
                    ),
                    caption=caption
                )
            logger.info(f"Документ отправлен в Telegram канал: {file_path}")
            return True
        except Exception as e:
            logger.error(f"Ошибка отправки документа в Telegram: {e}")
            return False


class MockNotificationService(NotificationService):
    """
    Заглушка для сервиса уведомлений.
    Используется когда Telegram уведомления отключены или недоступны.
    """
    
    def __init__(self):
        """Инициализирует заглушку сервиса уведомлений."""
        logger.info("Используется заглушка сервиса уведомлений")
    
    def is_available(self) -> bool:
        """
        Заглушка всегда доступна.
        
        Returns:
            bool: Всегда True
        """
        return True
    
    async def send_message(self, text: str) -> bool:
        """
        Логирует сообщение вместо отправки.
        
        Args:
            text: Текст сообщения для логирования
            
        Returns:
            bool: Всегда True
        """
        logger.info(f"[УВЕДОМЛЕНИЕ] {text}")
        return True
    
    async def send_document(self, file_path: str, caption: str) -> bool:
        """
        Логирует отправку документа вместо реальной отправки.
        
        Args:
            file_path: Путь к файлу
            caption: Подпись к документу
            
        Returns:
            bool: Всегда True
        """
        logger.info(f"[ДОКУМЕНТ] {caption} - {file_path}")
        return True


class NotificationServiceFactory:
    """
    Фабрика для создания сервисов уведомлений.
    """
    
    @staticmethod
    def create_notification_service() -> NotificationService:
        """
        Создает соответствующий сервис уведомлений на основе конфигурации.
        
        Returns:
            NotificationService: Экземпляр сервиса уведомлений
        """
        # Проверяем настройки Telegram
        bot_token = os.getenv("BOT_TOKEN")
        channel_id = os.getenv("PRIVATE_CHANNEL_ID")
        enable_telegram = os.getenv("ENABLE_TELEGRAM_NOTIFICATIONS", "true").lower() == "true"
        
        # Если Telegram включен и настроен, создаем Telegram сервис
        if enable_telegram and bot_token and channel_id:
            telegram_service = TelegramNotificationService(bot_token, channel_id)
            if telegram_service.is_available():
                return telegram_service
            else:
                logger.warning("Telegram сервис недоступен, используется заглушка")
        
        # В остальных случаях используем заглушку
        return MockNotificationService()


# Глобальный экземпляр сервиса уведомлений
notification_service: Optional[NotificationService] = None


def get_notification_service() -> NotificationService:
    """
    Возвращает глобальный экземпляр сервиса уведомлений.
    Создает его при первом вызове.
    
    Returns:
        NotificationService: Экземпляр сервиса уведомлений
    """
    global notification_service
    if notification_service is None:
        notification_service = NotificationServiceFactory.create_notification_service()
    return notification_service


async def send_service_message(text: str) -> bool:
    """
    Отправляет служебное сообщение через текущий сервис уведомлений.
    
    Args:
        text: Текст сообщения для отправки
        
    Returns:
        bool: True если сообщение отправлено успешно, False в противном случае
    """
    service = get_notification_service()
    return await service.send_message(text)


async def send_service_document(file_path: str, caption: str) -> bool:
    """
    Отправляет служебный документ через текущий сервис уведомлений.
    
    Args:
        file_path: Путь к файлу для отправки
        caption: Подпись к документу
        
    Returns:
        bool: True если документ отправлен успешно, False в противном случае
    """
    service = get_notification_service()
    return await service.send_document(file_path, caption)
