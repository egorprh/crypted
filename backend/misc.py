"""
Вспомогательные функции для работы с внешними сервисами
"""

import asyncio
import aiohttp

from typing import Dict
from config import load_config
from logger import logger


async def send_survey_to_crm(user: Dict, survey_data: list, level: Dict):
    """
    Отправляет данные опроса пользователя в CRM через webhook.
    
    Args:
        user: Данные пользователя
        survey_data: Список ответов на вопросы опроса
        level: Данные уровня пользователя
    """
    try:
        # Загружаем конфигурацию
        config = load_config("../.env")
        
        if not config.misc.crm_webhook_url:
            logger.warning("CRM webhook URL не настроен, пропускаем отправку в CRM")
            return
        
        # Логируем исходные данные опроса
        logger.info(f"Исходные данные опроса: {survey_data}")
        
        # Извлекаем значения имени, возраста и телефона из survey_data
        def extract_answer(keywords):
            for item in survey_data:
                q = str(item.get("question", "")).lower()
                if any(k in q for k in keywords):
                    return item.get("answer")
            return None

        name_value = extract_answer(["имя", "как вас зовут", "фамилия", "фио", "name"])
        age_value = extract_answer(["возраст", "лет", "age"])
        phone_value = extract_answer(["телефон", "phone", "номер"])

        # Формируем плоский payload с требуемыми ключами
        payload = {
            "telegram_id": user["telegram_id"],
            "username": user.get("username"),
            "level_id": level["id"],
            "level": level["name"],
            "name": name_value,
            "age": age_value,
            "phone": phone_value
        }
        
        # Логируем payload для отладки
        logger.info(f"Отправляем в CRM payload: {payload}")
        
        # Отправляем POST запрос в CRM
        async with aiohttp.ClientSession() as session:
            response = await session.post(
                config.misc.crm_webhook_url,
                json=payload,
                headers={"Content-Type": "application/json"},
                timeout=aiohttp.ClientTimeout(total=30)
            )
            if response.status == 200:
                response_text = await response.text()
                logger.info(f"Данные опроса успешно отправлены в CRM для пользователя {user['telegram_id']}")
                logger.info(f"Ответ сервера CRM: {response_text}")
            else:
                logger.error(f"Ошибка отправки в CRM: статус {response.status}, ответ: {await response.text()}")
                    
    except Exception as e:
        logger.error(f"Ошибка при отправке данных в CRM: {e}")
        # Не прерываем выполнение основной логики при ошибке CRM


def remove_timestamps(data):
    """
    Удаляет временные метки из данных для очистки.
    
    Args:
        data: Данные для очистки
        
    Returns:
        Очищенные данные без временных меток
    """
    # Список полей с временными метками, которые нужно удалить
    timestamp_fields = ['created_at', 'updated_at', 'time_created', 'time_modified']
    
    if isinstance(data, dict):
        # Удаляем временные метки и рекурсивно обрабатываем остальные поля
        cleaned_data = {}
        removed_fields = []
        
        for k, v in data.items():
            if k in timestamp_fields:
                removed_fields.append(k)
            else:
                cleaned_data[k] = remove_timestamps(v)
        
        # Логируем удаленные поля (только если они были найдены)
        # if removed_fields:
        #     logger.debug(f"Удалены временные метки: {removed_fields}")
            
        return cleaned_data
    elif isinstance(data, list):
        return [remove_timestamps(item) for item in data]
    else:
        return data


async def get_previous_lesson(course_id: int, current_sort_order: int, db) -> dict:
    """
    Получает предыдущий урок по порядку сортировки.
    
    Args:
        course_id: ID курса
        current_sort_order: Текущий порядок сортировки
        db: Объект базы данных
    
    Returns:
        dict: Данные предыдущего урока или None если это первый урок
    """
    try:
        # Получаем предыдущий урок с меньшим sort_order
        previous_lessons = await db.get_records_sql(
            "SELECT * FROM lessons WHERE course_id = $1 AND visible = $2 AND sort_order < $3 ORDER BY sort_order DESC LIMIT 1",
            course_id, True, current_sort_order
        )
        
        return previous_lessons[0] if previous_lessons else None
        
    except Exception as e:
        logger.error(f"Ошибка при получении предыдущего урока для курса {course_id}, sort_order {current_sort_order}: {e}")
        return None


async def check_lesson_blocked(user_id: int, lesson: dict, course: dict, db) -> bool:
    """
    Проверяет, заблокирован ли урок для пользователя.
    
    Логика блокировки:
    1. Если completion_on = False, урок всегда разблокирован
    2. Если это первый урок (sort_order = 1), урок разблокирован
    3. Иначе проверяется завершение предыдущего урока:
       - Если у предыдущего урока есть задания: проверяется выполнение теста (quiz_attempt)
       - Если у предыдущего урока нет заданий: проверяется просмотр (lesson_viewed)
    
    Args:
        user_id: ID пользователя
        lesson: Данные текущего урока
        course: Данные курса
        db: Объект базы данных
    
    Returns:
        bool: True если урок заблокирован, False если доступен
    """
    try:
        # Проверяем флаг отслеживания выполнения
        if not course.get("completion_on", False):
            return False
        
        # Первый урок всегда доступен
        if lesson.get("sort_order", 0) == 1:
            return False
        
        # Получаем предыдущий урок
        previous_lesson = await get_previous_lesson(course["id"], lesson["sort_order"], db)
        if not previous_lesson:
            # Если предыдущего урока нет, считаем текущий доступным
            return False
        
        # Проверяем завершение предыдущего урока
        is_previous_completed = await is_lesson_completed_by_user(user_id, previous_lesson["id"], db)
        
        # Урок заблокирован, если предыдущий не завершен
        return not is_previous_completed
        
    except Exception as e:
        logger.error(f"Ошибка при проверке блокировки урока {lesson.get('id')} для пользователя {user_id}: {e}")
        return False


async def mark_lesson_completed(user_id: int, lesson_id: int, db):
    """
    Отмечает урок как завершенный пользователем.
    
    Args:
        user_id: ID пользователя
        lesson_id: ID урока
        db: Объект базы данных
    """
    try:
        # Проверяем, есть ли уже запись о завершении
        existing_completion = await db.get_records_sql(
            "SELECT id FROM lesson_completions WHERE user_id = $1 AND lesson_id = $2",
            user_id, lesson_id
        )
        
        if not existing_completion:
            # Создаем новую запись о завершении
            params = {
                "user_id": user_id,
                "lesson_id": lesson_id
            }
            await db.insert_record('lesson_completions', params)
            logger.info(f"Урок {lesson_id} отмечен как завершенный пользователем {user_id}")
        else:
            logger.info(f"Завершение урока {lesson_id} пользователем {user_id} уже существует")
            
    except Exception as e:
        logger.error(f"Ошибка при отметке завершения урока {lesson_id} для пользователя {user_id}: {e}")


async def is_lesson_completed_by_user(user_id: int, lesson_id: int, db) -> bool:
    """
    Проверяет, завершен ли урок пользователем.
    
    Логика завершения:
    - Если у урока есть задания (тесты): урок завершен только при выполнении теста
    - Если у урока нет заданий: урок завершен при просмотре
    
    Args:
        user_id: ID пользователя
        lesson_id: ID урока
        db: Объект базы данных
    
    Returns:
        bool: True если урок завершен, False в противном случае
    """
    try:
        # Проверяем, есть ли у урока задания
        quizzes = await db.get_records_sql(
            "SELECT id FROM quizzes WHERE lesson_id = $1 AND visible = $2", 
            lesson_id, True
        )
        
        if quizzes:
            # У урока есть задания - проверяем выполнение теста
            # В упрощенной логике: если есть запись в lesson_completions, значит тест выполнен
            quiz_attempts = await db.get_records_sql(
                "SELECT id FROM lesson_completions WHERE user_id = $1 AND lesson_id = $2",
                user_id, lesson_id
            )
            return len(quiz_attempts) > 0
        else:
            # У урока нет заданий - проверяем просмотр
            viewed_records = await db.get_records_sql(
                "SELECT id FROM lesson_completions WHERE user_id = $1 AND lesson_id = $2",
                user_id, lesson_id
            )
            return len(viewed_records) > 0
        
    except Exception as e:
        logger.error(f"Ошибка при проверке завершения урока {lesson_id} для пользователя {user_id}: {e}")
        return False


async def check_enter_survey_completion(user_id: int, db) -> bool:
    """
    Проверяет, прошел ли пользователь входное тестирование.
    
    Проверяет наличие реальных ответов пользователя на вопросы входного опроса
    в таблице user_answers, а не логи в user_actions_log.
    
    Args:
        user_id: ID пользователя
        db: Объект базы данных
    
    Returns:
        bool: True если пользователь прошел входное тестирование, False в противном случае
    """
    try:
        # Получаем активный входной опрос
        enter_survey = await db.get_records_sql(
            "SELECT id FROM surveys WHERE visible = $1 LIMIT 1", 
            True
        )
        
        if not enter_survey:
            # Если нет активного опроса, считаем что тестирование пройдено
            return True
        
        survey_id = enter_survey[0]["id"]
        
        # Проверяем, есть ли у пользователя ответы на вопросы входного опроса
        user_survey_answers = await db.get_records_sql("""
            SELECT COUNT(*) as answer_count 
            FROM user_answers ua
            JOIN survey_questions sq ON ua.instance_qid = sq.id
            WHERE ua.user_id = $1 AND ua.type = 'survey' AND sq.survey_id = $2
        """, user_id, survey_id)
        
        # Если есть хотя бы один ответ на вопросы опроса, считаем тестирование пройденным
        return user_survey_answers[0]["answer_count"] > 0
        
    except Exception as e:
        logger.error(f"Ошибка при проверке прохождения входного тестирования для пользователя {user_id}: {e}")
        # В случае ошибки считаем что тестирование не пройдено
        return False
