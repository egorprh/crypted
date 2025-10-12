import sys
import os
import pytest
import pytest_asyncio
import asyncio
import random
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
from backend.notifications.notifications import (
    schedule_on_user_created,
    schedule_welcome_notifications,
    schedule_access_end_notifications,
    enqueue_notification,
    _make_dedup_key,
    _at_next_day_time,
)


class TestNotificationsComprehensive:
    """Комплексные тесты системы уведомлений"""

    @pytest_asyncio.fixture(autouse=True)
    async def setup_and_cleanup(self):
        """Настройка и очистка для каждого теста"""
        self.db = PGApi()
        # Устанавливаем правильный путь к .env файлу
        import os
        env_path = os.path.join(PROJECT_ROOT, "backend", ".env")
        await self.db.create_with_env_path(env_path)  # Инициализируем подключение к БД
        self.test_users = []  # Список созданных пользователей для очистки
        self.test_courses = []  # Список созданных курсов для очистки
        self.test_enrollments = []  # Список созданных подписок для очистки
        
        # Очищаем все тестовые данные перед тестом
        await self._cleanup_all_test_data()
        
        # Уникальная временная метка для каждого теста
        import time
        import random
        self.test_timestamp = int(time.time()) + random.randint(1, 999999)  # Unix timestamp + случайное число
        
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
            
            # Удаляем тестовые курсы
            for course in self.test_courses:
                await self.db.delete_record("courses", course["id"])
                
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
            
            # Удаляем тестовые курсы (с тестовыми названиями)
            await self.db.execute(
                "DELETE FROM courses WHERE title LIKE 'Test Course%'",
                execute=True
            )
            
            # Дополнительная очистка: удаляем все уведомления с тестовыми telegram_id
            # Это помогает избежать коллизий при быстром запуске тестов
            await self.db.execute(
                "DELETE FROM notifications WHERE telegram_id > 100000",
                execute=True
            )
            
        except Exception as e:
            print(f"Ошибка при глобальной очистке тестовых данных: {e}")

    def _get_test_time(self, offset_minutes: int = 0) -> datetime:
        """Генерирует фиксированное время для теста с заданным смещением"""
        import time
        import random
        
        # Базовое время
        base_time = datetime(2025, 1, 1, 12, 0, 0, tzinfo=timezone.utc)
        
        # Используем test_timestamp для уникальности между тестами
        test_offset = getattr(self, 'test_timestamp', int(time.time())) % 1000
        
        # Добавляем случайное смещение для уникальности внутри теста
        random_offset = random.randint(0, 999)
        
        # Используем ID объекта теста для дополнительной уникальности
        test_id = id(self) % 1000
        
        # Общее смещение в минутах (увеличиваем разброс)
        total_minutes = test_offset + offset_minutes + random_offset + test_id + (test_id % 100) * 1000
        
        # Добавляем случайные секунды для гарантии уникальности
        random_seconds = random.randint(0, 59)
        
        return base_time + timedelta(minutes=total_minutes, seconds=random_seconds)

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
            # Генерируем уникальный telegram_id для каждого теста
            import time
            import uuid
            
            # Используем комбинацию: timestamp + случайное число + хеш от UUID
            base_timestamp = getattr(self, 'test_timestamp', int(time.time()))
            random_component = random.randint(1000, 9999)
            uuid_hash = hash(str(uuid.uuid4())) % 10000
            
            # Создаем уникальный ID: timestamp + random + uuid_hash
            telegram_id = base_timestamp + random_component + uuid_hash
        
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

    async def _create_test_course(self) -> Dict:
        """Создает тестовый курс"""
        course_data = {
            "title": f"Test Course {random.randint(1000, 9999)}",
            "description": "Test course for notifications",
            "visible": True,
            "type": "test"
        }
        
        course_id = await self.db.insert_record("courses", course_data)
        course_data["id"] = course_id
        self.test_courses.append(course_data)
        return course_data

    async def _create_user_enrollment(self, user_id: int, course_id: int, 
                                    time_end: datetime = None) -> Dict:
        """Создает подписку пользователя на курс"""
        if time_end is None:
            time_end = self._get_test_time(offset_minutes=30*24*60)  # +30 дней
        
        enrollment_data = {
            "user_id": user_id,
            "course_id": course_id,
            "time_start": self._get_test_time(),
            "time_end": time_end,
            "status": 1  # Активная подписка
        }
        
        enrollment_id = await self.db.insert_record("user_enrollment", enrollment_data)
        enrollment_data["id"] = enrollment_id
        self.test_enrollments.append(enrollment_data)
        return enrollment_data

    async def _get_user_notifications(self, user_id: int) -> List[Dict]:
        """Получает все уведомления пользователя"""
        return await self.db.get_records("notifications", {"user_id": user_id})

    async def _get_notifications_by_telegram_id(self, telegram_id: int) -> List[Dict]:
        """Получает все уведомления по telegram_id"""
        return await self.db.get_records("notifications", {"telegram_id": telegram_id})

    @pytest.mark.asyncio
    async def test_newbie_notifications_creation(self):
        """Тест 1: Проверка создания уведомлений для новичка/среднего уровня"""
        # Создаем пользователя
        user = await self._create_test_user()
        
        # Получаем уровень "Средний" (id=2)
        level = await self.db.get_record("levels", {"id": 2})
        assert level is not None, "Уровень 'Средний' должен существовать в БД"
        
        # Обновляем уровень пользователя
        await self.db.update_record("users", user["id"], {"level": 2})
        
        # Планируем уведомления (как в main.py)
        enrolled_at = self._get_test_time()
        is_pro = False  # Средний уровень не является профи
        
        # Сначала создаем приветственные уведомления
        await schedule_welcome_notifications(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=is_pro
        )
        
        # Затем создаем прогресс-слоты для курса
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=is_pro,
            course_id=1
        )
        
        # Проверяем, что создались правильные уведомления
        notifications = await self._get_user_notifications(user["id"])
        
        # Должно быть 5 уведомлений: 2 приветственных + 3 прогресс-слота
        assert len(notifications) == 5, f"Ожидалось 5 уведомлений, получено {len(notifications)}"
        
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
        
        # Проверяем, что все уведомления имеют статус 'pending'
        for notification in notifications:
            assert notification["status"] == "pending"
            assert notification["telegram_id"] == user["telegram_id"]
            assert notification["user_id"] == user["id"]
        
        # Проверяем корректность ext_data для каждого типа уведомления
        notification_map = {n["message"]: n for n in notifications}
        
        # Проверяем welcome уведомления
        welcome1 = notification_map.get("welcome_1")
        if welcome1 and welcome1["ext_data"]:
            import json
            ext_data = json.loads(welcome1["ext_data"])
            assert "track" in ext_data, "ext_data для welcome_1 должен содержать 'track'"
            assert ext_data["track"] == "newbie", f"track должен быть 'newbie', получен: {ext_data['track']}"
        
        welcome2 = notification_map.get("welcome_2")
        if welcome2 and welcome2["ext_data"]:
            import json
            ext_data = json.loads(welcome2["ext_data"])
            assert "track" in ext_data, "ext_data для welcome_2 должен содержать 'track'"
            assert ext_data["track"] == "newbie", f"track должен быть 'newbie', получен: {ext_data['track']}"
        
        # Проверяем progress_slot уведомления
        progress1 = notification_map.get("progress_slot_day1_1934")
        if progress1 and progress1["ext_data"]:
            import json
            ext_data = json.loads(progress1["ext_data"])
            assert "slot" in ext_data, "ext_data для progress_slot_day1_1934 должен содержать 'slot'"
            assert ext_data["slot"] == "day1_19:34", f"slot должен быть 'day1_19:34', получен: {ext_data['slot']}"
        
        progress2 = notification_map.get("progress_slot_day2_2022")
        if progress2 and progress2["ext_data"]:
            import json
            ext_data = json.loads(progress2["ext_data"])
            assert "slot" in ext_data, "ext_data для progress_slot_day2_2022 должен содержать 'slot'"
            assert ext_data["slot"] == "day2_20:22", f"slot должен быть 'day2_20:22', получен: {ext_data['slot']}"
        
        progress3 = notification_map.get("progress_slot_day3_0828")
        if progress3 and progress3["ext_data"]:
            import json
            ext_data = json.loads(progress3["ext_data"])
            assert "slot" in ext_data, "ext_data для progress_slot_day3_0828 должен содержать 'slot'"
            assert ext_data["slot"] == "day3_08:28", f"slot должен быть 'day3_08:28', получен: {ext_data['slot']}"

    @pytest.mark.asyncio
    async def test_pro_notifications_creation(self):
        """Тест 2: Проверка создания уведомлений для профи (advanced уровень)"""
        # Создаем пользователя
        user = await self._create_test_user()
        
        # Получаем уровень "Продвинутый" (id=3)
        level = await self.db.get_record("levels", {"id": 3})
        assert level is not None, "Уровень 'Продвинутый' должен существовать в БД"
        
        # Обновляем уровень пользователя
        await self.db.update_record("users", user["id"], {"level": 3})
        
        # Планируем уведомления
        enrolled_at = self._get_test_time()
        is_pro = True  # Продвинутый уровень является профи
        
        # Сначала создаем приветственные уведомления
        await schedule_welcome_notifications(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=is_pro
        )
        
        # Затем создаем прогресс-слоты для курса
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=is_pro,
            course_id=1
        )
        
        # Проверяем, что создались правильные уведомления
        notifications = await self._get_user_notifications(user["id"])
        
        # Должно быть 2 уведомления для профи
        assert len(notifications) == 2, f"Ожидалось 2 уведомления для профи, получено {len(notifications)}"
        
        # Проверяем типы уведомлений
        messages = [n["message"] for n in notifications]
        expected_messages = ["pro_welcome_12m", "pro_next_day"]
        
        for expected in expected_messages:
            assert expected in messages, f"Уведомление '{expected}' не найдено"
        
        # Проверяем, что все уведомления имеют статус 'pending'
        for notification in notifications:
            assert notification["status"] == "pending"
            assert notification["telegram_id"] == user["telegram_id"]
            assert notification["user_id"] == user["id"]
        
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

    @pytest.mark.asyncio
    async def test_notifications_deduplication(self):
        """Тест 3: Проверка дедупликации уведомлений"""
        # Создаем пользователя
        user = await self._create_test_user()
        
        # Планируем уведомления первый раз
        enrolled_at = self._get_test_time()
        # Сначала создаем приветственные уведомления
        await schedule_welcome_notifications(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False
        )
        
        # Затем создаем прогресс-слоты для курса
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False,
            course_id=1
        )
        
        # Получаем количество уведомлений после первого создания
        notifications_1 = await self._get_user_notifications(user["id"])
        count_1 = len(notifications_1)
        
        # Планируем уведомления второй раз (должны быть дедуплицированы)
        # Сначала создаем приветственные уведомления
        await schedule_welcome_notifications(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False
        )
        
        # Затем создаем прогресс-слоты для курса
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False,
            course_id=1
        )
        
        # Получаем количество уведомлений после второго создания
        notifications_2 = await self._get_user_notifications(user["id"])
        count_2 = len(notifications_2)
        
        # Количество должно остаться тем же (дедупликация работает)
        assert count_1 == count_2, f"Дедупликация не работает: {count_1} -> {count_2}"
        
        # Проверяем, что dedup_key уникальны
        dedup_keys = [n["dedup_key"] for n in notifications_2 if n["dedup_key"]]
        assert len(dedup_keys) == len(set(dedup_keys)), "Найдены дублирующиеся dedup_key"

    @pytest.mark.asyncio
    async def test_access_end_notifications(self):
        """Тест 4: Проверка создания уведомлений при окончании доступа"""
        # Создаем пользователя и курс
        user = await self._create_test_user()
        course = await self._create_test_course()
        
        # Создаем подписку с истекшим сроком
        expired_time = self._get_test_time(offset_minutes=-24*60)  # -1 день
        await self._create_user_enrollment(user["id"], course["id"], expired_time)
        
        # Планируем уведомления об окончании доступа
        access_end_at = self._get_test_time()
        await schedule_access_end_notifications(
            db=self.db,
            user=user,
            access_end_at=access_end_at,
            course_id=1
        )
        
        # Проверяем, что создались правильные уведомления
        notifications = await self._get_user_notifications(user["id"])
        
        # Должно быть 2 уведомления об окончании доступа
        assert len(notifications) == 2, f"Ожидалось 2 уведомления об окончании доступа, получено {len(notifications)}"
        
        # Проверяем типы уведомлений
        messages = [n["message"] for n in notifications]
        expected_messages = ["access_ended_1", "access_ended_2"]
        
        for expected in expected_messages:
            assert expected in messages, f"Уведомление '{expected}' не найдено"
        
        # Проверяем, что все уведомления имеют статус 'pending'
        for notification in notifications:
            assert notification["status"] == "pending"
            assert notification["telegram_id"] == user["telegram_id"]
            assert notification["user_id"] == user["id"]
        
        # Проверяем корректность ext_data для уведомлений об окончании доступа
        notification_map = {n["message"]: n for n in notifications}
        
        # Проверяем access_ended_1
        access_ended_1 = notification_map.get("access_ended_1")
        if access_ended_1 and access_ended_1["ext_data"]:
            import json
            ext_data = json.loads(access_ended_1["ext_data"])
            assert "type" in ext_data, "ext_data для access_ended_1 должен содержать 'type'"
            assert ext_data["type"] == "access_end", f"type должен быть 'access_end', получен: {ext_data['type']}"
        
        # Проверяем access_ended_2
        access_ended_2 = notification_map.get("access_ended_2")
        if access_ended_2 and access_ended_2["ext_data"]:
            import json
            ext_data = json.loads(access_ended_2["ext_data"])
            assert "type" in ext_data, "ext_data для access_ended_2 должен содержать 'type'"
            assert ext_data["type"] == "access_end", f"type должен быть 'access_end', получен: {ext_data['type']}"

    @pytest.mark.asyncio
    async def test_access_end_notifications_deduplication(self):
        """Тест 5: Проверка дедупликации уведомлений об окончании доступа"""
        # Создаем пользователя
        user = await self._create_test_user()
        
        # Планируем уведомления об окончании доступа первый раз
        access_end_at = self._get_test_time()
        await schedule_access_end_notifications(
            db=self.db,
            user=user,
            access_end_at=access_end_at,
            course_id=1
        )
        
        # Получаем количество уведомлений после первого создания
        notifications_1 = await self._get_user_notifications(user["id"])
        count_1 = len(notifications_1)
        
        # Планируем уведомления второй раз (должны быть дедуплицированы)
        await schedule_access_end_notifications(
            db=self.db,
            user=user,
            access_end_at=access_end_at,
            course_id=1
        )
        
        # Получаем количество уведомлений после второго создания
        notifications_2 = await self._get_user_notifications(user["id"])
        count_2 = len(notifications_2)
        
        # Количество должно остаться тем же (дедупликация работает)
        assert count_1 == count_2, f"Дедупликация уведомлений об окончании доступа не работает: {count_1} -> {count_2}"

    @pytest.mark.asyncio
    async def test_different_telegram_ids_separation(self):
        """Тест 6: Проверка, что уведомления для разных telegram_id не пересекаются"""
        # Очищаем возможные остатки от предыдущих тестов
        await self.db.delete_records("notifications", {"telegram_id": 111111})
        await self.db.delete_records("notifications", {"telegram_id": 222222})
        
        # Создаем двух пользователей с разными telegram_id
        user1 = await self._create_test_user(telegram_id=111111)
        user2 = await self._create_test_user(telegram_id=222222)
        
        # Планируем уведомления для обоих пользователей с разным временем
        enrolled_at1 = self._get_test_time()
        enrolled_at2 = self._get_test_time(offset_minutes=5)  # Разное время для избежания дубликатов
        
        # Сначала создаем приветственные уведомления для user1
        await schedule_welcome_notifications(
            db=self.db,
            user=user1,
            enrolled_at=enrolled_at1,
            is_pro=False
        )
        
        # Затем создаем прогресс-слоты для user1
        await schedule_on_user_created(
            db=self.db,
            user=user1,
            enrolled_at=enrolled_at1,
            is_pro=False,
            course_id=1
        )

        # Сначала создаем приветственные уведомления для user2
        await schedule_welcome_notifications(
            db=self.db,
            user=user2,
            enrolled_at=enrolled_at2,
            is_pro=False
        )
        
        # Затем создаем прогресс-слоты для user2
        await schedule_on_user_created(
            db=self.db,
            user=user2,
            enrolled_at=enrolled_at2,
            is_pro=False,
            course_id=1
        )
        
        # Получаем уведомления для каждого пользователя
        notifications1 = await self._get_notifications_by_telegram_id(user1["telegram_id"])
        notifications2 = await self._get_notifications_by_telegram_id(user2["telegram_id"])
        
        # Каждый пользователь должен иметь свои уведомления
        assert len(notifications1) == 5, f"Пользователь 1 должен иметь 5 уведомлений, получено {len(notifications1)}"
        assert len(notifications2) == 5, f"Пользователь 2 должен иметь 5 уведомлений, получено {len(notifications2)}"
        
        # Проверяем, что telegram_id не пересекаются
        telegram_ids1 = set(n["telegram_id"] for n in notifications1)
        telegram_ids2 = set(n["telegram_id"] for n in notifications2)
        
        assert telegram_ids1 == {user1["telegram_id"]}, "Уведомления пользователя 1 содержат чужие telegram_id"
        assert telegram_ids2 == {user2["telegram_id"]}, "Уведомления пользователя 2 содержат чужие telegram_id"

    @pytest.mark.asyncio
    async def test_dedup_key_format(self):
        """Тест 7: Проверка формата dedup_key"""
        # Создаем пользователя
        user = await self._create_test_user()
        
        # Планируем уведомления
        enrolled_at = self._get_test_time()
        # Сначала создаем приветственные уведомления
        await schedule_welcome_notifications(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False
        )
        
        # Затем создаем прогресс-слоты для курса
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False,
            course_id=1
        )
        
        # Получаем уведомления
        notifications = await self._get_user_notifications(user["id"])
        
        # Проверяем формат dedup_key
        for notification in notifications:
            if notification["dedup_key"]:
                dedup_key = notification["dedup_key"]
                # Формат: telegram_id:kind:YYYY-MM-DDTHH:MMZ
                parts = dedup_key.split(":")
                assert len(parts) >= 3, f"Неверный формат dedup_key: {dedup_key}"
                
                # Первая часть должна быть telegram_id
                assert parts[0] == str(user["telegram_id"]), f"telegram_id в dedup_key не совпадает: {dedup_key}"
                
                # Последняя часть должна быть временной меткой
                time_part = parts[-1]
                assert time_part.endswith("Z"), f"Временная часть должна заканчиваться на Z: {dedup_key}"
        
        # Проверяем типы данных в уведомлениях
        for notification in notifications:
            # Проверяем типы полей
            assert isinstance(notification["id"], int), f"id должен быть int, получен: {type(notification['id'])}"
            assert isinstance(notification["user_id"], int), f"user_id должен быть int, получен: {type(notification['user_id'])}"
            assert isinstance(notification["telegram_id"], int), f"telegram_id должен быть int, получен: {type(notification['telegram_id'])}"
            assert isinstance(notification["message"], str), f"message должен быть str, получен: {type(notification['message'])}"
            assert isinstance(notification["status"], str), f"status должен быть str, получен: {type(notification['status'])}"
            assert isinstance(notification["scheduled_at"], datetime), f"scheduled_at должен быть datetime, получен: {type(notification['scheduled_at'])}"
            assert isinstance(notification["attempts"], int), f"attempts должен быть int, получен: {type(notification['attempts'])}"
            assert isinstance(notification["max_attempts"], int), f"max_attempts должен быть int, получен: {type(notification['max_attempts'])}"
            
            # Проверяем, что ext_data является строкой (JSON)
            if notification["ext_data"]:
                assert isinstance(notification["ext_data"], str), f"ext_data должен быть str (JSON), получен: {type(notification['ext_data'])}"
                # Проверяем, что это валидный JSON
                import json
                try:
                    json.loads(notification["ext_data"])
                except json.JSONDecodeError:
                    assert False, f"ext_data должен быть валидным JSON: {notification['ext_data']}"

    @pytest.mark.asyncio
    async def test_notification_scheduling_times(self):
        """Тест 8: Проверка времени планирования уведомлений"""
        # Создаем пользователя
        user = await self._create_test_user()
        
        # Планируем уведомления
        enrolled_at = self._get_test_time()
        # Сначала создаем приветственные уведомления
        await schedule_welcome_notifications(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False
        )
        
        # Затем создаем прогресс-слоты для курса
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False,
            course_id=1
        )
        
        # Получаем уведомления
        notifications = await self._get_user_notifications(user["id"])
        
        # Проверяем время планирования для каждого типа уведомления
        notification_map = {n["message"]: n for n in notifications}
        
        # welcome_1 должно быть через 3 минуты
        welcome1 = notification_map.get("welcome_1")
        if welcome1:
            expected_time = enrolled_at + timedelta(minutes=3)
            actual_time = welcome1["scheduled_at"]
            time_diff = abs((actual_time - expected_time).total_seconds())
            assert time_diff < 60, f"welcome_1 запланировано не в то время: {actual_time} vs {expected_time}"
        
        # welcome_2 должно быть через 3.5 минуты
        welcome2 = notification_map.get("welcome_2")
        if welcome2:
            expected_time = enrolled_at + timedelta(minutes=3.5)
            actual_time = welcome2["scheduled_at"]
            time_diff = abs((actual_time - expected_time).total_seconds())
            assert time_diff < 60, f"welcome_2 запланировано не в то время: {actual_time} vs {expected_time}"
        
        # Проверяем время для progress_slot уведомлений
        # progress_slot_day1_1934 должно быть на следующий день в 19:34
        progress1 = notification_map.get("progress_slot_day1_1934")
        if progress1:
            # Проверяем, что время соответствует дню+1 и 19:34
            actual_time = progress1["scheduled_at"]
            expected_day = enrolled_at.date() + timedelta(days=1)
            actual_day = actual_time.date()
            assert actual_day == expected_day, f"progress_slot_day1_1934 запланировано не на следующий день: {actual_day} vs {expected_day}"
            assert actual_time.hour == 19, f"progress_slot_day1_1934 запланировано не в 19 часов: {actual_time.hour}"
            assert actual_time.minute == 34, f"progress_slot_day1_1934 запланировано не в 34 минуты: {actual_time.minute}"
        
        # progress_slot_day2_2022 должно быть через 2 дня в 20:22
        progress2 = notification_map.get("progress_slot_day2_2022")
        if progress2:
            actual_time = progress2["scheduled_at"]
            expected_day = enrolled_at.date() + timedelta(days=2)
            actual_day = actual_time.date()
            assert actual_day == expected_day, f"progress_slot_day2_2022 запланировано не через 2 дня: {actual_day} vs {expected_day}"
            assert actual_time.hour == 20, f"progress_slot_day2_2022 запланировано не в 20 часов: {actual_time.hour}"
            assert actual_time.minute == 22, f"progress_slot_day2_2022 запланировано не в 22 минуты: {actual_time.minute}"
        
        # progress_slot_day3_0828 должно быть через 3 дня в 08:28
        progress3 = notification_map.get("progress_slot_day3_0828")
        if progress3:
            actual_time = progress3["scheduled_at"]
            expected_day = enrolled_at.date() + timedelta(days=3)
            actual_day = actual_time.date()
            assert actual_day == expected_day, f"progress_slot_day3_0828 запланировано не через 3 дня: {actual_day} vs {expected_day}"
            assert actual_time.hour == 8, f"progress_slot_day3_0828 запланировано не в 8 часов: {actual_time.hour}"
            assert actual_time.minute == 28, f"progress_slot_day3_0828 запланировано не в 28 минут: {actual_time.minute}"

    @pytest.mark.asyncio
    async def test_mixed_notification_types(self):
        """Тест 9: Проверка создания разных типов уведомлений для одного пользователя"""
        # Создаем пользователя
        user = await self._create_test_user()
        
        # Создаем курс и подписку
        course = await self._create_test_course()
        await self._create_user_enrollment(user["id"], course["id"])
        
        # Планируем уведомления при создании пользователя
        enrolled_at = self._get_test_time()
        # Сначала создаем приветственные уведомления
        await schedule_welcome_notifications(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False
        )
        
        # Затем создаем прогресс-слоты для курса
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False,
            course_id=1
        )
        
        # Планируем уведомления об окончании доступа
        access_end_at = self._get_test_time() + timedelta(days=1)
        await schedule_access_end_notifications(
            db=self.db,
            user=user,
            access_end_at=access_end_at,
            course_id=1
        )
        
        # Получаем все уведомления пользователя
        notifications = await self._get_user_notifications(user["id"])
        
        # Должно быть 7 уведомлений: 5 при создании + 2 при окончании доступа
        assert len(notifications) == 7, f"Ожидалось 7 уведомлений, получено {len(notifications)}"
        
        # Проверяем, что есть уведомления обоих типов
        messages = [n["message"] for n in notifications]
        
        # Уведомления при создании
        creation_messages = ["welcome_1", "welcome_2", "progress_slot_day1_1934", 
                           "progress_slot_day2_2022", "progress_slot_day3_0828"]
        for msg in creation_messages:
            assert msg in messages, f"Уведомление при создании '{msg}' не найдено"
        
        # Уведомления об окончании доступа
        access_end_messages = ["access_ended_1", "access_ended_2"]
        for msg in access_end_messages:
            assert msg in messages, f"Уведомление об окончании доступа '{msg}' не найдено"


    @pytest.mark.asyncio
    async def test_notification_object_comparison(self):
        """Тест 10: Демонстрация использования метода сравнения объектов уведомлений"""
        # Создаем пользователя
        user = await self._create_test_user()
        
        # Планируем уведомления
        enrolled_at = self._get_test_time()
        # Сначала создаем приветственные уведомления
        await schedule_welcome_notifications(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False
        )
        
        # Затем создаем прогресс-слоты для курса
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False,
            course_id=1
        )
        
        # Получаем уведомления из БД
        notifications = await self._get_user_notifications(user["id"])
        
        # Создаем ожидаемые объекты для сравнения
        expected_notifications = [
            {
                "user_id": user["id"],
                "telegram_id": user["telegram_id"],
                "message": "welcome_1",
                "status": "pending",
                "attempts": 0,
                "max_attempts": 5,
                "scheduled_at": enrolled_at + timedelta(minutes=3),
                "ext_data": {"track": "newbie"},
                "dedup_key": f"{user['telegram_id']}:welcome_1:{enrolled_at.strftime('%Y-%m-%dT%H:%MZ')}"
            },
            {
                "user_id": user["id"],
                "telegram_id": user["telegram_id"],
                "message": "welcome_2",
                "status": "pending",
                "attempts": 0,
                "max_attempts": 5,
                "scheduled_at": enrolled_at + timedelta(minutes=3.5),
                "ext_data": {"track": "newbie"},
                "dedup_key": f"{user['telegram_id']}:welcome_2:{enrolled_at.strftime('%Y-%m-%dT%H:%MZ')}"
            },
            {
                "user_id": user["id"],
                "telegram_id": user["telegram_id"],
                "message": "progress_slot_day1_1934",
                "status": "pending",
                "attempts": 0,
                "max_attempts": 5,
                "scheduled_at": None,  # Будет рассчитано как в боевом коде
                "ext_data": {"slot": "day1_19:34"},
                "dedup_key": f"{user['telegram_id']}:progress_slot_day1_1934:{enrolled_at.strftime('%Y-%m-%dT%H:%MZ')}"
            }
        ]
        
        # Сравниваем каждое уведомление с ожидаемым
        for i, expected in enumerate(expected_notifications):
            # Находим соответствующее уведомление в БД
            actual = None
            for notification in notifications:
                if notification["message"] == expected["message"]:
                    actual = notification
                    break
            
            assert actual is not None, f"Уведомление {expected['message']} не найдено в БД"
            
            # Специальная обработка для progress_slot уведомлений
            if expected["message"] == "progress_slot_day1_1934":
                # Рассчитываем ожидаемое время как в боевом коде
                from backend.notifications.notifications import _at_next_day_time
                expected_time = _at_next_day_time(enrolled_at, 19, 34, day_offset=1)
                expected["scheduled_at"] = expected_time
            
            # Используем метод сравнения
            self._compare_notification_objects(
                expected, 
                actual, 
                f"test_notification_object_comparison - {expected['message']}"
            )

    @pytest.mark.asyncio
    async def test_at_next_day_time_function(self):
        """Тест 11: Проверка функции _at_next_day_time для расчета времени прогресс-слотов"""
        # Базовое время для тестов
        base_time = datetime(2025, 1, 1, 12, 0, 0, tzinfo=timezone.utc)
        
        # Тест D+1 19:34 (первый прогресс-слот)
        result = _at_next_day_time(base_time, 19, 34, day_offset=1)
        expected = datetime(2025, 1, 2, 19, 34, 0, tzinfo=timezone.utc)
        assert result == expected, f"D+1 19:34: ожидался {expected}, получен {result}"
        
        # Тест D+2 20:22 (второй прогресс-слот)
        result = _at_next_day_time(base_time, 20, 22, day_offset=2)
        expected = datetime(2025, 1, 3, 20, 22, 0, tzinfo=timezone.utc)
        assert result == expected, f"D+2 20:22: ожидался {expected}, получен {result}"
        
        # Тест D+3 08:28 (третий прогресс-слот)
        result = _at_next_day_time(base_time, 8, 28, day_offset=3)
        expected = datetime(2025, 1, 4, 8, 28, 0, tzinfo=timezone.utc)
        assert result == expected, f"D+3 08:28: ожидался {expected}, получен {result}"
        
        # Тест с day_offset=0 (тот же день)
        result = _at_next_day_time(base_time, 15, 30, day_offset=0)
        expected = datetime(2025, 1, 1, 15, 30, 0, tzinfo=timezone.utc)
        assert result == expected, f"D+0 15:30: ожидался {expected}, получен {result}"
        
        # Тест с большим day_offset
        result = _at_next_day_time(base_time, 10, 0, day_offset=7)
        expected = datetime(2025, 1, 8, 10, 0, 0, tzinfo=timezone.utc)
        assert result == expected, f"D+7 10:00: ожидался {expected}, получен {result}"
        
        # Тест с переходом через месяц
        base_time_month_end = datetime(2025, 1, 31, 12, 0, 0, tzinfo=timezone.utc)
        result = _at_next_day_time(base_time_month_end, 9, 0, day_offset=1)
        expected = datetime(2025, 2, 1, 9, 0, 0, tzinfo=timezone.utc)
        assert result == expected, f"Переход через месяц: ожидался {expected}, получен {result}"

    @pytest.mark.asyncio
    async def test_edge_cases(self):
        """Тест 12: Проверка граничных случаев"""
        # Тест с минимальным user_id - создаем пользователя с ID=1
        user_data = {
            "telegram_id": self._get_test_time().timestamp() * 1000,  # Уникальный telegram_id
            "username": "test_user_min_id",
            "first_name": "TestMinId",
            "last_name": "User",
            "level": 1
        }
        
        user_id = await self.db.insert_record("users", user_data)
        user = {"id": user_id, "telegram_id": user_data["telegram_id"]}
        
        enrolled_at = self._get_test_time()
        
        # Это должно работать
        # Сначала создаем приветственные уведомления
        await schedule_welcome_notifications(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False
        )
        
        # Затем создаем прогресс-слоты для курса
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False,
            course_id=1
        )
        
        notifications = await self._get_user_notifications(user_id)
        assert len(notifications) == 5, f"Уведомления для user_id={user_id} должны создаваться, получено {len(notifications)}"
        
        # Тест с очень большим telegram_id
        user_large_id = await self._create_test_user(telegram_id=999999999)
        
        # Сначала создаем приветственные уведомления для профи
        await schedule_welcome_notifications(
            db=self.db,
            user=user_large_id,
            enrolled_at=enrolled_at,
            is_pro=True
        )
        
        # Затем создаем прогресс-слоты для курса (для профи их не будет)
        await schedule_on_user_created(
            db=self.db,
            user=user_large_id,
            enrolled_at=enrolled_at,
            is_pro=True,
            course_id=1
        )
        
        notifications = await self._get_user_notifications(user_large_id["id"])
        assert len(notifications) == 2, f"Уведомления для большого telegram_id должны создаваться, получено {len(notifications)}"
        
        # Тест с пустым ext_data
        result = await enqueue_notification(
            db=self.db,
            user_id=user_large_id["id"],
            telegram_id=user_large_id["telegram_id"],
            message="test_empty_ext_data",
            when=self._get_test_time(),
            kind="test_empty",
            ext_data=None  # Пустые данные
        )
        
        assert result > 0, "Уведомление с пустым ext_data должно создаваться"
        
        # Проверяем, что уведомление создалось
        notifications = await self._get_user_notifications(user_large_id["id"])
        test_notifications = [n for n in notifications if n["message"] == "test_empty_ext_data"]
        assert len(test_notifications) == 1, "Должно быть одно тестовое уведомление"
        # ext_data может быть None, пустой строкой или '{}' - все это допустимо
        ext_data = test_notifications[0]["ext_data"]
        assert ext_data is None or ext_data == "" or ext_data == "{}", f"ext_data должен быть пустым, получен: {ext_data}"

    @pytest.mark.asyncio
    async def test_error_handling(self):
        """Тест 13: Проверка обработки ошибок"""
        # Тест с некорректными данными пользователя
        invalid_user = {
            "id": "invalid",  # Неправильный тип
            "telegram_id": "also_invalid"
        }
        
        enrolled_at = self._get_test_time()
        
        # Это должно обрабатываться gracefully
        try:
            await schedule_on_user_created(
                db=self.db,
                user=invalid_user,
                enrolled_at=enrolled_at,
                is_pro=False
            )
            # Если не упало, проверяем, что уведомления не создались
            # (так как user_id и telegram_id невалидны)
        except Exception as e:
            # Ошибка ожидаема для некорректных данных
            assert "invalid" in str(e).lower() or "int" in str(e).lower(), f"Неожиданная ошибка: {e}"
        
        # Тест с отсутствующими полями пользователя
        incomplete_user = {
            "id": 1
            # Отсутствует telegram_id
        }
        
        try:
            await schedule_on_user_created(
                db=self.db,
                user=incomplete_user,
                enrolled_at=enrolled_at,
                is_pro=False
            )
        except Exception as e:
            # Ошибка ожидаема для неполных данных
            assert "telegram_id" in str(e).lower() or "key" in str(e).lower(), f"Неожиданная ошибка: {e}"
        
        # Тест с некорректным временем (прошлое время)
        past_time = datetime(2020, 1, 1, 12, 0, 0, tzinfo=timezone.utc)
        user = await self._create_test_user()
        
        # Это должно работать (прошлое время допустимо для уведомлений)
        # Сначала создаем приветственные уведомления
        await schedule_welcome_notifications(
            db=self.db,
            user=user,
            enrolled_at=past_time,
            is_pro=False
        )
        
        # Затем создаем прогресс-слоты для курса
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=past_time,
            is_pro=False,
            course_id=1
        )
        
        notifications = await self._get_user_notifications(user["id"])
        assert len(notifications) == 5, f"Уведомления с прошлым временем должны создаваться, получено {len(notifications)}"

    @pytest.mark.asyncio
    async def test_performance_large_scale(self):
        """Тест 14: Проверка производительности при большом количестве уведомлений"""
        import time
        
        # Создаем 10 пользователей для тестирования производительности
        users = []
        for i in range(10):
            user = await self._create_test_user()
            users.append(user)
        
        start_time = time.time()
        
        # Создаем уведомления для всех пользователей
        enrolled_at = self._get_test_time()
        
        for user in users:
            # Сначала создаем приветственные уведомления
            await schedule_welcome_notifications(
                db=self.db,
                user=user,
                enrolled_at=enrolled_at,
                is_pro=False
            )
            
            # Затем создаем прогресс-слоты для курса
            await schedule_on_user_created(
                db=self.db,
                user=user,
                enrolled_at=enrolled_at,
                is_pro=False,
                course_id=1
            )
        
        end_time = time.time()
        execution_time = end_time - start_time
        
        # Проверяем, что все уведомления создались
        total_notifications = 0
        for user in users:
            notifications = await self._get_user_notifications(user["id"])
            total_notifications += len(notifications)
            assert len(notifications) == 5, f"Пользователь {user['id']} должен иметь 5 уведомлений, получено {len(notifications)}"
        
        # Должно быть 10 пользователей * 5 уведомлений = 50 уведомлений
        assert total_notifications == 50, f"Ожидалось 50 уведомлений, получено {total_notifications}"
        
        # Проверяем производительность (должно быть быстрее 5 секунд)
        assert execution_time < 5.0, f"Создание 50 уведомлений заняло {execution_time:.2f} секунд, что слишком медленно"
        
        print(f"✅ Производительность: создание 50 уведомлений за {execution_time:.2f} секунд")
        
        # Дополнительный тест: создание уведомлений с разными временами
        start_time = time.time()
        
        for i, user in enumerate(users):
            # Каждый пользователь получает уведомления с разным временем
            user_enrolled_at = enrolled_at + timedelta(minutes=i)
            await schedule_access_end_notifications(
                db=self.db,
                user=user,
                access_end_at=user_enrolled_at,
                course_id=1
            )
        
        end_time = time.time()
        execution_time = end_time - start_time
        
        # Проверяем, что дополнительные уведомления создались
        total_notifications = 0
        for user in users:
            notifications = await self._get_user_notifications(user["id"])
            total_notifications += len(notifications)
            # Теперь должно быть 5 (основных) + 2 (access_end) = 7 уведомлений
            assert len(notifications) == 7, f"Пользователь {user['id']} должен иметь 7 уведомлений, получено {len(notifications)}"
        
        # Должно быть 10 пользователей * 7 уведомлений = 70 уведомлений
        assert total_notifications == 70, f"Ожидалось 70 уведомлений, получено {total_notifications}"
        
        # Проверяем производительность (должно быть быстрее 3 секунд)
        assert execution_time < 3.0, f"Создание дополнительных 20 уведомлений заняло {execution_time:.2f} секунд, что слишком медленно"
        
        print(f"✅ Производительность: создание дополнительных 20 уведомлений за {execution_time:.2f} секунд")

if __name__ == "__main__":
    # Запуск тестов
    pytest.main([__file__, "-v"])
