import asyncio
import time
import traceback
from fastapi import FastAPI, HTTPException, Request
from fastapi.exception_handlers import http_exception_handler
from fastapi.responses import JSONResponse, RedirectResponse
from starlette.exceptions import HTTPException as StarletteHTTPException
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from contextlib import asynccontextmanager
from typing import Any, AsyncGenerator, Dict
from db.pgapi import PGApi
from telegram_bot import send_service_message, bot
import json
from logger import logger  # Импортируем логгер


db = PGApi()

# Хранилище для отслеживания запросов
request_timestamps: Dict[str, float] = {}


async def daily_db_backup():
    """
    Фоновая задача для создания дампа базы данных раз в день.
    """
    while True:
        try:
            logger.info("Запуск фоновой задачи для создания дампа базы данных.")
            await db.create_db_dump()
            logger.info("Дамп базы данных успешно создан.")
        except Exception as e:
            logger.error(f"Ошибка при создании дампа базы данных: {e}")
        # Ожидаем 24 часа перед следующим выполнением
        await asyncio.sleep(24*60*60)


# https://medium.com/@marcnealer/fastapi-after-the-getting-started-867ecaa99de9
@asynccontextmanager
async def lifespan(app: FastAPI):
    # app startup
    max_retries = 3  # Максимальное количество попыток подключения
    retry_delay = 2  # Задержка между попытками (в секундах)
    
    attempt = 0
    while attempt < max_retries:
        try:
            await db.create()  # Попытка подключения к базе данных
            # Запуск фоновой задачи
            asyncio.create_task(daily_db_backup())
            logger.info("Приложение запущено")
            await send_service_message(bot, "DeptSpace запущен!")
            break  # Если подключение успешно, выходим из цикла
        except Exception as e:
            attempt += 1
            if attempt == max_retries:
                logger.info(f"Не удалось подключиться к базе данных после {max_retries} попыток. Ошибка: {e}")
                raise  # Выбрасываем исключение, чтобы завершить работу приложения
            logger.info(f"Попытка {attempt} не удалась. Повторная попытка через {retry_delay} секунд...")
            await asyncio.sleep(retry_delay)  # Ждем перед следующей попыткой

    yield  # Основной код приложения выполняется здесь
    logger.info("Приложение остановлено")
    await send_service_message(bot, "DeptSpace остановлен! Проверьте, если это не запланировано")
    
    # app teardown
    try:
        await db.close()  # Закрытие соединения с базой данных
    except Exception as e:
        logger.info(f"Ошибка при закрытии соединения с базой данных: {e}")



#https://habr.com/ru/articles/799337/
app = FastAPI(lifespan=lifespan)


# Миддлвар для ограничения запросов
# @app.middleware("http")
# async def rate_limit_middleware(request: Request, call_next):
#     client_ip = request.client.host  # Получаем IP-адрес клиента
#     current_time = time.time()

#     # Проверяем, был ли запрос с этого IP недавно
#     if client_ip in request_timestamps:
#         last_request_time = request_timestamps[client_ip]
#         if current_time - last_request_time < 1:  # Ограничение: 1 запрос каждые 5 секунд
#             logger.warning(f"Слишком частые запросы с IP: {client_ip}")
#             return JSONResponse(
#                 status_code=429,
#                 content={"detail": "Слишком много запросов. Попробуйте снова через 5 секунд."},
#             )

#     # Обновляем время последнего запроса
#     request_timestamps[client_ip] = current_time

#     # Продолжаем обработку запроса
#     response = await call_next(request)
#     return response

def remove_timestamps(data):
    """
    Рекурсивно удаляет ключи time_created и time_modified из всех объектов.
    """
    if isinstance(data, list):
        # Если это список, обрабатываем каждый элемент
        return [remove_timestamps(item) for item in data]
    elif isinstance(data, dict):
        # Если это словарь, удаляем ключи и обрабатываем вложенные структуры
        return {
            key: remove_timestamps(value)
            for key, value in data.items()
            if key not in {"time_created", "time_modified"}
        }
    else:
        # Если это не список и не словарь, возвращаем как есть
        return data
    

async def trigger_event(event_name: str, user_id: int, instance_id: int, data: Any = None):
    """
    Триггерит событие с указанным именем и данными.
    """
    params = {
        "user_id": user_id,
        "instance_id": instance_id,
        "action": event_name,
    }
    event_id = await db.insert_record('user_actions_log', params)

    user = await db.get_record("users", {"id": user_id})

    if event_name == 'course_viewed':
        course = await db.get_record("courses", {"id": instance_id})
        text = f"""
        Переход в курс DSpace!

Пользователь @{user["username"]} {user["first_name"]} {user["last_name"]} зашел в курс "{course['title']}"
        """
    elif event_name == 'enter_survey':
        formatted_answers = "\n".join([f"<b>{question['question']}</b>: {question['answer']}" for question in data])
        text = f"""
        Пользователь @{user["username"]} {user["first_name"]} {user["last_name"]} прошел входное тестирование в DSpace!

{formatted_answers}
        """
    elif event_name == 'course_completed':
        course = await db.get_record("courses", {"id": instance_id})
        text = f"""
        Переход в курс DSpace!

Пользователь @{user["username"]} {user["first_name"]} {user["last_name"]} прошел все тесты в курсе "{course['title']}"
        """
    
    if text:
        asyncio.create_task(send_service_message(bot, text))

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
    return {"status": "ok", "message": "Pong"}


# Cобытие просмотра курса 
@app.post("/api/save_user")
async def save_user(request: Request):
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
    request = await request.json()
    user_id = request["userId"]
    user = await db.get_record("users", {"telegram_id": user_id})
    asyncio.create_task(trigger_event('course_viewed', user["id"], request["courseId"]))
    return {"status": "success", "message": "Course viewed event triggered."}


# Cобытие просмотра курса 
@app.post("/api/submit_enter_survey")
async def submit_enter_survey(request: Request):
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
    user = await db.get_record("users", {"telegram_id": user_id})

    # Если пользователь не найден, берем служебного гостя
    if user is None:
        logger.info(f"--> Пользователь не найден, берем служебного гостя")
        user = await db.get_record("users", {"telegram_id": 0})

    courses = await db.get_records("courses", {"visible": True})
    for course in courses:
        lessons = await db.get_records_sql("SELECT * FROM lessons WHERE course_id = $1 AND visible = $2 ORDER BY id", course["id"], True)
        for lesson in lessons:
            lesson["materials"] = await db.get_records_sql("SELECT * FROM materials WHERE lesson_id = $1 AND visible = $2 ORDER BY id", lesson["id"], True)
            lesson["quizzes"] = await db.get_records_sql("SELECT * FROM quizzes WHERE lesson_id = $1 AND visible = $2 ORDER BY id", lesson["id"], True)
            for quiz in lesson["quizzes"]:
                quiz["questions"] = await db.get_records_sql(
                    f"""SELECT q.* FROM quiz_questions qq
                    JOIN questions q ON qq.question_id = q.id
                    AND qq.quiz_id = $1 AND q.visible = $2 ORDER BY id""", quiz["id"], True)
                for question in quiz["questions"]:
                    question["answers"] = await db.get_records("answers", {"question_id": question["id"]})

        course["lessons"] = lessons

    events = await db.get_records_sql("SELECT * FROM events WHERE visible = $1 ORDER BY date DESC ", True)

    faq = await db.get_records_sql("SELECT * FROM faq WHERE visible = $1 ORDER BY id", True)

    config = await db.get_records("config")

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
            WHERE up_inner.user_id = {user["id"]}
            GROUP BY up_inner.quiz_id
        )
        AND up.user_id = {user["id"]} ORDER BY q.id ASC;
    """
    homeworks = await db.get_records_sql(homeworks_sql)
    for homework in homeworks:
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
        "config": config
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

    # Сохраняем данные в JSON-файл
    with open("app_data.json", "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=4)

    return data

# Обработчик для несуществующих маршрутов
@app.exception_handler(StarletteHTTPException)
async def custom_404_handler(request: Request, exc: StarletteHTTPException):
    if exc.status_code == 404:
        # Выполняем редирект на главную страницу или другую страницу
        return RedirectResponse(url="/")
    # Если статус-код не 404, возвращаем стандартный ответ
    return await http_exception_handler(request, exc)



# Static frontend
app.mount("/", StaticFiles(directory="../frontend/dist", html=True), name="static")

@app.get("/")
async def serve_frontend():
    return FileResponse("../frontend/dist/index.html")
