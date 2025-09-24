"""
Представления для админ панели.
Определяет интерфейс для управления данными через SQLAdmin.
"""

from sqladmin import ModelView
import os
from sqlalchemy.orm import joinedload
from sqlalchemy import or_, cast, String
from wtforms import SelectField
from admin.models import (
    File, User, Course, UserActionsLog, Lesson, Materials, Quiz, Survey, 
    Question, SurveyQuestion, QuizQuestion, Answer, UserAnswer, 
    QuizAttempt, Event, Level, Faq, Config, UserEnrolment, LessonCompletion
)
from admin.custom_fields import FileUploadField, HexColorField
from logger import logger


class FileAdmin(ModelView, model=File):
    """
    Админ представление для управления файлами.
    Позволяет загружать, просматривать и удалять файлы.
    """
    name = "Файл"
    name_plural = "Файлы"
    icon = "fa-solid fa-file"
    page_size = 50
    
    # Отображаемые колонки
    column_list = [File.id, File.name, File.path, File.size, File.mime_type, File.time_created]
    column_searchable_list = [File.name, File.description]
    column_sortable_list = [File.id, File.name, File.size, File.time_created]
    
    # Русские названия колонок
    column_labels = {
        'id': 'ID',
        'name': 'Имя файла',
        'path': 'Путь к файлу',
        'size': 'Размер (байт)',
        'mime_type': 'MIME тип',
        'description': 'Описание',
        'time_modified': 'Дата изменения',
        'time_created': 'Дата загрузки'
    }
    
    # Исключаем автоматические поля из формы
    form_excluded_columns = ["time_modified", "time_created", "path", "size", "mime_type"]
    
    # Настройка полей формы
    form_overrides = {
        'name': FileUploadField
    }
    
    form_args = {
        'name': {
            'upload_folder': os.path.join(os.path.dirname(__file__), 'uploads'),
            'allowed_extensions': ['jpg', 'jpeg', 'png', 'gif', 'webp', 'pdf', 'doc', 'docx'],
            'max_size': 10 * 1024 * 1024  # 10MB
        }
    }
    
    # Права доступа
    can_create = True
    can_edit = False  # Запрещаем редактирование, только создание
    can_delete = True
    can_view_details = True
    
    async def on_model_change(self, data, model, is_created, request):
        """
        Обработка при создании/изменении модели файла.
        
        Args:
            data: Данные формы
            model: Модель файла
            is_created: True если это создание новой записи
            request: HTTP запрос
        """
        # Преобразуем dict из кастомного FileUploadField в скалярные поля
        file_payload = None
        if isinstance(data, dict) and isinstance(data.get('name'), dict):
            file_payload = data.get('name')
        elif hasattr(model, 'name') and isinstance(model.name, dict):
            file_payload = model.name

        if is_created and file_payload:
            # Если name содержит данные о загруженном файле
            file_data = file_payload
            original_name = file_data.get('name', '')
            file_path = file_data.get('path', '')
            file_size = file_data.get('size', 0)
            mime_type = file_data.get('mime_type', '')
            
            # Устанавливаем данные файла
            model.name = original_name
            model.path = file_path
            model.size = file_size
            model.mime_type = mime_type
            # Также нормализуем входные данные формы, чтобы в БД ушли строки, а не dict
            if isinstance(data, dict):
                data['name'] = original_name
                data['path'] = file_path
                data['size'] = file_size
                data['mime_type'] = mime_type
            
            logger.info(f"Создан новый файл: {original_name} ({file_size} байт)")


class UserAdmin(ModelView, model=User):
    """
    Админ представление для управления пользователями.
    """
    name = "Пользователь"
    name_plural = "Пользователи"
    icon = "fa-solid fa-user"
    page_size = 50
    
    # Отображаемые колонки
    column_list = [User.id, User.telegram_id, User.first_name, User.last_name, User.username, User.level, User.time_created]
    column_searchable_list = [User.telegram_id, User.first_name, User.last_name, User.username]
    column_sortable_list = [User.id, User.telegram_id, User.first_name, User.level, User.time_created]
    
    # Русские названия колонок
    column_labels = {
        'id': 'ID',
        'telegram_id': 'Telegram ID',
        'first_name': 'Имя',
        'last_name': 'Фамилия',
        'username': 'Username',
        'level': 'Уровень',
        'time_modified': 'Дата изменения',
        'time_created': 'Дата регистрации'
    }
    
    # Исключаем автоматические поля
    form_excluded_columns = ["time_modified", "time_created"]
    
    # Права доступа
    can_create = False  # Пользователи создаются через Telegram
    can_edit = True
    can_delete = True
    can_view_details = True


class CourseAdmin(ModelView, model=Course):
    """
    Админ представление для управления курсами.
    """
    name = "Курс"
    name_plural = "Курсы"
    icon = "fa-solid fa-graduation-cap"
    page_size = 100
    
    # Отображаемые колонки
    column_list = [Course.id, Course.title, Course.type, Course.level, Course.visible, Course.sort_order, Course.completion_on, Course.time_created]
    column_searchable_list = [Course.title, Course.description]
    column_sortable_list = [Course.id, Course.title, Course.level, Course.sort_order, Course.time_created]
    
    # Русские названия колонок
    column_labels = {
        'id': 'ID',
        'title': 'Название',
        'description': 'Описание',
        'oldprice': 'Старая цена',
        'newprice': 'Новая цена',
        'image': 'Изображение',
        'color': 'Цвет',
        'has_popup': 'Есть попап',
        'popup_title': 'Заголовок попапа',
        'popup_desc': 'Описание попапа',
        'popup_img': 'Изображение попапа',
        'direct_link': 'Прямая ссылка',
        'type': 'Тип',
        'level': 'Уровень',
        'access_time': 'Время доступа',
        'visible': 'Видимый',
        'sort_order': 'Порядок сортировки',
        'completion_on': 'Отслеживание выполнения',
        'time_modified': 'Дата изменения',
        'time_created': 'Дата создания'
    }
    
    # Исключаем автоматические поля
    form_excluded_columns = ["time_modified", "time_created"]
    
    # Настройка полей формы
    form_overrides = {
        'color': HexColorField
    }
    
    # Права доступа
    can_create = True
    can_edit = True
    can_delete = True
    can_view_details = True


class LessonAdmin(ModelView, model=Lesson):
    """
    Админ представление для управления уроками.
    """
    name = "Урок"
    name_plural = "Уроки"
    icon = "fa-solid fa-book"
    page_size = 100
    
    # Отображаемые колонки
    column_list = [Lesson.id, Lesson.title, Lesson.course, Lesson.duration, Lesson.visible, Lesson.sort_order, Lesson.time_created]
    column_searchable_list = [Lesson.title, Lesson.description]
    column_sortable_list = [Lesson.id, Lesson.title, Lesson.course_id, Lesson.sort_order, Lesson.time_created]
    
    # Русские названия колонок
    column_labels = {
        'id': 'ID',
        'title': 'Название',
        'description': 'Описание',
        'video_url': 'URL видео',
        'source_url': 'Исходный URL',
        'duration': 'Длительность',
        'course_id': 'ID курса',
        'course': 'Курс',
        'image': 'Изображение',
        'visible': 'Видимый',
        'sort_order': 'Порядок сортировки',
        'time_modified': 'Дата изменения',
        'time_created': 'Дата создания'
    }
    
    # Исключаем автоматические поля
    form_excluded_columns = ["time_modified", "time_created"]
    
    # Настройка отображения связанного курса
    form_ajax_refs = {
        'course': {
            'fields': ['title', 'id'],
            'page_size': 10
        }
    }
    
    # Права доступа
    can_create = True
    can_edit = True
    can_delete = True
    can_view_details = True


class MaterialsAdmin(ModelView, model=Materials):
    """
    Админ представление для управления материалами.
    """
    name = "Материал"
    name_plural = "Материалы"
    icon = "fa-solid fa-file-alt"
    page_size = 100
    
    # Отображаемые колонки
    column_list = [Materials.id, Materials.title, Materials.lesson, Materials.visible, Materials.time_created]
    column_searchable_list = [Materials.title, Materials.description]
    column_sortable_list = [Materials.id, Materials.title, Materials.lesson_id, Materials.time_created]
    
    # Русские названия колонок
    column_labels = {
        'id': 'ID',
        'title': 'Название',
        'description': 'Описание',
        'url': 'URL',
        'visible': 'Видимый',
        'lesson_id': 'ID урока',
        'lesson': 'Урок',
        'time_modified': 'Дата изменения',
        'time_created': 'Дата создания'
    }
    
    # Исключаем автоматические поля
    form_excluded_columns = ["time_modified", "time_created"]
    
    # Настройка отображения связанного урока
    form_ajax_refs = {
        'lesson': {
            'fields': ['title', 'id'],
            'page_size': 10
        }
    }
    
    # Права доступа
    can_create = True
    can_edit = True
    can_delete = True
    can_view_details = True


class QuizAdmin(ModelView, model=Quiz):
    """
    Админ представление для управления тестами.
    """
    name = "Тест"
    name_plural = "Тесты"
    icon = "fa-solid fa-question-circle"
    page_size = 100
    
    # Отображаемые колонки
    column_list = [Quiz.id, Quiz.title, Quiz.lesson, Quiz.visible, Quiz.time_created]
    column_searchable_list = [Quiz.title, Quiz.description]
    column_sortable_list = [Quiz.id, Quiz.title, Quiz.lesson_id, Quiz.time_created]
    
    # Русские названия колонок
    column_labels = {
        'id': 'ID',
        'title': 'Название',
        'description': 'Описание',
        'visible': 'Видимый',
        'lesson_id': 'ID урока',
        'lesson': 'Урок',
        'time_modified': 'Дата изменения',
        'time_created': 'Дата создания'
    }
    
    # Исключаем автоматические поля
    form_excluded_columns = ["time_modified", "time_created"]
    
    # Настройка отображения связанного урока
    form_ajax_refs = {
        'lesson': {
            'fields': ['title', 'id'],
            'page_size': 10
        }
    }
    
    # Права доступа
    can_create = True
    can_edit = True
    can_delete = True
    can_view_details = True


class SurveyAdmin(ModelView, model=Survey):
    """
    Админ представление для управления опросами.
    """
    name = "Опрос"
    name_plural = "Опросы"
    icon = "fa-solid fa-poll"
    page_size = 100
    
    # Отображаемые колонки
    column_list = [Survey.id, Survey.title, Survey.visible, Survey.time_created]
    column_searchable_list = [Survey.title, Survey.description]
    column_sortable_list = [Survey.id, Survey.title, Survey.time_created]
    
    # Русские названия колонок
    column_labels = {
        'id': 'ID',
        'title': 'Название',
        'description': 'Описание',
        'visible': 'Видимый',
        'time_modified': 'Дата изменения',
        'time_created': 'Дата создания'
    }
    
    # Исключаем автоматические поля
    form_excluded_columns = ["time_modified", "time_created"]
    
    # Права доступа
    can_create = True
    can_edit = True
    can_delete = True
    can_view_details = True


class QuestionAdmin(ModelView, model=Question):
    """
    Админ представление для управления вопросами.
    """
    name = "Вопрос"
    name_plural = "Вопросы"
    icon = "fa-solid fa-question"
    page_size = 100
    
    # Отображаемые колонки
    column_list = [Question.id, Question.text, Question.type, Question.visible, Question.time_created]
    column_searchable_list = [Question.text]
    column_sortable_list = [Question.id, Question.type, Question.visible, Question.time_created]
    
    # Русские названия колонок
    column_labels = {
        'id': 'ID',
        'text': 'Текст вопроса',
        'type': 'Тип вопроса',
        'visible': 'Видимый',
        'time_modified': 'Дата изменения',
        'time_created': 'Дата создания'
    }
    
    # Исключаем автоматические поля и связанные объекты
    form_excluded_columns = ["time_modified", "time_created", "quiz_questions", "answers"]
    
    # Настройка поля типа как селекта
    form_overrides = {
        'type': SelectField
    }
    
    # Подсказки для типов вопросов в админке
    form_args = {
        'type': {
            'choices': [
                ('quiz', 'Тест - вопрос с вариантами ответов'),
                ('text', 'Произвольный ответ - до 512 символов'),
                ('phone', 'Телефон'),
                ('age', 'Возраст')
            ],
            'description': 'Выберите тип вопроса. Для типа "text" пользователи смогут вводить произвольный ответ.'
        }
    }
    
    # Права доступа
    can_create = True
    can_edit = True
    can_delete = True
    can_view_details = True


class AnswerAdmin(ModelView, model=Answer):
    """
    Админ представление для управления ответами.
    """
    name = "Ответ"
    name_plural = "Ответы"
    icon = "fa-solid fa-check"
    page_size = 100
    
    # Отображаемые колонки
    column_list = [Answer.id, Answer.text, Answer.correct, Answer.question, Answer.time_created]
    column_searchable_list = [Answer.text]
    column_sortable_list = [Answer.id, Answer.correct, Answer.question_id, Answer.time_created]
    
    # Русские названия колонок
    column_labels = {
        'id': 'ID',
        'text': 'Текст ответа',
        'correct': 'Правильный',
        'question_id': 'ID вопроса',
        'question': 'Вопрос',
        'time_modified': 'Дата изменения',
        'time_created': 'Дата создания'
    }
    
    # Исключаем автоматические поля
    form_excluded_columns = ["time_modified", "time_created"]
    
    # Настройка отображения связанного вопроса
    form_ajax_refs = {
        'question': {
            'fields': ['text', 'id'],
            'page_size': 10
        }
    }
    
    # Права доступа
    can_create = True
    can_edit = True
    can_delete = True
    can_view_details = True


class QuizQuestionAdmin(ModelView, model=QuizQuestion):
    """
    Админ представление для управления связями тестов и вопросов.
    """
    name = "Вопрос теста"
    name_plural = "Вопросы тестов"
    icon = "fa-solid fa-link"
    page_size = 100
    
    # Отображаемые колонки
    column_list = [QuizQuestion.id, QuizQuestion.quiz, QuizQuestion.question, QuizQuestion.time_created]
    column_searchable_list = []
    column_sortable_list = [QuizQuestion.id, QuizQuestion.quiz_id, QuizQuestion.question_id, QuizQuestion.time_created]
    
    # Русские названия колонок
    column_labels = {
        'id': 'ID',
        'quiz_id': 'ID теста',
        'quiz': 'Тест',
        'question_id': 'ID вопроса',
        'question': 'Вопрос',
        'time_modified': 'Дата изменения',
        'time_created': 'Дата создания'
    }
    
    # Исключаем автоматические поля
    form_excluded_columns = ["time_modified", "time_created"]
    
    # Настройка отображения связанных объектов
    form_ajax_refs = {
        'quiz': {
            'fields': ['title', 'id'],
            'page_size': 10
        },
        'question': {
            'fields': ['text', 'id'],
            'page_size': 10
        }
    }
    
    # Права доступа
    can_create = True
    can_edit = True
    can_delete = True
    can_view_details = True


class SurveyQuestionAdmin(ModelView, model=SurveyQuestion):
    """
    Админ представление для управления связями опросов и вопросов.
    """
    name = "Вопрос опроса"
    name_plural = "Вопросы опросов"
    icon = "fa-solid fa-poll-h"
    page_size = 100
    
    # Отображаемые колонки
    column_list = [SurveyQuestion.id, SurveyQuestion.survey, SurveyQuestion.question, SurveyQuestion.time_created]
    column_searchable_list = []
    column_sortable_list = [SurveyQuestion.id, SurveyQuestion.survey_id, SurveyQuestion.question_id, SurveyQuestion.time_created]
    
    # Русские названия колонок
    column_labels = {
        'id': 'ID',
        'survey_id': 'ID опроса',
        'survey': 'Опрос',
        'question_id': 'ID вопроса',
        'question': 'Вопрос',
        'time_modified': 'Дата изменения',
        'time_created': 'Дата создания'
    }
    
    # Исключаем автоматические поля
    form_excluded_columns = ["time_modified", "time_created"]
    
    # Настройка отображения связанных объектов
    form_ajax_refs = {
        'survey': {
            'fields': ['title', 'id'],
            'page_size': 10
        },
        'question': {
            'fields': ['text', 'id'],
            'page_size': 10
        }
    }
    
    # Права доступа
    can_create = True
    can_edit = True
    can_delete = True
    can_view_details = True


class QuizAttemptAdmin(ModelView, model=QuizAttempt):
    """
    Админ представление для управления попытками прохождения тестов.
    """
    name = "Попытка теста"
    name_plural = "Попытки тестов"
    icon = "fa-solid fa-play-circle"
    page_size = 50
    
    # Отображаемые колонки
    column_list = [QuizAttempt.id, QuizAttempt.user, QuizAttempt.quiz, QuizAttempt.progress, QuizAttempt.time_created]
    column_searchable_list = [QuizAttempt.user_id, QuizAttempt.quiz_id]
    column_sortable_list = [QuizAttempt.id, QuizAttempt.user_id, QuizAttempt.quiz_id, QuizAttempt.progress, QuizAttempt.time_created]
    
    # Русские названия колонок
    column_labels = {
        'id': 'ID',
        'user_id': 'ID пользователя',
        'user': 'Пользователь',
        'quiz_id': 'ID теста',
        'quiz': 'Тест',
        'progress': 'Прогресс (%)',
        'time_modified': 'Дата изменения',
        'time_created': 'Дата создания'
    }
    
    # Исключаем автоматические поля
    form_excluded_columns = ["time_modified", "time_created"]
    
    # Настройка отображения связанных объектов
    form_ajax_refs = {
        'user': {
            'fields': ['username', 'first_name', 'last_name', 'id'],
            'page_size': 10
        },
        'quiz': {
            'fields': ['title', 'id'],
            'page_size': 10
        }
    }
    
    # Права доступа
    can_create = False  # Попытки создаются автоматически
    can_edit = True     # Можно редактировать прогресс
    can_delete = True
    can_view_details = True


class EventAdmin(ModelView, model=Event):
    """
    Админ представление для управления событиями.
    """
    name = "Материалы (для вкладки Курсы)"
    name_plural = "Материалы (для вкладки Курсы)"
    icon = "fa-solid fa-calendar"
    page_size = 100
    
    # Отображаемые колонки
    column_list = [Event.id, Event.title, Event.author, Event.date, Event.button_color, Event.button_text, Event.sort_order, Event.visible, Event.time_created]
    column_searchable_list = [Event.title, Event.description, Event.author]
    column_sortable_list = [Event.id, Event.title, Event.date, Event.sort_order, Event.visible, Event.time_created]
    
    # Русские названия колонок
    column_labels = {
        'id': 'ID',
        'title': 'Название',
        'description': 'Описание',
        'author': 'Автор',
        'image': 'Изображение',
        'date': 'Дата',
        'price': 'Цена',
        'link': 'Ссылка',
        'button_color': 'Цвет кнопки',
        'button_text': 'Текст кнопки',
        'sort_order': 'Порядок сортировки',
        'visible': 'Видимое',
        'time_modified': 'Дата изменения',
        'time_created': 'Дата создания'
    }
    
    # Исключаем автоматические поля
    form_excluded_columns = ["time_modified", "time_created"]

    # Настройка полей формы
    form_overrides = {
        'button_color': HexColorField
    }
    
    # Права доступа
    can_create = True
    can_edit = True
    can_delete = True
    can_view_details = True


class FaqAdmin(ModelView, model=Faq):
    """
    Админ представление для управления FAQ.
    """
    name = "FAQ"
    name_plural = "FAQ"
    icon = "fa-solid fa-question-circle"
    page_size = 100
    
    # Отображаемые колонки
    column_list = [Faq.id, Faq.question, Faq.visible, Faq.time_created]
    column_searchable_list = [Faq.question, Faq.answer]
    column_sortable_list = [Faq.id, Faq.visible, Faq.time_created]
    
    # Русские названия колонок
    column_labels = {
        'id': 'ID',
        'question': 'Вопрос',
        'answer': 'Ответ',
        'visible': 'Видимый',
        'time_modified': 'Дата изменения',
        'time_created': 'Дата создания'
    }
    
    # Исключаем автоматические поля
    form_excluded_columns = ["time_modified", "time_created"]
    
    # Права доступа
    can_create = True
    can_edit = True
    can_delete = True
    can_view_details = True


class ConfigAdmin(ModelView, model=Config):
    """
    Админ представление для управления конфигурацией.
    """
    name = "Конфигурация"
    name_plural = "Конфигурация"
    icon = "fa-solid fa-cog"
    page_size = 100
    
    # Отображаемые колонки
    column_list = [Config.id, Config.name, Config.value, Config.time_modified]
    column_searchable_list = [Config.name, Config.value]
    column_sortable_list = [Config.id, Config.name, Config.time_modified]
    
    # Русские названия колонок
    column_labels = {
        'id': 'ID',
        'name': 'Название параметра',
        'value': 'Значение',
        'time_modified': 'Дата изменения',
        'time_created': 'Дата создания'
    }
    
    # Исключаем автоматические поля
    form_excluded_columns = ["time_modified", "time_created"]
    
    # Права доступа
    can_create = True
    can_edit = True
    can_delete = True
    can_view_details = True


class UserEnrolmentAdmin(ModelView, model=UserEnrolment):
    """
    Админ представление для управления записями пользователей на курсы.
    """
    name = "Запись на курс"
    name_plural = "Записи на курсы"
    icon = "fa-solid fa-user-plus"
    page_size = 100
    
    # Отображаемые колонки
    column_list = [
        UserEnrolment.id, 
        UserEnrolment.user_id, 
        UserEnrolment.user,  # Связанный объект пользователя
        "user_telegram_id",  # Telegram ID пользователя (вычисляемое свойство)
        UserEnrolment.course_id, 
        UserEnrolment.course,  # Связанный объект курса
        "formatted_time_start",  # Форматированное время начала
        "formatted_time_end",  # Форматированное время окончания
        "formatted_status"  # Форматированный статус
    ]
    
    # Колонки для детального представления
    column_details_list = [
        UserEnrolment.id,
        UserEnrolment.user,  # Связанный объект пользователя
        UserEnrolment.course,  # Связанный объект курса
        UserEnrolment.user_id,
        UserEnrolment.course_id,
        "formatted_time_start",  # Форматированное время начала
        "formatted_time_end",  # Форматированное время окончания
        "formatted_status",  # Форматированный статус
        UserEnrolment.time_modified,
        UserEnrolment.time_created
    ]
    column_sortable_list = [UserEnrolment.id, UserEnrolment.user_id, UserEnrolment.course_id, UserEnrolment.time_end, UserEnrolment.status, UserEnrolment.time_created]
    # Включаем отображение поля поиска (UI) минимальным безопасным списком;
    # фактическую фильтрацию выполняет кастомный search_query
    column_searchable_list = [UserEnrolment.id]
    
    def search_query(self, stmt, term):
        """Кастомный поиск по базовой таблице и колонке Пользователь (User)."""
        if not term:
            return stmt

        term_str = str(term).strip()

        # Добавляем JOIN с пользователями и курсами для поиска по связанным колонкам
        try:
            stmt = stmt.join(User, UserEnrolment.user_id == User.id)
        except Exception:
            # JOIN уже мог быть добавлен ранее движком
            pass
        try:
            stmt = stmt.join(Course, UserEnrolment.course_id == Course.id)
        except Exception:
            pass

        conditions = []

        # Текстовый поиск по колонке Пользователь: username, first_name, last_name
        conditions.extend([
            User.username.contains(term_str),
            User.first_name.contains(term_str),
            User.last_name.contains(term_str),
        ])

        # Если терм — число, добавим точные сравнения по числовым полям базовой таблицы
        # и по telegram_id пользователя. Для частичных совпадений по telegram_id используем CAST -> contains
        if term_str.isdigit():
            num = int(term_str)
            conditions.extend([
                UserEnrolment.id == num,
                UserEnrolment.user_id == num,
                UserEnrolment.course_id == num,
                UserEnrolment.status == num,
                User.telegram_id == num,
            ])
        else:
            # Частичный поиск по telegram_id и названию курса как по строке
            conditions.append(cast(User.telegram_id, String).contains(term_str))
            conditions.append(Course.title.contains(term_str))

        stmt = stmt.filter(or_(*conditions))
        logger.info(f"SQL запрос: {stmt}")
        return stmt
    
    # Русские названия колонок
    column_labels = {
        'id': 'ID',
        'user_id': 'ID пользователя',
        'user_telegram_id': 'Telegram ID',
        'course_id': 'ID курса',
        'user': 'Пользователь',
        'course': 'Курс',
        'formatted_time_start': 'Время начала',
        'formatted_time_end': 'Время окончания',
        'formatted_status': 'Статус',
        'time_modified': 'Дата изменения',
        'time_created': 'Дата записи'
    }
    
    # Исключаем автоматические поля
    form_excluded_columns = ["time_modified", "time_created", "user", "course"]
    
    # Описания полей формы
    form_args = {
        'time_end': {
            'description': 'Укажите дату окончания или 0. 0 или пустота - значит подписка неограничена по времени.'
        },
        'status': {
            'description': '0 - не записан, курс будет недоступен. 1 - записан, курс будет доступен'
        }
    }
    
    # Настройка отображения связанных объектов
    form_ajax_refs = {
        'user': {
            'fields': ['username', 'first_name', 'last_name', 'id'],
            'page_size': 10
        },
        'course': {
            'fields': ['title', 'id'],
            'page_size': 10
        }
    }
    
    # Права доступа
    can_create = True
    can_edit = True
    can_delete = True
    can_view_details = True
    
    # Кастомные колонки для отображения username и времени окончания
    def get_list_query(self, request):
        """Кастомный запрос с eager loading для получения связанных данных"""
        return (
            self.session.query(UserEnrolment)
            .options(
                joinedload(UserEnrolment.user),
                joinedload(UserEnrolment.course)
            )
        )
    



class LevelAdmin(ModelView, model=Level):
    """
    Админ представление для управления уровнями.
    """
    name = "Уровень"
    name_plural = "Уровни"
    icon = "fa-solid fa-layer-group"
    page_size = 100
    
    # Отображаемые колонки
    column_list = [Level.id, Level.name, Level.description, Level.time_created]
    column_searchable_list = [Level.name, Level.description]
    column_sortable_list = [Level.id, Level.name, Level.time_created]
    
    # Русские названия колонок
    column_labels = {
        'id': 'ID',
        'name': 'Название уровня',
        'description': 'Описание уровня',
        'time_modified': 'Дата изменения',
        'time_created': 'Дата создания'
    }
    
    # Исключаем автоматические поля
    form_excluded_columns = ["time_modified", "time_created"]
    
    # Права доступа
    can_create = True
    can_edit = True
    can_delete = True
    can_view_details = True


class UserActionsLogAdmin(ModelView, model=UserActionsLog):
    """
    Админ представление для управления логами действий пользователей.
    """
    name = "Лог действий"
    name_plural = "Логи действий"
    icon = "fa-solid fa-clipboard-list"
    page_size = 50
    
    # Отображаемые колонки
    column_list = [UserActionsLog.id, UserActionsLog.user_id, UserActionsLog.action, UserActionsLog.instance_id, UserActionsLog.time_created]
    column_searchable_list = [UserActionsLog.action]
    column_sortable_list = [UserActionsLog.id, UserActionsLog.user_id, UserActionsLog.instance_id, UserActionsLog.time_created]
    
    # Русские названия колонок
    column_labels = {
        'id': 'ID',
        'user_id': 'ID пользователя',
        'action': 'Действие',
        'instance_id': 'ID экземпляра',
        'time_modified': 'Дата изменения',
        'time_created': 'Дата создания'
    }
    
    # Исключаем автоматические поля
    form_excluded_columns = ["time_modified", "time_created"]
    
    # Права доступа
    can_create = False
    can_edit = False
    can_delete = True
    can_view_details = True


class UserAnswerAdmin(ModelView, model=UserAnswer):
    """
    Админ представление для управления ответами пользователей.
    """
    name = "Ответ пользователя"
    name_plural = "Ответы пользователей"
    icon = "fa-solid fa-comment-dots"
    page_size = 50
    
    # Отображаемые колонки
    column_list = [
        UserAnswer.id, 
        UserAnswer.user_id, 
        UserAnswer.user,  # Связанный объект пользователя для отображения username
        UserAnswer.answer_id, 
        UserAnswer.type, 
        UserAnswer.text,
        UserAnswer.instance_qid,  # ID экземпляра вопроса
        "lesson_id_display"     # ID урока (будет вычисляться)
    ]
    column_searchable_list = [UserAnswer.text, UserAnswer.type, UserAnswer.user_id]
    column_sortable_list = [
        UserAnswer.id, 
        UserAnswer.user_id, 
        UserAnswer.answer_id,
        UserAnswer.type
    ]
    
    # Русские названия колонок
    column_labels = {
        'id': 'ID',
        'user_id': 'ID пользователя',
        'user': 'Пользователь',
        'answer_id': 'ID ответа',
        'text': 'Текст ответа',
        'type': 'Тип',
        'instance_qid': 'ID вопроса',
        'lesson_id_display': 'ID урока',
        'time_modified': 'Дата изменения',
        'time_created': 'Дата создания'
    }
    
    # Исключаем автоматические поля
    form_excluded_columns = ["time_modified", "time_created"]
    
    # Настройка поля типа как селекта
    form_overrides = {
        'type': SelectField
    }
    
    # Подсказки для типов ответов в админке
    form_args = {
        'type': {
            'choices': [
                ('quiz', 'Тест - ответ на вопрос теста'),
                ('survey', 'Опрос - ответ на вопрос опроса')
            ],
            'description': 'Выберите тип ответа пользователя.'
        }
    }
    
    # Права доступа
    can_create = False  # Ответы создаются автоматически через API
    can_edit = False    # Ответы не редактируются
    can_delete = True
    can_view_details = True
    
    # Кастомный метод для отображения ID урока
    def get_lesson_id_display(self, obj):
        """Получает ID урока из instance_qid"""
        try:
            if obj.instance_qid:
                if obj.type == 'quiz':
                    # Для quiz: instance_qid -> quiz_questions.id -> quiz_id -> lesson_id
                    quiz_question = self.session.query(QuizQuestion).filter_by(id=obj.instance_qid).first()
                    if quiz_question:
                        quiz = self.session.query(Quiz).filter_by(id=quiz_question.quiz_id).first()
                        return quiz.lesson_id if quiz else None
                elif obj.type == 'survey':
                    # Для survey: instance_qid -> survey_questions.id -> survey_id
                    # У опросов нет прямой связи с уроками
                    return None
        except Exception as e:
            # В случае ошибки возвращаем None
            return None
        return None
    
    # Кастомный запрос с eager loading для получения связанных данных
    def get_list_query(self, request):
        """Кастомный запрос с eager loading для получения связанных данных пользователя"""
        return (
            self.session.query(UserAnswer)
            .options(
                joinedload(UserAnswer.user)
            )
        )


class LessonCompletionAdmin(ModelView, model=LessonCompletion):
    """
    Админ представление для управления завершениями уроков.
    """
    name = "Завершение урока"
    name_plural = "Завершения уроков"
    icon = "fa-solid fa-check-circle"
    page_size = 50
    
    # Отображаемые колонки
    column_list = [LessonCompletion.id, LessonCompletion.user, LessonCompletion.lesson, LessonCompletion.completed_at]
    column_searchable_list = []
    column_sortable_list = [LessonCompletion.id, LessonCompletion.user_id, LessonCompletion.lesson_id, LessonCompletion.completed_at]
    
    # Русские названия колонки
    column_labels = {
        'id': 'ID',
        'user_id': 'ID пользователя',
        'user': 'Пользователь',
        'lesson_id': 'ID урока',
        'lesson': 'Урок',
        'completed_at': 'Время завершения'
    }
    
    # Исключаем автоматические поля
    form_excluded_columns = ["completed_at"]
    
    # Настройка отображения связанных объектов
    form_ajax_refs = {
        'user': {
            'fields': ['telegram_id', 'username'],
            'page_size': 10
        },
        'lesson': {
            'fields': ['title', 'id'],
            'page_size': 10
        }
    }
    
    # Права доступа
    can_create = False  # Завершения создаются автоматически
    can_edit = False    # Завершения не редактируются
    can_delete = True
    can_view_details = True
