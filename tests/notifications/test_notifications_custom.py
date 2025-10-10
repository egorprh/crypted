import sys
import os
from datetime import datetime, timezone, timedelta
import pytest

# Добавляем корень проекта в sys.path, чтобы импортировать backend/ и telegram_bot/
PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
BACKEND_DIR = os.path.join(PROJECT_ROOT, "backend")
if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)
if BACKEND_DIR not in sys.path:
    sys.path.insert(0, BACKEND_DIR)

from backend.notifications.notifications import (
    _make_dedup_key,
    enqueue_notification,
    schedule_on_user_created,
    schedule_access_end_notifications,
)
from telegram_bot.helper import resolve_message_text
from telegram_bot.notification_texts import (
    WELCOME_1,
    DAY1_1934,
    DAY2_2022,
    DAY3_0828,
)


class FakeDB:
    """
    Простая заглушка БД для тестов. Хранит вставки в память.
    Реализует только методы, используемые в тестируемых функциях.
    """

    def __init__(self):
        self.inserted = []  # список словарей-параметров для notifications
        self.counter = 0

    async def insert_record(self, table_name: str, params: dict):
        # Сохраняем только вставки в notifications
        if table_name == "notifications":
            self.counter += 1
            # эмулируем auto-increment id
            saved = dict(params)
            saved["id"] = self.counter
            self.inserted.append(saved)
            return self.counter
        # прочих таблиц здесь не требуется
        return 1

    async def get_field(self, table_name: str, field: str, params: dict):
        # Используется в enqueue_notification при конфликте; нам не нужен в обычном пути
        # Добавим минимальную совместимость
        if table_name == "notifications" and field == "id" and "dedup_key" in params:
            for row in self.inserted:
                if row.get("dedup_key") == params["dedup_key"]:
                    return row["id"]
        return None


def test_make_dedup_key_minute_bucket():
    when = datetime(2025, 10, 7, 12, 34, 56, tzinfo=timezone.utc)
    key = _make_dedup_key(123, "day1_19:34", when)
    # Должна быть точность до минут, окончание Z
    assert key.endswith("2025-10-07T12:34Z")
    assert key.startswith("123:day1_19:34:")


@pytest.mark.asyncio
async def test_enqueue_notification_builds_dedup_and_inserts():
    db = FakeDB()
    when = datetime.now(timezone.utc)
    notif_id = await enqueue_notification(
        db,
        user_id=1,
        telegram_id=111,
        message="welcome_1",
        when=when,
        kind="welcome+3m",
        ext_data={"track": "newbie"},
    )
    assert notif_id == 1
    assert len(db.inserted) == 1
    row = db.inserted[0]
    assert row["user_id"] == 1
    assert row["telegram_id"] == 111
    assert row["status"] == "pending"
    assert row["dedup_key"].startswith("111:welcome+3m:")


@pytest.mark.asyncio
async def test_schedule_on_user_created_newbie_creates_5_slots():
    db = FakeDB()
    user = {"id": 1, "telegram_id": 111}
    enrolled_at = datetime(2025, 10, 7, 12, 0, 0, tzinfo=timezone.utc)
    await schedule_on_user_created(db, user=user, enrolled_at=enrolled_at, is_pro=False)
    # 2 приветствия + 3 прогресс-слота
    assert len(db.inserted) == 5
    markers = [row["message"] for row in db.inserted]
    assert "welcome_1" in markers and "welcome_2" in markers
    assert "progress_slot_day1_1934" in markers
    assert "progress_slot_day2_2022" in markers
    assert "progress_slot_day3_0828" in markers


@pytest.mark.asyncio
async def test_schedule_on_user_created_pro_creates_2_slots():
    db = FakeDB()
    user = {"id": 2, "telegram_id": 222}
    enrolled_at = datetime(2025, 10, 7, 12, 0, 0, tzinfo=timezone.utc)
    await schedule_on_user_created(db, user=user, enrolled_at=enrolled_at, is_pro=True)
    assert len(db.inserted) == 2
    markers = [row["message"] for row in db.inserted]
    assert "pro_welcome_12m" in markers and "pro_next_day" in markers


@pytest.mark.asyncio
async def test_schedule_access_end_notifications_creates_2_slots():
    db = FakeDB()
    user = {"id": 3, "telegram_id": 333}
    access_end_at = datetime(2025, 10, 15, 12, 0, 0, tzinfo=timezone.utc)
    await schedule_access_end_notifications(db, user=user, access_end_at=access_end_at)
    assert len(db.inserted) == 2
    kinds = {row["message"] for row in db.inserted}
    assert "access_ended_1" in kinds and "access_ended_2" in kinds


def test_resolve_message_text_basic_and_progress_slots():
    # Простые константы
    assert resolve_message_text("welcome_1") == WELCOME_1

    # Progress-слоты: возвращают какой-то из вариантов словаря; проверяем, что строка не False и из набора
    t1 = resolve_message_text("progress_slot_day1_1934")
    assert t1 in DAY1_1934.values()
    t2 = resolve_message_text("progress_slot_day2_2022")
    assert t2 in DAY2_2022.values()
    t3 = resolve_message_text("progress_slot_day3_0828")
    assert t3 in DAY3_0828.values()

    # Неизвестный маркер -> False
    assert resolve_message_text("unknown_key") is False


