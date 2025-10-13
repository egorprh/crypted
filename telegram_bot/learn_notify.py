"""
Модуль для обработки очереди уведомлений в Telegram боте.

Содержит:
- Воркер для обработки pending уведомлений
- Функции для отправки сообщений с ретраями
- Резолв текстов сообщений по маркерам
"""

import asyncio
from datetime import datetime, timezone
from typing import Optional, Tuple

from aiogram import Bot
from logger import logger

from telegram_bot.notification_texts import (
    WELCOME_1, WELCOME_2, PRO_WELCOME_12M, PRO_NEXT_DAY,
    ACCESS_ENDED_1, ACCESS_ENDED_2, DAY1_1934, DAY2_2022, DAY3_0828,
)


async def send_telegram_message(bot: Bot, telegram_id: int, message: str, max_attempts: int = 3) -> Tuple[str, Optional[str], int]:
    """
    Простая отправка сообщения с ретраями.

    Вход:
    - bot: уже инициализированный экземпляр aiogram.Bot (создаётся снаружи)
    - telegram_id: числовой chat_id получателя
    - message: текст сообщения
    - max_attempts: число попыток отправки (>=1)

    Логика:
    - Пытаемся отправить сообщение.
    - При любой ошибке запоминаем текст ошибки и повторяем попытку (пауза 0.1s),
      пока не исчерпаем лимит.

    Возврат:
    - ("sent", None, attempts_used) при успехе
    - ("failed", "текст_ошибки", attempts_used) при окончательной неудаче
    """

    last_error: Optional[str] = None
    attempts_used = 0

    for attempt in range(1, max_attempts + 1):
        attempts_used = attempt
        try:
            await bot.send_message(chat_id=telegram_id, text=message)
            return "sent", None, attempts_used
        except Exception as e:
            # Сохраняем текст ошибки (тип ошибки нам не критичен для решения — важно описание)
            last_error = str(e)
            if attempt < max_attempts:
                await asyncio.sleep(0.1)  # Уменьшена задержка до 0.1 секунды

    return "failed", last_error, attempts_used


async def resolve_message_text(message_marker: str, user_id: int, course_id: int, db):
    """
    Возвращает фактический текст сообщения по маркеру из очереди.

    Вход:
    - message_marker: строка-маркер вида "welcome_1", "progress_slot_day1_1934" и т.п.
                      (без фигурных скобок).
    - user_id: ID пользователя для проверки прогресса
    - course_id: ID курса для проверки прогресса и получения названия
    - db: экземпляр PGApi для работы с БД

    Правила:
    - Для простых констант возвращаем соответствующий текст из notification_texts.py
    - Для прогресс-слотов (day1/day2/day3) — проверяем реальный прогресс пользователя
      в таблице lesson_completions по конкретному курсу и выбираем соответствующий текст
    - Подставляем название курса в тексты с плейсхолдером {course_title}

    Возврат:
    - (text, progress_type) где:
      - text: строка с текстом сообщения
      - progress_type: тип прогресса ("none", "lt3", "lt5", "all") для прогресс-слотов, None для остальных
    - Если маркер не распознан — возвращаем (False, None).

    Логика определения прогресса:
    - none: 0 завершенных уроков
    - lt3: 1-2 завершенных урока  
    - lt5: 3-4 завершенных урока
    - all: 5+ завершенных уроков
    """

    key = message_marker.strip()

    # Простые константы - возвращаем сразу (приветственные не зависят от курса)
    simple_map = {
        "welcome_1": WELCOME_1,
        "welcome_2": WELCOME_2,
        "pro_welcome_12m": PRO_WELCOME_12M,
        "pro_next_day": PRO_NEXT_DAY,
    }

    if key in simple_map:
        return simple_map[key], None

    # Все остальные сообщения требуют курс - проверяем его наличие один раз
    course_data = await db.get_records_sql("SELECT title FROM courses WHERE id = $1", course_id)
    if not course_data or not course_data[0]['title']:
        logger.error(f"Курс {course_id} не найден или не имеет названия")
        return False, None
    course_title = course_data[0]['title']

    # Уведомления об окончании доступа - подставляем название курса
    if key in ["access_ended_1", "access_ended_2"]:
        if key == "access_ended_1":
            return ACCESS_ENDED_1.format(course_title=course_title), None
        if key == "access_ended_2":
            return ACCESS_ENDED_2.format(course_title=course_title), None

    # Прогресс-слоты: проверяем реальный прогресс пользователя по конкретному курсу
    if key in ["progress_slot_day1_1934", "progress_slot_day2_2022", "progress_slot_day3_0828"]:
        try:
            
            # Получаем количество завершенных уроков для пользователя по конкретному курсу
            completed_lessons = await db.get_records_sql("""
                SELECT COUNT(*) as completed_count
                FROM lesson_completions lc
                JOIN lessons l ON lc.lesson_id = l.id
                WHERE lc.user_id = $1 AND l.course_id = $2
            """, user_id, course_id)
            
            completed_count = completed_lessons[0]['completed_count'] if completed_lessons else 0
            
            # Определяем ключ прогресса на основе количества завершенных уроков
            if completed_count == 0:
                progress_key = "none"
            elif completed_count <= 2:
                progress_key = "lt3"
            elif completed_count <= 4:
                progress_key = "lt5"
            else:  # 5 и более
                progress_key = "all"
            
            # Выбираем соответствующий словарь и текст с подстановкой названия курса
            if key == "progress_slot_day1_1934":
                text = DAY1_1934.get(progress_key, DAY1_1934["none"])
                return text.format(course_title=course_title), progress_key
            elif key == "progress_slot_day2_2022":
                text = DAY2_2022.get(progress_key, DAY2_2022["none"])
                return text.format(course_title=course_title), progress_key
            elif key == "progress_slot_day3_0828":
                text = DAY3_0828.get(progress_key, DAY3_0828["none"])
                return text.format(course_title=course_title), progress_key
                
        except Exception as e:
            logger.error(f"Ошибка при получении прогресса пользователя {user_id} для курса {course_id}: {e}")
            # В случае ошибки не отправляем ничего
            return False, None

    # Если ничего не подошло — возвращаем False
    return False, None


async def _cancel_future_progress_slots_if_completed(db, user_id: int, course_id: int, progress_type: str):
    """
    Отменяет будущие прогресс-слоты, если пользователь уже прошел все уроки.
    
    Логика:
    - Если progress_type == "all" (пользователь прошел 5+ уроков),
      отменяем все pending прогресс-слоты для этого пользователя по конкретному курсу
    - Отменяем только progress_slot_* уведомления, остальные оставляем
    
    Args:
        db: Экземпляр PGApi
        user_id: ID пользователя
        course_id: ID курса
        progress_type: Тип прогресса ("none", "lt3", "lt5", "all")
    """
    try:
        # Отменяем прогресс-слоты только если пользователь прошел все уроки
        if progress_type == "all":
            result = await db.execute("""
                UPDATE notifications 
                SET status = 'cancelled', 
                    error = 'Отменено: пользователь уже прошел все уроки'
                WHERE user_id = $1 
                  AND course_id = $2
                  AND status = 'pending' 
                  AND message LIKE 'progress_slot_%'
            """, user_id, course_id, execute=True)
            
            # Извлекаем количество обновленных записей из строки результата
            cancelled_count = 0
            if isinstance(result, str) and result.startswith("UPDATE "):
                try:
                    cancelled_count = int(result.split()[1])
                except (IndexError, ValueError):
                    cancelled_count = 0
            
            if cancelled_count > 0:
                logger.info(f"Отменено {cancelled_count} будущих прогресс-слотов для пользователя {user_id} по курсу {course_id} (прошел все уроки)")
                
    except Exception as e:
        logger.error(f"Ошибка при отмене будущих прогресс-слотов для пользователя {user_id} по курсу {course_id}: {e}")


async def notification_worker(bot: Bot, db):
    """
    Воркер для обработки очереди уведомлений.
    
    Логика работы:
    1. Каждые 30 секунд проверяет pending уведомления с scheduled_at <= NOW()
    2. Резолвит текст сообщения через resolve_message_text
    3. Отправляет сообщение через send_telegram_message
    4. Обновляет статус уведомления (sent/failed)
    5. При ошибке увеличивает attempts и планирует ретрай
    """
    logger.info("Запуск воркера уведомлений")
    
    while True:
        try:
            # Получаем pending уведомления, готовые к отправке
            # Используем FOR UPDATE SKIP LOCKED для конкурентной обработки
            notifications = await db.get_records_sql("""
                SELECT id, user_id, course_id, telegram_id, message, attempts, max_attempts, ext_data
                FROM notifications 
                WHERE status = 'pending' 
                  AND scheduled_at <= NOW() AT TIME ZONE 'UTC'
                ORDER BY scheduled_at ASC
                LIMIT 10
                FOR UPDATE SKIP LOCKED
            """)
            
            if not notifications:
                # Нет уведомлений для обработки, ждем 30 секунд
                await asyncio.sleep(30)
                continue
            
            logger.info(f"Найдено {len(notifications)} уведомлений для отправки")
            
            for notification in notifications:
                notification_id = notification['id']
                user_id = notification['user_id']
                telegram_id = notification['telegram_id']
                message_marker = notification['message']
                attempts = notification['attempts']
                max_attempts = notification['max_attempts']
                
                try:
                    # Резолвим текст сообщения с учетом прогресса пользователя и курса
                    course_id = notification.get('course_id', 0)
                    result = await resolve_message_text(message_marker, user_id, course_id, db)
                    
                    # Проверяем, что resolve_message_text вернул кортеж
                    if not result or not isinstance(result, tuple) or len(result) != 2:
                        logger.warning(f"Не удалось резолвить сообщение для маркера: {message_marker}, результат: {result}")
                        # Помечаем как failed
                        await db.update_record("notifications", notification_id,
                            {"status": "failed", "error": f"Неизвестный маркер: {message_marker}"}
                        )
                        continue
                    
                    message_text, progress_type = result
                    
                    if not message_text:
                        logger.warning(f"Не удалось резолвить сообщение для маркера: {message_marker}")
                        # Помечаем как failed
                        await db.update_record("notifications", notification_id,
                            {"status": "failed", "error": f"Неизвестный маркер: {message_marker}"}
                        )
                        continue
                    
                    # Отправляем сообщение
                    status, error_text, attempts_used = await send_telegram_message(
                        bot, telegram_id, message_text, max_attempts
                    )
                    
                    # Обновляем статус в БД (используем данные из send_telegram_message)
                    update_data = {
                        "status": status,
                        "attempts": attempts_used,  # Записываем количество использованных попыток
                        "error": error_text,
                    }
                    
                    if status == "sent":
                        update_data["sent_at"] = datetime.now(timezone.utc)
                        logger.info(f"Уведомление {notification_id} успешно отправлено пользователю {telegram_id}")
                    else:
                        logger.error(f"Уведомление {notification_id} провалено: {error_text}")
                    
                    await db.update_record("notifications", notification_id, update_data)
                    
                    # Проверяем, нужно ли отменить последующие прогресс-слоты (для любого исхода)
                    if progress_type:
                        await _cancel_future_progress_slots_if_completed(db, user_id, course_id, progress_type)
                    
                    # Небольшая пауза между отправками для rate limiting
                    await asyncio.sleep(0.1)
                    
                except Exception as e:
                    logger.error(f"Ошибка при обработке уведомления {notification_id}: {e}", exc_info=True)
                    # Помечаем как failed при критической ошибке
                    await db.update_record("notifications", notification_id,
                        {
                            "status": "failed",
                            "error": f"Критическая ошибка: {str(e)}"
                        }
                    )
            
            # Пауза между циклами обработки
            await asyncio.sleep(5)
            
        except Exception as e:
            logger.error(f"Ошибка в воркере уведомлений: {e}", exc_info=True)
            # При критической ошибке ждем дольше перед повтором
            await asyncio.sleep(60)
