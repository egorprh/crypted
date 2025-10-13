from __future__ import annotations
import json

"""
Модуль планирования персональных уведомлений.

Идея и допущения:
- Мы создаём в БД записи-«слоты» в таблице `notifications` заранее, сразу при создании пользователя
  (или при событии окончания доступа). У каждой записи есть поле `scheduled_at` (в UTC), говорящее,
  когда её нужно отправить.
- Текст сообщения на момент постановки в очередь может быть не финальным. Для сценариев с «вилками по
  прогрессу» мы ставим маркеры вида `{progress_slot_*}`. Воркер перед фактической отправкой вычисляет
  текущий прогресс пользователя и подставляет подходящий текст из `notify_tz.md` на лету. Это делает
  уведомления актуальными и упрощает планировщик.
- Идемпотентность обеспечивается полем `dedup_key` и уникальным индексом по нему: повторные вызовы
  планировщика/гонки не создадут дубликаты одного и того же слота.

Основные функции:
- `enqueue_notification(...)` — универсальная постановка одной записи в очередь.
- `schedule_on_user_created(...)` — сценарии для новичка/«профи» из ТЗ (все базовые слоты).
- `schedule_access_end_notifications(...)` — два сообщения при окончании доступа.
"""

from datetime import datetime, timedelta, time, timezone
from zoneinfo import ZoneInfo
from typing import Optional, Dict

from db.pgapi import PGApi, sanitize_input


def _minute_bucket(dt: datetime) -> str:
    """Возвращает UTC-временную «корзину» (до минут) для включения в dedup ключ.

    Это фиксирует идемпотентность на уровне минуты и исключает разные записи
    одного смыслового слота из-за секунд/миллисекунд.
    """
    dt_utc = dt.astimezone(timezone.utc)
    return dt_utc.strftime("%Y-%m-%dT%H:%MZ")


def _make_dedup_key(telegram_id: int, kind: str, scheduled_at: datetime) -> str:
    """Строит детерминированный ключ идемпотентности для слота уведомления.

    Состав: telegram_id + семантический «вид»/код слота (kind) + временная корзина.
    Пример: `12345:day1_19:34:2025-10-07T19:34Z`.
    """
    return f"{telegram_id}:{kind}:{_minute_bucket(scheduled_at)}"


async def enqueue_notification(
    db: PGApi,
    *,
    user_id: int,
    telegram_id: int,
    message: str,
    when: datetime,
    kind: str,
    course_id: int = 0,
    channel: str = "telegram",
    ext_data: Optional[Dict] = None,
    max_attempts: int = 5,
) -> int:
    """Ставит одно уведомление в очередь `notifications` с защитой от дублей.

    Параметры:
    - user_id/telegram_id: получатель; telegram_id кладём рядом, чтобы воркер не делал JOIN по users.
    - message: может быть финальным текстом или маркером (например, `{progress_slot_day1_1934}`).
    - when: локальное или UTC время — всегда конвертируем и храним как UTC.
    - kind: семантическое имя слота (например, `day1_19:34`, `welcome+3m`), влияет на dedup.
    - ext_data: произвольные данные (dict) — попадут в JSONB; удобно хранить тип/слот.

    Возврат: ID записи в таблице `notifications` (существующей или новой).
    """
    cleaned_message = sanitize_input(message, max_length=4096)
    scheduled_at_utc = when.astimezone(timezone.utc)
    dedup_key = _make_dedup_key(telegram_id, kind, scheduled_at_utc)
    
    params = {
        "user_id": int(user_id),
        "course_id": int(course_id),
        "telegram_id": int(telegram_id),
        "channel": channel,
        "message": cleaned_message,
        "scheduled_at": scheduled_at_utc,
        "status": "pending",
        "attempts": 0,
        "max_attempts": int(max_attempts),
        "dedup_key": dedup_key,
        "ext_data": json.dumps(ext_data or {}),
    }

    try:
        notif_id = await db.insert_record("notifications", params)
        if notif_id is not None:
            return int(notif_id)
        else:
            existing_id = await db.get_field("notifications", "id", {"dedup_key": dedup_key})
            return int(existing_id) if existing_id is not None else 0
    except Exception:
        # Нарушение уникального индекса по dedup_key — слот уже есть.
        # Небольшая задержка для избежания race conditions при одновременных запросах
        import asyncio
        await asyncio.sleep(0.01)  # 10ms задержка
        
        existing_id = await db.get_field("notifications", "id", {"dedup_key": dedup_key})
        if existing_id is not None:
            return int(existing_id)
        else:
            return 0


def _at_next_day_time(base_dt: datetime, hh: int, mm: int, day_offset: int = 1) -> datetime:
    """Возвращает UTC-момент нужного дня в заданный час:минуты по МСК.

    Алгоритм:
    1) Переводим базовое время (обычно enrolled_at) в зону Europe/Moscow
    2) На этой временной шкале выставляем нужные hh:mm и добавляем day_offset
    3) Полученный момент переводим обратно в UTC для записи в БД
    """
    msk = ZoneInfo("Europe/Moscow")
    base_msk = base_dt.astimezone(msk)
    target_msk = base_msk.replace(hour=hh, minute=mm, second=0, microsecond=0) + timedelta(days=day_offset)
    return target_msk.astimezone(timezone.utc)


async def schedule_on_user_created(
    db: PGApi,
    user: Dict,
    enrolled_at: datetime,
    is_pro: bool = False,
    course_id: int = 0,
) -> None:
    """Ставит все базовые слоты при создании пользователя.

    Варианты:
    - Новичок/Средний: 2 приветственных (T0+3м, T0+3.5м) и три «прогресс-слота»
      на D+1 19:34, D+2 20:22, D+3 08:28 (по ТЗ из notify_tz.md). В текст кладём
      маркеры `{progress_slot_*}`, чтобы воркер выбрал подходящую развилку.
    - Профи: привет через 12 минут и напоминание через сутки.
    
    Примечание: прогресс-слоты создаются только для курсов с enable_notify=True.
    Приветственные сообщения создаются всегда (course_id=0).
    """
    user_id = int(user.get("id", 0))
    telegram_id = int(user.get("telegram_id", 0))

    # Прогресс-слоты создаем только для курсов с enable_notify=True
    if course_id > 0:
        # Проверяем, включены ли уведомления для этого курса
        course_data = await db.get_record("courses", {"id": course_id})
        if course_data and course_data.get("enable_notify"):
            # Новичок/Средний - создаем прогресс-слоты
            if not is_pro:
                # D+1 19:34 — прогресс-слот (текст определяется при отправке)
                await enqueue_notification(
                    db,
                    user_id=user_id,
                    telegram_id=telegram_id,
                    message="progress_slot_day1_1934",
                    when=_at_next_day_time(enrolled_at, 19, 34, day_offset=1),
                    kind=f"day1_19:34_course_{course_id}",
                    course_id=course_id,
                    ext_data={"slot": "day1_19:34", "course_id": course_id},
                )

                # D+2 20:22 — прогресс-слот
                await enqueue_notification(
                    db,
                    user_id=user_id,
                    telegram_id=telegram_id,
                    message="progress_slot_day2_2022",
                    when=_at_next_day_time(enrolled_at, 20, 22, day_offset=2),
                    kind=f"day2_20:22_course_{course_id}",
                    course_id=course_id,
                    ext_data={"slot": "day2_20:22", "course_id": course_id},
                )

                # D+3 08:28 — прогресс-слот
                await enqueue_notification(
                    db,
                    user_id=user_id,
                    telegram_id=telegram_id,
                    message="progress_slot_day3_0828",
                    when=_at_next_day_time(enrolled_at, 8, 28, day_offset=3),
                    kind=f"day3_08:28_course_{course_id}",
                    course_id=course_id,
                    ext_data={"slot": "day3_08:28", "course_id": course_id},
                )


async def schedule_welcome_notifications(
    db: PGApi,
    user: Dict,
    enrolled_at: datetime,
    is_pro: bool = False,
) -> None:
    """Создает приветственные уведомления (независимо от курса).
    
    Создает приветственные сообщения только один раз для пользователя.
    """
    user_id = int(user.get("id", 0))
    telegram_id = int(user.get("telegram_id", 0))

    # Новичок/Средний
    if not is_pro:
        # 2 приветственных сообщения: ставим два коротких слота (независимо от курса)
        await enqueue_notification(
            db,
            user_id=user_id,
            telegram_id=telegram_id,
            message="welcome_1",
            when=enrolled_at + timedelta(minutes=3),
            kind="welcome+3m",
            course_id=0,  # Приветственные сообщения не привязаны к курсу
            ext_data={"track": "newbie"},
        )
        await enqueue_notification(
            db,
            user_id=user_id,
            telegram_id=telegram_id,
            message="welcome_2",
            when=enrolled_at + timedelta(minutes=3.5),
            kind="welcome+4m",
            course_id=0,  # Приветственные сообщения не привязаны к курсу
            ext_data={"track": "newbie"},
        )

    # Профи
    else:
        # Привет через 12 минут (независимо от курса)
        await enqueue_notification(
            db,
            user_id=user_id,
            telegram_id=telegram_id,
            message="pro_welcome_12m",
            when=enrolled_at + timedelta(minutes=12),
            kind="pro+12m",
            course_id=0,  # Приветственные сообщения не привязаны к курсу
            ext_data={"track": "pro"},
        )

        # На следующий день (через сутки после приветствия)
        await enqueue_notification(
            db,
            user_id=user_id,
            telegram_id=telegram_id,
            message="pro_next_day",
            when=(enrolled_at + timedelta(minutes=12)) + timedelta(days=1),
            kind="pro+1d",
            course_id=0,  # Приветственные сообщения не привязаны к курсу
            ext_data={"track": "pro"},
        )


async def schedule_access_end_notifications(
    db: PGApi,
    *,
    user: Dict,
    access_end_at: datetime,
    course_id: int = 0,
) -> None:
    """Ставит два слота при окончании доступа: сразу и «сразу следом» (+5 секунд).

    Тексты — маркеры `{access_ended_1}` и `{access_ended_2}`. Их можно
    заменить на финальные тексты или разрешать в воркере.
    """
    user_id = int(user.get("id", 0))
    telegram_id = int(user.get("telegram_id", 0))

    when1 = access_end_at
    when2 = access_end_at + timedelta(seconds=5)

    await enqueue_notification(
        db,
        user_id=user_id,
        telegram_id=telegram_id,
        message="access_ended_1",
        when=when1,
        kind="access_end_1",
        course_id=course_id,
        ext_data={"type": "access_end"},
    )

    await enqueue_notification(
        db,
        user_id=user_id,
        telegram_id=telegram_id,
        message="access_ended_2",
        when=when2,
        kind="access_end_2",
        course_id=course_id,
        ext_data={"type": "access_end"},
    )


