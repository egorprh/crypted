from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from contextlib import asynccontextmanager
from typing import AsyncGenerator
from db.pgapi import PGApi
import json


###
# Сервисы:
# 1) Получение данных для приложения: вопросы, ивенты, курсы+уроки+ответы, домашка для пользователя, входное тестирование
# 3) Сохранение результата теста
# 4) Отпрвка в бота при нажатии кнопки "Начать" (с сохранением этого факта)
###

db = PGApi()

@asynccontextmanager
async def lifespan(app: FastAPI):
    # app startup
    await db.create()
    yield
    # app teardown


app = FastAPI(lifespan=lifespan)


@app.get("/ping")
async def ping():
    return {"status": "ok", "message": "Pong"}

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

    up_sql = f"""SELECT up.id, up.progress, c.title, l.title FROM user_progress up 
    LEFT JOIN quizzes q ON up.quiz_id = q.id 
    LEFT JOIN lessons l ON q.lesson_id = l.id 
    LEFT JOIN courses c ON l.course_id = c.id 
    LEFT JOIN users u ON up.user_id = u.id 
    WHERE u.telegram_id = {user_id}"""

    homework = await db.get_records_sql(up_sql)

    # Формируем данные для возврата
    data = {
        "courses": courses, 
        "events": events,
        "homework": homework,
        "faq": faq,
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