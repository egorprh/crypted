import asyncio
import traceback
from fastapi import FastAPI, HTTPException, Request
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from contextlib import asynccontextmanager
from typing import Any, AsyncGenerator, Dict
from db.pgapi import PGApi
from db.models import UserProgress
# from telegram_bot import send_telegram_message
import json


###
# Сервисы:
# 1) Получение данных для приложения: вопросы, ивенты, курсы+уроки+ответы, домашка для пользователя, входное тестирование
# 3) Сохранение результата теста
# 4) Отпрвка в бота при нажатии кнопки "Начать" (с сохранением этого факта)
# 5) Сохранение пользователя
###

db = PGApi()

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
            print("Приложение запущено")
            break  # Если подключение успешно, выходим из цикла
        except Exception as e:
            attempt += 1
            if attempt == max_retries:
                print(f"Не удалось подключиться к базе данных после {max_retries} попыток. Ошибка: {e}")
                raise  # Выбрасываем исключение, чтобы завершить работу приложения
            print(f"Попытка {attempt} не удалась. Повторная попытка через {retry_delay} секунд...")
            await asyncio.sleep(retry_delay)  # Ждем перед следующей попыткой
    
    yield  # Основной код приложения выполняется здесь
    print("Приложение завершено")
    
    # app teardown
    try:
        await db.close()  # Закрытие соединения с базой данных
    except Exception as e:
        print(f"Ошибка при закрытии соединения с базой данных: {e}")



#https://habr.com/ru/articles/799337/
app = FastAPI(lifespan=lifespan)

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
    

async def trigger_event(event_name: str, user_id: int, instance_id: int):
    """
    Триггерит событие с указанным именем и данными.
    """
    params = {
        "user_id": user_id,
        "instance_id": instance_id,
        "action": event_name,
    }
    event_id = await db.insert_record('user_actions_log', params)

    # Отправка уведолмения в Telegram
    # asyncio.create_task(send_telegram_message(params))

    print(f"Triggered event: {params}")

    return event_id


@app.get("/ping")
async def ping():
    return {"status": "ok", "message": "Pong"}


# Cобытие просмотра курса 
@app.post("/api/save_user")
async def course_viewed(request: Request):
    request = await request.json()
    params = {
        "telegram_id": request["id"],
        "username": request["username"],
        "first_name": request["first_name"],
        "last_name": request["last_name"],
    }
    # Вызов метода insert_record
    if await db.get_record('users', {'telegram_id':request["id"]}) is None:
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
    asyncio.create_task(trigger_event('enter_survey', user["id"], request["surveyId"]))

    # Записывем ответы пользователей
    for request_answer in request["answers"]:
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
@app.post("/api/save_progress")
async def save_progress(request: Request):
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
        record_id = await db.insert_record('user_progress', params)

        # Записывем ответы пользователей
        for request_answer in request["answers"]:
            params = {
                "user_id": user["id"],
                "instance_qid": request_answer["questionId"],
                "type": 'quiz',
                "answer_id": request_answer["answerId"],
                # "text": request_answer["answer"],
            }
            # Вызов метода insert_record
            await db.insert_record('user_answers', params)

        # Возвращаем успешный ответ
        return {
            "status": "success",
            "message": f"Progress saved successfully with ID: {record_id}",
            "data": {"id": record_id},
        }

    except Exception as e:
        # Логируем ошибку (можно использовать logging)
        print(f"Error saving progress: {e}")
        traceback.print_exc()  # Вывод полной трассировки ошибки

        # Возвращаем ошибку
        raise HTTPException(status_code=500, detail="Failed to save progress")


@app.get("/api/get_app_data")
async def get_app_data(user_id: int):
    user = await db.get_record("users", {"telegram_id": user_id})

    courses = await db.get_records("courses", {"visible": True})
    for course in courses:
        lessons = await db.get_records("lessons", {"course_id": course["id"]})
        for lesson in lessons:
            lesson["materials"] = await db.get_records("materials", {"lesson_id": lesson["id"]})
            lesson["quizzes"] = await db.get_records("quizzes", {"lesson_id": lesson["id"]})
            for quiz in lesson["quizzes"]:
                quiz["questions"] = await db.get_records_sql(
                    f"""SELECT q.* FROM quiz_questions qq
                    JOIN questions q ON qq.question_id = q.id
                    AND qq.quiz_id = $1 AND q.visible = $2""", quiz["id"], True)
                for question in quiz["questions"]:
                    question["answers"] = await db.get_records("answers", {"question_id": question["id"]})

        course["lessons"] = lessons

    events = await db.get_records("events")

    faq = await db.get_records("faq")

    config = await db.get_records("config")

    homeworks_sql = f"""
        SELECT 
            up.id, 
            up.quiz_id, 
            up.user_id, 
            up.progress, 
            c.title AS course_title, 
            l.title AS lesson_title
        FROM user_progress up
        LEFT JOIN quizzes q ON up.quiz_id = q.id
        LEFT JOIN lessons l ON q.lesson_id = l.id
        LEFT JOIN courses c ON l.course_id = c.id
        WHERE up.id IN (
            SELECT MAX(up_inner.id)
            FROM user_progress up_inner
            WHERE up_inner.user_id = {user["id"]}
            GROUP BY up_inner.quiz_id
        )
        AND up.user_id = {user["id"]};
    """
    homeworks = await db.get_records_sql(homeworks_sql)
    for homework in homeworks:
        homework["questions"] = await db.get_records_sql("""
                    SELECT qq.id, q.id AS qid, q.text, q.type FROM quiz_questions qq
                    JOIN questions q ON qq.question_id = q.id
                    AND qq.quiz_id = $1 AND q.visible = $2""", homework["quiz_id"], True)
        for question in homework["questions"]:
            question["answers"] = await db.get_records("answers", {"question_id": question["qid"]})
            for answer in question["answers"]:
                # Берем последний ответ пользователя на вопрос
                user_answer = await db.get_records_sql("""
                    SELECT * FROM user_answers 
                    WHERE type = 'quiz' AND user_id = $1 AND instance_qid = $2 AND answer_id = $3
                    ORDER BY id DESC LIMIT 1""",
                    user["id"], question["qid"], answer["id"])

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
    if await db.get_record("user_actions_log", {"user_id": user["id"], "action": "enter_survey"}) is None:
        enter_survey = await db.get_records_sql(f"""SELECT * FROM surveys WHERE visible = $1 LIMIT 1""", True)
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



# Static frontend
app.mount("/", StaticFiles(directory="../frontend/dist", html=True), name="static")

@app.get("/")
async def serve_frontend():
    return FileResponse("../frontend/dist/index.html")