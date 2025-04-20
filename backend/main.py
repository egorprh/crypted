from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from db.pgapi import PGApi


###
# Сервисы:
# 1) Получение данных для приложения: вопросы, ивенты, курсы+уроки+ответы, домашка для пользователя, входное тестирование
# 3) Сохранение результата теста
# 4) Отпрвка в бота при нажатии кнопки "Начать" (с сохранением этого факта)
###

app = FastAPI()


@app.get("/ping")
async def ping():
    return {"status": "ok", "message": "Pong"}

# Static frontend
app.mount("/", StaticFiles(directory="../frontend/dist", html=True), name="static")

@app.get("/")
async def serve_frontend():
    return FileResponse("../frontend/dist/index.html")