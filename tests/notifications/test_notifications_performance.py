import sys
import os
import pytest
import pytest_asyncio
import asyncio
import random
import time
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
    schedule_access_end_notifications,
    enqueue_notification,
)


class TestNotificationsPerformance:
    """Тесты производительности системы уведомлений"""

    @pytest_asyncio.fixture(autouse=True)
    async def setup_and_cleanup(self):
        """Настройка и очистка для каждого теста"""
        self.db = PGApi()
        # Устанавливаем правильный путь к .env файлу
        import os
        env_path = os.path.join(PROJECT_ROOT, "backend", ".env")
        await self.db.create_with_env_path(env_path)  # Инициализируем подключение к БД
        self.test_users = []
        self.test_courses = []
        self.test_enrollments = []
        
        # Очищаем все тестовые данные перед тестом
        await self._cleanup_all_test_data()
        
        # Увеличенная задержка для избежания коллизий по времени
        import asyncio
        await asyncio.sleep(0.5)  # 500ms задержка
        
        yield
        
        await self._cleanup_test_data()
        # Закрываем пул подключений
        await self.db.close()

    async def _cleanup_test_data(self):
        """Очистка всех тестовых данных"""
        try:
            for user in self.test_users:
                await self.db.delete_records("notifications", {"user_id": user["id"]})
                await self.db.delete_records("user_enrollment", {"user_id": user["id"]})
                await self.db.delete_record("users", user["id"])
            
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
            telegram_id = random.randint(100000, 999999)
        
        user_data = {
            "telegram_id": telegram_id,
            "username": f"perf_test_user_{telegram_id}",
            "first_name": f"PerfTest{telegram_id}",
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
            "title": f"Perf Test Course {random.randint(1000, 9999)}",
            "description": "Performance test course",
            "visible": True,
            "type": "perf_test"
        }
        
        course_id = await self.db.insert_record("courses", course_data)
        course_data["id"] = course_id
        self.test_courses.append(course_data)
        return course_data

    async def _get_user_notifications(self, user_id: int) -> List[Dict]:
        """Получает все уведомления пользователя"""
        return await self.db.get_records("notifications", {"user_id": user_id})

    @pytest.mark.asyncio
    async def test_bulk_user_creation_performance(self):
        """Тест производительности создания уведомлений для множества пользователей"""
        # Создаем 50 пользователей
        user_count = 50
        users = []
        
        start_time = time.time()
        
        for i in range(user_count):
            user = await self._create_test_user()
            users.append(user)
        
        creation_time = time.time() - start_time
        print(f"Создание {user_count} пользователей заняло {creation_time:.2f} секунд")
        
        # Планируем уведомления для всех пользователей
        start_time = time.time()
        
        enrolled_at = datetime.now(timezone.utc)
        for user in users:
            await schedule_on_user_created(
                db=self.db,
                user=user,
                enrolled_at=enrolled_at,
                is_pro=False
            )
        
        notification_time = time.time() - start_time
        print(f"Создание уведомлений для {user_count} пользователей заняло {notification_time:.2f} секунд")
        
        # Проверяем, что все уведомления создались
        total_notifications = 0
        for user in users:
            notifications = await self._get_user_notifications(user["id"])
            total_notifications += len(notifications)
            assert len(notifications) == 5, f"Пользователь {user['id']} должен иметь 5 уведомлений"
        
        expected_notifications = user_count * 5
        assert total_notifications == expected_notifications, f"Ожидалось {expected_notifications} уведомлений, получено {total_notifications}"
        
        print(f"Всего создано {total_notifications} уведомлений")
        print(f"Среднее время на пользователя: {notification_time/user_count:.3f} секунд")

    @pytest.mark.asyncio
    async def test_concurrent_notification_creation(self):
        """Тест создания уведомлений в конкурентном режиме"""
        # Создаем пользователя
        user = await self._create_test_user()
        
        # Создаем несколько задач для одновременного планирования уведомлений
        async def create_notifications():
            enrolled_at = datetime.now(timezone.utc)
            await schedule_on_user_created(
                db=self.db,
                user=user,
                enrolled_at=enrolled_at,
                is_pro=False
            )
        
        # Запускаем 10 задач одновременно
        tasks = [create_notifications() for _ in range(10)]
        
        start_time = time.time()
        await asyncio.gather(*tasks)
        concurrent_time = time.time() - start_time
        
        print(f"10 одновременных вызовов заняли {concurrent_time:.2f} секунд")
        
        # Проверяем, что создалось только 5 уведомлений (дедупликация работает)
        notifications = await self._get_user_notifications(user["id"])
        assert len(notifications) == 5, f"Должно быть 5 уведомлений (дедупликация), получено {len(notifications)}"

    @pytest.mark.asyncio
    async def test_large_notification_batch(self):
        """Тест создания большого количества уведомлений"""
        # Создаем пользователя
        user = await self._create_test_user()
        
        # Создаем 100 уведомлений
        notification_count = 100
        start_time = time.time()
        
        enrolled_at = datetime.now(timezone.utc)
        for i in range(notification_count):
            await enqueue_notification(
                db=self.db,
                user_id=user["id"],
                telegram_id=user["telegram_id"],
                message=f"test_notification_{i}",
                when=enrolled_at + timedelta(minutes=i),
                kind=f"test_{i}",
                ext_data={"test": f"batch_{i}"}
            )
        
        batch_time = time.time() - start_time
        print(f"Создание {notification_count} уведомлений заняло {batch_time:.2f} секунд")
        
        # Проверяем, что все уведомления создались
        notifications = await self._get_user_notifications(user["id"])
        assert len(notifications) == notification_count, f"Ожидалось {notification_count} уведомлений, получено {len(notifications)}"
        
        print(f"Среднее время на уведомление: {batch_time/notification_count:.4f} секунд")

    @pytest.mark.asyncio
    async def test_notification_query_performance(self):
        """Тест производительности запросов уведомлений"""
        # Создаем 20 пользователей с уведомлениями
        user_count = 20
        users = []
        
        for i in range(user_count):
            user = await self._create_test_user()
            users.append(user)
            
            # Создаем уведомления для каждого пользователя
            enrolled_at = datetime.now(timezone.utc)
            await schedule_on_user_created(
                db=self.db,
                user=user,
                enrolled_at=enrolled_at,
                is_pro=False
            )
        
        # Тестируем производительность запросов
        start_time = time.time()
        
        # Запрос всех уведомлений
        all_notifications = await self.db.get_records("notifications", {})
        
        query_time = time.time() - start_time
        print(f"Запрос всех уведомлений ({len(all_notifications)} записей) занял {query_time:.3f} секунд")
        
        # Тестируем запросы по отдельным пользователям
        start_time = time.time()
        
        for user in users:
            user_notifications = await self._get_user_notifications(user["id"])
            assert len(user_notifications) == 5, f"Пользователь {user['id']} должен иметь 5 уведомлений"
        
        individual_query_time = time.time() - start_time
        print(f"Запросы уведомлений для {user_count} пользователей заняли {individual_query_time:.3f} секунд")
        print(f"Среднее время на запрос: {individual_query_time/user_count:.4f} секунд")

    @pytest.mark.asyncio
    async def test_notification_deduplication_performance(self):
        """Тест производительности дедупликации"""
        # Создаем пользователя
        user = await self._create_test_user()
        
        # Создаем уведомления с одинаковыми dedup_key
        enrolled_at = datetime.now(timezone.utc)
        
        # Первое создание
        start_time = time.time()
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False
        )
        first_creation_time = time.time() - start_time
        
        # Второе создание (должно быть быстрее из-за дедупликации)
        start_time = time.time()
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False
        )
        second_creation_time = time.time() - start_time
        
        print(f"Первое создание уведомлений: {first_creation_time:.3f} секунд")
        print(f"Второе создание (дедупликация): {second_creation_time:.3f} секунд")
        
        # Проверяем, что количество уведомлений не изменилось
        notifications = await self._get_user_notifications(user["id"])
        assert len(notifications) == 5, "Количество уведомлений не должно измениться при дедупликации"

    @pytest.mark.asyncio
    async def test_mixed_notification_types_performance(self):
        """Тест производительности создания разных типов уведомлений"""
        # Создаем 10 пользователей
        user_count = 10
        users = []
        
        for i in range(user_count):
            user = await self._create_test_user()
            users.append(user)
        
        # Тестируем создание уведомлений при создании пользователя
        start_time = time.time()
        
        enrolled_at = datetime.now(timezone.utc)
        for user in users:
            await schedule_on_user_created(
                db=self.db,
                user=user,
                enrolled_at=enrolled_at,
                is_pro=False
            )
        
        creation_time = time.time() - start_time
        
        # Тестируем создание уведомлений об окончании доступа
        start_time = time.time()
        
        access_end_at = datetime.now(timezone.utc) + timedelta(days=1)
        for user in users:
            await schedule_access_end_notifications(
                db=self.db,
                user=user,
                access_end_at=access_end_at
            )
        
        access_end_time = time.time() - start_time
        
        print(f"Создание уведомлений при создании пользователя: {creation_time:.3f} секунд")
        print(f"Создание уведомлений об окончании доступа: {access_end_time:.3f} секунд")
        
        # Проверяем общее количество уведомлений
        total_notifications = 0
        for user in users:
            notifications = await self._get_user_notifications(user["id"])
            total_notifications += len(notifications)
            # 5 при создании + 2 при окончании доступа = 7
            assert len(notifications) == 7, f"Пользователь {user['id']} должен иметь 7 уведомлений"
        
        expected_total = user_count * 7
        assert total_notifications == expected_total, f"Ожидалось {expected_total} уведомлений, получено {total_notifications}"

    @pytest.mark.asyncio
    async def test_notification_cleanup_performance(self):
        """Тест производительности очистки уведомлений"""
        # Создаем 30 пользователей с уведомлениями
        user_count = 30
        users = []
        
        for i in range(user_count):
            user = await self._create_test_user()
            users.append(user)
            
            # Создаем уведомления
            enrolled_at = datetime.now(timezone.utc)
            await schedule_on_user_created(
                db=self.db,
                user=user,
                enrolled_at=enrolled_at,
                is_pro=False
            )
        
        # Проверяем, что уведомления создались
        total_before = 0
        for user in users:
            notifications = await self._get_user_notifications(user["id"])
            total_before += len(notifications)
        
        print(f"Создано {total_before} уведомлений для {user_count} пользователей")
        
        # Тестируем производительность удаления
        start_time = time.time()
        
        for user in users:
            await self.db.delete_records("notifications", {"user_id": user["id"]})
        
        cleanup_time = time.time() - start_time
        print(f"Удаление {total_before} уведомлений заняло {cleanup_time:.3f} секунд")
        
        # Проверяем, что все уведомления удалились
        total_after = 0
        for user in users:
            notifications = await self._get_user_notifications(user["id"])
            total_after += len(notifications)
        
        assert total_after == 0, f"Все уведомления должны быть удалены, осталось {total_after}"

    @pytest.mark.asyncio
    async def test_notification_memory_usage(self):
        """Тест использования памяти при создании уведомлений"""
        import psutil
        import os
        
        # Получаем текущий процесс
        process = psutil.Process(os.getpid())
        initial_memory = process.memory_info().rss / 1024 / 1024  # MB
        
        # Создаем 100 пользователей с уведомлениями
        user_count = 100
        users = []
        
        for i in range(user_count):
            user = await self._create_test_user()
            users.append(user)
            
            # Создаем уведомления
            enrolled_at = datetime.now(timezone.utc)
            await schedule_on_user_created(
                db=self.db,
                user=user,
                enrolled_at=enrolled_at,
                is_pro=False
            )
        
        # Проверяем использование памяти
        final_memory = process.memory_info().rss / 1024 / 1024  # MB
        memory_increase = final_memory - initial_memory
        
        print(f"Начальное использование памяти: {initial_memory:.2f} MB")
        print(f"Финальное использование памяти: {final_memory:.2f} MB")
        print(f"Увеличение памяти: {memory_increase:.2f} MB")
        print(f"Память на пользователя: {memory_increase/user_count:.3f} MB")
        
        # Проверяем, что создались все уведомления
        total_notifications = 0
        for user in users:
            notifications = await self._get_user_notifications(user["id"])
            total_notifications += len(notifications)
        
        expected_notifications = user_count * 5
        assert total_notifications == expected_notifications, f"Ожидалось {expected_notifications} уведомлений, получено {total_notifications}"


if __name__ == "__main__":
    # Запуск тестов
    pytest.main([__file__, "-v", "-s"])  # -s для вывода print statements
