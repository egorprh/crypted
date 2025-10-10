#!/usr/bin/env python3
"""
Скрипт для полной очистки тестовых данных из БД
"""

import sys
import os
import asyncio

# Добавляем корень проекта в sys.path
PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)

import sys
sys.path.append(os.path.join(PROJECT_ROOT, "backend"))
from db.pgapi import PGApi

async def cleanup_all_test_data():
    """Полная очистка всех тестовых данных"""
    db = PGApi()
    
    try:
        # Устанавливаем правильный путь к .env файлу
        env_path = os.path.join(PROJECT_ROOT, "backend", ".env")
        await db.create_with_env_path(env_path)
        
        print("🧹 Начинаем очистку тестовых данных...")
        
        # Удаляем все уведомления с тестовыми telegram_id
        result = await db.execute(
            "DELETE FROM notifications WHERE telegram_id > 100000",
            execute=True
        )
        print(f"✅ Удалено уведомлений: {result}")
        
        # Удаляем все подписки тестовых пользователей
        result = await db.execute(
            "DELETE FROM user_enrollment WHERE user_id IN (SELECT id FROM users WHERE telegram_id > 100000)",
            execute=True
        )
        print(f"✅ Удалено подписок: {result}")
        
        # Удаляем всех тестовых пользователей
        result = await db.execute(
            "DELETE FROM users WHERE telegram_id > 100000",
            execute=True
        )
        print(f"✅ Удалено пользователей: {result}")
        
        # Удаляем тестовые курсы
        result = await db.execute(
            "DELETE FROM courses WHERE title LIKE 'Test Course%' OR title LIKE 'Perf Test Course%'",
            execute=True
        )
        print(f"✅ Удалено курсов: {result}")
        
        print("🎉 Очистка завершена успешно!")
        
    except Exception as e:
        print(f"❌ Ошибка при очистке: {e}")
    finally:
        await db.close()

if __name__ == "__main__":
    asyncio.run(cleanup_all_test_data())
