import json
from pathlib import Path
from fastapi import FastAPI
from pydantic import BaseModel
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse

app = FastAPI()

USERS_FILE = Path("/data/users.json")

class User(BaseModel):
    telegram_id: int
    username: str
    first_name: str
    last_name: str | None = None
    timecreated: str

@app.post("/api/save_user")
async def save_user(user: User):
    # Проверяем, существует ли файл
    if not USERS_FILE.exists():
        USERS_FILE.parent.mkdir(parents=True, exist_ok=True)
        USERS_FILE.write_text("[]", encoding="utf-8")

    # Загружаем существующих пользователей
    with USERS_FILE.open("r", encoding="utf-8") as f:
        users = json.load(f)

    # Проверяем, есть ли пользователь
    if any(u["telegram_id"] == user.telegram_id for u in users):
        return {"status": "exists", "message": "Пользователь уже существует"}

    # Добавляем нового пользователя
    users.append(user.dict())

    # Сохраняем обновленный список
    with USERS_FILE.open("w", encoding="utf-8") as f:
        json.dump(users, f, ensure_ascii=False, indent=4)

    return {"status": "ok", "message": "Пользователь успешно сохранен"}

# Static frontend
app.mount("/static", StaticFiles(directory="../frontend/dist"), name="static")

@app.get("/")
async def serve_frontend():
    return FileResponse("../frontend/dist/index.html")