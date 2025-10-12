"""
Комплексные интеграционные тесты системы уведомлений для реального окружения.

Тестирует:
- Отправку сообщений в реальный Telegram
- Полный цикл обработки уведомлений
- Резолв сообщений с реальными данными БД
- Умную отмену уведомлений
- Обработку ошибок в реальных условиях
"""

import sys
import os
import pytest
import pytest_asyncio
import asyncio
import random
import time
import json
from datetime import datetime, timezone, timedelta
from typing import Dict, List
from unittest.mock import patch, AsyncMock
from dotenv import load_dotenv

# Добавляем корень проекта в sys.path, чтобы импортировать backend/
PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
BACKEND_DIR = os.path.join(PROJECT_ROOT, "backend")
if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)
if BACKEND_DIR not in sys.path:
    sys.path.insert(0, BACKEND_DIR)

# Загружаем переменные окружения из .env файла
env_path = os.path.join(BACKEND_DIR, ".env")
load_dotenv(env_path)

from backend.db.pgapi import PGApi
from telegram_bot.learn_notify import (
    send_telegram_message,
    resolve_message_text,
    notification_worker,
    _cancel_future_progress_slots_if_completed
)
from backend.notifications.notifications import (
    schedule_welcome_notifications,
    schedule_on_user_created,
    schedule_access_end_notifications,
    enqueue_notification
)
from aiogram import Bot


class TestIntegrationReal:
    """Интеграционные тесты с реальным окружением"""

    @pytest_asyncio.fixture(autouse=True)
    async def setup_and_cleanup(self):
        """Настройка и очистка для каждого теста"""
        self.db = PGApi()
        # Устанавливаем правильный путь к .env файлу
        env_path = os.path.join(PROJECT_ROOT, "backend", ".env")
        await self.db.create_with_env_path(env_path)
        
        # Списки для отслеживания созданных данных
        self.test_users = []
        self.test_courses = []
        self.test_enrollments = []
        self.test_notifications = []
        
        # Реальный telegram_id для тестов
        self.real_telegram_id = 342799025
        
        # Очищаем все тестовые данные перед тестом
        await self._cleanup_all_test_data()
        
        # Уникальная временная метка для каждого теста
        self.test_timestamp = int(time.time()) + random.randint(1, 999999)
        
        yield
        
        # Очистка после теста
        await self._cleanup_test_data()
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
            
            # Удаляем тестовые курсы
            await self.db.execute(
                "DELETE FROM courses WHERE title LIKE 'Test Course%'",
                execute=True
            )
            
        except Exception as e:
            print(f"Ошибка при глобальной очистке тестовых данных: {e}")

    def _get_test_time(self, offset_minutes: int = 0) -> datetime:
        """Генерирует фиксированное время для теста с заданным смещением"""
        base_time = datetime(2025, 1, 1, 12, 0, 0, tzinfo=timezone.utc)
        test_offset = getattr(self, 'test_timestamp', int(time.time())) % 1000
        random_offset = random.randint(0, 999)
        test_id = id(self) % 1000
        total_minutes = test_offset + offset_minutes + random_offset + test_id + (test_id % 100) * 1000
        random_seconds = random.randint(0, 59)
        return base_time + timedelta(minutes=total_minutes, seconds=random_seconds)

    async def _create_test_user(self, telegram_id: int = None) -> Dict:
        """Создает тестового пользователя"""
        if telegram_id is None:
            base_timestamp = getattr(self, 'test_timestamp', int(time.time()))
            random_component = random.randint(1000, 9999)
            telegram_id = base_timestamp + random_component + random.randint(1000, 9999)
        
        user_data = {
            "telegram_id": telegram_id,
            "username": f"test_user_{telegram_id}",
            "first_name": f"Test{telegram_id}",
            "last_name": "User",
            "level": 1
        }
        
        user_id = await self.db.insert_record("users", user_data)
        user = {"id": user_id, **user_data}
        self.test_users.append(user)
        return user

    async def _create_test_course(self, enable_notify: bool = True) -> Dict:
        """Создает тестовый курс"""
        course_data = {
            "title": f"Test Course {self.test_timestamp}",
            "description": "Test course for notifications",
            "enable_notify": enable_notify,
            "visible": True
        }
        
        course_id = await self.db.insert_record("courses", course_data)
        course = {"id": course_id, **course_data}
        self.test_courses.append(course)
        return course

    async def _create_test_course_with_lessons(self, enable_notify: bool = True) -> Dict:
        """Создает тестовый курс с уроками"""
        course = await self._create_test_course(enable_notify)
        
        # Создаем тестовые уроки для курса
        for i in range(1, 7):  # 6 уроков
            lesson_data = {
                "course_id": course["id"],
                "title": f"Урок {i}: Тестовый урок {i}",
                "description": f"Описание тестового урока {i}",
                "sort_order": i,
                "visible": True
            }
            await self.db.insert_record("lessons", lesson_data)
        
        return course

    async def _complete_lessons_for_course(self, user_id: int, course_id: int, lesson_count: int):
        """Завершает указанное количество уроков для пользователя в курсе"""
        # Получаем уроки курса
        lessons = await self.db.get_records_sql(
            "SELECT id FROM lessons WHERE course_id = $1 ORDER BY sort_order LIMIT $2",
            course_id, lesson_count
        )
        
        for lesson in lessons:
            await self.db.insert_record("lesson_completions", {
                "user_id": user_id,
                "lesson_id": lesson["id"],
                "completed_at": datetime.now(timezone.utc)
            })

    async def _create_user_enrollment(self, user_id: int, course_id: int) -> Dict:
        """Создает подписку пользователя на курс"""
        enrollment_data = {
            "user_id": user_id,
            "course_id": course_id,
            "status": 1,  # ENROLLMENT_STATUS_ENROLLED
            "time_start": datetime.now(timezone.utc),
            "time_end": datetime.now(timezone.utc) + timedelta(days=30)
        }
        
        enrollment_id = await self.db.insert_record("user_enrollment", enrollment_data)
        enrollment = {"id": enrollment_id, **enrollment_data}
        self.test_enrollments.append(enrollment)
        return enrollment

    async def _get_user_notifications(self, user_id: int) -> List[Dict]:
        """Получает все уведомления пользователя"""
        return await self.db.get_records("notifications", {"user_id": user_id})

    async def _get_notifications_by_telegram_id(self, telegram_id: int) -> List[Dict]:
        """Получает все уведомления по telegram_id"""
        return await self.db.get_records("notifications", {"telegram_id": telegram_id})

    async def _create_test_bot(self, token: str = None) -> Bot:
        """Создает тестового бота"""
        if token is None:
            # Используем реальный токен из переменных окружения
            token = os.getenv("BOT_TOKEN")
            if not token:
                pytest.skip("BOT_TOKEN не установлен")
        
        return Bot(token=token)

    # ==================== ТЕСТЫ ОТПРАВКИ СООБЩЕНИЙ ====================

    @pytest.mark.asyncio
    async def test_send_to_real_telegram_id(self):
        """Отправка на реальный telegram_id"""
        bot = await self._create_test_bot()
        
        try:
            status, error_text, attempts_used = await send_telegram_message(
                bot, self.real_telegram_id, "🧪 Тестовое сообщение из интеграционного теста"
            )
            
            assert status == "sent", f"Сообщение не отправлено: {error_text}"
            assert error_text is None, f"Ошибка при отправке: {error_text}"
            assert attempts_used == 1, f"Ожидалась 1 попытка, использовано {attempts_used}"
            
        finally:
            await bot.session.close()

    @pytest.mark.asyncio
    async def test_send_to_nonexistent_telegram_id(self):
        """Отправка на несуществующий telegram_id"""
        bot = await self._create_test_bot()
        
        try:
            # Используем заведомо несуществующий ID
            nonexistent_id = 999999999999
            
            status, error_text, attempts_used = await send_telegram_message(
                bot, nonexistent_id, "Тестовое сообщение"
            )
            
            assert status == "failed", f"Ожидался статус 'failed', получен '{status}'"
            assert error_text is not None, "Ошибка должна быть указана"
            assert "chat not found" in error_text.lower() or "user not found" in error_text.lower(), f"Неожиданная ошибка: {error_text}"
            assert attempts_used == 3, f"Ожидалось 3 попытки, использовано {attempts_used}"
            
        finally:
            await bot.session.close()

    @pytest.mark.asyncio
    async def test_send_with_invalid_bot_token(self):
        """Отправка с невалидным токеном бота"""
        # В aiogram 3.x токен валидируется при создании Bot объекта
        # Тестируем, что невалидный токен вызывает исключение
        with pytest.raises(Exception) as exc_info:
            invalid_bot = Bot(token="invalid_token_12345")
        
        # Проверяем, что это именно ошибка валидации токена
        assert "Token is invalid" in str(exc_info.value) or "TokenValidationError" in str(type(exc_info.value).__name__)
        
        print(f"✅ Невалидный токен корректно отклонен: {exc_info.value}")

    @pytest.mark.asyncio
    async def test_send_retry_logic(self):
        """Тест логики ретраев"""
        bot = await self._create_test_bot()
        
        try:
            # Тестируем с несуществующим ID, чтобы вызвать ошибки
            nonexistent_id = 999999999999
            
            status, error_text, attempts_used = await send_telegram_message(
                bot, nonexistent_id, "Тестовое сообщение", max_attempts=2
            )
            
            assert status == "failed", f"Ожидался статус 'failed', получен '{status}'"
            assert attempts_used == 2, f"Ожидалось 2 попытки, использовано {attempts_used}"
            
        finally:
            await bot.session.close()

    # ==================== ТЕСТЫ УМНОЙ ОТМЕНЫ УВЕДОМЛЕНИЙ ====================

    @pytest.mark.asyncio
    async def test_cancel_when_progress_all(self):
        """Отмена при progress_type='all'"""
        # Создаем пользователя и курс
        user = await self._create_test_user()
        course = await self._create_test_course()
        
        # Создаем несколько уведомлений
        enrolled_at = self._get_test_time()
        
        # Создаем приветственные уведомления
        await schedule_welcome_notifications(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False
        )
        
        # Создаем прогресс-слоты
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False,
            course_id=course["id"]
        )
        
        # Создаем дополнительные прогресс-слоты вручную
        await enqueue_notification(
            db=self.db,
            user_id=user["id"],
            telegram_id=user["telegram_id"],
            message="progress_slot_day4_1000",
            when=enrolled_at + timedelta(days=4, hours=10),
            kind="progress_slot_day4_1000",
            course_id=course["id"],
            ext_data={"slot": "day4_10:00"}
        )
        
        # Проверяем, что уведомления созданы
        notifications_before = await self._get_user_notifications(user["id"])
        progress_slots_before = [n for n in notifications_before if n["message"].startswith("progress_slot_")]
        assert len(progress_slots_before) >= 3, f"Ожидалось минимум 3 прогресс-слота, найдено {len(progress_slots_before)}"
        
        # Вызываем функцию отмены с progress_type="all"
        await _cancel_future_progress_slots_if_completed(self.db, user["id"], int(course["id"]), "all")
        
        # Проверяем, что прогресс-слоты отменены
        notifications_after = await self._get_user_notifications(user["id"])
        cancelled_slots = [n for n in notifications_after if n["message"].startswith("progress_slot_") and n["status"] == "cancelled"]
        assert len(cancelled_slots) > 0, "Должны быть отменены прогресс-слоты"
        
        # Проверяем, что приветственные уведомления не затронуты
        welcome_notifications = [n for n in notifications_after if n["message"] in ["welcome_1", "welcome_2"]]
        pending_welcome = [n for n in welcome_notifications if n["status"] == "pending"]
        assert len(pending_welcome) == 2, "Приветственные уведомления не должны быть отменены"

    @pytest.mark.asyncio
    async def test_no_cancel_when_progress_not_all(self):
        """НЕ отмена при progress_type != 'all'"""
        user = await self._create_test_user()
        course = await self._create_test_course()
        
        enrolled_at = self._get_test_time()
        
        # Создаем прогресс-слоты
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False,
            course_id=course["id"]
        )
        
        # Проверяем количество уведомлений до отмены
        notifications_before = await self._get_user_notifications(user["id"])
        progress_slots_before = [n for n in notifications_before if n["message"].startswith("progress_slot_")]
        
        # Вызываем функцию отмены с progress_type != "all"
        for progress_type in ["none", "lt3", "lt5"]:
            await _cancel_future_progress_slots_if_completed(self.db, user["id"], int(course["id"]), progress_type)
        
        # Проверяем, что уведомления НЕ отменены
        notifications_after = await self._get_user_notifications(user["id"])
        progress_slots_after = [n for n in notifications_after if n["message"].startswith("progress_slot_")]
        pending_slots = [n for n in progress_slots_after if n["status"] == "pending"]
        
        assert len(pending_slots) == len(progress_slots_before), "Прогресс-слоты не должны быть отменены"

    @pytest.mark.asyncio
    async def test_cancel_only_progress_slots(self):
        """Отмена только progress_slot_* уведомлений"""
        user = await self._create_test_user()
        course = await self._create_test_course()
        
        enrolled_at = self._get_test_time()
        
        # Создаем разные типы уведомлений
        await schedule_welcome_notifications(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False
        )
        
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False,
            course_id=course["id"]
        )
        
        await schedule_access_end_notifications(
            db=self.db,
            user=user,
            access_end_at=enrolled_at + timedelta(days=1),
            course_id=course["id"]
        )
        
        # Вызываем отмену
        await _cancel_future_progress_slots_if_completed(self.db, user["id"], int(course["id"]), "all")
        
        # Проверяем результаты
        notifications = await self._get_user_notifications(user["id"])
        
        # Прогресс-слоты должны быть отменены
        progress_slots = [n for n in notifications if n["message"].startswith("progress_slot_")]
        cancelled_progress = [n for n in progress_slots if n["status"] == "cancelled"]
        assert len(cancelled_progress) > 0, "Прогресс-слоты должны быть отменены"
        
        # Остальные уведомления не должны быть затронуты
        welcome_notifications = [n for n in notifications if n["message"] in ["welcome_1", "welcome_2"]]
        pending_welcome = [n for n in welcome_notifications if n["status"] == "pending"]
        assert len(pending_welcome) == 2, "Приветственные уведомления не должны быть отменены"
        
        access_notifications = [n for n in notifications if n["message"].startswith("access_ended_")]
        pending_access = [n for n in access_notifications if n["status"] == "pending"]
        assert len(pending_access) == 2, "Уведомления об окончании доступа не должны быть отменены"

    @pytest.mark.asyncio
    async def test_cancel_only_specific_course(self):
        """Отмена только для конкретного курса"""
        user = await self._create_test_user()
        course1 = await self._create_test_course()
        course2 = await self._create_test_course()
        
        enrolled_at = self._get_test_time()
        
        # Создаем уведомления для обоих курсов
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False,
            course_id=course1["id"]
        )
        
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False,
            course_id=course2["id"]
        )
        
        # Отменяем только для course1
        await _cancel_future_progress_slots_if_completed(self.db, user["id"], int(course1["id"]), "all")
        
        # Проверяем результаты
        notifications = await self._get_user_notifications(user["id"])
        
        # Уведомления для course1 должны быть отменены
        course1_slots = [n for n in notifications if n["course_id"] == course1["id"] and n["message"].startswith("progress_slot_")]
        cancelled_course1 = [n for n in course1_slots if n["status"] == "cancelled"]
        assert len(cancelled_course1) > 0, "Уведомления для course1 должны быть отменены"
        
        # Уведомления для course2 не должны быть затронуты
        course2_slots = [n for n in notifications if n["course_id"] == course2["id"] and n["message"].startswith("progress_slot_")]
        pending_course2 = [n for n in course2_slots if n["status"] == "pending"]
        assert len(pending_course2) > 0, "Уведомления для course2 не должны быть отменены"

    # ==================== ТЕСТЫ РЕЗОЛВА СООБЩЕНИЙ ====================

    @pytest.mark.asyncio
    async def test_resolve_welcome_messages(self):
        """Резолв приветственных сообщений"""
        user = await self._create_test_user()
        
        # Тестируем резолв приветственных сообщений
        welcome_1_text, progress_type = await resolve_message_text("welcome_1", user["id"], 0, self.db)
        assert welcome_1_text is not False, "welcome_1 должен резолвиться"
        assert progress_type is None, "Приветственные сообщения не имеют progress_type"
        assert "Привет" in welcome_1_text, "Текст должен содержать приветствие"
        
        welcome_2_text, progress_type = await resolve_message_text("welcome_2", user["id"], 0, self.db)
        assert welcome_2_text is not False, "welcome_2 должен резолвиться"
        assert progress_type is None, "Приветственные сообщения не имеют progress_type"

    @pytest.mark.asyncio
    async def test_resolve_progress_slots_by_progress(self):
        """Резолв прогресс-слотов по реальному прогрессу"""
        user = await self._create_test_user()
        # Используем существующий курс с ID=1, к которому привязаны уроки
        course = {"id": 1, "title": "Старт в торговле криптовалютой"}
        
        # Создаем подписку
        await self._create_user_enrollment(user["id"], course["id"])
        
        # Тестируем без завершенных уроков (progress_type="none")
        text_none, progress_type = await resolve_message_text("progress_slot_day1_1934", user["id"], course["id"], self.db)
        assert text_none is not False, "Прогресс-слот должен резолвиться"
        assert progress_type == "none", f"Ожидался progress_type='none', получен '{progress_type}'"
        assert course["title"] in text_none, "Текст должен содержать название курса"
        
        # Добавляем завершенные уроки (1-2 урока) - используем существующие lesson_id
        for lesson_id in [1, 2]:
            await self.db.insert_record("lesson_completions", {
                "user_id": user["id"],
                "lesson_id": lesson_id,
                "completed_at": datetime.now(timezone.utc)
            })
        
        text_lt3, progress_type = await resolve_message_text("progress_slot_day1_1934", user["id"], course["id"], self.db)
        assert text_lt3 is not False, "Прогресс-слот должен резолвиться"
        assert progress_type == "lt3", f"Ожидался progress_type='lt3', получен '{progress_type}'"
        
        # Добавляем еще уроки (3-4 урока)
        for lesson_id in [3, 4]:
            await self.db.insert_record("lesson_completions", {
                "user_id": user["id"],
                "lesson_id": lesson_id,
                "completed_at": datetime.now(timezone.utc)
            })
        
        text_lt5, progress_type = await resolve_message_text("progress_slot_day1_1934", user["id"], course["id"], self.db)
        assert text_lt5 is not False, "Прогресс-слот должен резолвиться"
        assert progress_type == "lt5", f"Ожидался progress_type='lt5', получен '{progress_type}'"
        
        # Добавляем еще уроки (5+ уроков)
        for lesson_id in [5, 6]:
            await self.db.insert_record("lesson_completions", {
                "user_id": user["id"],
                "lesson_id": lesson_id,
                "completed_at": datetime.now(timezone.utc)
            })
        
        text_all, progress_type = await resolve_message_text("progress_slot_day1_1934", user["id"], course["id"], self.db)
        assert text_all is not False, "Прогресс-слот должен резолвиться"
        assert progress_type == "all", f"Ожидался progress_type='all', получен '{progress_type}'"

    @pytest.mark.asyncio
    async def test_resolve_with_course_title(self):
        """Резолв с подстановкой названия курса"""
        user = await self._create_test_user()
        course = await self._create_test_course()
        
        # Создаем подписку
        await self._create_user_enrollment(user["id"], course["id"])
        
        # Тестируем резолв с названием курса
        text, progress_type = await resolve_message_text("progress_slot_day1_1934", user["id"], course["id"], self.db)
        assert text is not False, "Сообщение должно резолвиться"
        assert course["title"] in text, f"Текст должен содержать название курса '{course['title']}'"

    @pytest.mark.asyncio
    async def test_resolve_unknown_marker(self):
        """Резолв неизвестного маркера"""
        user = await self._create_test_user()
        
        # Тестируем неизвестный маркер
        text, progress_type = await resolve_message_text("unknown_marker_123", user["id"], 0, self.db)
        assert text is False, "Неизвестный маркер должен возвращать False"
        assert progress_type is None, "Неизвестный маркер должен возвращать None для progress_type"

    # ==================== ТЕСТЫ ПОЛНОГО ЦИКЛА ====================

    @pytest.mark.asyncio
    async def test_newbie_full_cycle(self):
        """Полный цикл для новичка"""
        user = await self._create_test_user()
        course = await self._create_test_course()
        
        # Создаем подписку
        await self._create_user_enrollment(user["id"], course["id"])
        
        enrolled_at = self._get_test_time()
        
        # Планируем уведомления
        await schedule_welcome_notifications(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False
        )
        
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False,
            course_id=course["id"]
        )
        
        # Проверяем, что уведомления созданы
        notifications = await self._get_user_notifications(user["id"])
        assert len(notifications) == 5, f"Ожидалось 5 уведомлений, создано {len(notifications)}"
        
        # Проверяем типы уведомлений
        welcome_count = len([n for n in notifications if n["message"] in ["welcome_1", "welcome_2"]])
        progress_count = len([n for n in notifications if n["message"].startswith("progress_slot_")])
        
        assert welcome_count == 2, f"Ожидалось 2 приветственных уведомления, найдено {welcome_count}"
        assert progress_count == 3, f"Ожидалось 3 прогресс-слота, найдено {progress_count}"
        
        # Проверяем, что все уведомления имеют правильный статус
        pending_count = len([n for n in notifications if n["status"] == "pending"])
        assert pending_count == 5, f"Все уведомления должны быть pending, найдено {pending_count}"

    @pytest.mark.asyncio
    async def test_pro_full_cycle(self):
        """Полный цикл для профи"""
        user = await self._create_test_user()
        
        enrolled_at = self._get_test_time()
        
        # Планируем уведомления для профи
        await schedule_welcome_notifications(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=True
        )
        
        # Для профи прогресс-слоты не создаются
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=True,
            course_id=1
        )
        
        # Проверяем, что созданы только приветственные уведомления
        notifications = await self._get_user_notifications(user["id"])
        assert len(notifications) == 2, f"Ожидалось 2 уведомления для профи, создано {len(notifications)}"
        
        # Проверяем типы уведомлений
        welcome_count = len([n for n in notifications if n["message"] in ["pro_welcome_12m", "pro_next_day"]])
        assert welcome_count == 2, f"Ожидалось 2 приветственных уведомления для профи, найдено {welcome_count}"

    @pytest.mark.asyncio
    async def test_progress_based_messages_full_cycle(self):
        """Тест динамических сообщений по прогрессу в полном цикле"""
        user = await self._create_test_user()
        course = await self._create_test_course_with_lessons()
        
        # Создаем подписку
        await self._create_user_enrollment(user["id"], course["id"])
        
        enrolled_at = self._get_test_time()
        
        # Планируем уведомления
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False,
            course_id=course["id"]
        )
        
        # Добавляем прогресс пользователя (3 урока из 6)
        await self._complete_lessons_for_course(user["id"], course["id"], 3)
        
        # Тестируем резолв с учетом прогресса
        notifications = await self._get_user_notifications(user["id"])
        progress_notifications = [n for n in notifications if n["message"].startswith("progress_slot_")]
        
        for notification in progress_notifications:
            text, progress_type = await resolve_message_text(
                notification["message"], user["id"], course["id"], self.db
            )
            assert text is not False, f"Сообщение {notification['message']} должно резолвиться"
            assert progress_type == "lt5", f"Ожидался progress_type='lt5', получен '{progress_type}'"
            assert course["title"] in text, "Текст должен содержать название курса"

    # ==================== ТЕСТЫ ИНТЕГРАЦИИ С КУРСАМИ ====================

    @pytest.mark.asyncio
    async def test_notifications_only_for_enabled_courses(self):
        """Уведомления только для курсов с enable_notify=True"""
        user = await self._create_test_user()
        course_enabled = await self._create_test_course(enable_notify=True)
        course_disabled = await self._create_test_course(enable_notify=False)
        
        enrolled_at = self._get_test_time()
        
        # Планируем уведомления для обоих курсов
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False,
            course_id=course_enabled["id"]
        )
        
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False,
            course_id=course_disabled["id"]
        )
        
        # Проверяем результаты
        notifications = await self._get_user_notifications(user["id"])
        
        # Должны быть уведомления только для включенного курса
        enabled_notifications = [n for n in notifications if n["course_id"] == course_enabled["id"]]
        disabled_notifications = [n for n in notifications if n["course_id"] == course_disabled["id"]]
        
        assert len(enabled_notifications) == 3, f"Ожидалось 3 уведомления для включенного курса, найдено {len(enabled_notifications)}"
        assert len(disabled_notifications) == 0, f"Не должно быть уведомлений для отключенного курса, найдено {len(disabled_notifications)}"

    @pytest.mark.asyncio
    async def test_course_specific_progress_check(self):
        """Проверка прогресса по конкретному курсу"""
        user = await self._create_test_user()
        course1 = await self._create_test_course_with_lessons()
        course2 = await self._create_test_course_with_lessons()
        
        # Создаем подписки на оба курса
        await self._create_user_enrollment(user["id"], course1["id"])
        await self._create_user_enrollment(user["id"], course2["id"])
        
        # Добавляем прогресс только для course1 (3 урока)
        await self._complete_lessons_for_course(user["id"], course1["id"], 3)
        
        # Тестируем резолв для обоих курсов
        text1, progress_type1 = await resolve_message_text("progress_slot_day1_1934", user["id"], course1["id"], self.db)
        text2, progress_type2 = await resolve_message_text("progress_slot_day1_1934", user["id"], course2["id"], self.db)
        
        assert progress_type1 == "lt5", f"Для course1 ожидался progress_type='lt5', получен '{progress_type1}'"
        assert progress_type2 == "none", f"Для course2 ожидался progress_type='none', получен '{progress_type2}'"

    # ==================== ТЕСТЫ ИДЕМПОТЕНТНОСТИ ====================

    @pytest.mark.asyncio
    async def test_dedup_key_prevents_duplicates(self):
        """dedup_key предотвращает дубликаты"""
        user = await self._create_test_user()
        course = await self._create_test_course()
        
        enrolled_at = self._get_test_time()
        
        # Планируем уведомления дважды с одинаковым временем
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False,
            course_id=course["id"]
        )
        
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False,
            course_id=course["id"]
        )
        
        # Проверяем, что дубликаты не созданы
        notifications = await self._get_user_notifications(user["id"])
        progress_notifications = [n for n in notifications if n["message"].startswith("progress_slot_")]
        
        assert len(progress_notifications) == 3, f"Должно быть 3 прогресс-слота, найдено {len(progress_notifications)}"

    # ==================== ТЕСТЫ ОБРАБОТКИ ОШИБОК ====================

    @pytest.mark.asyncio
    async def test_telegram_api_errors_handling(self):
        """Обработка ошибок Telegram API"""
        # В aiogram 3.x токен валидируется при создании Bot объекта
        # Тестируем, что невалидный токен вызывает исключение
        with pytest.raises(Exception) as exc_info:
            invalid_bot = Bot(token="invalid_token")
        
        # Проверяем, что это именно ошибка валидации токена
        assert "Token is invalid" in str(exc_info.value) or "TokenValidationError" in str(type(exc_info.value).__name__)
        
        print(f"✅ Невалидный токен корректно отклонен: {exc_info.value}")
        
        # Дополнительно тестируем обработку ошибок с валидным токеном, но несуществующим chat_id
        bot = await self._create_test_bot()
        try:
            status, error_text, attempts_used = await send_telegram_message(
                bot, 999999999, "Тестовое сообщение", max_attempts=2
            )
            
            assert status == "failed", f"Ожидался статус 'failed', получен '{status}'"
            assert error_text is not None, "Ошибка должна быть указана"
            assert attempts_used == 2, f"Ожидалось 2 попытки, использовано {attempts_used}"
            
        finally:
            await bot.session.close()

    @pytest.mark.asyncio
    async def test_database_errors_handling(self):
        """Обработка ошибок БД"""
        user = await self._create_test_user()
        
        # Тестируем с несуществующим user_id
        text, progress_type = await resolve_message_text("welcome_1", 999999, 0, self.db)
        assert text is not False, "Резолв должен работать даже с несуществующим user_id"
        
        # Тестируем с несуществующим course_id
        text, progress_type = await resolve_message_text("progress_slot_day1_1934", user["id"], 999999, self.db)
        assert text is False, "Несуществующий course_id должен возвращать False"

    # ==================== ТЕСТЫ ПРОИЗВОДИТЕЛЬНОСТИ ====================

    @pytest.mark.asyncio
    async def test_bulk_notification_processing(self):
        """Обработка большого количества уведомлений"""
        # Создаем 10 пользователей
        users = []
        for i in range(10):
            user = await self._create_test_user()
            users.append(user)
        
        course = await self._create_test_course()
        
        # Создаем уведомления для всех пользователей
        enrolled_at = self._get_test_time()
        
        start_time = time.time()
        for user in users:
            await schedule_welcome_notifications(
                db=self.db,
                user=user,
                enrolled_at=enrolled_at,
                is_pro=False
            )
            
            await schedule_on_user_created(
                db=self.db,
                user=user,
                enrolled_at=enrolled_at,
                is_pro=False,
                course_id=course["id"]
            )
        
        creation_time = time.time() - start_time
        print(f"Создание уведомлений для {len(users)} пользователей заняло {creation_time:.2f} секунд")
        
        # Проверяем, что все уведомления созданы
        total_notifications = 0
        for user in users:
            notifications = await self._get_user_notifications(user["id"])
            total_notifications += len(notifications)
        
        expected_notifications = len(users) * 5  # 2 приветственных + 3 прогресс-слота
        assert total_notifications == expected_notifications, f"Ожидалось {expected_notifications} уведомлений, создано {total_notifications}"

    # ==================== ТЕСТЫ МОНИТОРИНГА ====================

    @pytest.mark.asyncio
    async def test_notification_stats_query(self):
        """Тест запроса статистики уведомлений"""
        user = await self._create_test_user()
        course = await self._create_test_course()
        
        enrolled_at = self._get_test_time()
        
        # Создаем уведомления
        await schedule_welcome_notifications(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False
        )
        
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False,
            course_id=course["id"]
        )
        
        # Тестируем запрос статистики
        stats = await self.db.get_records_sql("""
            SELECT 
                status,
                COUNT(*) as count
            FROM notifications 
            WHERE user_id = $1
            GROUP BY status
            ORDER BY status
        """, user["id"])
        
        assert len(stats) > 0, "Статистика должна содержать данные"
        
        # Проверяем, что все уведомления имеют статус pending
        pending_count = sum(1 for stat in stats if stat["status"] == "pending")
        assert pending_count > 0, "Должны быть pending уведомления"

    # ==================== ТЕСТЫ EDGE CASES ====================

    @pytest.mark.asyncio
    async def test_very_long_message(self):
        """Тест очень длинного сообщения"""
        bot = await self._create_test_bot()
        
        try:
            # Создаем очень длинное сообщение (более 4096 символов)
            long_message = "🧪 " + "Тестовое сообщение " * 300
            
            status, error_text, attempts_used = await send_telegram_message(
                bot, self.real_telegram_id, long_message
            )
            
            # Telegram может отклонить слишком длинное сообщение
            if status == "failed":
                assert "too long" in error_text.lower() or "message too long" in error_text.lower(), f"Неожиданная ошибка для длинного сообщения: {error_text}"
            else:
                assert status == "sent", f"Длинное сообщение должно быть отправлено или отклонено"
            
        finally:
            await bot.session.close()

    @pytest.mark.asyncio
    async def test_special_characters_in_message(self):
        """Тест специальных символов в сообщении"""
        bot = await self._create_test_bot()
        
        try:
            # Сообщение со специальными символами
            special_message = "🧪 Тест: эмодзи 🚀, символы: @#$%^&*(), unicode: 中文, арабский: العربية"
            
            status, error_text, attempts_used = await send_telegram_message(
                bot, self.real_telegram_id, special_message
            )
            
            assert status == "sent", f"Сообщение со специальными символами не отправлено: {error_text}"
            
        finally:
            await bot.session.close()

    @pytest.mark.asyncio
    async def test_boundary_time_values(self):
        """Тест граничных значений времени"""
        user = await self._create_test_user()
        course = await self._create_test_course()
        
        # Тестируем с очень старым временем
        old_time = datetime(2020, 1, 1, 12, 0, 0, tzinfo=timezone.utc)
        
        await schedule_welcome_notifications(
            db=self.db,
            user=user,
            enrolled_at=old_time,
            is_pro=False
        )
        
        # Тестируем с очень будущим временем
        future_time = datetime(2030, 12, 31, 23, 59, 59, tzinfo=timezone.utc)
        
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=future_time,
            is_pro=False,
            course_id=course["id"]
        )
        
        # Проверяем, что уведомления созданы
        notifications = await self._get_user_notifications(user["id"])
        assert len(notifications) == 5, f"Уведомления должны создаваться для любого времени, создано {len(notifications)}"
