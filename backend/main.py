from fastapi import FastAPI
from pydantic import BaseModel
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse

app = FastAPI()

DATABASE_URL = "sqlite:///./users.db"
engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    telegram_id = Column(Integer, unique=True, index=True)
    username = Column(String)
    first_name = Column(String)
    last_name = Column(String, nullable=True)
    photo_url = Column(String, nullable=True)

Base.metadata.create_all(bind=engine)

class UserCreate(BaseModel):
    telegram_id: int
    username: str
    first_name: str
    last_name: str | None = None
    photo_url: str | None = None

@app.post("/auth/telegram")
async def auth_telegram(user: UserCreate):
    db = SessionLocal()
    existing_user = db.query(User).filter(User.telegram_id == user.telegram_id).first()

    if existing_user:
        for key, value in user.dict().items():
            setattr(existing_user, key, value)
    else:
        new_user = User(**user.dict())
        db.add(new_user)

    db.commit()
    db.close()
    return {"status": "ok"}

@app.get("/get_lessons")
async def get_lessons():
    lessons = [
        {"id": 1, "title": "Что такое криптовалюта?"},
        {"id": 2, "title": "Развитие трейдера."},
        {"id": 3, "title": "Основы технического анализа."},
    ]
    return {"lessons": lessons}

# Static frontend
app.mount("/static", StaticFiles(directory="../frontend/dist"), name="static")

@app.get("/")
async def serve_frontend():
    return FileResponse("../frontend/dist/index.html")