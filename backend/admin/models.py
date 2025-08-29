"""
SQLAlchemy модели для админ панели.
Созданы на основе существующих Pydantic моделей для совместимости с SQLAdmin.
"""

from sqlalchemy import Column, Integer, String, Text, Boolean, DateTime, Float, BigInteger, ForeignKey
from sqlalchemy.orm import declarative_base, relationship
from sqlalchemy.sql import func
from datetime import datetime

Base = declarative_base()


class File(Base):
    """
    Модель для хранения информации о загруженных файлах.
    """
    __tablename__ = "files"
    
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    name = Column(String(255), nullable=False, comment="Оригинальное имя файла")
    path = Column(String(500), nullable=False, comment="Путь к файлу на сервере")
    size = Column(BigInteger, comment="Размер файла в байтах")
    mime_type = Column(String(100), comment="MIME тип файла")
    description = Column(Text, comment="Описание файла")
    time_modified = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    time_created = Column(DateTime(timezone=True), server_default=func.now())


class User(Base):
    """
    Модель пользователей системы.
    """
    __tablename__ = "users"
    
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    telegram_id = Column(BigInteger, unique=True, nullable=False, comment="Telegram ID пользователя")
    username = Column(String(255), comment="Username в Telegram")
    first_name = Column(String(255), comment="Имя пользователя")
    last_name = Column(String(255), comment="Фамилия пользователя")
    level = Column(Integer, default=0, comment="Уровень пользователя")
    time_modified = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    time_created = Column(DateTime(timezone=True), server_default=func.now())
    
    def __str__(self):
        if self.username:
            return f"{self.username}"
        elif self.first_name and self.last_name:
            return f"{self.first_name} {self.last_name}"
        elif self.first_name:
            return self.first_name
        else:
            return f"User {self.telegram_id}"


class Course(Base):
    """
    Модель курсов.
    """
    __tablename__ = "courses"
    
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    title = Column(String(255), comment="Название курса")
    description = Column(Text, comment="Описание курса")
    oldprice = Column(String(255), comment="Старая цена")
    newprice = Column(String(255), comment="Новая цена")
    image = Column(String(255), comment="Путь к изображению курса")
    color = Column(String(255), comment="Цвет курса")
    has_popup = Column(Boolean, comment="Есть ли попап")
    popup_title = Column(String(255), comment="Заголовок попапа")
    popup_desc = Column(String(255), comment="Описание попапа")
    popup_img = Column(String(255), comment="Изображение попапа")
    direct_link = Column(String(255), comment="Прямая ссылка")
    type = Column(String(255), comment="Тип курса")
    level = Column(Integer, default=0, comment="Уровень курса")
    access_time = Column(Integer, default=-1, comment="Время доступа")
    visible = Column(Boolean, default=True, comment="Видимость курса")
    sort_order = Column(BigInteger, default=0, comment="Порядок сортировки")
    time_modified = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    time_created = Column(DateTime(timezone=True), server_default=func.now())
    
    def __str__(self):
        return self.title or f"Course {self.id}"


class UserActionsLog(Base):
    """
    Модель логов действий пользователей.
    """
    __tablename__ = "user_actions_log"
    
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    user_id = Column(BigInteger, nullable=False, comment="ID пользователя")
    action = Column(String(255), nullable=False, comment="Действие пользователя")
    instance_id = Column(BigInteger, ForeignKey("courses.id", ondelete="CASCADE"), comment="ID экземпляра")
    time_modified = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    time_created = Column(DateTime(timezone=True), server_default=func.now())


class Lesson(Base):
    """
    Модель уроков.
    """
    __tablename__ = "lessons"
    
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    title = Column(String(255), comment="Название урока")
    description = Column(Text, comment="Описание урока")
    video_url = Column(String(255), comment="URL видео")
    source_url = Column(String(255), comment="Исходный URL")
    course_id = Column(BigInteger, ForeignKey("courses.id", ondelete="CASCADE"), comment="ID курса")
    image = Column(String(255), comment="Путь к изображению урока")
    visible = Column(Boolean, default=True, comment="Видимость урока")
    sort_order = Column(BigInteger, default=0, comment="Порядок сортировки")
    time_modified = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    time_created = Column(DateTime(timezone=True), server_default=func.now())
    
    # Связь с курсом для удобного отображения и выбора в админке
    course = relationship("Course", backref="lessons")
    
    def __str__(self):
        # Безопасное отображение без обращения к связанным объектам
        return f"Урок {self.id}: {self.title} (курс {self.course_id})"


class Materials(Base):
    """
    Модель материалов к урокам.
    """
    __tablename__ = "materials"
    
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    title = Column(String(255), comment="Название материала")
    description = Column(String(255), comment="Описание материала")
    url = Column(String(255), comment="URL материала")
    visible = Column(Boolean, default=True, comment="Видимость материала")
    lesson_id = Column(BigInteger, ForeignKey("lessons.id", ondelete="CASCADE"), comment="ID урока")
    time_modified = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    time_created = Column(DateTime(timezone=True), server_default=func.now())
    
    # Связь с уроком для удобного отображения и выбора в админке
    lesson = relationship("Lesson", backref="materials")
    
    def __str__(self):
        # Безопасное отображение без обращения к связанным объектам
        return f"Материал {self.id}: {self.title} (урок {self.lesson_id})"


class Quiz(Base):
    """
    Модель тестов.
    """
    __tablename__ = "quizzes"
    
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    title = Column(String(255), comment="Название теста")
    description = Column(Text, comment="Описание теста")
    visible = Column(Boolean, default=True, comment="Видимость теста")
    lesson_id = Column(BigInteger, ForeignKey("lessons.id", ondelete="CASCADE"), comment="ID урока")
    time_modified = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    time_created = Column(DateTime(timezone=True), server_default=func.now())
    
    # Связь с уроком для удобного отображения и выбора в админке
    lesson = relationship("Lesson", backref="quizzes")
    
    def __str__(self):
        # Безопасное отображение без обращения к связанным объектам
        return f"Тест {self.id}: {self.title} (урок {self.lesson_id})"


class Survey(Base):
    """
    Модель опросов.
    """
    __tablename__ = "surveys"
    
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    title = Column(String(255), comment="Название опроса")
    description = Column(Text, comment="Описание опроса")
    visible = Column(Boolean, default=True, comment="Видимость опроса")
    time_modified = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    time_created = Column(DateTime(timezone=True), server_default=func.now())


class Question(Base):
    """
    Модель вопросов.
    """
    __tablename__ = "questions"
    
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    text = Column(Text, comment="Текст вопроса")
    type = Column(String(255), comment="Тип вопроса (quiz, text, phone, age)")
    visible = Column(Boolean, default=True, comment="Видимость вопроса")
    time_modified = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    time_created = Column(DateTime(timezone=True), server_default=func.now())


class SurveyQuestion(Base):
    """
    Модель связи опросов и вопросов.
    """
    __tablename__ = "survey_questions"
    
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    survey_id = Column(BigInteger, ForeignKey("surveys.id", ondelete="CASCADE"), comment="ID опроса")
    question_id = Column(BigInteger, ForeignKey("questions.id", ondelete="CASCADE"), comment="ID вопроса")
    time_modified = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    time_created = Column(DateTime(timezone=True), server_default=func.now())


class QuizQuestion(Base):
    """
    Модель связи тестов и вопросов.
    """
    __tablename__ = "quiz_questions"
    
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    quiz_id = Column(BigInteger, ForeignKey("quizzes.id", ondelete="CASCADE"), comment="ID теста")
    question_id = Column(BigInteger, ForeignKey("questions.id", ondelete="CASCADE"), comment="ID вопроса")
    time_modified = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    time_created = Column(DateTime(timezone=True), server_default=func.now())


class Answer(Base):
    """
    Модель ответов на вопросы.
    """
    __tablename__ = "answers"
    
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    text = Column(Text, comment="Текст ответа")
    correct = Column(Boolean, comment="Правильность ответа")
    question_id = Column(BigInteger, ForeignKey("questions.id", ondelete="CASCADE"), comment="ID вопроса")
    time_modified = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    time_created = Column(DateTime(timezone=True), server_default=func.now())


class UserAnswer(Base):
    """
    Модель ответов пользователей.
    """
    __tablename__ = "user_answers"
    
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    user_id = Column(BigInteger, ForeignKey("users.id", ondelete="CASCADE"), comment="ID пользователя")
    attempt_id = Column(BigInteger, comment="ID попытки")
    answer_id = Column(BigInteger, default=0, comment="ID ответа")
    text = Column(Text, comment="Текст ответа пользователя")
    type = Column(String(255), comment="Тип (quiz или survey)")
    instance_qid = Column(BigInteger, comment="ID из quiz_questions или survey_questions")
    time_modified = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    time_created = Column(DateTime(timezone=True), server_default=func.now())


class QuizAttempt(Base):
    """
    Модель попыток прохождения тестов.
    """
    __tablename__ = "quiz_attempts"
    
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    user_id = Column(BigInteger, comment="ID пользователя")
    quiz_id = Column(BigInteger, ForeignKey("quizzes.id", ondelete="CASCADE"), comment="ID теста")
    progress = Column(Float, comment="Прогресс прохождения")
    time_modified = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    time_created = Column(DateTime(timezone=True), server_default=func.now())


class Event(Base):
    """
    Модель событий.
    """
    __tablename__ = "events"
    
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    title = Column(String(255), comment="Название события")
    description = Column(Text, comment="Описание события")
    author = Column(String(255), comment="Автор события")
    image = Column(String(255), comment="Путь к изображению события")
    date = Column(String(255), comment="Дата события")
    price = Column(String(255), comment="Цена события")
    link = Column(String(255), comment="Ссылка на событие")
    sort_order = Column(BigInteger, default=0, comment="Порядок сортировки")
    visible = Column(Boolean, default=False, comment="Видимость события")
    time_modified = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    time_created = Column(DateTime(timezone=True), server_default=func.now())


class Level(Base):
    """
    Модель уровней.
    """
    __tablename__ = "levels"
    
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    name = Column(Text, comment="Название уровня")
    description = Column(Text, comment="Описание уровня")
    time_modified = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    time_created = Column(DateTime(timezone=True), server_default=func.now())


class Faq(Base):
    """
    Модель FAQ.
    """
    __tablename__ = "faq"
    
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    question = Column(Text, comment="Вопрос")
    answer = Column(Text, comment="Ответ")
    visible = Column(Boolean, default=True, comment="Видимость FAQ")
    time_modified = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    time_created = Column(DateTime(timezone=True), server_default=func.now())


class Config(Base):
    """
    Модель конфигурации.
    """
    __tablename__ = "config"
    
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    name = Column(Text, comment="Название параметра")
    value = Column(Text, comment="Значение параметра")
    time_modified = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    time_created = Column(DateTime(timezone=True), server_default=func.now())


class UserEnrolment(Base):
    """
    Модель записи пользователей на курсы.
    """
    __tablename__ = "user_enrollment"
    
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    user_id = Column(BigInteger, ForeignKey("users.id", ondelete="CASCADE"), comment="ID пользователя")
    course_id = Column(BigInteger, ForeignKey("courses.id", ondelete="CASCADE"), comment="ID курса")
    time_start = Column(DateTime(timezone=True), server_default=func.now(), comment="Время начала")
    time_end = Column(DateTime(timezone=True), server_default=func.now(), comment="Время окончания")
    status = Column(Integer, default=0, comment="Статус записи (0 - незаписан, 1 - записан)")
    time_modified = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    time_created = Column(DateTime(timezone=True), server_default=func.now())
    
    # Связи с другими таблицами
    user = relationship("User", backref="enrollments")
    course = relationship("Course", backref="enrollments")
    
    def __str__(self):
        # Важно не обращаться к self.user / self.course, чтобы не триггерить lazy load
        # на отсоединённых инстансах (DetachedInstanceError) в админке
        return f"Запись {self.id}: user_id={self.user_id}, course_id={self.course_id}"
    
    @property
    def formatted_time_end(self):
        """Форматированное время окончания"""
        if self.time_end is None:
            return "Бесконечно"
        return self.time_end.strftime("%d.%m.%Y %H:%M")
    
    @property
    def formatted_time_start(self):
        """Форматированное время начала"""
        if self.time_start:
            return self.time_start.strftime("%d.%m.%Y %H:%M:%S")
        return "Не указано"
    
    @property
    def formatted_status(self):
        """Форматированный статус"""
        if self.status == 0:
            return "Незаписан"
        elif self.status == 1:
            return "Записан"
        else:
            return f"Неизвестно ({self.status})"
