from typing import Any, Dict, Optional
from pydantic import BaseModel
from datetime import datetime

class File(BaseModel):
    id: int
    name: str
    path: str
    size: Optional[int] = None
    mime_type: Optional[str] = None
    description: Optional[str] = None
    time_modified: Optional[datetime] = None
    time_created: Optional[datetime] = None

class User(BaseModel):
    id: int
    telegram_id: int
    username: Optional[str] = None
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    level: int = 0
    time_modified: Optional[datetime] = None
    time_created: Optional[datetime] = None

class Course(BaseModel):
    id: int
    title: Optional[str] = None
    description: Optional[str] = None
    oldprice: Optional[str] = None
    newprice: Optional[str] = None
    image: Optional[str] = None
    color: Optional[str] = None
    has_popup: Optional[bool] = None
    popup_title: Optional[str] = None
    popup_desc: Optional[str] = None
    popup_img: Optional[str] = None
    direct_link: Optional[str] = None
    type: Optional[str] = None
    level: int = 0
    access_time: int = -1
    visible: bool = True
    sort_order: int = 0
    completion_on: bool = False
    time_modified: Optional[datetime] = None
    time_created: Optional[datetime] = None

class UserActionsLog(BaseModel):
    id: int
    user_id: int
    action: str
    instance_id: Optional[int] = None
    time_modified: Optional[datetime] = None
    time_created: Optional[datetime] = None

class Lesson(BaseModel):
    id: int
    title: Optional[str] = None
    description: Optional[str] = None
    video_url: Optional[str] = None
    source_url: Optional[str] = None
    course_id: int
    image: Optional[str] = None
    visible: bool = True
    sort_order: int = 0
    time_modified: Optional[datetime] = None
    time_created: Optional[datetime] = None

class Materials(BaseModel):
    id: int
    title: Optional[str] = None
    description: Optional[str] = None
    url: Optional[str] = None
    visible: bool = True
    lesson_id: int
    time_modified: Optional[datetime] = None
    time_created: Optional[datetime] = None

class Quiz(BaseModel):
    id: int
    title: Optional[str] = None
    description: Optional[str] = None
    visible: bool = True
    lesson_id: int
    time_modified: Optional[datetime] = None
    time_created: Optional[datetime] = None

class Survey(BaseModel):
    id: int
    title: Optional[str] = None
    description: Optional[str] = None
    visible: bool = True
    time_modified: Optional[datetime] = None
    time_created: Optional[datetime] = None

class Question(BaseModel):
    id: int
    text: Optional[str] = None
    type: Optional[str] = None  # quiz (тест), text (произвольный ответ), phone (телефон), age (возраст)
    visible: bool = True
    time_modified: Optional[datetime] = None
    time_created: Optional[datetime] = None

class SurveyQuestion(BaseModel):
    id: int
    survey_id: int
    question_id: int
    time_modified: Optional[datetime] = None
    time_created: Optional[datetime] = None

class QuizQuestion(BaseModel):
    id: int
    quiz_id: int
    question_id: int
    time_modified: Optional[datetime] = None
    time_created: Optional[datetime] = None

class Answer(BaseModel):
    id: int
    text: Optional[str] = None
    correct: bool
    question_id: int
    time_modified: Optional[datetime] = None
    time_created: Optional[datetime] = None

class UserAnswer(BaseModel):
    id: int
    user_id: int
    attempt_id: Optional[int] = None
    answer_id: int = 0
    text: Optional[str] = None
    type: Optional[str] = None  # quiz or survey
    instance_qid: Optional[int] = None  # id из quiz_questions или survey_questions
    time_modified: Optional[datetime] = None
    time_created: Optional[datetime] = None

class QuizAttempt(BaseModel):
    id: int
    user_id: int
    quiz_id: int
    progress: Optional[float] = None
    time_modified: Optional[datetime] = None
    time_created: Optional[datetime] = None

class Event(BaseModel):
    id: int
    title: Optional[str] = None
    description: Optional[str] = None
    author: Optional[str] = None
    image: Optional[str] = None
    date: Optional[str] = None
    price: Optional[str] = None
    link: Optional[str] = None
    sort_order: int = 0
    visible: bool = False
    time_modified: Optional[datetime] = None
    time_created: Optional[datetime] = None

class Level(BaseModel):
    id: int
    name: Optional[str] = None
    description: Optional[str] = None
    time_modified: Optional[datetime] = None
    time_created: Optional[datetime] = None

class Faq(BaseModel):
    id: int
    question: Optional[str] = None
    answer: Optional[str] = None
    visible: bool = True
    time_modified: Optional[datetime] = None
    time_created: Optional[datetime] = None

class Config(BaseModel):
    id: int
    name: Optional[str] = None
    value: Optional[str] = None
    time_modified: Optional[datetime] = None
    time_created: Optional[datetime] = None

class UserEnrolment(BaseModel):
    id: int
    user_id: int
    course_id: int
    time_start: Optional[datetime] = None
    time_end: Optional[datetime] = None
    status: int = 0  # 0 - незаписан, 1 - записан
    time_modified: Optional[datetime] = None
    time_created: Optional[datetime] = None

class LessonCompletion(BaseModel):
    id: int
    user_id: int
    lesson_id: int
    completed_at: Optional[datetime] = None
    time_modified: Optional[datetime] = None
    time_created: Optional[datetime] = None

class Notification(BaseModel):
    id: int
    user_id: int
    telegram_id: int
    channel: Optional[str] = "telegram"
    message: str
    scheduled_at: datetime
    sent_at: Optional[datetime] = None
    status: Optional[str] = "pending"  # pending|sent|failed|cancelled
    error: Optional[str] = None
    attempts: int = 0
    max_attempts: int = 5
    dedup_key: Optional[str] = None
    ext_data: Optional[Dict[str, Any]] = None
    time_modified: Optional[datetime] = None
    time_created: Optional[datetime] = None