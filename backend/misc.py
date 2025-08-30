"""
Вспомогательные функции для работы с внешними сервисами
"""

import asyncio
import aiohttp
from datetime import datetime, timezone
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
        
        # Логируем исходные данные опроса
        logger.info(f"Исходные данные опроса: {survey_data}")
        
        # Извлекаем значения имени, возраста и телефона из survey_data
        def extract_answer(keywords):
            for item in survey_data:
                q = str(item.get("question", "")).lower()
                if any(k in q for k in keywords):
                    return item.get("answer")
            return None

        name_value = extract_answer(["имя", "как вас зовут", "фамилия", "фио", "name"])
        age_value = extract_answer(["возраст", "лет", "age"])
        phone_value = extract_answer(["телефон", "phone", "номер"])

        # Формируем плоский payload с требуемыми ключами
        payload = {
            "telegram_id": user["telegram_id"],
            "username": user.get("username"),
            "level_id": level["id"],
            "level": level["name"],
            "name": name_value,
            "age": age_value,
            "phone": phone_value
        }
        
        # Логируем payload для отладки
        logger.info(f"Отправляем в CRM payload: {payload}")
        
        # Отправляем POST запрос в CRM
        async with aiohttp.ClientSession() as session:
            response = await session.post(
                config.misc.crm_webhook_url,
                json=payload,
                headers={"Content-Type": "application/json"},
                timeout=aiohttp.ClientTimeout(total=30)
            )
            if response.status == 200:
                response_text = await response.text()
                logger.info(f"Данные опроса успешно отправлены в CRM для пользователя {user['telegram_id']}")
                logger.info(f"Ответ сервера CRM: {response_text}")
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
