"""
Вспомогательные функции для работы с внешними сервисами
"""

import asyncio
import aiohttp
from datetime import datetime
from typing import Dict, Any
from config import load_config
from logger import logger


async def send_survey_to_crm(user: Dict, survey_data: list, level: Dict):
    """
    Отправляет данные опроса пользователя в CRM через webhook.
    
    Args:
        user: Данные пользователя
        survey_data: Список ответов на вопросы опроса
        level: Данные уровня пользователя
    """
    try:
        # Загружаем конфигурацию
        config = load_config("../.env")
        
        if not config.misc.crm_webhook_url:
            logger.warning("CRM webhook URL не настроен, пропускаем отправку в CRM")
            return
        
        # Формируем данные для отправки
        payload = {
            "user": {
                "telegram_id": user["telegram_id"],
                "username": user.get("username", ""),
                "first_name": user.get("first_name", ""),
                "last_name": user.get("last_name", ""),
                "level": level["name"],
                "level_id": level["id"]
            },
            "survey_answers": survey_data,
            "timestamp": datetime.now().isoformat(),
            "event_type": "enter_survey"
        }
        
        # Отправляем POST запрос в CRM
        async with aiohttp.ClientSession() as session:
            async with session.post(
                config.misc.crm_webhook_url,
                json=payload,
                headers={"Content-Type": "application/json"},
                timeout=aiohttp.ClientTimeout(total=30)
            ) as response:
                if response.status == 200:
                    logger.info(f"Данные опроса успешно отправлены в CRM для пользователя {user['telegram_id']}")
                else:
                    logger.error(f"Ошибка отправки в CRM: статус {response.status}, ответ: {await response.text()}")
                    
    except Exception as e:
        logger.error(f"Ошибка при отправке данных в CRM: {e}")
        # Не прерываем выполнение основной логики при ошибке CRM


def remove_timestamps(data):
    """
    Удаляет временные метки из данных для очистки.
    
    Args:
        data: Данные для очистки
        
    Returns:
        Очищенные данные без временных меток
    """
    # Список полей с временными метками, которые нужно удалить
    timestamp_fields = ['created_at', 'updated_at', 'time_created', 'time_modified']
    
    if isinstance(data, dict):
        # Удаляем временные метки и рекурсивно обрабатываем остальные поля
        cleaned_data = {}
        removed_fields = []
        
        for k, v in data.items():
            if k in timestamp_fields:
                removed_fields.append(k)
            else:
                cleaned_data[k] = remove_timestamps(v)
        
        # Логируем удаленные поля (только если они были найдены)
        # if removed_fields:
        #     logger.debug(f"Удалены временные метки: {removed_fields}")
            
        return cleaned_data
    elif isinstance(data, list):
        return [remove_timestamps(item) for item in data]
    else:
        return data
