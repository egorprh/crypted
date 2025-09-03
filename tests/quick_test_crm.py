#!/usr/bin/env python3
"""
Быстрый тест функции send_survey_to_crm без pytest
"""

import asyncio
import sys
import os

# Добавляем путь к модулям backend
sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'backend'))

from misc import send_survey_to_crm


async def quick_test():
    """Быстрый тест функции отправки в CRM"""
    
    # Тестовые данные
    test_user = {
        "telegram_id": 123456789,
        "username": "test_user",
        "first_name": "Тест",
        "last_name": "Пользователь"
    }
    
    test_survey_data = [
        {
            "question": "Как вас зовут?",
            "answer": "Иван Иванов"
        },
        {
            "question": "Ваш возраст?",
            "answer": "25"
        },
        {
            "question": "Телефон?",
            "answer": "+7 (999) 123-45-67"
        },
        {
            "question": "Ваш опыт в трейдинге?",
            "answer": "Начинающий"
        },
        {
            "question": "Какую сумму планируете инвестировать?",
            "answer": "1000-5000 USD"
        }
    ]
    
    test_level = {
        "id": 1,
        "name": "Начинающий"
    }
    
    print("🚀 Быстрый тест функции send_survey_to_crm")
    print(f"👤 Пользователь: {test_user}")
    print(f"📝 Данные опроса: {len(test_survey_data)} вопросов")
    print(f"📊 Уровень: {test_level}")
    print("-" * 50)
    
    try:
        await send_survey_to_crm(test_user, test_survey_data, test_level)
        print("✅ Тест завершен успешно")
        print("💡 Проверьте логи для деталей")
    except Exception as e:
        print(f"❌ Ошибка в тесте: {e}")


if __name__ == "__main__":
    asyncio.run(quick_test())
