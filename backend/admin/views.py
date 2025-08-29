"""
Представления для админ панели.
Определяет интерфейс для управления данными через SQLAdmin.
"""

from sqladmin import ModelView
import os
from sqlalchemy.orm import joinedload
from admin.models import (
    File, User, Course, UserActionsLog, Lesson, Materials, Quiz, Survey, 
    Question, SurveyQuestion, QuizQuestion, Answer, UserAnswer, 
    QuizAttempt, Event, Level, Faq, Config, UserEnrolment
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
    page_size = 30
    
    # Отображаемые колонки
    column_list = [Course.id, Course.title, Course.type, Course.level, Course.visible, Course.sort_order, Course.time_created]
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
    page_size = 30
    
    # Отображаемые колонки
    column_list = [Lesson.id, Lesson.title, Lesson.course, Lesson.visible, Lesson.sort_order, Lesson.time_created]
    column_searchable_list = [Lesson.title, Lesson.description]
    column_sortable_list = [Lesson.id, Lesson.title, Lesson.course_id, Lesson.sort_order, Lesson.time_created]
    
    # Русские названия колонок
    column_labels = {
        'id': 'ID',
        'title': 'Название',
        'description': 'Описание',
        'video_url': 'URL видео',
        'source_url': 'Исходный URL',
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
    page_size = 30
    
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
    page_size = 30
    
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
    page_size = 30
    
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
    page_size = 30
    
    # Отображаемые колонки
    column_list = [Question.id, Question.text, Question.type, Question.visible, Question.time_created]
    column_searchable_list = [Question.text]
    column_sortable_list = [Question.id, Question.type, Question.visible, Question.time_created]
    
    # Русские названия колонок
    column_labels = {
        'id': 'ID',
        'text': 'Текст вопроса',
        'type': 'Тип',
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


class AnswerAdmin(ModelView, model=Answer):
    """
    Админ представление для управления ответами.
    """
    name = "Ответ"
    name_plural = "Ответы"
    icon = "fa-solid fa-check"
    page_size = 30
    
    # Отображаемые колонки
    column_list = [Answer.id, Answer.text, Answer.correct, Answer.question_id, Answer.time_created]
    column_searchable_list = [Answer.text]
    column_sortable_list = [Answer.id, Answer.correct, Answer.question_id, Answer.time_created]
    
    # Русские названия колонок
    column_labels = {
        'id': 'ID',
        'text': 'Текст ответа',
        'correct': 'Правильный',
        'question_id': 'ID вопроса',
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


class EventAdmin(ModelView, model=Event):
    """
    Админ представление для управления событиями.
    """
    name = "Материалы (для вкладки Курсы)"
    name_plural = "Материалы (для вкладки Курсы)"
    icon = "fa-solid fa-calendar"
    page_size = 30
    
    # Отображаемые колонки
    column_list = [Event.id, Event.title, Event.author, Event.date, Event.sort_order, Event.visible, Event.time_created]
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
        'sort_order': 'Порядок сортировки',
        'visible': 'Видимое',
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


class FaqAdmin(ModelView, model=Faq):
    """
    Админ представление для управления FAQ.
    """
    name = "FAQ"
    name_plural = "FAQ"
    icon = "fa-solid fa-question-circle"
    page_size = 30
    
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
    page_size = 30
    
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
    page_size = 30
    
    # Отображаемые колонки
    column_list = [
        UserEnrolment.id, 
        UserEnrolment.user_id, 
        UserEnrolment.user,  # Связанный объект пользователя
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
    column_searchable_list = [UserEnrolment.user_id, UserEnrolment.course_id, UserEnrolment.status]
    
    def get_search_query(self, request, search_term):
        """Кастомный поиск с поддержкой username и названия курса"""
        query = self.get_list_query(request)
        
        if search_term:
            # Поиск по ID пользователя, ID курса, статусу, username и названию курса
            search_filter = (
                UserEnrolment.user_id.contains(search_term) |
                UserEnrolment.course_id.contains(search_term) |
                UserEnrolment.status.contains(search_term) |
                User.username.contains(search_term) |
                Course.title.contains(search_term)
            )
            query = query.filter(search_filter)
        
        return query
    
    # Русские названия колонок
    column_labels = {
        'id': 'ID',
        'user_id': 'ID пользователя',
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
    page_size = 30
    
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
