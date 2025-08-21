from typing import Any, Dict, Optional
from pydantic import BaseModel

class User(BaseModel):
    id: int
    telegram_id: int
    username: str
    first_name: str
    last_name: Optional[str] = None
    level: Optional[int] = 0

class Course(BaseModel):
    id: int
    title: str
    description: str
    price: str | None = None
    image: str | None = None
    type: str

class Lesson(BaseModel):
    id: int
    title: str
    description: str
    video_url: str | None = None
    course_id: int
    image: str | None = None

class Materials(BaseModel):
    id: int
    title: str
    url: str
    lesson_id: int

class Quiz(BaseModel):
    id: int
    title: str
    description: str
    lesson_id: int

class Question(BaseModel):
    id: int
    text: str
    type: int # 1 - multiple choice, 2 - text
    quiz_id: int

class Answer(BaseModel):
    id: int
    text: str
    correct: bool # for text always true
    question_id: int

class UserAnswer(BaseModel):
    id: int
    answer_id: str
    text: bool # for text always true
    question_id: int

class UserProgress(BaseModel):
    id: int
    user_id: int
    quiz_id: int
    progress: float # for text always true

class Events(BaseModel):
    id: int
    title: str
    description: str
    author: str | None = None
    image: str | None = None
    date: str
    link: str
    price: str | None = None

class Faq(BaseModel):
    id: int
    question: str
    answer: str

class Levels(BaseModel):
    id: int
    name: str
    desc: str
