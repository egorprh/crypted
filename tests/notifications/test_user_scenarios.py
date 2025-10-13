"""
Комплексные тесты пользовательских сценариев системы уведомлений.

Покрывает все возможные кейсы:
1. Пользователь про: все необходимые уведомления
2. Пользователь новичок: различные сценарии прохождения курса
3. Проверка создания, отправки и отмены уведомлений
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

# Добавляем корень проекта в sys.path, чтобы импортировать backend/
PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
BACKEND_DIR = os.path.join(PROJECT_ROOT, "backend")
if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)
if BACKEND_DIR not in sys.path:
    sys.path.insert(0, BACKEND_DIR)

# Загружаем переменные окружения из .env файла
from dotenv import load_dotenv
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


class TestUserScenarios:
    """Тесты пользовательских сценариев"""

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

    async def _create_test_course(self, enable_notify: bool = True, course_title: str = None) -> Dict:
        """Создает тестовый курс с уроками"""
        if course_title is None:
            course_title = f"Test Course {self.test_timestamp}"
        
        course_data = {
            "title": course_title,
            "description": f"Test course for notifications - {course_title}",
            "enable_notify": enable_notify,
            "visible": True
        }
        
        course_id = await self.db.insert_record("courses", course_data)
        course = {"id": course_id, **course_data}
        self.test_courses.append(course)
        
        # Создаем тестовые уроки для курса
        await self._create_test_lessons(course_id)
        
        return course

    async def _create_test_lessons(self, course_id: int, lesson_count: int = 6):
        """Создает тестовые уроки для курса"""
        for i in range(1, lesson_count + 1):
            lesson_data = {
                "course_id": course_id,
                "title": f"Урок {i}: Тестовый урок {i}",
                "description": f"Описание тестового урока {i}",
                "sort_order": i,
                "visible": True
            }
            await self.db.insert_record("lessons", lesson_data)

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

    async def _complete_lessons(self, user_id: int, course_id: int, lesson_count: int):
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

    async def _simulate_notification_sending(self, user_id: int, course_id: int = 1, test_case_name: str = "Тест"):
        """Симулирует отправку уведомлений (имитирует работу воркера)"""
        bot = await self._create_test_bot()
        sent_count = 0
        
        try:
            # Отправляем уведомления по одному, как в реальном воркере
            while True:
                # Получаем следующее pending уведомление
                notifications = await self._get_user_notifications(user_id)
                pending_notifications = [n for n in notifications if n["status"] == "pending"]
                
                if not pending_notifications:
                    break
                
                # Берем первое уведомление
                notification = pending_notifications[0]
                
                # Резолвим текст сообщения
                message_text, progress_type = await resolve_message_text(
                    notification["message"], user_id, course_id, self.db
                )
                
                if message_text and message_text is not False:
                    # Отправляем форматированное тестовое сообщение
                    status, error_text, attempts_used = await self._send_test_notification(
                        bot, self.real_telegram_id, test_case_name, 
                        notification["scheduled_at"], message_text
                    )
                    
                    # Обновляем статус в БД
                    update_data = {
                        "status": status,
                        "attempts": attempts_used,
                        "error": error_text,
                    }
                    
                    if status == "sent":
                        update_data["sent_at"] = datetime.now(timezone.utc)
                        sent_count += 1
                    
                    await self.db.update_record("notifications", notification["id"], update_data)
                    
                    # Проверяем, нужно ли отменить последующие прогресс-слоты
                    # Это должно происходить для КАЖДОГО уведомления, как в реальном воркере
                    if progress_type:
                        await _cancel_future_progress_slots_if_completed(self.db, user_id, course_id, progress_type)
                else:
                    # Если не удалось резолвить сообщение, помечаем как failed
                    await self.db.update_record("notifications", notification["id"], {
                        "status": "failed",
                        "error": "Не удалось резолвить сообщение",
                        "attempts": 1
                    })
        
        finally:
            await bot.session.close()
        
        return sent_count

    def _format_test_message(self, test_case_name: str, scheduled_time: datetime, message: str) -> str:
        """Форматирует тестовое сообщение с информацией о тест-кейсе и времени"""
        time_str = scheduled_time.strftime("%d.%m.%Y %H:%M UTC")
        return f"🧪 {test_case_name}\n⏰ Время отправки: {time_str}\n\n{message}"

    async def _send_test_notification(self, bot: Bot, telegram_id: int, test_case_name: str, 
                                    scheduled_time: datetime, original_message: str) -> tuple:
        """Отправляет тестовое уведомление с форматированием"""
        formatted_message = self._format_test_message(test_case_name, scheduled_time, original_message)
        return await send_telegram_message(bot, telegram_id, formatted_message, max_attempts=1)

    # ==================== ТЕСТЫ ДЛЯ ПРОФИ ====================

    @pytest.mark.asyncio
    async def test_pro_user_complete_scenario(self):
        """Сценарий 1: Пользователь ПРО - все необходимые уведомления"""
        print("\n🧪 Тестируем сценарий: Пользователь ПРО")
        
        # Создаем пользователя-профи
        user = await self._create_test_user()
        
        # Устанавливаем уровень "Продвинутый" (id=3)
        await self.db.update_record("users", user["id"], {"level": 3})
        
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
        
        # Проверяем созданные уведомления
        notifications = await self._get_user_notifications(user["id"])
        print(f"Создано уведомлений для профи: {len(notifications)}")
        
        # Должно быть 2 приветственных уведомления
        assert len(notifications) == 2, f"Ожидалось 2 уведомления для профи, создано {len(notifications)}"
        
        # Проверяем типы уведомлений
        welcome_messages = [n["message"] for n in notifications]
        assert "pro_welcome_12m" in welcome_messages, "Должно быть приветственное сообщение pro_welcome_12m"
        assert "pro_next_day" in welcome_messages, "Должно быть приветственное сообщение pro_next_day"
        
        # Проверяем время отправки
        pro_welcome_12m = next(n for n in notifications if n["message"] == "pro_welcome_12m")
        pro_next_day = next(n for n in notifications if n["message"] == "pro_next_day")
        
        expected_12m_time = enrolled_at + timedelta(minutes=12)
        # pro_next_day планируется через сутки после приветствия (enrolled_at + 12 минут + 1 день)
        expected_next_day_time = (enrolled_at + timedelta(minutes=12)) + timedelta(days=1)
        
        # Проверяем время с допуском в 1 минуту
        time_diff_12m = abs((pro_welcome_12m["scheduled_at"] - expected_12m_time).total_seconds())
        time_diff_next_day = abs((pro_next_day["scheduled_at"] - expected_next_day_time).total_seconds())
        
        assert time_diff_12m < 60, f"Время отправки pro_welcome_12m неверное: {pro_welcome_12m['scheduled_at']}"
        assert time_diff_next_day < 60, f"Время отправки pro_next_day неверное: {pro_next_day['scheduled_at']}"
        
        # Симулируем отправку уведомлений
        sent_count = await self._simulate_notification_sending(user["id"], test_case_name="Пользователь ПРО")
        print(f"Отправлено уведомлений: {sent_count}")
        
        # Проверяем, что все уведомления отправлены
        final_notifications = await self._get_user_notifications(user["id"])
        sent_notifications = [n for n in final_notifications if n["status"] == "sent"]
        assert len(sent_notifications) == 2, f"Все уведомления должны быть отправлены, отправлено {len(sent_notifications)}"
        
        print("✅ Сценарий ПРО: все уведомления созданы и отправлены корректно")

    # ==================== ТЕСТЫ ДЛЯ НОВИЧКОВ ====================

    @pytest.mark.asyncio
    async def test_newbie_no_progress_three_days(self):
        """Сценарий 2: Новичок НЕ прошел курс за три дня"""
        print("\n🧪 Тестируем сценарий: Новичок НЕ прошел курс за 3 дня")
        
        # Создаем пользователя-новичка
        user = await self._create_test_user()
        course = await self._create_test_course(course_title="Курс для новичка - без прогресса")
        
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
        
        # Проверяем созданные уведомления
        notifications = await self._get_user_notifications(user["id"])
        print(f"Создано уведомлений для новичка: {len(notifications)}")
        
        # Должно быть 5 уведомлений: 2 приветственных + 3 прогресс-слота
        assert len(notifications) == 5, f"Ожидалось 5 уведомлений, создано {len(notifications)}"
        
        # Проверяем типы уведомлений
        welcome_count = len([n for n in notifications if n["message"] in ["welcome_1", "welcome_2"]])
        progress_count = len([n for n in notifications if n["message"].startswith("progress_slot_")])
        
        assert welcome_count == 2, f"Ожидалось 2 приветственных уведомления, найдено {welcome_count}"
        assert progress_count == 3, f"Ожидалось 3 прогресс-слота, найдено {progress_count}"
        
        # Симулируем отправку всех уведомлений (пользователь не проходит уроки)
        sent_count = await self._simulate_notification_sending(user["id"], course["id"], "Новичок без прогресса")
        print(f"Отправлено уведомлений: {sent_count}")
        
        # Проверяем, что все уведомления отправлены
        final_notifications = await self._get_user_notifications(user["id"])
        sent_notifications = [n for n in final_notifications if n["status"] == "sent"]
        assert len(sent_notifications) == 5, f"Все уведомления должны быть отправлены, отправлено {len(sent_notifications)}"
        
        # Проверяем, что прогресс-слоты содержат сообщения типа "none" (0 уроков)
        progress_notifications = [n for n in final_notifications if n["message"].startswith("progress_slot_")]
        for notification in progress_notifications:
            # Проверяем, что сообщение было отправлено (статус sent)
            assert notification["status"] == "sent", f"Прогресс-слот {notification['message']} должен быть отправлен"
        
        print("✅ Сценарий Новичок без прогресса: все уведомления созданы и отправлены")

    @pytest.mark.asyncio
    async def test_newbie_completed_all_first_day(self):
        """Сценарий 3: Новичок прошел ВСЕ уроки в первый день"""
        print("\n🧪 Тестируем сценарий: Новичок прошел ВСЕ уроки в первый день")
        
        # Создаем пользователя-новичка
        user = await self._create_test_user()
        course = await self._create_test_course(course_title="Курс для новичка - прошел все в первый день")
        
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
        
        # Пользователь проходит ВСЕ уроки в первый день (5+ уроков)
        await self._complete_lessons(user["id"], course["id"], 6)
        
        # Симулируем отправку уведомлений
        sent_count = await self._simulate_notification_sending(user["id"], int(course["id"]), "Новичок прошел все в первый день")
        print(f"Отправлено уведомлений: {sent_count}")
        
        # Проверяем результаты
        final_notifications = await self._get_user_notifications(user["id"])
        
        # Должны быть отправлены приветственные уведомления
        welcome_notifications = [n for n in final_notifications if n["message"] in ["welcome_1", "welcome_2"]]
        sent_welcome = [n for n in welcome_notifications if n["status"] == "sent"]
        assert len(sent_welcome) == 2, f"Приветственные уведомления должны быть отправлены, отправлено {len(sent_welcome)}"
        
        # Прогресс-слоты: один должен быть отправлен, остальные отменены
        progress_notifications = [n for n in final_notifications if n["message"].startswith("progress_slot_")]
        sent_progress = [n for n in progress_notifications if n["status"] == "sent"]
        cancelled_progress = [n for n in progress_notifications if n["status"] == "cancelled"]
        pending_progress = [n for n in progress_notifications if n["status"] == "pending"]
        
        print(f"Прогресс-слотов отправлено: {len(sent_progress)}")
        print(f"Прогресс-слотов отменено: {len(cancelled_progress)}")
        print(f"Прогресс-слотов pending: {len(pending_progress)}")
        
        # Должен быть отправлен только первый прогресс-слот (с сообщением "all")
        assert len(sent_progress) == 1, f"Должен быть отправлен 1 прогресс-слот, отправлено {len(sent_progress)}"
        assert len(cancelled_progress) == 2, f"Должно быть отменено 2 прогресс-слота, отменено {len(cancelled_progress)}"
        assert len(pending_progress) == 0, f"Не должно быть pending прогресс-слотов, найдено {len(pending_progress)}"
        
        print("✅ Сценарий Новичок прошел все в первый день: прогресс-слоты отменены")

    @pytest.mark.asyncio
    async def test_newbie_completed_all_second_day(self):
        """Сценарий 4: Новичок прошел ВСЕ уроки во второй день"""
        print("\n🧪 Тестируем сценарий: Новичок прошел ВСЕ уроки во второй день")
        
        # Создаем пользователя-новичка
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
        
        # Симулируем первый день (пользователь не проходит уроки)
        # Отправляем приветственные уведомления
        welcome_notifications = await self.db.get_records_sql(
            "SELECT * FROM notifications WHERE user_id = $1 AND message IN ($2, $3)",
            user["id"], "welcome_1", "welcome_2"
        )
        
        for notification in welcome_notifications:
            await self.db.update_record("notifications", notification["id"], {
                "status": "sent",
                "sent_at": datetime.now(timezone.utc),
                "attempts": 1
            })
        
        # Отправляем первый прогресс-слот (день 1)
        day1_notifications = await self.db.get_records("notifications", {
            "user_id": user["id"],
            "message": "progress_slot_day1_1934"
        })
        
        for notification in day1_notifications:
            await self.db.update_record("notifications", notification["id"], {
                "status": "sent",
                "sent_at": datetime.now(timezone.utc),
                "attempts": 1
            })
        
        # Пользователь проходит ВСЕ уроки во второй день
        await self._complete_lessons(user["id"], course["id"], 6)
        
        # Симулируем отправку второго прогресс-слота
        day2_notifications = await self.db.get_records("notifications", {
            "user_id": user["id"],
            "message": "progress_slot_day2_2022"
        })
        
        for notification in day2_notifications:
            # Резолвим сообщение (теперь должно быть "all")
            message_text, progress_type = await resolve_message_text(
                notification["message"], user["id"], course["id"], self.db
            )
            
            # Отправляем сообщение
            bot = await self._create_test_bot()
            try:
                status, error_text, attempts_used = await send_telegram_message(
                    bot, self.real_telegram_id, message_text, max_attempts=1
                )
                
                await self.db.update_record("notifications", notification["id"], {
                    "status": status,
                    "sent_at": datetime.now(timezone.utc) if status == "sent" else None,
                    "attempts": attempts_used,
                    "error": error_text
                })
                
                # Отменяем будущие прогресс-слоты
                if progress_type:
                    await _cancel_future_progress_slots_if_completed(self.db, user["id"], course["id"], progress_type)
            
            finally:
                await bot.session.close()
        
        # Проверяем результаты
        final_notifications = await self._get_user_notifications(user["id"])
        
        # Должны быть отправлены приветственные уведомления
        welcome_notifications = [n for n in final_notifications if n["message"] in ["welcome_1", "welcome_2"]]
        sent_welcome = [n for n in welcome_notifications if n["status"] == "sent"]
        assert len(sent_welcome) == 2, f"Приветственные уведомления должны быть отправлены, отправлено {len(sent_welcome)}"
        
        # Должен быть отправлен первый прогресс-слот
        day1_sent = [n for n in final_notifications if n["message"] == "progress_slot_day1_1934" and n["status"] == "sent"]
        assert len(day1_sent) == 1, "Первый прогресс-слот должен быть отправлен"
        
        # Должен быть отправлен второй прогресс-слот
        day2_sent = [n for n in final_notifications if n["message"] == "progress_slot_day2_2022" and n["status"] == "sent"]
        assert len(day2_sent) == 1, "Второй прогресс-слот должен быть отправлен"
        
        # Третий прогресс-слот должен быть отменен
        day3_cancelled = [n for n in final_notifications if n["message"] == "progress_slot_day3_0828" and n["status"] == "cancelled"]
        assert len(day3_cancelled) == 1, "Третий прогресс-слот должен быть отменен"
        
        print("✅ Сценарий Новичок прошел все во второй день: третий слот отменен")

    @pytest.mark.asyncio
    async def test_newbie_partial_progress_scenarios(self):
        """Сценарий 5: Новичок с частичным прогрессом (различные комбинации)"""
        print("\n🧪 Тестируем сценарий: Новичок с частичным прогрессом")
        
        # Создаем пользователя-новичка
        user = await self._create_test_user()
        course = await self._create_test_course(course_title="Курс для тестирования прогресса")
        
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
        
        # Тестируем различные уровни прогресса
        progress_scenarios = [
            (1, "lt3", "1 урок"),
            (2, "lt3", "2 урока"),
            (3, "lt5", "3 урока"),
            (4, "lt5", "4 урока"),
            (5, "all", "5 уроков"),
            (6, "all", "6 уроков"),
        ]
        
        for lesson_count, expected_progress, description in progress_scenarios:
            print(f"  Тестируем: {description}")
            
            # Очищаем предыдущие завершения уроков
            await self.db.execute(
                "DELETE FROM lesson_completions WHERE user_id = $1",
                user["id"], execute=True
            )
            
            # Завершаем указанное количество уроков
            await self._complete_lessons(user["id"], course["id"], lesson_count)
            
            # Тестируем резолв первого прогресс-слота
            text, progress_type = await resolve_message_text(
                "progress_slot_day1_1934", user["id"], course["id"], self.db
            )
            
            assert text is not False, f"Сообщение должно резолвиться для {description}"
            assert progress_type == expected_progress, f"Ожидался progress_type='{expected_progress}', получен '{progress_type}' для {description}"
            
            print(f"    ✅ {description}: progress_type='{progress_type}'")
        
        print("✅ Сценарий частичного прогресса: все комбинации работают корректно")

    @pytest.mark.asyncio
    async def test_newbie_course_without_notifications(self):
        """Сценарий 6: Новичок на курсе БЕЗ уведомлений"""
        print("\n🧪 Тестируем сценарий: Новичок на курсе БЕЗ уведомлений")
        
        # Создаем пользователя-новичка
        user = await self._create_test_user()
        
        # Создаем курс БЕЗ уведомлений
        course_disabled = await self._create_test_course(enable_notify=False, course_title="Курс БЕЗ уведомлений")
        course_enabled = await self._create_test_course(enable_notify=True, course_title="Курс С уведомлениями")
        
        # Создаем подписки на оба курса
        await self._create_user_enrollment(user["id"], course_disabled["id"])
        await self._create_user_enrollment(user["id"], course_enabled["id"])
        
        enrolled_at = self._get_test_time()
        
        # Планируем уведомления
        await schedule_welcome_notifications(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False
        )
        
        # Планируем прогресс-слоты для обоих курсов
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False,
            course_id=course_disabled["id"]
        )
        
        await schedule_on_user_created(
            db=self.db,
            user=user,
            enrolled_at=enrolled_at,
            is_pro=False,
            course_id=course_enabled["id"]
        )
        
        # Проверяем результаты
        notifications = await self._get_user_notifications(user["id"])
        
        # Должны быть приветственные уведомления (независимо от курса)
        welcome_count = len([n for n in notifications if n["message"] in ["welcome_1", "welcome_2"]])
        assert welcome_count == 2, f"Должны быть приветственные уведомления, найдено {welcome_count}"
        
        # Должны быть прогресс-слоты только для включенного курса
        progress_notifications = [n for n in notifications if n["message"].startswith("progress_slot_")]
        enabled_course_progress = [n for n in progress_notifications if n["course_id"] == course_enabled["id"]]
        disabled_course_progress = [n for n in progress_notifications if n["course_id"] == course_disabled["id"]]
        
        assert len(enabled_course_progress) == 3, f"Должны быть прогресс-слоты для включенного курса, найдено {len(enabled_course_progress)}"
        assert len(disabled_course_progress) == 0, f"НЕ должно быть прогресс-слотов для отключенного курса, найдено {len(disabled_course_progress)}"
        
        print("✅ Сценарий курса без уведомлений: прогресс-слоты созданы только для включенного курса")

    @pytest.mark.asyncio
    async def test_newbie_access_expiration(self):
        """Сценарий 7: Новичок - истечение доступа к курсу"""
        print("\n🧪 Тестируем сценарий: Истечение доступа к курсу")
        
        # Создаем пользователя-новичка
        user = await self._create_test_user()
        course = await self._create_test_course()
        
        # Создаем подписку с истекшим доступом
        enrollment_data = {
            "user_id": user["id"],
            "course_id": course["id"],
            "status": 1,  # ENROLLMENT_STATUS_ENROLLED
            "time_start": datetime.now(timezone.utc) - timedelta(days=2),
            "time_end": datetime.now(timezone.utc) - timedelta(hours=1)  # Доступ истек час назад
        }
        
        enrollment_id = await self.db.insert_record("user_enrollment", enrollment_data)
        
        # Планируем уведомления об окончании доступа
        access_end_at = datetime.now(timezone.utc) - timedelta(hours=1)
        await schedule_access_end_notifications(
            db=self.db,
            user=user,
            access_end_at=access_end_at,
            course_id=course["id"]
        )
        
        # Проверяем созданные уведомления
        notifications = await self._get_user_notifications(user["id"])
        access_notifications = [n for n in notifications if n["message"].startswith("access_ended_")]
        
        assert len(access_notifications) == 2, f"Должно быть 2 уведомления об окончании доступа, найдено {len(access_notifications)}"
        
        # Проверяем типы уведомлений
        access_messages = [n["message"] for n in access_notifications]
        assert "access_ended_1" in access_messages, "Должно быть уведомление access_ended_1"
        assert "access_ended_2" in access_messages, "Должно быть уведомление access_ended_2"
        
        # Симулируем отправку уведомлений
        sent_count = await self._simulate_notification_sending(user["id"], course["id"], "Истечение доступа")
        print(f"Отправлено уведомлений об окончании доступа: {sent_count}")
        
        # Проверяем, что уведомления отправлены
        final_notifications = await self._get_user_notifications(user["id"])
        sent_access = [n for n in final_notifications if n["message"].startswith("access_ended_") and n["status"] == "sent"]
        assert len(sent_access) == 2, f"Уведомления об окончании доступа должны быть отправлены, отправлено {len(sent_access)}"
        
        print("✅ Сценарий истечения доступа: уведомления созданы и отправлены")

    @pytest.mark.asyncio
    async def test_access_expiration_with_test_course(self):
        """Сценарий 8: Истечение доступа с тестовым курсом"""
        print("\n🧪 Тестируем сценарий: Истечение доступа с тестовым курсом")
        
        # Создаем пользователя-новичка
        user = await self._create_test_user()
        course = await self._create_test_course(
            course_title="Курс с истекающим доступом",
            enable_notify=True
        )
        
        # Создаем подписку с истекшим доступом
        enrollment_data = {
            "user_id": user["id"],
            "course_id": course["id"],
            "status": 1,  # ENROLLMENT_STATUS_ENROLLED
            "time_start": datetime.now(timezone.utc) - timedelta(days=2),
            "time_end": datetime.now(timezone.utc) - timedelta(hours=1)  # Доступ истек час назад
        }
        
        enrollment_id = await self.db.insert_record("user_enrollment", enrollment_data)
        
        # Планируем уведомления об окончании доступа
        access_end_at = datetime.now(timezone.utc) - timedelta(hours=1)
        await schedule_access_end_notifications(
            db=self.db,
            user=user,
            access_end_at=access_end_at,
            course_id=course["id"]
        )
        
        # Проверяем созданные уведомления
        notifications = await self._get_user_notifications(user["id"])
        access_notifications = [n for n in notifications if n["message"].startswith("access_ended_")]
        
        assert len(access_notifications) == 2, f"Должно быть 2 уведомления об окончании доступа, найдено {len(access_notifications)}"
        
        # Проверяем типы уведомлений
        access_messages = [n["message"] for n in access_notifications]
        assert "access_ended_1" in access_messages, "Должно быть уведомление access_ended_1"
        assert "access_ended_2" in access_messages, "Должно быть уведомление access_ended_2"
        
        # Симулируем отправку уведомлений
        sent_count = await self._simulate_notification_sending(user["id"], course["id"], "Истечение доступа с тестовым курсом")
        print(f"Отправлено уведомлений об окончании доступа: {sent_count}")
        
        # Проверяем, что уведомления отправлены
        final_notifications = await self._get_user_notifications(user["id"])
        sent_access = [n for n in final_notifications if n["message"].startswith("access_ended_") and n["status"] == "sent"]
        assert len(sent_access) == 2, f"Уведомления об окончании доступа должны быть отправлены, отправлено {len(sent_access)}"
        
        print("✅ Сценарий истечения доступа с тестовым курсом: уведомления созданы и отправлены")

    @pytest.mark.asyncio
    async def test_comprehensive_user_journey(self):
        """Сценарий 8: Комплексный пользовательский путь"""
        print("\n🧪 Тестируем сценарий: Комплексный пользовательский путь")
        
        # Создаем пользователя-новичка
        user = await self._create_test_user()
        course = await self._create_test_course()
        
        # Создаем подписку
        await self._create_user_enrollment(user["id"], course["id"])
        
        enrolled_at = self._get_test_time()
        
        # Планируем все уведомления
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
        
        # Симулируем полный пользовательский путь
        
        # День 0: Регистрация - отправляем приветственные уведомления
        print("  День 0: Отправка приветственных уведомлений")
        welcome_notifications = await self.db.get_records_sql(
            "SELECT * FROM notifications WHERE user_id = $1 AND message IN ($2, $3)",
            user["id"], "welcome_1", "welcome_2"
        )
        
        for notification in welcome_notifications:
            await self.db.update_record("notifications", notification["id"], {
                "status": "sent",
                "sent_at": datetime.now(timezone.utc),
                "attempts": 1
            })
        
        # День 1: Пользователь проходит 2 урока
        print("  День 1: Пользователь проходит 2 урока")
        await self._complete_lessons(user["id"], course["id"], 2)
        
        # Отправляем первый прогресс-слот
        day1_notification = await self.db.get_record("notifications", {
            "user_id": user["id"],
            "message": "progress_slot_day1_1934"
        })
        
        if day1_notification:
            await self.db.update_record("notifications", day1_notification["id"], {
                "status": "sent",
                "sent_at": datetime.now(timezone.utc),
                "attempts": 1
            })
        
        # День 2: Пользователь проходит еще 3 урока (всего 5)
        print("  День 2: Пользователь проходит еще 3 урока (всего 5)")
        # Очищаем предыдущие завершения и добавляем 5 уроков
        await self.db.execute(
            "DELETE FROM lesson_completions WHERE user_id = $1",
            user["id"], execute=True
        )
        await self._complete_lessons(user["id"], course["id"], 5)
        
        # Отправляем второй прогресс-слот
        day2_notification = await self.db.get_record("notifications", {
            "user_id": user["id"],
            "message": "progress_slot_day2_2022"
        })
        
        if day2_notification:
            # Резолвим сообщение (теперь должно быть "all")
            message_text, progress_type = await resolve_message_text(
                day2_notification["message"], user["id"], course["id"], self.db
            )
            
            # Отправляем сообщение
            bot = await self._create_test_bot()
            try:
                status, error_text, attempts_used = await send_telegram_message(
                    bot, self.real_telegram_id, message_text, max_attempts=1
                )
                
                await self.db.update_record("notifications", day2_notification["id"], {
                    "status": status,
                    "sent_at": datetime.now(timezone.utc) if status == "sent" else None,
                    "attempts": attempts_used,
                    "error": error_text
                })
                
                # Отменяем будущие прогресс-слоты
                if progress_type:
                    await _cancel_future_progress_slots_if_completed(self.db, user["id"], course["id"], progress_type)
            
            finally:
                await bot.session.close()
        
        # Проверяем финальные результаты
        final_notifications = await self._get_user_notifications(user["id"])
        
        # Статистика
        sent_count = len([n for n in final_notifications if n["status"] == "sent"])
        cancelled_count = len([n for n in final_notifications if n["status"] == "cancelled"])
        pending_count = len([n for n in final_notifications if n["status"] == "pending"])
        
        print(f"  Итоговая статистика:")
        print(f"    Отправлено: {sent_count}")
        print(f"    Отменено: {cancelled_count}")
        print(f"    Ожидает: {pending_count}")
        
        # Проверяем, что третий прогресс-слот отменен
        day3_notification = await self.db.get_record("notifications", {
            "user_id": user["id"],
            "message": "progress_slot_day3_0828"
        })
        
        if day3_notification:
            assert day3_notification["status"] == "cancelled", "Третий прогресс-слот должен быть отменен"
        
        print("✅ Комплексный пользовательский путь: все сценарии работают корректно")

    @pytest.mark.asyncio
    async def test_newbie_progress_day_by_day(self):
        """Сценарий 9: Новичок с прогрессом день за днем"""
        print("\n🧪 Тестируем сценарий: Новичок с прогрессом день за днем")
        
        # Создаем пользователя-новичка
        user = await self._create_test_user()
        course = await self._create_test_course(course_title="Курс с прогрессом день за днем")
        
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
        
        # День 1: Пользователь проходит 2 урока
        print("  День 1: Пользователь проходит 2 урока")
        await self._complete_lessons(user["id"], course["id"], 2)
        
        # Отправляем первый прогресс-слот
        day1_notification = await self.db.get_record("notifications", {
            "user_id": user["id"],
            "message": "progress_slot_day1_1934"
        })
        
        if day1_notification:
            # Резолвим сообщение (должно быть "lt3")
            message_text, progress_type = await resolve_message_text(
                day1_notification["message"], user["id"], course["id"], self.db
            )
            
            # Отправляем форматированное сообщение
            bot = await self._create_test_bot()
            try:
                status, error_text, attempts_used = await self._send_test_notification(
                    bot, self.real_telegram_id, "День 1: 2 урока", 
                    day1_notification["scheduled_at"], message_text
                )
                
                await self.db.update_record("notifications", day1_notification["id"], {
                    "status": status,
                    "sent_at": datetime.now(timezone.utc) if status == "sent" else None,
                    "attempts": attempts_used,
                    "error": error_text
                })
                
                assert progress_type == "lt3", f"Ожидался progress_type='lt3', получен '{progress_type}'"
                print(f"    ✅ День 1: progress_type='{progress_type}'")
            
            finally:
                await bot.session.close()
        
        # День 2: Пользователь проходит еще 2 урока (всего 4)
        print("  День 2: Пользователь проходит еще 2 урока (всего 4)")
        # Очищаем предыдущие завершения и добавляем 4 урока
        await self.db.execute(
            "DELETE FROM lesson_completions WHERE user_id = $1",
            user["id"], execute=True
        )
        await self._complete_lessons(user["id"], course["id"], 4)
        
        # Отправляем второй прогресс-слот
        day2_notification = await self.db.get_record("notifications", {
            "user_id": user["id"],
            "message": "progress_slot_day2_2022"
        })
        
        if day2_notification:
            # Резолвим сообщение (должно быть "lt5")
            message_text, progress_type = await resolve_message_text(
                day2_notification["message"], user["id"], course["id"], self.db
            )
            
            # Отправляем форматированное сообщение
            bot = await self._create_test_bot()
            try:
                status, error_text, attempts_used = await self._send_test_notification(
                    bot, self.real_telegram_id, "День 2: 4 урока", 
                    day2_notification["scheduled_at"], message_text
                )
                
                await self.db.update_record("notifications", day2_notification["id"], {
                    "status": status,
                    "sent_at": datetime.now(timezone.utc) if status == "sent" else None,
                    "attempts": attempts_used,
                    "error": error_text
                })
                
                assert progress_type == "lt5", f"Ожидался progress_type='lt5', получен '{progress_type}'"
                print(f"    ✅ День 2: progress_type='{progress_type}'")
            
            finally:
                await bot.session.close()
        
        # День 3: Пользователь проходит еще 2 урока (всего 6)
        print("  День 3: Пользователь проходит еще 2 урока (всего 6)")
        # Очищаем предыдущие завершения и добавляем 6 уроков
        await self.db.execute(
            "DELETE FROM lesson_completions WHERE user_id = $1",
            user["id"], execute=True
        )
        await self._complete_lessons(user["id"], course["id"], 6)
        
        # Отправляем третий прогресс-слот
        day3_notification = await self.db.get_record("notifications", {
            "user_id": user["id"],
            "message": "progress_slot_day3_0828"
        })
        
        if day3_notification:
            # Резолвим сообщение (должно быть "all")
            message_text, progress_type = await resolve_message_text(
                day3_notification["message"], user["id"], course["id"], self.db
            )
            
            # Отправляем форматированное сообщение
            bot = await self._create_test_bot()
            try:
                status, error_text, attempts_used = await self._send_test_notification(
                    bot, self.real_telegram_id, "День 3: 6 уроков", 
                    day3_notification["scheduled_at"], message_text
                )
                
                await self.db.update_record("notifications", day3_notification["id"], {
                    "status": status,
                    "sent_at": datetime.now(timezone.utc) if status == "sent" else None,
                    "attempts": attempts_used,
                    "error": error_text
                })
                
                assert progress_type == "all", f"Ожидался progress_type='all', получен '{progress_type}'"
                print(f"    ✅ День 3: progress_type='{progress_type}'")
            
            finally:
                await bot.session.close()
        
        print("✅ Сценарий прогресса день за днем: все этапы работают корректно")

    @pytest.mark.asyncio
    async def test_newbie_late_starter(self):
        """Сценарий 10: Новичок-поздний стартер (начинает на 3-й день)"""
        print("\n🧪 Тестируем сценарий: Новичок-поздний стартер")
        
        # Создаем пользователя-новичка
        user = await self._create_test_user()
        course = await self._create_test_course(course_title="Курс для позднего стартера")
        
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
        
        # Отправляем приветственные уведомления
        welcome_notifications = await self.db.get_records_sql(
            "SELECT * FROM notifications WHERE user_id = $1 AND message IN ($2, $3)",
            user["id"], "welcome_1", "welcome_2"
        )
        
        for notification in welcome_notifications:
            await self.db.update_record("notifications", notification["id"], {
                "status": "sent",
                "sent_at": datetime.now(timezone.utc),
                "attempts": 1
            })
        
        # Отправляем первые два прогресс-слота (пользователь не проходит уроки)
        day1_notification = await self.db.get_record("notifications", {
            "user_id": user["id"],
            "message": "progress_slot_day1_1934"
        })
        
        if day1_notification:
            message_text, progress_type = await resolve_message_text(
                day1_notification["message"], user["id"], course["id"], self.db
            )
            
            bot = await self._create_test_bot()
            try:
                status, error_text, attempts_used = await self._send_test_notification(
                    bot, self.real_telegram_id, "День 1: без прогресса", 
                    day1_notification["scheduled_at"], message_text
                )
                
                await self.db.update_record("notifications", day1_notification["id"], {
                    "status": status,
                    "sent_at": datetime.now(timezone.utc) if status == "sent" else None,
                    "attempts": attempts_used,
                    "error": error_text
                })
                
                assert progress_type == "none", f"Ожидался progress_type='none', получен '{progress_type}'"
                print(f"    ✅ День 1: progress_type='{progress_type}'")
            
            finally:
                await bot.session.close()
        
        day2_notification = await self.db.get_record("notifications", {
            "user_id": user["id"],
            "message": "progress_slot_day2_2022"
        })
        
        if day2_notification:
            message_text, progress_type = await resolve_message_text(
                day2_notification["message"], user["id"], course["id"], self.db
            )
            
            bot = await self._create_test_bot()
            try:
                status, error_text, attempts_used = await self._send_test_notification(
                    bot, self.real_telegram_id, "День 2: без прогресса", 
                    day2_notification["scheduled_at"], message_text
                )
                
                await self.db.update_record("notifications", day2_notification["id"], {
                    "status": status,
                    "sent_at": datetime.now(timezone.utc) if status == "sent" else None,
                    "attempts": attempts_used,
                    "error": error_text
                })
                
                assert progress_type == "none", f"Ожидался progress_type='none', получен '{progress_type}'"
                print(f"    ✅ День 2: progress_type='{progress_type}'")
            
            finally:
                await bot.session.close()
        
        # День 3: Пользователь наконец начинает и проходит все уроки
        print("  День 3: Пользователь начинает и проходит все уроки")
        await self._complete_lessons(user["id"], course["id"], 6)
        
        day3_notification = await self.db.get_record("notifications", {
            "user_id": user["id"],
            "message": "progress_slot_day3_0828"
        })
        
        if day3_notification:
            message_text, progress_type = await resolve_message_text(
                day3_notification["message"], user["id"], course["id"], self.db
            )
            
            bot = await self._create_test_bot()
            try:
                status, error_text, attempts_used = await self._send_test_notification(
                    bot, self.real_telegram_id, "День 3: прошел все уроки", 
                    day3_notification["scheduled_at"], message_text
                )
                
                await self.db.update_record("notifications", day3_notification["id"], {
                    "status": status,
                    "sent_at": datetime.now(timezone.utc) if status == "sent" else None,
                    "attempts": attempts_used,
                    "error": error_text
                })
                
                assert progress_type == "all", f"Ожидался progress_type='all', получен '{progress_type}'"
                print(f"    ✅ День 3: progress_type='{progress_type}'")
            
            finally:
                await bot.session.close()
        
        print("✅ Сценарий позднего стартера: все этапы работают корректно")
