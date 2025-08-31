#!/usr/bin/env python3
"""
Юнит тесты для функционала завершения уроков
"""

import asyncio
import sys
import os
import pytest
from unittest.mock import AsyncMock, MagicMock

# Добавляем путь к backend для импорта модулей
sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'backend'))

from misc import (
    mark_lesson_completed, 
    is_lesson_completed_by_user, 
    check_lesson_blocked,
    get_previous_lesson
)


class MockDB:
    """Мок базы данных для тестирования"""
    
    def __init__(self):
        self.lesson_completions = []
        self.quizzes_data = {}
        self.lessons_data = {}
        self.courses_data = {}
    
    async def insert_record(self, table, params):
        if table == 'lesson_completions':
            # Проверяем уникальность
            for completion in self.lesson_completions:
                if (completion["user_id"] == params["user_id"] and 
                    completion["lesson_id"] == params["lesson_id"]):
                    return None  # Дубликат не создается
            
            completion_id = len(self.lesson_completions) + 1
            self.lesson_completions.append({
                "id": completion_id,
                **params
            })
            return completion_id
        return None
    
    async def get_records_sql(self, query, *args):
        if "quizzes WHERE lesson_id" in query:
            lesson_id = args[0]
            return self.quizzes_data.get(lesson_id, [])
        elif "lesson_completions WHERE user_id" in query:
            user_id = args[0]
            lesson_id = args[1] if len(args) > 1 else None
            
            results = []
            for completion in self.lesson_completions:
                if completion["user_id"] == user_id:
                    if lesson_id is None or completion["lesson_id"] == lesson_id:
                        results.append(completion)
            return results
        elif "lessons WHERE course_id" in query:
            course_id = args[0]
            current_sort = args[2]
            # Возвращаем предыдущий урок с максимальным sort_order < current_sort
            previous_lessons = []
            for lesson in self.lessons_data.values():
                if lesson["course_id"] == course_id and lesson["sort_order"] < current_sort:
                    previous_lessons.append(lesson)
            
            if previous_lessons:
                # Сортируем по sort_order DESC и берем первый
                previous_lessons.sort(key=lambda x: x["sort_order"], reverse=True)
                return [previous_lessons[0]]
            return []
        return []


class TestLessonCompletion:
    """Тесты для функционала завершения уроков"""
    
    @pytest.fixture
    def db(self):
        """Фикстура для создания мок базы данных"""
        return MockDB()
    
    @pytest.fixture
    def user_id(self):
        """Фикстура для ID пользователя"""
        return 1
    
    @pytest.fixture
    def lesson_id(self):
        """Фикстура для ID урока"""
        return 1
    
    @pytest.mark.asyncio
    async def test_mark_lesson_completed_new(self, db, user_id, lesson_id):
        """Тест создания новой записи о завершении урока"""
        # Act
        result = await mark_lesson_completed(user_id, lesson_id, db)
        
        # Assert
        assert len(db.lesson_completions) == 1
        assert db.lesson_completions[0]["user_id"] == user_id
        assert db.lesson_completions[0]["lesson_id"] == lesson_id
    
    @pytest.mark.asyncio
    async def test_mark_lesson_completed_duplicate(self, db, user_id, lesson_id):
        """Тест предотвращения дубликатов"""
        # Arrange
        await mark_lesson_completed(user_id, lesson_id, db)
        initial_count = len(db.lesson_completions)
        
        # Act
        await mark_lesson_completed(user_id, lesson_id, db)
        
        # Assert
        assert len(db.lesson_completions) == initial_count  # Дубликат не создан
    
    @pytest.mark.asyncio
    async def test_is_lesson_completed_by_user_with_quiz(self, db, user_id, lesson_id):
        """Тест завершения урока с заданием"""
        # Arrange
        db.quizzes_data[lesson_id] = [{"id": 101}]  # У урока есть задание
        
        # Act - только просмотр (не должен считаться завершением)
        # В новой логике просмотр урока с заданием НЕ создает запись
        is_completed = await is_lesson_completed_by_user(user_id, lesson_id, db)
        
        # Assert - урок не завершен при простом просмотре
        assert is_completed == False
        
        # Act - выполнение теста (создает запись)
        await mark_lesson_completed(user_id, lesson_id, db)
        is_completed = await is_lesson_completed_by_user(user_id, lesson_id, db)
        
        # Assert - урок завершен при выполнении теста
        assert is_completed == True
    
    @pytest.mark.asyncio
    async def test_is_lesson_completed_by_user_without_quiz(self, db, user_id, lesson_id):
        """Тест завершения урока без задания"""
        # Arrange
        db.quizzes_data[lesson_id] = []  # У урока нет заданий
        
        # Act
        await mark_lesson_completed(user_id, lesson_id, db)
        is_completed = await is_lesson_completed_by_user(user_id, lesson_id, db)
        
        # Assert - урок завершен при просмотре
        assert is_completed == True
    

    
    @pytest.mark.asyncio
    async def test_lesson_viewed_logic(self, db, user_id, lesson_id):
        """Тест логики просмотра урока (имитация API)"""
        # Arrange - урок без заданий
        db.quizzes_data[lesson_id] = []
        
        # Act - просмотр урока без заданий
        await mark_lesson_completed(user_id, lesson_id, db)
        is_completed = await is_lesson_completed_by_user(user_id, lesson_id, db)
        
        # Assert - урок завершен при просмотре
        assert is_completed == True
        
        # Arrange - урок с заданиями
        db.quizzes_data[lesson_id] = [{"id": 101}]
        db.lesson_completions.clear()  # Очищаем предыдущие записи
        
        # Act - просмотр урока с заданиями (не создает запись)
        # В реальном API здесь не будет вызова mark_lesson_completed
        is_completed = await is_lesson_completed_by_user(user_id, lesson_id, db)
        
        # Assert - урок не завершен при просмотре
        assert is_completed == False
    

    
    @pytest.mark.asyncio
    async def test_check_lesson_blocked_first_lesson(self, db, user_id):
        """Тест блокировки первого урока (sort_order = 1)"""
        # Arrange
        lesson = {"id": 1, "sort_order": 1}
        course = {"id": 1, "completion_on": True}
        
        # Act
        blocked = await check_lesson_blocked(user_id, lesson, course, db)
        
        # Assert - первый урок всегда доступен
        assert blocked == False
    
    @pytest.mark.asyncio
    async def test_check_lesson_blocked_completion_disabled(self, db, user_id):
        """Тест блокировки при отключенном отслеживании"""
        # Arrange
        lesson = {"id": 2, "sort_order": 2}
        course = {"id": 1, "completion_on": False}
        
        # Act
        blocked = await check_lesson_blocked(user_id, lesson, course, db)
        
        # Assert - урок доступен при отключенном отслеживании
        assert blocked == False
    
    @pytest.mark.asyncio
    async def test_check_lesson_blocked_previous_completed(self, db, user_id):
        """Тест блокировки при завершенном предыдущем уроке"""
        # Arrange
        db.lessons_data = {
            1: {"id": 1, "sort_order": 1, "course_id": 1},
            2: {"id": 2, "sort_order": 2, "course_id": 1}
        }
        db.quizzes_data = {1: []}  # Урок 1 без заданий
        
        lesson = {"id": 2, "sort_order": 2}
        course = {"id": 1, "completion_on": True}
        
        # Завершаем предыдущий урок
        await mark_lesson_completed(user_id, 1, db)
        
        # Act
        blocked = await check_lesson_blocked(user_id, lesson, course, db)
        
        # Assert - урок доступен при завершенном предыдущем
        assert blocked == False
    
    @pytest.mark.asyncio
    async def test_check_lesson_blocked_previous_not_completed(self, db, user_id):
        """Тест блокировки при незавершенном предыдущем уроке"""
        # Arrange
        db.lessons_data = {
            1: {"id": 1, "sort_order": 1, "course_id": 1},
            2: {"id": 2, "sort_order": 2, "course_id": 1}
        }
        db.quizzes_data = {1: [{"id": 101}]}  # Урок 1 с заданием
        
        lesson = {"id": 2, "sort_order": 2}
        course = {"id": 1, "completion_on": True}
        
        # Предыдущий урок не завершен (нет записи в lesson_completions)
        # Не вызываем mark_lesson_completed для урока 1
        
        # Act
        blocked = await check_lesson_blocked(user_id, lesson, course, db)
        
        # Assert - урок заблокирован при незавершенном предыдущем
        assert blocked == True
    
    @pytest.mark.asyncio
    async def test_get_previous_lesson(self, db):
        """Тест получения предыдущего урока"""
        # Arrange
        db.lessons_data = {
            1: {"id": 1, "sort_order": 1, "course_id": 1},
            2: {"id": 2, "sort_order": 2, "course_id": 1},
            3: {"id": 3, "sort_order": 3, "course_id": 1}
        }
        
        # Act
        previous_lesson = await get_previous_lesson(1, 3, db)
        
        # Assert
        assert previous_lesson is not None
        assert previous_lesson["id"] == 2
        assert previous_lesson["sort_order"] == 2


if __name__ == "__main__":
    # Запуск тестов без pytest
    async def run_tests():
        db = MockDB()
        user_id = 1
        lesson_id = 1
        
        print("🧪 Запуск юнит тестов для функционала завершения уроков...")
        
        # Тест 1: Создание новой записи
        print("\n📋 Тест 1: Создание новой записи о завершении")
        await mark_lesson_completed(user_id, lesson_id, db)
        assert len(db.lesson_completions) == 1
        print("   ✅ Успешно")
        
        # Тест 2: Предотвращение дубликатов
        print("\n📋 Тест 2: Предотвращение дубликатов")
        initial_count = len(db.lesson_completions)
        await mark_lesson_completed(user_id, lesson_id, db)
        assert len(db.lesson_completions) == initial_count
        print("   ✅ Успешно")
        
        # Тест 3: Урок с заданием
        print("\n📋 Тест 3: Урок с заданием")
        db.lesson_completions.clear()  # Очищаем предыдущие записи
        db.quizzes_data[lesson_id] = [{"id": 101}]
        # В новой логике просмотр урока с заданием НЕ создает запись
        is_completed = await is_lesson_completed_by_user(user_id, lesson_id, db)
        assert is_completed == False  # Урок не завершен при простом просмотре
        print("   ✅ Успешно")
        
        # Тест 4: Урок без задания
        print("\n📋 Тест 4: Урок без задания")
        db.lesson_completions.clear()  # Очищаем предыдущие записи
        db.quizzes_data[lesson_id] = []
        # Создаем запись о завершении (имитируем API)
        await mark_lesson_completed(user_id, lesson_id, db)
        is_completed = await is_lesson_completed_by_user(user_id, lesson_id, db)
        assert is_completed == True  # Урок завершен при просмотре
        print("   ✅ Успешно")
        

        

        
        # Тест 5: Первый урок
        print("\n📋 Тест 5: Первый урок")
        lesson = {"id": 1, "sort_order": 1}
        course = {"id": 1, "completion_on": True}
        blocked = await check_lesson_blocked(user_id, lesson, course, db)
        assert blocked == False
        print("   ✅ Успешно")
        
        print("\n🎉 Все тесты прошли успешно!")
    
    asyncio.run(run_tests())
