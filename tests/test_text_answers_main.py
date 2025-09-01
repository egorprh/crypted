"""
Тесты для основного функционала произвольных ответов в main.py
"""

import pytest
import sys
import os
from unittest.mock import AsyncMock, MagicMock, patch, Mock
import json

# Добавляем путь к backend для импорта
sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'backend'))

# Импортируем необходимые модули
from main import app
from fastapi.testclient import TestClient


class TestTextAnswersAPI:
    """Тесты для API эндпоинтов с функционалом произвольных ответов."""
    
    @pytest.fixture
    def client(self):
        """Тестовый клиент FastAPI."""
        return TestClient(app)
    
    @pytest.fixture
    def mock_db(self):
        """Мок для объекта базы данных."""
        db = MagicMock()
        db.get_records = AsyncMock()
        db.get_records_sql = AsyncMock()
        db.insert_record = AsyncMock()
        db.update_record = AsyncMock()
        return db
    
    @pytest.fixture
    def mock_user(self):
        """Тестовые данные пользователя."""
        return {
            'id': 123,
            'name': 'Иван Петров',
            'username': 'ivan_petrov',
            'telegram_id': 456789
        }
    
    @pytest.fixture
    def mock_quiz_data(self):
        """Тестовые данные теста."""
        return {
            'id': 1,
            'lesson_id': 1,
            'title': 'Тест по основам криптовалют'
        }
    
    @pytest.fixture
    def mock_questions(self):
        """Тестовые данные вопросов."""
        return [
            {
                'id': 1,
                'text': 'Какая биржа считается самой надежной?',
                'type': 'quiz'
            },
            {
                'id': 2,
                'text': 'Опишите ваш опыт работы с криптовалютами',
                'type': 'text'
            },
            {
                'id': 3,
                'text': 'Какой способ пополнения счета самый быстрый?',
                'type': 'quiz'
            }
        ]
    
    @pytest.fixture
    def mock_answers(self):
        """Тестовые данные вариантов ответов."""
        return [
            {
                'id': 5,
                'text': 'Binance',
                'question_id': 1,
                'correct': True
            },
            {
                'id': 6,
                'text': 'Coinbase',
                'question_id': 1,
                'correct': False
            },
            {
                'id': 8,
                'text': 'Банковская карта',
                'question_id': 3,
                'correct': True
            }
        ]
    
    @patch('main.send_homework_notification')
    @patch('main.get_user_by_telegram_id')
    @patch('main.get_quiz_by_id')
    @patch('main.get_quiz_questions')
    @patch('main.get_quiz_answers')
    @pytest.mark.asyncio
    async def test_save_attempt_with_text_answers(
        self,
        mock_get_answers,
        mock_get_questions,
        mock_get_quiz,
        mock_get_user,
        mock_send_notification,
        client,
        mock_db
    ):
        """Тест сохранения попытки с текстовыми ответами."""
        # Настраиваем моки
        mock_get_user.return_value = {
            'id': 123,
            'name': 'Иван Петров',
            'username': 'ivan_petrov'
        }
        mock_get_quiz.return_value = mock_quiz_data
        mock_get_questions.return_value = mock_questions
        mock_get_answers.return_value = mock_answers
        
        # Мокаем insert_record для сохранения ответов
        mock_db.insert_record.return_value = 1
        
        # Данные для отправки
        request_data = {
            "telegram_id": 456789,
            "quiz_id": 1,
            "answers": [
                {
                    "questionId": 1,
                    "answerId": 5
                },
                {
                    "questionId": 2,
                    "answerText": "Мой опыт работы с криптовалютами составляет 2 года"
                },
                {
                    "questionId": 3,
                    "answerId": 8
                }
            ]
        }
        
        # Патчим базу данных в main
        with patch('main.db', mock_db):
            response = client.post("/api/save_attempt", json=request_data)
        
        # Проверяем успешный ответ
        assert response.status_code == 200
        response_data = response.json()
        assert response_data["success"] is True
        assert "attempt_id" in response_data
        
        # Проверяем, что все ответы были сохранены
        assert mock_db.insert_record.call_count == 4  # 3 ответа + 1 попытка
        
        # Проверяем, что уведомление было отправлено
        mock_send_notification.assert_called_once()
        
        # Проверяем параметры вызова уведомления
        call_args = mock_send_notification.call_args
        assert call_args[1]['quiz_id'] == 1
        assert call_args[1]['user']['id'] == 123
        assert len(call_args[1]['answers']) == 3
    
    @patch('main.send_homework_notification')
    @patch('main.get_user_by_telegram_id')
    @patch('main.get_quiz_by_id')
    @patch('main.get_quiz_questions')
    @patch('main.get_quiz_answers')
    @pytest.mark.asyncio
    async def test_save_attempt_only_text_answers(
        self,
        mock_get_answers,
        mock_get_questions,
        mock_get_quiz,
        mock_get_user,
        mock_send_notification,
        client,
        mock_db
    ):
        """Тест сохранения попытки только с текстовыми ответами."""
        # Настраиваем моки
        mock_get_user.return_value = {
            'id': 123,
            'name': 'Иван Петров',
            'username': 'ivan_petrov'
        }
        mock_get_quiz.return_value = mock_quiz_data
        mock_get_questions.return_value = [
            {
                'id': 1,
                'text': 'Опишите ваш опыт работы с криптовалютами',
                'type': 'text'
            },
            {
                'id': 2,
                'text': 'Какие биржи вы знаете?',
                'type': 'text'
            }
        ]
        mock_get_answers.return_value = []
        
        # Мокаем insert_record для сохранения ответов
        mock_db.insert_record.return_value = 1
        
        # Данные для отправки - только текстовые ответы
        request_data = {
            "telegram_id": 456789,
            "quiz_id": 4,
            "answers": [
                {
                    "questionId": 1,
                    "answerText": "Работаю с криптовалютами уже 2 года"
                },
                {
                    "questionId": 2,
                    "answerText": "Знаю Binance, Coinbase, Kraken"
                }
            ]
        }
        
        # Патчим базу данных в main
        with patch('main.db', mock_db):
            response = client.post("/api/save_attempt", json=request_data)
        
        # Проверяем успешный ответ
        assert response.status_code == 200
        response_data = response.json()
        assert response_data["success"] is True
        
        # Проверяем, что все ответы были сохранены
        assert mock_db.insert_record.call_count == 3  # 2 ответа + 1 попытка
        
        # Проверяем, что уведомление было отправлено
        mock_send_notification.assert_called_once()
    
    @patch('main.send_homework_notification')
    @patch('main.get_user_by_telegram_id')
    @patch('main.get_quiz_by_id')
    @patch('main.get_quiz_questions')
    @patch('main.get_quiz_answers')
    @pytest.mark.asyncio
    async def test_save_attempt_character_limit_enforcement(
        self,
        mock_get_answers,
        mock_get_questions,
        mock_get_quiz,
        mock_get_user,
        mock_send_notification,
        client,
        mock_db
    ):
        """Тест ограничения на количество символов в текстовых ответах."""
        # Настраиваем моки
        mock_get_user.return_value = {
            'id': 123,
            'name': 'Иван Петров',
            'username': 'ivan_petrov'
        }
        mock_get_quiz.return_value = mock_quiz_data
        mock_get_questions.return_value = [
            {
                'id': 1,
                'text': 'Опишите ваш опыт',
                'type': 'text'
            }
        ]
        mock_get_answers.return_value = []
        
        # Мокаем insert_record для сохранения ответов
        mock_db.insert_record.return_value = 1
        
        # Данные для отправки - ответ превышает лимит в 512 символов
        long_answer = "A" * 513  # 513 символов
        request_data = {
            "telegram_id": 456789,
            "quiz_id": 5,
            "answers": [
                {
                    "questionId": 1,
                    "answerText": long_answer
                }
            ]
        }
        
        # Патчим базу данных в main
        with patch('main.db', mock_db):
            response = client.post("/api/save_attempt", json=request_data)
        
        # Проверяем, что ответ был отклонен из-за превышения лимита
        assert response.status_code == 400
        response_data = response.json()
        assert "слишком длинный" in response_data["error"].lower()
        
        # Проверяем, что уведомление НЕ было отправлено
        mock_send_notification.assert_not_called()
    
    @patch('main.send_homework_notification')
    @patch('main.get_user_by_telegram_id')
    @patch('main.get_quiz_by_id')
    @patch('main.get_quiz_questions')
    @patch('main.get_quiz_answers')
    @pytest.mark.asyncio
    async def test_save_attempt_mixed_answer_types(
        self,
        mock_get_answers,
        mock_get_questions,
        mock_get_quiz,
        mock_get_user,
        mock_send_notification,
        client,
        mock_db
    ):
        """Тест сохранения попытки со смешанными типами ответов."""
        # Настраиваем моки
        mock_get_user.return_value = {
            'id': 123,
            'name': 'Иван Петров',
            'username': 'ivan_petrov'
        }
        mock_get_quiz.return_value = mock_quiz_data
        mock_get_questions.return_value = mock_questions
        mock_get_answers.return_value = mock_answers
        
        # Мокаем insert_record для сохранения ответов
        mock_db.insert_record.return_value = 1
        
        # Данные для отправки - смешанные типы ответов
        request_data = {
            "telegram_id": 456789,
            "quiz_id": 2,
            "answers": [
                {
                    "questionId": 1,
                    "answerId": 5  # Тестовый ответ
                },
                {
                    "questionId": 2,
                    "answerText": "Мой опыт работы с криптовалютами составляет 2 года"  # Текстовый ответ
                },
                {
                    "questionId": 3,
                    "answerId": 8  # Тестовый ответ
                }
            ]
        }
        
        # Патчим базу данных в main
        with patch('main.db', mock_db):
            response = client.post("/api/save_attempt", json=request_data)
        
        # Проверяем успешный ответ
        assert response.status_code == 200
        response_data = response.json()
        assert response_data["success"] is True
        
        # Проверяем, что все ответы были сохранены
        assert mock_db.insert_record.call_count == 4  # 3 ответа + 1 попытка
        
        # Проверяем, что уведомление было отправлено
        mock_send_notification.assert_called_once()
    
    @patch('main.send_homework_notification')
    @patch('main.get_user_by_telegram_id')
    @patch('main.get_quiz_by_id')
    @patch('main.get_quiz_questions')
    @patch('main.get_quiz_answers')
    @pytest.mark.asyncio
    async def test_save_attempt_notification_always_sent(
        self,
        mock_get_answers,
        mock_get_questions,
        mock_get_quiz,
        mock_get_user,
        mock_send_notification,
        client,
        mock_db
    ):
        """Тест, что уведомление всегда отправляется независимо от типа ответов."""
        # Настраиваем моки
        mock_get_user.return_value = {
            'id': 123,
            'name': 'Иван Петров',
            'username': 'ivan_petrov'
        }
        mock_get_quiz.return_value = mock_quiz_data
        mock_get_questions.return_value = [
            {
                'id': 1,
                'text': 'Простой вопрос',
                'type': 'quiz'
            }
        ]
        mock_get_answers.return_value = [
            {
                'id': 1,
                'text': 'Вариант ответа',
                'question_id': 1,
                'correct': True
            }
        ]
        
        # Мокаем insert_record для сохранения ответов
        mock_db.insert_record.return_value = 1
        
        # Данные для отправки - только тестовые ответы
        request_data = {
            "telegram_id": 456789,
            "quiz_id": 1,
            "answers": [
                {
                    "questionId": 1,
                    "answerId": 1
                }
            ]
        }
        
        # Патчим базу данных в main
        with patch('main.db', mock_db):
            response = client.post("/api/save_attempt", json=request_data)
        
        # Проверяем успешный ответ
        assert response.status_code == 200
        
        # Проверяем, что уведомление было отправлено даже для тестовых ответов
        mock_send_notification.assert_called_once()
    
    @patch('main.send_homework_notification')
    @patch('main.get_user_by_telegram_id')
    @patch('main.get_quiz_by_id')
    @patch('main.get_quiz_questions')
    @patch('main.get_quiz_answers')
    @pytest.mark.asyncio
    async def test_save_attempt_error_handling(
        self,
        mock_get_answers,
        mock_get_questions,
        mock_get_quiz,
        mock_get_user,
        mock_send_notification,
        client,
        mock_db
    ):
        """Тест обработки ошибок при сохранении попытки."""
        # Настраиваем моки
        mock_get_user.return_value = {
            'id': 123,
            'name': 'Иван Петров',
            'username': 'ivan_petrov'
        }
        mock_get_quiz.return_value = mock_quiz_data
        mock_get_questions.return_value = mock_questions
        mock_get_answers.return_value = mock_answers
        
        # Мокаем insert_record для генерации ошибки
        mock_db.insert_record.side_effect = Exception("Database error")
        
        # Данные для отправки
        request_data = {
            "telegram_id": 456789,
            "quiz_id": 1,
            "answers": [
                {
                    "questionId": 1,
                    "answerId": 5
                }
            ]
        }
        
        # Патчим базу данных в main
        with patch('main.db', mock_db):
            response = client.post("/api/save_attempt", json=request_data)
        
        # Проверяем, что произошла ошибка
        assert response.status_code == 500
        response_data = response.json()
        assert "error" in response_data
        
        # Проверяем, что уведомление НЕ было отправлено при ошибке
        mock_send_notification.assert_not_called()


class TestGetAppDataTextAnswers:
    """Тесты для получения данных приложения с текстовыми ответами."""
    
    @pytest.fixture
    def client(self):
        """Тестовый клиент FastAPI."""
        return TestClient(app)
    
    @pytest.fixture
    def mock_db(self):
        """Мок для объекта базы данных."""
        db = MagicMock()
        db.get_records = AsyncMock()
        db.get_records_sql = AsyncMock()
        return db
    
    @patch('main.get_user_by_telegram_id')
    @pytest.mark.asyncio
    async def test_get_app_data_with_text_answers(
        self,
        mock_get_user,
        client,
        mock_db
    ):
        """Тест получения данных приложения с текстовыми ответами."""
        # Настраиваем моки
        mock_get_user.return_value = {
            'id': 123,
            'name': 'Иван Петров',
            'username': 'ivan_petrov'
        }
        
        # Мокаем данные курсов
        mock_db.get_records.return_value = [
            {
                'id': 1,
                'title': 'Основы криптовалют',
                'lesson_count': 3
            }
        ]
        
        # Мокаем данные уроков
        mock_db.get_records_sql.side_effect = [
            # Курсы
            [{'id': 1, 'title': 'Основы криптовалют', 'lesson_count': 3}],
            # Уроки для курса 1
            [
                {'id': 1, 'title': 'Урок 1', 'course_id': 1, 'order': 1},
                {'id': 2, 'title': 'Урок 2', 'course_id': 1, 'order': 2}
            ],
            # Тесты для уроков
            [{'id': 1, 'lesson_id': 1}],
            [{'id': 2, 'lesson_id': 2}],
            # Вопросы для теста 1
            [
                {'id': 1, 'text': 'Вопрос 1', 'type': 'quiz'},
                {'id': 2, 'text': 'Вопрос 2', 'type': 'text'}
            ],
            # Вопросы для теста 2
            [
                {'id': 3, 'text': 'Вопрос 3', 'type': 'quiz'},
                {'id': 4, 'text': 'Вопрос 4', 'type': 'text'}
            ],
            # Варианты ответов для теста 1
            [
                {'id': 1, 'text': 'Вариант 1', 'question_id': 1, 'correct': True},
                {'id': 2, 'text': 'Вариант 2', 'question_id': 1, 'correct': False}
            ],
            # Варианты ответов для теста 2
            [
                {'id': 3, 'text': 'Вариант 3', 'question_id': 3, 'correct': True},
                {'id': 4, 'text': 'Вариант 4', 'question_id': 3, 'correct': False}
            ],
            # Домашние задания
            [
                {
                    'id': 1,
                    'quiz_id': 1,
                    'user_id': 123,
                    'progress': 100,
                    'lesson': 1,
                    'lesson_title': 'Урок 1: Основы'
                },
                {
                    'id': 2,
                    'quiz_id': 2,
                    'user_id': 123,
                    'progress': 100,
                    'lesson': 2,
                    'lesson_title': 'Урок 2: Продвинутый'
                }
            ],
            # Вопросы для домашнего задания 1
            [
                {'id': 1, 'qid': 1, 'text': 'Вопрос 1', 'type': 'quiz'},
                {'id': 2, 'qid': 2, 'text': 'Вопрос 2', 'type': 'text'}
            ],
            # Вопросы для домашнего задания 2
            [
                {'id': 3, 'qid': 3, 'text': 'Вопрос 3', 'type': 'quiz'},
                {'id': 4, 'qid': 4, 'text': 'Вопрос 4', 'type': 'text'}
            ],
            # Текстовый ответ пользователя для вопроса 2
            [{'text': 'Мой текстовый ответ на вопрос 2'}],
            # Текстовый ответ пользователя для вопроса 4
            [{'text': 'Мой текстовый ответ на вопрос 4'}],
            # Варианты ответов для вопроса 1
            [
                {'id': 1, 'text': 'Вариант 1', 'question_id': 1, 'correct': True},
                {'id': 2, 'text': 'Вариант 2', 'question_id': 1, 'correct': False}
            ],
            # Варианты ответов для вопроса 3
            [
                {'id': 3, 'text': 'Вариант 3', 'question_id': 3, 'correct': True},
                {'id': 4, 'text': 'Вариант 4', 'question_id': 3, 'correct': False}
            ],
            # Ответ пользователя на вопрос 1
            [{'id': 1, 'user_id': 123, 'instance_qid': 1, 'answer_id': 1, 'attempt_id': 1}],
            # Ответ пользователя на вопрос 3
            [{'id': 2, 'user_id': 123, 'instance_qid': 3, 'answer_id': 3, 'attempt_id': 2}]
        ]
        
        # Патчим базу данных в main
        with patch('main.db', mock_db):
            response = client.get("/api/get_app_data?telegram_id=456789")
        
        # Проверяем успешный ответ
        assert response.status_code == 200
        response_data = response.json()
        
        # Проверяем, что данные содержат домашние задания
        assert "homework" in response_data
        assert len(response_data["homework"]) == 2
        
        # Проверяем первое домашнее задание
        homework1 = response_data["homework"][0]
        assert homework1["quiz_id"] == 1
        assert len(homework1["questions"]) == 2
        
        # Проверяем, что текстовый вопрос имеет правильную структуру
        text_question = homework1["questions"][1]  # Вопрос 2 - текстовый
        assert text_question["type"] == "text"
        assert "answers" in text_question
        assert len(text_question["answers"]) == 1
        
        # Проверяем виртуальный ответ для текстового вопроса
        text_answer = text_question["answers"][0]
        assert text_answer["id"] == 0  # Виртуальный ID
        assert text_answer["text"] == "Мой текстовый ответ на вопрос 2"
        assert text_answer["correct"] is True
        assert text_answer["user_answer"] is True
        
        # Проверяем, что тестовый вопрос имеет правильную структуру
        quiz_question = homework1["questions"][0]  # Вопрос 1 - тестовый
        assert quiz_question["type"] == "quiz"
        assert "answers" in quiz_question
        assert len(quiz_question["answers"]) == 2
        
        # Проверяем, что пользователь выбрал правильный ответ
        user_answer = quiz_question["answers"][0]  # Вариант 1
        assert user_answer["user_answer"] is True
        assert user_answer["correct"] is True


if __name__ == '__main__':
    pytest.main([__file__, '-v'])
