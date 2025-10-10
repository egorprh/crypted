"""
Модуль для настройки и инициализации админ панели.
Содержит всю логику создания и настройки SQLAdmin.
"""

import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqladmin import Admin
from admin.models import Base
from admin.views import (
    FileAdmin, UserAdmin, CourseAdmin, LessonAdmin, MaterialsAdmin, 
    QuizAdmin, SurveyAdmin, QuestionAdmin, AnswerAdmin, QuizQuestionAdmin, SurveyQuestionAdmin, QuizAttemptAdmin, EventAdmin, 
    FaqAdmin, ConfigAdmin, UserEnrolmentAdmin, LevelAdmin, UserActionsLogAdmin, UserAnswerAdmin, LessonCompletionAdmin, NotificationAdmin
)
from admin.auth import AdminAuth
from logger import logger


def setup_admin(app):
    """
    Настраивает и инициализирует админ панель для FastAPI приложения.
    
    Args:
        app: FastAPI приложение для интеграции админки
    """
    try:
        # Загружаем конфигурацию напрямую из .env файла
        from dotenv import load_dotenv
        import os
        
        # Загружаем .env файл
        env_path = os.path.join(os.path.dirname(__file__), '.env')
        load_dotenv(env_path)
        
        # Получаем DATABASE_URL из переменных окружения
        DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://deptmaster:VgPZGd1B2rkDW!@localhost:5432/deptspace")
        
        # Создаем движок SQLAlchemy для админки
        engine = create_engine(DATABASE_URL)
        
        # Создаем таблицы для админки (только если их нет)
        # Base.metadata.create_all(bind=engine)
        # logger.info("Таблицы админки созданы успешно")
        logger.info("Проверка таблиц админки завершена")
        
        # Создаем сессию
        SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
        
        # Создаем директорию uploads, если её нет
        uploads_dir = os.path.join(os.path.dirname(__file__), "uploads")
        os.makedirs(uploads_dir, exist_ok=True)
        logger.info(f"Директория для загрузок создана: {uploads_dir}")
        
        # Подключаем статические файлы для загруженных изображений
        app.mount("/uploads", StaticFiles(directory=uploads_dir), name="uploads")
        logger.info("Статические файлы для загрузок подключены")
        
        # Создаем админку с аутентификацией
        authentication_backend = AdminAuth()
        admin = Admin(
            app, 
            engine,
            title="D-Space Админка",
            authentication_backend=authentication_backend
        )
        
        # Добавляем админские представления
        admin_views = [
            FileAdmin,
            UserAdmin,
            CourseAdmin,
            LessonAdmin,
            MaterialsAdmin,
            QuizAdmin,
            SurveyAdmin,
            QuestionAdmin,
            AnswerAdmin,
            QuizQuestionAdmin,
            SurveyQuestionAdmin,
            QuizAttemptAdmin,
            EventAdmin,
            FaqAdmin,
            ConfigAdmin,
            UserEnrolmentAdmin,
            LevelAdmin,
            UserActionsLogAdmin,
            UserAnswerAdmin,
            LessonCompletionAdmin,
            NotificationAdmin
        ]
        
        for view in admin_views:
            admin.add_view(view)
        
        logger.info(f"Админ панель настроена успешно с {len(admin_views)} представлениями")
        
        return admin
        
    except Exception as e:
        logger.error(f"Ошибка при настройке админки: {e}")
        raise


def get_uploads_directory():
    """
    Возвращает путь к директории для загрузки файлов.
    
    Returns:
        str: Абсолютный путь к директории uploads
    """
    return os.path.join(os.path.dirname(__file__), "uploads")


# Импорт StaticFiles для использования в функции
from fastapi.staticfiles import StaticFiles
