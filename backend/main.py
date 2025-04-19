from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from db.pgapi import PGApi


###
# Сервисы:
# 1) Сохранение пользотеля (таблица юзер)
# 3) Сохранение результата теста
# 4) Отпрвка в бота при нажатии кнопки "Начать"
# 5) Получение всех данных при инициализации приложения (Входной тест, пройден ли входной тест, курсы, уроки, ивенты, вопросы, домашка)
# 6) Сохранение результатов теста
# 7) Перепрохождение теста
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