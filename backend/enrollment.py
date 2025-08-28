"""
Модуль для работы с записями пользователей на курсы.
Содержит функции для создания и обновления записей пользователей на курсы.
"""

from datetime import datetime, timedelta, timezone
from logger import logger

# Константы статусов подписки
ENROLLMENT_STATUS_NOT_ENROLLED = 0  # Незаписан
ENROLLMENT_STATUS_ENROLLED = 1      # Записан


async def create_user_enrollment(db, user_id: int, course_id: int):
    """
    Создает запись пользователя на курс при первом входе.
    Если запись уже существует, не создает новую и не обновляет существующую.
    
    Args:
        db: Объект базы данных
        user_id: ID пользователя
        course_id: ID курса
    
    Returns:
        bool: True если запись создана или уже существует, False при ошибке
    """
    try:
        # Проверяем, существует ли уже запись для этого пользователя и курса
        existing_enrollment = await db.get_record('user_enrollment', {
            'user_id': user_id,
            'course_id': course_id
        })
        
        if existing_enrollment:
            logger.info(f"Запись на курс {course_id} для пользователя {user_id} уже существует")
            return True
        
        # Получаем информацию о курсе для определения времени доступа
        course = await db.get_record('courses', {'id': course_id})
        if not course:
            logger.error(f"Курс {course_id} не найден")
            return False
        
        # Получаем время доступа к курсу (в часах)
        access_time_hours = course.get('access_time', 0)
        
        # Вычисляем время окончания доступа (используем timezone-aware время в UTC)
        current_time = datetime.now(timezone.utc)
        
        # Если access_time == 0, создаем бесконечную подписку (time_end = None)
        if access_time_hours == 0:
            time_end = None
            logger.info(f"Курс {course_id} не имеет ограничений по времени (access_time = 0), создается бесконечная подписка")
        else:
            time_end = current_time + timedelta(hours=access_time_hours)
        
        # Создаем запись
        enrollment_data = {
            'user_id': user_id,
            'course_id': course_id,
            'time_start': current_time,
            'time_end': time_end,
            'status': ENROLLMENT_STATUS_ENROLLED
        }
        
        enrollment_id = await db.insert_record('user_enrollment', enrollment_data)
        logger.info(f"Создана запись на курс {course_id} для пользователя {user_id} с ID {enrollment_id}")
        return True
        
    except Exception as e:
        logger.error(f"Ошибка при создании записи на курс: {e}")
        return False


async def update_user_enrollment(db, user_id: int, course_id: int):
    """
    Проверяет не вышло ли время доступа к курсу и обновляет статус записи.
    Если время вышло, меняет статус на 0 (незаписан).
    
    Args:
        db: Объект базы данных
        user_id: ID пользователя
        course_id: ID курса
    
    Returns:
        bool: True если обновление прошло успешно, False при ошибке
    """
    try:
        # Получаем запись пользователя на курс
        enrollment = await db.get_record('user_enrollment', {
            'user_id': user_id,
            'course_id': course_id
        })
        
        if not enrollment:
            logger.info(f"Запись на курс {course_id} для пользователя {user_id} не найдена")
            return True  # Нет записи - считаем успешным
        
        # Проверяем, не истекло ли время доступа (используем timezone-aware время в UTC)
        current_time = datetime.now(timezone.utc)
        # Если current_time вернулся naive (например, замокан), приводим к UTC
        if getattr(current_time, 'tzinfo', None) is None:
            current_time = current_time.replace(tzinfo=timezone.utc)
        time_end = enrollment.get('time_end')
        # Приводим time_end к timezone-aware UTC, если он naive (без isinstance, чтобы не ломаться при моках)
        if time_end is not None and getattr(time_end, 'tzinfo', None) is None:
            time_end = time_end.replace(tzinfo=timezone.utc)
        
        # Если time_end == None, подписка бесконечная
        if time_end is None:
            logger.info(f"Подписка на курс {course_id} для пользователя {user_id} бесконечная (time_end = None)")
            return True
        
        if time_end and current_time > time_end:
            # Время истекло, обновляем статус на незаписан
            await db.update_record('user_enrollment', enrollment['id'], {
                'status': ENROLLMENT_STATUS_NOT_ENROLLED
            })
            logger.info(f"Время доступа к курсу {course_id} для пользователя {user_id} истекло, статус обновлен")
        
        return True
        
    except Exception as e:
        logger.error(f"Ошибка при обновлении записи на курс: {e}")
        return False


async def get_course_access_info(db, user_id: int, course_id: int):
    """
    Вычисляет оставшееся время доступа и статус записи пользователя на курс.
    
    Args:
        db: Объект базы данных
        user_id: ID пользователя
        course_id: ID курса
    
    Returns:
        dict: Словарь с ключами 'time_left' и 'user_enrolment'
    """
    try:
        # Проверяем и обновляем статус записи пользователя на курс
        await update_user_enrollment(db, user_id, course_id)
        
        # Получаем запись пользователя на курс
        enrollment = await db.get_record('user_enrollment', {
            'user_id': user_id,
            'course_id': course_id
        })
        
        # Получаем информацию о курсе
        course = await db.get_record('courses', {'id': course_id})
        if not course:
            logger.error(f"Курс {course_id} не найден")
            return {'time_left': 0, 'user_enrolment': ENROLLMENT_STATUS_NOT_ENROLLED}
        
        # Вычисляем оставшееся время доступа
        time_left = 0
        user_enrolment_status = ENROLLMENT_STATUS_NOT_ENROLLED
        
        if enrollment and enrollment.get('status') == ENROLLMENT_STATUS_ENROLLED:
            user_enrolment_status = ENROLLMENT_STATUS_ENROLLED
            time_end = enrollment.get('time_end')
            if time_end is None:
                # Бесконечная подписка
                time_left = -1  # Специальное значение для бесконечной подписки
            elif time_end:
                # Приводим time_end к timezone-aware UTC, если он naive
                if getattr(time_end, 'tzinfo', None) is None:
                    time_end = time_end.replace(tzinfo=timezone.utc)
                current_time = datetime.now(timezone.utc)
                if getattr(current_time, 'tzinfo', None) is None:
                    current_time = current_time.replace(tzinfo=timezone.utc)
                time_diff = time_end - current_time
                time_left = max(0, time_diff.total_seconds() / 3600)  # Конвертируем в часы
        else:
            # Если записи нет, возвращаем время доступа из курса
            access_time = course.get('access_time', 0)
            if access_time == 0:
                time_left = -1  # Курс без ограничений по времени
            else:
                time_left = access_time
        
        # Округляем время доступа до 2 знаков после запятой
        time_left = round(time_left, 2)
        
        logger.info(f"Курс {course_id}, пользователь {user_id}: time_left={time_left}, status={user_enrolment_status}")
        
        return {
            'time_left': time_left,
            'user_enrolment': user_enrolment_status
        }
        
    except Exception as e:
        logger.error(f"Ошибка при вычислении времени доступа к курсу: {e}")
        return {'time_left': 0, 'user_enrolment': ENROLLMENT_STATUS_NOT_ENROLLED}
