import asyncio
import os
import time
import traceback
from datetime import datetime, timedelta
from fastapi import FastAPI, HTTPException, Request
from fastapi.exception_handlers import http_exception_handler
from fastapi.responses import JSONResponse, RedirectResponse
from starlette.exceptions import HTTPException as StarletteHTTPException
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from contextlib import asynccontextmanager
from typing import Any, AsyncGenerator, Dict
from db.pgapi import PGApi
from notification_service import send_service_message, send_service_document
from config import load_config
import json
from logger import logger  # Импортируем логгер
# Импортируем функции для работы с записями пользователей на курсы
from enrollment import create_user_enrollment, get_course_access_info
# Импортируем вспомогательные функции
from misc import send_survey_to_crm, remove_timestamps

# Импорт для настройки админки
from admin.admin_setup import setup_admin


db = PGApi()

# Хранилище для отслеживания запросов
request_timestamps: Dict[str, float] = {}

# Флаг состояния подключения к БД
db_connected = False

def check_db_connection():
    """Проверяет, подключена ли БД"""
    return db_connected


async def daily_db_backup():
    """
    Фоновая задача для создания дампа базы данных раз в день.
    Создает сжатый архив и отправляет его в Telegram канал.
    """
    # Загружаем конфигурацию
    config = load_config("../.env")
    
    while True:
        try:
            logger.info("Запуск фоновой задачи для создания дампа базы данных.")
            
            # Создаем дамп и получаем путь к архиву
            archive_path = await db.create_db_dump()
            
            # Отправляем архив в Telegram канал
            if archive_path and os.path.exists(archive_path):
                try:
                    # Получаем размер архива
                    archive_size = os.path.getsize(archive_path)
                    archive_size_mb = archive_size / (1024 * 1024)
                    
                    # Формируем сообщение
                    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                    message = f"📦 <b>Ежедневный дамп базы данных</b>\n\n"
                    message += f"📅 Дата: {timestamp}\n"
                    message += f"📊 Размер: {archive_size_mb:.2f} MB\n"
                    message += f"✅ Статус: Успешно создан"
                    
                    # Отправляем сообщение
                    await send_service_message(message)
                    
                    # Отправляем файл архива
                    await send_service_document(
                        archive_path,
                        f"🗄️ Дамп БД от {timestamp}"
                    )
                    
                    logger.info(f"Архив дампа отправлен в канал: {archive_path}")
                    
                except Exception as e:
                    logger.error(f"Ошибка при отправке архива в Telegram: {e}")
                    # Отправляем сообщение об ошибке
                    error_message = f"❌ <b>Ошибка отправки дампа</b>\n\nДамп создан, но не отправлен в канал.\nОшибка: {str(e)}"
                    await send_service_message(error_message)
            
            logger.info("Дамп базы данных успешно создан и отправлен.")
            
            # Очищаем старые дампы (оставляем только последние 3 дня)
            try:
                await db.cleanup_old_dumps(keep_days=3)
            except Exception as cleanup_error:
                logger.error(f"Ошибка при очистке старых дампов: {cleanup_error}")
            
        except Exception as e:
            logger.error(f"Ошибка при создании дампа базы данных: {e}")
            # Отправляем сообщение об ошибке
            try:
                error_message = f"❌ <b>Ошибка создания дампа БД</b>\n\nОшибка: {str(e)}"
                await send_service_message(error_message)
            except Exception as send_error:
                logger.error(f"Не удалось отправить сообщение об ошибке: {send_error}")
        
        # Ожидаем 24 часа перед следующим выполнением
        await asyncio.sleep(24*60*60)


# https://medium.com/@marcnealer/fastapi-after-the-getting-started-867ecaa99de9
@asynccontextmanager
async def lifespan(app: FastAPI):
    # app startup
    max_retries = 3  # Максимальное количество попыток подключения
    retry_delay = 2  # Задержка между попытками (в секундах)
    
    global db_connected
    db_connected = False
    attempt = 0
    while attempt < max_retries:
        try:
            await db.create()  # Попытка подключения к базе данных
            db_connected = True
            # Запуск фоновой задачи только если БД подключена
            asyncio.create_task(daily_db_backup())
            logger.info("Приложение запущено с подключением к БД")
            break  # Если подключение успешно, выходим из цикла
        except Exception as e:
            attempt += 1
            if attempt == max_retries:
                logger.warning(f"Не удалось подключиться к базе данных после {max_retries} попыток. Ошибка: {e}")
                logger.info("Приложение запускается без подключения к БД")
                break  # Не выбрасываем исключение, продолжаем работу
            logger.info(f"Попытка {attempt} не удалась. Повторная попытка через {retry_delay} секунд...")
            await asyncio.sleep(retry_delay)  # Ждем перед следующей попыткой

    await send_service_message("DeptSpace запущен! Состояние БД: " + ("Подключена" if db_connected else "Не подключена"))

    yield  # Основной код приложения выполняется здесь
    logger.info("Приложение остановлено")
    await send_service_message("DeptSpace остановлен! Проверьте, если это не запланировано")
    
    # app teardown
    if db_connected:
        try:
            await db.close()  # Закрытие соединения с базой данных
        except Exception as e:
            logger.info(f"Ошибка при закрытии соединения с базой данных: {e}")



#https://habr.com/ru/articles/799337/
app = FastAPI(lifespan=lifespan)

# Настраиваем админ панель
setup_admin(app)


async def trigger_event(event_name: str, user_id: int, instance_id: int, data: Any = None):
    """
    Триггерит событие с указанным именем и данными.
    """
    if not check_db_connection():
        logger.warning(f"Database not connected, skipping event: {event_name}")
        return None
    
    params = {
        "user_id": user_id,
        "instance_id": instance_id,
        "action": event_name,
    }
    event_id = await db.insert_record('user_actions_log', params)

    user = await db.get_record("users", {"id": user_id})
    level = await db.get_record("levels", {"id": user["level"]})

    if event_name == 'course_viewed':
        course = await db.get_record("courses", {"id": instance_id})
        text = f"""
        Переход в курс DSpace!

Пользователь @{user["username"]} ({user["telegram_id"]}) {user["first_name"]} {user["last_name"]} зашел в курс "{course['title']}"
        """
    elif event_name == 'enter_survey':
        formatted_answers = "\n".join([f"<b>{question['question']}</b>: {question['answer']}" for question in data])
        text = f"""
        Пользователь @{user["username"]} ({user["telegram_id"]}) {user["first_name"]} {user["last_name"]} прошел входное тестирование в DSpace!

{formatted_answers}
<b>Уровень:</b> {level["name"]}
        """
        
        # Отправляем данные в CRM
        asyncio.create_task(send_survey_to_crm(user, data, level))
    elif event_name == 'course_completed':
        course = await db.get_record("courses", {"id": instance_id})
        text = f"""
        Переход в курс DSpace!

Пользователь @{user["username"]} ({user["telegram_id"]}) {user["first_name"]} {user["last_name"]} прошел все тесты в курсе "{course['title']}"
        """
    
    if text:
        asyncio.create_task(send_service_message(text))

    logger.info(f"Triggered event: {params}")

    return event_id


async def get_user_homeworks_by_course(user_id: int, course_id: int):
    homeworks_sql = f"""
        SELECT 
            up.id, 
            up.quiz_id, 
            up.user_id, 
            up.progress, 
            c.title AS course_title, 
            l.title AS lesson_title
        FROM quiz_attempts up
        LEFT JOIN quizzes q ON up.quiz_id = q.id
        LEFT JOIN lessons l ON q.lesson_id = l.id
        LEFT JOIN courses c ON l.course_id = c.id
        WHERE up.id IN (
            SELECT MAX(up_inner.id)
            FROM quiz_attempts up_inner
            WHERE up_inner.user_id = {user_id}
            GROUP BY up_inner.quiz_id
        )
        AND up.user_id = {user_id} AND c.id = {course_id} ORDER BY up.id DESC;
    """
    return await db.get_records_sql(homeworks_sql)


@app.get("/api/ping")
async def ping():
    return {
        "status": "ok", 
        "message": "Pong",
        "database_connected": check_db_connection()
    }


# Cобытие просмотра курса 
@app.post("/api/save_user")
async def save_user(request: Request):
    if not check_db_connection():
        return {"status": "error", "message": "Database not connected"}
    
    request = await request.json()
    logger.info(f"Запрос /api/save_user: {request}")
    params = {
        "telegram_id": request["telegram_id"],  # обязательное поле
        "username": request.get("username", ""),  # если нет - пустая строка
        "first_name": request.get("first_name", ""),  # если нет - пустая строка
        "last_name": request.get("last_name", ""),  # если нет - пустая строка
    }
    # Проверяем существование пользователя
    if await db.get_record('users', {'telegram_id': request["telegram_id"]}) is None:
        logger.info(f"Создаем пользователя: {params}")
        await db.insert_record('users', params)


# Cобытие просмотра курса 
@app.post("/api/course_viewed")
async def course_viewed(request: Request):
    if not check_db_connection():
        return {"status": "error", "message": "Database not connected"}
    
    request = await request.json()
    user_id = request["userId"]
    user = await db.get_record("users", {"telegram_id": user_id})
    
    # Создаем запись пользователя на курс при первом входе
    await create_user_enrollment(db, user["id"], request["courseId"])
    
    asyncio.create_task(trigger_event('course_viewed', user["id"], request["courseId"]))
    return {"status": "success", "message": "Course viewed event triggered."}


# Сохранение уровня пользовтеля 
@app.post("/api/save_level")
async def save_level(request: Request):
    if not check_db_connection():
        return {"status": "error", "message": "Database not connected"}
    
    try:
        request = await request.json()
        user_id = request["telegram_id"]
        level = request["level_id"]
        
        # Получаем пользователя по telegram_id
        user = await db.get_record("users", {"telegram_id": user_id})
        
        if not user:
            return {"status": "error", "message": "User not found"}
        
        # Обновляем уровень пользователя
        await db.update_record("users", user["id"], {"level": level})
        
        logger.info(f"User {user['id']} level updated to {level}")
        
        return {"status": "success", "message": "User level was updated"}
        
    except Exception as e:
        logger.error(f"Error updating user level: {e}")
        return {"status": "error", "message": f"Failed to update user level: {str(e)}"}


# Cобытие просмотра курса 
@app.post("/api/submit_enter_survey")
async def submit_enter_survey(request: Request):
    if not check_db_connection():
        return {"status": "error", "message": "Database not connected"}
    
    request = await request.json()
    user_id = request["userId"]
    user = await db.get_record("users", {"telegram_id": user_id})
    #TODO Почему сразу падаем, а не в фоне?
    asyncio.create_task(trigger_event('enter_survey', user["id"], request["surveyId"], request["verboseAnswers"]))

    # Записывем ответы пользователей
    for request_answer in request["formattedAnswers"]:
        params = {
                "user_id": user["id"],
                "instance_qid": request_answer["questionId"],
                "type": 'survey',
                "answer_id": request_answer["answerId"],
                "text": request_answer["text"],
        }
        # Вызов метода insert_record
        await db.insert_record('user_answers', params)

    return {"status": "success", "message": "Survey entered event triggered."}


# сохранение ответов пользователя на тест к уроку
@app.post("/api/save_attempt")
async def save_attempt(request: Request):
    """
    Сохраняет прогресс пользователя в таблицу UserProgress.
    """
    if not check_db_connection():
        return {"status": "error", "message": "Database not connected"}

    request = await request.json()

    try:
        user_id = request["userId"]
        user = await db.get_record("users", {"telegram_id": user_id})

        # Подготовка данных для вставки
        params = {
            "user_id": user["id"],
            "quiz_id": request["quizId"],
            "progress": request["progress"],
        }
        record_id = await db.insert_record('quiz_attempts', params)

        # Записывем ответы пользователей
        for request_answer in request["answers"]:
            params = {
                "user_id": user["id"],
                "attempt_id": record_id,
                "instance_qid": request_answer["questionId"],
                "type": 'quiz',
                "answer_id": request_answer["answerId"],
                # "text": request_answer["answer"],
            }
            # Вызов метода insert_record
            await db.insert_record('user_answers', params)

        # Получаем количество ДЗ в курсе
        count_homeworks = await db.get_records_sql(
            f"SELECT q.id FROM quizzes q LEFT JOIN lessons l ON q.lesson_id = l.id WHERE l.course_id = {request['courseId']} AND q.visible = True")
        user_homeworks = await get_user_homeworks_by_course(user["id"], request["courseId"])
        
        if len(count_homeworks) == len(user_homeworks):
            asyncio.create_task(trigger_event('course_completed', int(user["id"]), int(request["courseId"])))

        logger.info(f"User {user['id']} completed the quiz {request['quizId']}.")

        # Возвращаем успешный ответ
        return {
            "status": "success",
            "message": f"Progress saved successfully with ID: {record_id}",
            "data": {"id": record_id},
        }

    except Exception as e:
        # Логируем ошибку (можно использовать logging)
        logger.info(f"Error saving progress: {e}")
        traceback.print_exc()  # Вывод полной трассировки ошибки

        # Возвращаем ошибку
        raise HTTPException(status_code=500, detail="Failed to save progress")


@app.get("/api/get_app_data")
async def get_app_data(user_id: int):
    if not check_db_connection():
        # Если БД не подключена, возвращаем данные из файла
        try:
            with open("backend/app_data.json", "r", encoding="utf-8") as f:
                data = json.load(f)
            logger.info("Возвращены данные из app_data.json (БД не подключена)")
            return data
        except FileNotFoundError:
            logger.error("Файл app_data.json не найден")
            return {"status": "error", "message": "Data file not found and database not connected"}
        except Exception as e:
            logger.error(f"Ошибка чтения app_data.json: {e}")
            return {"status": "error", "message": "Failed to load data"}
    
    user = await db.get_record("users", {"telegram_id": user_id})

    # Если пользователь не найден, берем служебного гостя
    if user is None:
        logger.info(f"--> Пользователь не найден, берем служебного гостя")
        user = await db.get_record("users", {"telegram_id": 0})

    courses = await db.get_records_sql("SELECT * FROM courses WHERE visible = $1 AND level <= $2 ORDER BY sort_order", True, user["level"])
    for course in courses:
        # Получаем информацию о времени доступа и статусе записи пользователя на курс
        access_info = await get_course_access_info(db, user["id"], course["id"])
        
        # Добавляем информацию о времени и статусе записи к курсу
        course["time_left"] = access_info["time_left"]
        course["user_enrolment"] = access_info["user_enrolment"]
        
        lessons = await db.get_records_sql("SELECT * FROM lessons WHERE course_id = $1 AND visible = $2 ORDER BY id", course["id"], True)
        has_home_work = False
        
        for lesson in lessons:
            lesson["materials"] = await db.get_records_sql("SELECT * FROM materials WHERE lesson_id = $1 AND visible = $2 ORDER BY id", lesson["id"], True)
            lesson["quizzes"] = await db.get_records_sql("SELECT * FROM quizzes WHERE lesson_id = $1 AND visible = $2 ORDER BY id", lesson["id"], True)
            for quiz in lesson["quizzes"]:
                has_home_work = True
                quiz["questions"] = await db.get_records_sql(
                    f"""SELECT q.* FROM quiz_questions qq
                    JOIN questions q ON qq.question_id = q.id
                    AND qq.quiz_id = $1 AND q.visible = $2 ORDER BY id""", quiz["id"], True)
                for question in quiz["questions"]:
                    question["answers"] = await db.get_records("answers", {"question_id": question["id"]})

        # Добавляем количество уроков в курсе
        course["lesson_count"] = len(lessons)
        # Проверяем, есть ли квизы в собранном массиве lessons
        course["has_home_work"] = has_home_work        
        course["lessons"] = lessons

    events = await db.get_records_sql("SELECT * FROM events WHERE visible = $1 ORDER BY sort_order", True)

    faq = await db.get_records_sql("SELECT * FROM faq WHERE visible = $1 ORDER BY id", True)

    config = await db.get_records("config")
    config.append({'name': 'user_level', 'value': str(user["level"])})

    levels = await db.get_records("levels")

    homeworks_sql = f"""
        SELECT 
            up.id, 
            up.quiz_id, 
            up.user_id, 
            up.progress, 
            c.title AS course_title, 
            l.title AS lesson_title,
            l.sort_order AS lesson_order,
            c.id AS course_id
        FROM quiz_attempts up
        LEFT JOIN quizzes q ON up.quiz_id = q.id
        LEFT JOIN lessons l ON q.lesson_id = l.id
        LEFT JOIN courses c ON l.course_id = c.id
        WHERE up.id IN (
            SELECT MAX(up_inner.id)
            FROM quiz_attempts up_inner
            WHERE up_inner.user_id = {user["id"]}
            GROUP BY up_inner.quiz_id
        )
        AND up.user_id = {user["id"]} ORDER BY q.id ASC;
    """
    homeworks = await db.get_records_sql(homeworks_sql)
    for homework in homeworks:
        # Получаем количество уроков в курсе
        lesson_count = await db.get_records_sql(
            "SELECT COUNT(*) FROM lessons WHERE course_id = $1 AND visible = $2", 
            homework["course_id"], True
        )
        homework["lesson_count"] = lesson_count[0]["count"] if lesson_count else 0
        
        homework["questions"] = await db.get_records_sql("""
                    SELECT qq.id, q.id AS qid, q.text, q.type FROM quiz_questions qq
                    JOIN questions q ON qq.question_id = q.id
                    AND qq.quiz_id = $1 AND q.visible = $2 ORDER BY qq.id""", homework["quiz_id"], True)
        for question in homework["questions"]:
            question["answers"] = await db.get_records("answers", {"question_id": question["qid"]})
            for answer in question["answers"]:
                # Берем последний ответ пользователя на вопрос
                user_answer = await db.get_records_sql("""
                    SELECT * FROM user_answers 
                    WHERE type = 'quiz' AND user_id = $1 AND instance_qid = $2 AND answer_id = $3 AND attempt_id = $4
                    ORDER BY id DESC LIMIT 1""",
                    user["id"], question["qid"], answer["id"], homework["id"])

                answer["user_answer"] = len(user_answer) != 0

    # Формируем данные для возврата
    data = {
        "courses": courses, 
        "events": events,
        "homework": homeworks,
        "faq": faq,
        "levels": levels,
        "config": config,
        "events_count": len(events) # Это ключ нужен для плашки с количеством ивентов
    }

    # Если пользователь не прошел входное тестирование, добавляем его
    enter_survey = await db.get_records_sql(f"""SELECT * FROM surveys WHERE visible = $1 LIMIT 1""", True)
    user_actions = await db.get_records("user_actions_log", {"user_id": user["id"], "action": "enter_survey"})
    if len(enter_survey) > 0 and len(user_actions) == 0:
        enter_survey = enter_survey[0]
        enter_survey["questions"] = await db.get_records_sql(
                        """SELECT sq.id, q.text, q.type FROM survey_questions sq
                        JOIN questions q ON sq.question_id = q.id
                        AND sq.survey_id = $1 AND q.visible = $2""",
                        enter_survey["id"], True)
        for question in enter_survey["questions"]:
                question["answers"] = await db.get_records("answers", {"question_id": question["id"]})

        data["enter_survey"] = enter_survey

    # Удаляем ключи time_created и time_modified
    data = remove_timestamps(data)

    # Сохраняем данные в JSON-файл для отладки
    with open("backend/app_data.json", "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=4)

    return data


# Роут для фавикона
@app.get("/favicon.ico")
async def favicon():
    return FileResponse(
        os.path.join(os.path.dirname(__file__), "..", "frontend", "dist", "images", "favicon.ico"),
        media_type="image/x-icon"
    )


# Обработчик для несуществующих маршрутов
@app.exception_handler(StarletteHTTPException)
async def custom_404_handler(request: Request, exc: StarletteHTTPException):
    if exc.status_code == 404:
        # Выполняем редирект на главную страницу или другую страницу
        return RedirectResponse(url="/")
    # Если статус-код не 404, возвращаем стандартный ответ
    return await http_exception_handler(request, exc)


# Static frontend - монтируем на корневой путь, но после роутов
app.mount("/", StaticFiles(directory=os.path.join(os.path.dirname(__file__), "..", "frontend", "dist"), html=True), name="static")
