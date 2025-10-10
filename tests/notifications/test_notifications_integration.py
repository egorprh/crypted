import sys
import os
import pytest
import pytest_asyncio
import asyncio
import random
import json
from datetime import datetime, timezone, timedelta
from typing import Dict, List

# Добавляем корень проекта в sys.path, чтобы импортировать backend/
PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
BACKEND_DIR = os.path.join(PROJECT_ROOT, "backend")
if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)
if BACKEND_DIR not in sys.path:
    sys.path.insert(0, BACKEND_DIR)

from backend.db.pgapi import PGApi


class TestNotificationsIntegration:
    """Интеграционные тесты системы уведомлений через API"""

    @pytest_asyncio.fixture(autouse=True)
    async def setup_and_cleanup(self):
        """Настройка и очистка для каждого теста"""
        self.db = PGApi()
        # Устанавливаем правильный путь к .env файлу
        import os
        env_path = os.path.join(PROJECT_ROOT, "backend", ".env")
        await self.db.create_with_env_path(env_path)  # Инициализируем подключение к БД
        self.test_users = []  # Список созданных пользователей для очистки
        
        # Очищаем все тестовые данные перед тестом
        await self._cleanup_all_test_data()
        
        # Уникальная временная метка для каждого теста
        import time
        self.test_timestamp = int(time.time())  # Unix timestamp в секундах
        
        yield
        
        # Очистка после теста
        await self._cleanup_test_data()
        # Закрываем пул подключений
        await self.db.close()

    async def _cleanup_test_data(self):
        """Очистка всех тестовых данных"""
        try:
            # Удаляем уведомления тестовых пользователей
            for user in self.test_users:
                await self.db.delete_records("notifications", {"user_id": user["id"]})
                await self.db.delete_records("user_enrollment", {"user_id": user["id"]})
                await self.db.delete_record("users", user["id"])
                
        except Exception as e:
            print(f"Ошибка при очистке тестовых данных: {e}")

    async def _cleanup_all_test_data(self):
        """Глобальная очистка всех тестовых данных перед запуском тестов"""
        try:
            # Удаляем все уведомления с тестовыми telegram_id (больше 100000)
            await self.db.execute(
                "DELETE FROM notifications WHERE telegram_id > 100000",
                execute=True
            )
            
            # Удаляем все подписки тестовых пользователей
            await self.db.execute(
                "DELETE FROM user_enrollment WHERE user_id IN (SELECT id FROM users WHERE telegram_id > 100000)",
                execute=True
            )
            
            # Удаляем всех тестовых пользователей
            await self.db.execute(
                "DELETE FROM users WHERE telegram_id > 100000",
                execute=True
            )
            
            # Дополнительная очистка: удаляем все уведомления с тестовыми telegram_id
            await self.db.execute(
                "DELETE FROM notifications WHERE telegram_id > 100000",
                execute=True
            )
            
        except Exception as e:
            print(f"Ошибка при глобальной очистке тестовых данных: {e}")

    def _compare_notification_objects(self, expected: dict, actual: dict, test_name: str = ""):
        """
        Универсальный метод для сравнения объектов уведомлений
        
        Args:
            expected: Ожидаемый объект уведомления
            actual: Фактический объект уведомления из БД
            test_name: Название теста для отладки
        """
        # Проверяем основные поля
        assert actual["user_id"] == expected["user_id"], f"{test_name}: user_id не совпадает: ожидался {expected['user_id']}, получен {actual['user_id']}"
        assert actual["telegram_id"] == expected["telegram_id"], f"{test_name}: telegram_id не совпадает: ожидался {expected['telegram_id']}, получен {actual['telegram_id']}"
        assert actual["message"] == expected["message"], f"{test_name}: message не совпадает: ожидался {expected['message']}, получен {actual['message']}"
        assert actual["status"] == expected["status"], f"{test_name}: status не совпадает: ожидался {expected['status']}, получен {actual['status']}"
        assert actual["attempts"] == expected["attempts"], f"{test_name}: attempts не совпадает: ожидался {expected['attempts']}, получен {actual['attempts']}"
        assert actual["max_attempts"] == expected["max_attempts"], f"{test_name}: max_attempts не совпадает: ожидался {expected['max_attempts']}, получен {actual['max_attempts']}"
        
        # Проверяем время планирования (с допуском в 1 минуту)
        if "scheduled_at" in expected:
            time_diff = abs((actual["scheduled_at"] - expected["scheduled_at"]).total_seconds())
            assert time_diff < 60, f"{test_name}: scheduled_at не совпадает: ожидался {expected['scheduled_at']}, получен {actual['scheduled_at']}, разница {time_diff} сек"
        
        # Проверяем ext_data
        if "ext_data" in expected:
            if expected["ext_data"] is None:
                assert actual["ext_data"] is None or actual["ext_data"] == "", f"{test_name}: ext_data должен быть пустым, получен: {actual['ext_data']}"
            else:
                assert actual["ext_data"] is not None, f"{test_name}: ext_data не должен быть пустым"
                assert actual["ext_data"] != "", f"{test_name}: ext_data не должен быть пустой строкой"
                
                # Проверяем, что это валидный JSON
                import json
                try:
                    actual_ext_data = json.loads(actual["ext_data"])
                    expected_ext_data = expected["ext_data"]
                    
                    # Сравниваем содержимое JSON
                    for key, value in expected_ext_data.items():
                        assert key in actual_ext_data, f"{test_name}: ext_data не содержит ключ '{key}'"
                        assert actual_ext_data[key] == value, f"{test_name}: ext_data['{key}'] не совпадает: ожидался {value}, получен {actual_ext_data[key]}"
                        
                except json.JSONDecodeError:
                    assert False, f"{test_name}: ext_data не является валидным JSON: {actual['ext_data']}"
        
        # Проверяем dedup_key
        if "dedup_key" in expected:
            if expected["dedup_key"] is None:
                assert actual["dedup_key"] is None or actual["dedup_key"] == "", f"{test_name}: dedup_key должен быть пустым, получен: {actual['dedup_key']}"
            else:
                assert actual["dedup_key"] is not None, f"{test_name}: dedup_key не должен быть пустым"
                assert actual["dedup_key"] != "", f"{test_name}: dedup_key не должен быть пустой строкой"
                
                # Проверяем формат dedup_key
                parts = actual["dedup_key"].split(":")
                assert len(parts) >= 3, f"{test_name}: Неверный формат dedup_key: {actual['dedup_key']}"
                assert parts[0] == str(expected["telegram_id"]), f"{test_name}: telegram_id в dedup_key не совпадает: {actual['dedup_key']}"
        
        # Проверяем типы данных
        assert isinstance(actual["id"], int), f"{test_name}: id должен быть int, получен: {type(actual['id'])}"
        assert isinstance(actual["user_id"], int), f"{test_name}: user_id должен быть int, получен: {type(actual['user_id'])}"
        assert isinstance(actual["telegram_id"], int), f"{test_name}: telegram_id должен быть int, получен: {type(actual['telegram_id'])}"
        assert isinstance(actual["message"], str), f"{test_name}: message должен быть str, получен: {type(actual['message'])}"
        assert isinstance(actual["status"], str), f"{test_name}: status должен быть str, получен: {type(actual['status'])}"
        assert isinstance(actual["scheduled_at"], datetime), f"{test_name}: scheduled_at должен быть datetime, получен: {type(actual['scheduled_at'])}"
        assert isinstance(actual["attempts"], int), f"{test_name}: attempts должен быть int, получен: {type(actual['attempts'])}"
        assert isinstance(actual["max_attempts"], int), f"{test_name}: max_attempts должен быть int, получен: {type(actual['max_attempts'])}"
        
        if actual["ext_data"]:
            assert isinstance(actual["ext_data"], str), f"{test_name}: ext_data должен быть str (JSON), получен: {type(actual['ext_data'])}"
        
        if actual["dedup_key"]:
            assert isinstance(actual["dedup_key"], str), f"{test_name}: dedup_key должен быть str, получен: {type(actual['dedup_key'])}"

    async def _create_test_user(self, telegram_id: int = None) -> Dict:
        """Создает тестового пользователя"""
        if telegram_id is None:
            # Используем уникальную временную метку + случайное число для telegram_id
            import time
            base_id = getattr(self, 'test_timestamp', int(time.time())) * 1000
            telegram_id = base_id + random.randint(1, 999)
        
        user_data = {
            "telegram_id": telegram_id,
            "username": f"test_user_{telegram_id}",
            "first_name": f"Test{telegram_id}",
            "last_name": "User",
            "level": 0
        }
        
        user_id = await self.db.insert_record("users", user_data)
        user_data["id"] = user_id
        self.test_users.append(user_data)
        return user_data

    async def _get_user_notifications(self, user_id: int) -> List[Dict]:
        """Получает все уведомления пользователя"""
        return await self.db.get_records("notifications", {"user_id": user_id})

    async def _get_notifications_by_telegram_id(self, telegram_id: int) -> List[Dict]:
        """Получает все уведомления по telegram_id"""
        return await self.db.get_records("notifications", {"telegram_id": telegram_id})

    @pytest.mark.asyncio
    async def test_save_level_api_integration(self):
        """Тест интеграции с API save_level"""
        # Создаем пользователя
        user = await self._create_test_user()
        
        # Проверяем, что у пользователя нет уведомлений
        initial_notifications = await self._get_user_notifications(user["id"])
        assert len(initial_notifications) == 0, "У нового пользователя не должно быть уведомлений"
        
        # Имитируем вызов API save_level (как в main.py)
        # Получаем уровень "Средний" (id=2)
        level = await self.db.get_record("levels", {"id": 2})
        assert level is not None, "Уровень 'Средний' должен существовать в БД"
        
        # Обновляем уровень пользователя (как в API)
        await self.db.update_record("users", user["id"], {"level": 2})
        
        # Имитируем логику из main.py для планирования уведомлений
        level_row = await self.db.get_record("levels", {"id": 2})
        is_pro = False
        try:
            short_name = (level_row or {}).get("short_name")
            is_pro = (str(short_name).lower() == "advanced")
        except Exception:
            is_pro = False
        
        # Планируем уведомления (как в main.py)
        from backend.notifications.notifications import schedule_on_user_created
        
        enrolled_at = datetime.now(timezone.utc)
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=is_pro
        )
        
        # Проверяем, что уведомления создались
        notifications = await self._get_user_notifications(user["id"])
        assert len(notifications) == 5, f"Ожидалось 5 уведомлений для среднего уровня, получено {len(notifications)}"
        
        # Проверяем типы уведомлений
        messages = [n["message"] for n in notifications]
        expected_messages = [
            "welcome_1",
            "welcome_2", 
            "progress_slot_day1_1934",
            "progress_slot_day2_2022",
            "progress_slot_day3_0828"
        ]
        
        for expected in expected_messages:
            assert expected in messages, f"Уведомление '{expected}' не найдено"
        
        # Проверяем корректность ext_data для каждого типа уведомления
        notification_map = {n["message"]: n for n in notifications}
        
        # Проверяем welcome уведомления
        welcome1 = notification_map.get("welcome_1")
        if welcome1 and welcome1["ext_data"]:
            import json
            ext_data = json.loads(welcome1["ext_data"])
            assert "track" in ext_data, "ext_data для welcome_1 должен содержать 'track'"
            assert ext_data["track"] == "newbie", f"track должен быть 'newbie', получен: {ext_data['track']}"
        
        # Проверяем progress_slot уведомления
        progress1 = notification_map.get("progress_slot_day1_1934")
        if progress1 and progress1["ext_data"]:
            import json
            ext_data = json.loads(progress1["ext_data"])
            assert "slot" in ext_data, "ext_data для progress_slot_day1_1934 должен содержать 'slot'"
            assert ext_data["slot"] == "day1_19:34", f"slot должен быть 'day1_19:34', получен: {ext_data['slot']}"
        
        # Проверяем, что все уведомления имеют правильные типы данных
        for notification in notifications:
            assert isinstance(notification["id"], int), f"id должен быть int, получен: {type(notification['id'])}"
            assert isinstance(notification["user_id"], int), f"user_id должен быть int, получен: {type(notification['user_id'])}"
            assert isinstance(notification["telegram_id"], int), f"telegram_id должен быть int, получен: {type(notification['telegram_id'])}"
            assert isinstance(notification["message"], str), f"message должен быть str, получен: {type(notification['message'])}"
            assert isinstance(notification["status"], str), f"status должен быть str, получен: {type(notification['status'])}"
            assert notification["status"] == "pending", f"status должен быть 'pending', получен: {notification['status']}"
            assert isinstance(notification["scheduled_at"], datetime), f"scheduled_at должен быть datetime, получен: {type(notification['scheduled_at'])}"
            assert isinstance(notification["attempts"], int), f"attempts должен быть int, получен: {type(notification['attempts'])}"
            assert notification["attempts"] == 0, f"attempts должен быть 0, получен: {notification['attempts']}"
            assert isinstance(notification["max_attempts"], int), f"max_attempts должен быть int, получен: {type(notification['max_attempts'])}"
            assert notification["max_attempts"] == 5, f"max_attempts должен быть 5, получен: {notification['max_attempts']}"

    @pytest.mark.asyncio
    async def test_pro_level_api_integration(self):
        """Тест интеграции с API save_level для профи"""
        # Создаем пользователя
        user = await self._create_test_user()
        
        # Имитируем вызов API save_level для профи
        # Получаем уровень "Продвинутый" (id=3)
        level = await self.db.get_record("levels", {"id": 3})
        assert level is not None, "Уровень 'Продвинутый' должен существовать в БД"
        
        # Обновляем уровень пользователя
        await self.db.update_record("users", user["id"], {"level": 3})
        
        # Имитируем логику из main.py
        level_row = await self.db.get_record("levels", {"id": 3})
        is_pro = False
        try:
            short_name = (level_row or {}).get("short_name")
            is_pro = (str(short_name).lower() == "advanced")
        except Exception:
            is_pro = False
        
        # Планируем уведомления
        from backend.notifications.notifications import schedule_on_user_created
        
        enrolled_at = datetime.now(timezone.utc)
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=is_pro
        )
        
        # Проверяем, что уведомления создались
        notifications = await self._get_user_notifications(user["id"])
        assert len(notifications) == 2, f"Ожидалось 2 уведомления для профи, получено {len(notifications)}"
        
        # Проверяем типы уведомлений
        messages = [n["message"] for n in notifications]
        expected_messages = ["pro_welcome_12m", "pro_next_day"]
        
        for expected in expected_messages:
            assert expected in messages, f"Уведомление '{expected}' не найдено"
        
        # Проверяем корректность ext_data для профи
        notification_map = {n["message"]: n for n in notifications}
        
        # Проверяем pro_welcome_12m
        pro_welcome = notification_map.get("pro_welcome_12m")
        if pro_welcome and pro_welcome["ext_data"]:
            import json
            ext_data = json.loads(pro_welcome["ext_data"])
            assert "track" in ext_data, "ext_data для pro_welcome_12m должен содержать 'track'"
            assert ext_data["track"] == "pro", f"track должен быть 'pro', получен: {ext_data['track']}"
        
        # Проверяем pro_next_day
        pro_next = notification_map.get("pro_next_day")
        if pro_next and pro_next["ext_data"]:
            import json
            ext_data = json.loads(pro_next["ext_data"])
            assert "track" in ext_data, "ext_data для pro_next_day должен содержать 'track'"
            assert ext_data["track"] == "pro", f"track должен быть 'pro', получен: {ext_data['track']}"
        
        # Проверяем, что все уведомления имеют правильные типы данных
        for notification in notifications:
            assert isinstance(notification["id"], int), f"id должен быть int, получен: {type(notification['id'])}"
            assert isinstance(notification["user_id"], int), f"user_id должен быть int, получен: {type(notification['user_id'])}"
            assert isinstance(notification["telegram_id"], int), f"telegram_id должен быть int, получен: {type(notification['telegram_id'])}"
            assert isinstance(notification["message"], str), f"message должен быть str, получен: {type(notification['message'])}"
            assert isinstance(notification["status"], str), f"status должен быть str, получен: {type(notification['status'])}"
            assert notification["status"] == "pending", f"status должен быть 'pending', получен: {notification['status']}"
            assert isinstance(notification["scheduled_at"], datetime), f"scheduled_at должен быть datetime, получен: {type(notification['scheduled_at'])}"
            assert isinstance(notification["attempts"], int), f"attempts должен быть int, получен: {type(notification['attempts'])}"
            assert notification["attempts"] == 0, f"attempts должен быть 0, получен: {notification['attempts']}"
            assert isinstance(notification["max_attempts"], int), f"max_attempts должен быть int, получен: {type(notification['max_attempts'])}"
            assert notification["max_attempts"] == 5, f"max_attempts должен быть 5, получен: {notification['max_attempts']}"

    @pytest.mark.asyncio
    async def test_multiple_level_changes(self):
        """Тест множественных изменений уровня пользователя"""
        # Создаем пользователя
        user = await self._create_test_user()
        
        # Изменяем уровень с 0 на 1 (Начальный)
        await self.db.update_record("users", user["id"], {"level": 1})
        
        from backend.notifications.notifications import schedule_on_user_created
        
        enrolled_at = datetime.now(timezone.utc)
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False
        )
        
        # Проверяем количество уведомлений после первого изменения
        notifications_1 = await self._get_user_notifications(user["id"])
        count_1 = len(notifications_1)
        
        # Изменяем уровень с 1 на 2 (Средний)
        await self.db.update_record("users", user["id"], {"level": 2})
        
        # Планируем уведомления снова
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False
        )
        
        # Проверяем количество уведомлений после второго изменения
        notifications_2 = await self._get_user_notifications(user["id"])
        count_2 = len(notifications_2)
        
        # Количество должно остаться тем же (дедупликация работает)
        assert count_1 == count_2, f"Дедупликация не работает при изменении уровня: {count_1} -> {count_2}"

    @pytest.mark.asyncio
    async def test_notification_status_consistency(self):
        """Тест консистентности статуса уведомлений"""
        # Создаем пользователя
        user = await self._create_test_user()
        
        # Планируем уведомления
        from backend.notifications.notifications import schedule_on_user_created
        
        enrolled_at = datetime.now(timezone.utc)
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False
        )
        
        # Получаем уведомления
        notifications = await self._get_user_notifications(user["id"])
        
        # Проверяем консистентность данных
        for notification in notifications:
            # Статус должен быть 'pending'
            assert notification["status"] == "pending", f"Неверный статус уведомления: {notification['status']}"
            
            # attempts должен быть 0
            assert notification["attempts"] == 0, f"Неверное количество попыток: {notification['attempts']}"
            
            # max_attempts должен быть 5
            assert notification["max_attempts"] == 5, f"Неверное максимальное количество попыток: {notification['max_attempts']}"
            
            # channel должен быть 'telegram'
            assert notification["channel"] == "telegram", f"Неверный канал: {notification['channel']}"
            
            # telegram_id должен совпадать с пользователем
            assert notification["telegram_id"] == user["telegram_id"], f"Неверный telegram_id: {notification['telegram_id']}"
            
            # user_id должен совпадать с пользователем
            assert notification["user_id"] == user["id"], f"Неверный user_id: {notification['user_id']}"
            
            # scheduled_at должен быть в будущем
            assert notification["scheduled_at"] > datetime.now(timezone.utc), f"Время отправки должно быть в будущем: {notification['scheduled_at']}"
            
            # sent_at должен быть None
            assert notification["sent_at"] is None, f"sent_at должен быть None для новых уведомлений: {notification['sent_at']}"

    @pytest.mark.asyncio
    async def test_notification_ext_data_format(self):
        """Тест формата ext_data в уведомлениях"""
        # Создаем пользователя
        user = await self._create_test_user()
        
        # Планируем уведомления
        from backend.notifications.notifications import schedule_on_user_created
        
        enrolled_at = datetime.now(timezone.utc)
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False
        )
        
        # Получаем уведомления
        notifications = await self._get_user_notifications(user["id"])
        
        # Проверяем ext_data для каждого типа уведомления
        notification_map = {n["message"]: n for n in notifications}
        
        # Проверяем welcome уведомления
        welcome1 = notification_map.get("welcome_1")
        if welcome1 and welcome1["ext_data"]:
            ext_data_str = welcome1["ext_data"]
            # ext_data должен быть корректным JSON
            import json
            ext_data = json.loads(ext_data_str) if ext_data_str else {}
            assert "track" in ext_data, "ext_data для welcome_1 должен содержать 'track'"
            assert ext_data["track"] == "newbie", f"track должен быть 'newbie', получен: {ext_data['track']}"
        
        # Проверяем progress_slot уведомления
        progress1 = notification_map.get("progress_slot_day1_1934")
        if progress1 and progress1["ext_data"]:
            ext_data_str = progress1["ext_data"]
            # ext_data должен быть корректным JSON
            import json
            ext_data = json.loads(ext_data_str) if ext_data_str else {}
            assert "slot" in ext_data, "ext_data для progress_slot должен содержать 'slot'"
            assert ext_data["slot"] == "day1_19:34", f"slot должен быть 'day1_19:34', получен: {ext_data['slot']}"

    @pytest.mark.asyncio
    async def test_notification_cleanup_on_user_deletion(self):
        """Тест очистки уведомлений при удалении пользователя"""
        # Создаем пользователя
        user = await self._create_test_user()
        
        # Планируем уведомления
        from backend.notifications.notifications import schedule_on_user_created
        
        enrolled_at = datetime.now(timezone.utc)
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False
        )
        
        # Проверяем, что уведомления создались
        notifications_before = await self._get_user_notifications(user["id"])
        assert len(notifications_before) > 0, "Уведомления должны быть созданы"
        
        # Удаляем пользователя (каскадное удаление должно удалить уведомления)
        await self.db.delete_record("users", user["id"])
        
        # Проверяем, что уведомления удалились
        notifications_after = await self._get_user_notifications(user["id"])
        assert len(notifications_after) == 0, "Уведомления должны быть удалены при удалении пользователя"
        
        # Убираем пользователя из списка для очистки (он уже удален)
        self.test_users = [u for u in self.test_users if u["id"] != user["id"]]

    @pytest.mark.asyncio
    async def test_notification_scheduling_edge_cases(self):
        """Тест граничных случаев планирования уведомлений"""
        # Создаем пользователя
        user = await self._create_test_user()
        
        # Тестируем планирование в прошлом (должно работать)
        past_time = datetime.now(timezone.utc) - timedelta(hours=1)
        
        from backend.notifications.notifications import enqueue_notification
        
        notification_id = await enqueue_notification(
            db=self.db,
            user_id=user["id"],
            telegram_id=user["telegram_id"],
            message="test_past_notification",
            when=past_time,
            kind="test_past",
            ext_data={"test": "past"}
        )
        
        assert notification_id > 0, "Уведомление в прошлом должно быть создано"
        
        # Получаем созданное уведомление
        notifications = await self._get_user_notifications(user["id"])
        test_notification = next((n for n in notifications if n["message"] == "test_past_notification"), None)
        
        assert test_notification is not None, "Тестовое уведомление должно быть найдено"
        assert test_notification["scheduled_at"] == past_time, "Время отправки должно совпадать с переданным"

    @pytest.mark.asyncio
    async def test_notification_deduplication_with_different_times(self):
        """Тест дедупликации с разными временами"""
        # Создаем пользователя
        user = await self._create_test_user()
        
        from backend.notifications.notifications import enqueue_notification
        
        # Создаем уведомление
        time1 = datetime.now(timezone.utc) + timedelta(minutes=10)
        notification_id1 = await enqueue_notification(
            db=self.db,
            user_id=user["id"],
            telegram_id=user["telegram_id"],
            message="test_dedup",
            when=time1,
            kind="test_dedup",
            ext_data={"test": "dedup"}
        )
        
        # Создаем уведомление с тем же kind, но другим временем (должно создать новое)
        time2 = datetime.now(timezone.utc) + timedelta(minutes=20)
        notification_id2 = await enqueue_notification(
            db=self.db,
            user_id=user["id"],
            telegram_id=user["telegram_id"],
            message="test_dedup",
            when=time2,
            kind="test_dedup",
            ext_data={"test": "dedup"}
        )
        
        # Должны быть созданы два разных уведомления
        assert notification_id1 != notification_id2, "Уведомления с разным временем должны быть разными"
        
        # Получаем уведомления
        notifications = await self._get_user_notifications(user["id"])
        test_notifications = [n for n in notifications if n["message"] == "test_dedup"]
        
        assert len(test_notifications) == 2, f"Должно быть 2 тестовых уведомления, получено {len(test_notifications)}"


if __name__ == "__main__":
    # Запуск тестов
    pytest.main([__file__, "-v"])
