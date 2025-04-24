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
###

db = PGApi()

# https://medium.com/@marcnealer/fastapi-after-the-getting-started-867ecaa99de9
@asynccontextmanager
async def lifespan(app: FastAPI):
    # app startup
    await db.create()
    yield
    # app teardown


#https://habr.com/ru/articles/799337/
app = FastAPI(lifespan=lifespan)


@app.get("/ping")
async def ping():
    return {"status": "ok", "message": "Pong"}


@app.get("/get_courses")
async def get_courses():
    courses = await db.get_records("courses")

    for course in courses:
        lessons = await db.get_records("lessons", {"course_id": course["id"]})
        for lesson in lessons:
            lesson["materials"] = await db.get_records("materials", {"lesson_id": lesson["id"]})
            lesson["quizzes"] = await db.get_records("quizzes", {"lesson_id": lesson["id"]})
            for quiz in lesson["quizzes"]:
                quiz["questions"] = await db.get_records("questions", {"quiz_id": quiz["id"]})
                for question in quiz["questions"]:
                    question["answers"] = await db.get_records("answers", {"question_id": question["id"]})

        course["lessons"] = lessons

    return remove_timestamps(courses)


@app.get("/get_events")
async def get_events():
    events = await db.get_records("events")
    return remove_timestamps(events)


@app.get("/get_faq")
async def get_faq():
    faq = await db.get_records("faq")
    return remove_timestamps(faq)


@app.get("/get_homework")
async def get_homework(user_id: int):
    up_sql = f"""
    SELECT up.id, up.quiz_id, up.user_id, up.progress, c.title AS course_title, l.title AS lesson_title 
    FROM user_progress up 
    LEFT JOIN quizzes q ON up.quiz_id = q.id 
    LEFT JOIN lessons l ON q.lesson_id = l.id 
    LEFT JOIN courses c ON l.course_id = c.id 
    LEFT JOIN users u ON up.user_id = u.id 
    WHERE up.user_id = {user_id}
    """
    homework = await db.get_records_sql(up_sql)

    return remove_timestamps(homework)


@app.get("/get_config")
async def get_config():
    config = await db.get_records("config")
    return remove_timestamps(config)


# Обработчик POST-запроса
@app.post("/api/save_progress")
async def save_progress(request: Request):
    """
    Сохраняет прогресс пользователя в таблицу UserProgress.
    """

    request = await request.json()

    try:
        # Подготовка данных для вставки
        params = {
            "user_id": request["userId"],
            "quiz_id": request["quizId"],
            "progress": request["progress"],
        }

        # Вызов метода insert_record
        up = await db.get_record("user_progress", params)
        if up is None:
            record_id = await db.insert_record('user_progress', params)
        else:
            # Если запись существует, обновляем её
            record_id = up["id"]
            await db.update_record("user_progress", record_id, params)

        # Возвращаем успешный ответ
        return {
            "status": "success",
            "message": f"Progress saved successfully with ID: {record_id}",
            "data": {"id": record_id},
        }

    except Exception as e:
        # Логируем ошибку (можно использовать logging)
        print(f"Error saving progress: {e}")

        # Возвращаем ошибку
        raise HTTPException(status_code=500, detail="Failed to save progress")



# API-метод для обработки POST-запроса
# @app.post("/send_user_notification")
# async def send_user_notification(request: Request):
#     """
#     Принимает данные о пользователе и отправляет уведомление в Telegram.
#     """
#     try:
#         # Получаем данные из тела запроса
#         data = await request.json()
#         user_id = data.get("user_id")
#         user_name = data.get("user_name")

#         # Проверяем, что все необходимые поля присутствуют
#         if not user_id or not user_name:
#             raise ValueError("Отсутствуют обязательные поля 'user_id' или 'user_name'")

#         # Формируем текст сообщения
#         message_text = f"Пользователь {user_name} (ID: {user_id}) начал обучение."

#         # Отправляем сообщение через Telegram
#         success = send_telegram_message(chat_id="CHAT_ID", message_text=message_text)

#         if success:
#             return {"status": "success", "message": "Уведомление успешно отправлено"}
#         else:
#             raise HTTPException(status_code=500, detail="Не удалось отправить уведомление")

#     except ValueError as ve:
#         raise HTTPException(status_code=400, detail=str(ve))
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=f"Произошла ошибка: {str(e)}")


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


@app.get("/get_app_data")
async def get_app_data(user_id: int):
    courses = await db.get_records("courses")

    for course in courses:
        lessons = await db.get_records("lessons", {"course_id": course["id"]})
        for lesson in lessons:
            lesson["materials"] = await db.get_records("materials", {"lesson_id": lesson["id"]})
            lesson["quizzes"] = await db.get_records("quizzes", {"lesson_id": lesson["id"]})
            for quiz in lesson["quizzes"]:
                quiz["questions"] = await db.get_records("questions", {"quiz_id": quiz["id"]})
                for question in quiz["questions"]:
                    question["answers"] = await db.get_records("answers", {"question_id": question["id"]})

        course["lessons"] = lessons

    events = await db.get_records("events")
    faq = await db.get_records("faq")
    config = await db.get_records("config")

    up_sql = f"""SELECT up.id, up.quiz_id, up.user_id, up.progress, c.title, l.title FROM user_progress up 
    LEFT JOIN quizzes q ON up.quiz_id = q.id 
    LEFT JOIN lessons l ON q.lesson_id = l.id 
    LEFT JOIN courses c ON l.course_id = c.id 
    LEFT JOIN users u ON up.user_id = u.id 
    """

    homework = await db.get_records_sql(up_sql)

    # Формируем данные для возврата
    data = {
        "courses": courses, 
        "events": events,
        "homework": homework,
        "faq": faq,
        "config": config
    }

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