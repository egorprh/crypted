"""
Тесты интеграции очистки данных в API эндпоинтах
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


class TestSanitizationIntegration:
    """Тесты интеграции очистки данных в API."""
    
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
        db.get_record = AsyncMock()
        db.insert_record = AsyncMock()
        db.update_record = AsyncMock()
        return db
    
    @patch('main.send_homework_notification')
    @patch('main.mark_lesson_completed')
    @patch('main.trigger_event')
    @pytest.mark.asyncio
    async def test_save_attempt_sanitizes_text_answers(
        self,
        mock_trigger_event,
        mock_mark_lesson,
        mock_send_notification,
        client,
        mock_db
    ):
        """Тест, что текстовые ответы автоматически очищаются при сохранении."""
        # Настраиваем моки
        mock_db.get_record.return_value = {
            'id': 123,
            'name': 'Иван Петров',
            'username': 'ivan_petrov'
        }
        mock_db.insert_record.return_value = 1
        mock_db.get_records_sql.return_value = [{'id': 1}]
        
        # Данные для отправки с опасными символами
        request_data = {
            "userId": 456789,
            "quizId": 1,
            "courseId": 1,
            "progress": 100,
            "answers": [
                {
                    "questionId": 1,
                    "answerText": "<script>alert('XSS')</script>Мой опыт работы с криптовалютами составляет 2 года"
                }
            ]
        }
        
        # Патчим базу данных в main
        with patch('main.db', mock_db):
            response = client.post("/api/save_attempt", json=request_data)
        
        # Проверяем успешный ответ
        assert response.status_code == 200
        
        # Проверяем, что insert_record был вызван
        mock_db.insert_record.assert_called()
        
        # Получаем параметры вызова insert_record
        call_args = mock_db.insert_record.call_args_list
        
        # Ищем вызов для user_answers
        user_answer_call = None
        for call in call_args:
            if call[0][0] == "user_answers":  # table_name
                user_answer_call = call
                break
        
        assert user_answer_call is not None, "Не найден вызов insert_record для user_answers"
        
        # Проверяем, что опасные символы были удалены
        params = user_answer_call[0][1]  # params
        assert "text" in params
        
        # HTML теги должны быть удалены
        answer_text = params["text"]
        assert "<script>" not in answer_text
        assert "</script>" not in answer_text
        assert "alert('XSS')" not in answer_text
        
        # Полезный текст должен остаться
        assert "Мой опыт работы с криптовалютами составляет 2 года" in answer_text
    
    @patch('main.send_homework_notification')
    @patch('main.get_user_by_telegram_id')
    @patch('main.get_quiz_by_id')
    @patch('main.get_quiz_questions')
    @patch('main.get_quiz_answers')
    @pytest.mark.asyncio
    async def test_save_attempt_sanitizes_multiple_dangerous_inputs(
        self,
        mock_get_answers,
        mock_get_questions,
        mock_get_quiz,
        mock_get_user,
        mock_send_notification,
        client,
        mock_db
    ):
        """Тест очистки множественных опасных вводов."""
        # Настраиваем моки
        mock_get_user.return_value = {
            'id': 123,
            'name': 'Иван Петров',
            'username': 'ivan_petrov'
        }
        mock_get_quiz.return_value = {
            'id': 1,
            'lesson_id': 1,
            'title': 'Тест'
        }
        mock_get_questions.return_value = [
            {
                'id': 1,
                'text': 'Вопрос 1',
                'type': 'text'
            },
            {
                'id': 2,
                'text': 'Вопрос 2',
                'type': 'text'
            }
        ]
        mock_get_answers.return_value = []
        
        mock_db.insert_record.return_value = 1
        
        # Данные с различными типами опасных символов
        request_data = {
            "telegram_id": 456789,
            "quiz_id": 1,
            "answers": [
                {
                    "questionId": 1,
                    "answerText": "<script>alert('XSS')</script>Ответ 1"
                },
                {
                    "questionId": 2,
                    "answerText": "'; DROP TABLE users; -- Ответ 2"
                }
            ]
        }
        
        # Патчим базу данных в main
        with patch('main.db', mock_db):
            response = client.post("/api/save_attempt", json=request_data)
        
        # Проверяем успешный ответ
        assert response.status_code == 200
        
        # Проверяем, что все ответы были очищены
        call_args = mock_db.insert_record.call_args_list
        
        # Ищем вызовы для user_answers
        user_answer_calls = [call for call in call_args if call[0][0] == "user_answers"]
        assert len(user_answer_calls) == 2, "Должно быть 2 вызова для user_answers"
        
        # Проверяем первый ответ
        first_answer_params = user_answer_calls[0][0][1]
        assert "answerText" in first_answer_params
        first_text = first_answer_params["answerText"]
        assert "<script>" not in first_text
        assert "alert('XSS')" not in first_text
        assert "Ответ 1" in first_text
        
        # Проверяем второй ответ
        second_answer_params = user_answer_calls[1][0][1]
        assert "answerText" in second_answer_params
        second_text = second_answer_params["answerText"]
        assert "';" not in second_text
        assert "DROP TABLE users" not in second_text
        assert "--" not in second_text
        assert "Ответ 2" in second_text
    
    @patch('main.send_homework_notification')
    @patch('main.get_user_by_telegram_id')
    @patch('main.get_quiz_by_id')
    @patch('main.get_quiz_questions')
    @patch('main.get_quiz_answers')
    @pytest.mark.asyncio
    async def test_save_attempt_preserves_safe_input(
        self,
        mock_get_answers,
        mock_get_questions,
        mock_get_quiz,
        mock_get_user,
        mock_send_notification,
        client,
        mock_db
    ):
        """Тест, что безопасный ввод не изменяется."""
        # Настраиваем моки
        mock_get_user.return_value = {
            'id': 123,
            'name': 'Иван Петров',
            'username': 'ivan_petrov'
        }
        mock_get_quiz.return_value = {
            'id': 1,
            'lesson_id': 1,
            'title': 'Тест'
        }
        mock_get_questions.return_value = [
            {
                'id': 1,
                'text': 'Вопрос',
                'type': 'text'
            }
        ]
        mock_get_answers.return_value = []
        
        mock_db.insert_record.return_value = 1
        
        # Безопасный текст без опасных символов
        safe_text = "Мой опыт работы с криптовалютами составляет 2 года. Я торгую на Binance и Coinbase."
        request_data = {
            "telegram_id": 456789,
            "quiz_id": 1,
            "answers": [
                {
                    "questionId": 1,
                    "answerText": safe_text
                }
            ]
        }
        
        # Патчим базу данных в main
        with patch('main.db', mock_db):
            response = client.post("/api/save_attempt", json=request_data)
        
        # Проверяем успешный ответ
        assert response.status_code == 200
        
        # Проверяем, что текст не изменился
        call_args = mock_db.insert_record.call_args_list
        user_answer_call = [call for call in call_args if call[0][0] == "user_answers"][0]
        
        params = user_answer_call[0][1]
        assert "answerText" in params
        assert params["answerText"] == safe_text
    
    @patch('main.send_homework_notification')
    @patch('main.get_user_by_telegram_id')
    @patch('main.get_quiz_by_id')
    @patch('main.get_quiz_questions')
    @patch('main.get_quiz_answers')
    @pytest.mark.asyncio
    async def test_save_attempt_handles_very_long_input(
        self,
        mock_get_answers,
        mock_get_questions,
        mock_get_quiz,
        mock_get_user,
        mock_send_notification,
        client,
        mock_db
    ):
        """Тест обработки очень длинного ввода."""
        # Настраиваем моки
        mock_get_user.return_value = {
            'id': 123,
            'name': 'Иван Петров',
            'username': 'ivan_petrov'
        }
        mock_get_quiz.return_value = {
            'id': 1,
            'lesson_id': 1,
            'title': 'Тест'
        }
        mock_get_questions.return_value = [
            {
                'id': 1,
                'text': 'Вопрос',
                'type': 'text'
            }
        ]
        mock_get_answers.return_value = []
        
        mock_db.insert_record.return_value = 1
        
        # Очень длинный текст (больше 512 символов)
        long_text = "A" * 1000  # 1000 символов
        request_data = {
            "telegram_id": 456789,
            "quiz_id": 1,
            "answers": [
                {
                    "questionId": 1,
                    "answerText": long_text
                }
            ]
        }
        
        # Патчим базу данных в main
        with patch('main.db', mock_db):
            response = client.post("/api/save_attempt", json=request_data)
        
        # Проверяем успешный ответ
        assert response.status_code == 200
        
        # Проверяем, что текст был обрезан до 512 символов
        call_args = mock_db.insert_record.call_args_list
        user_answer_call = [call for call in call_args if call[0][0] == "user_answers"][0]
        
        params = user_answer_call[0][1]
        assert "answerText" in params
        answer_text = params["answerText"]
        assert len(answer_text) == 512
        assert answer_text == "A" * 512
    
    @patch('main.send_homework_notification')
    @patch('main.get_user_by_telegram_id')
    @patch('main.get_quiz_by_id')
    @patch('main.get_quiz_questions')
    @patch('main.get_quiz_answers')
    @pytest.mark.asyncio
    async def test_save_attempt_sanitizes_mixed_content(
        self,
        mock_get_answers,
        mock_get_questions,
        mock_get_quiz,
        mock_get_user,
        mock_send_notification,
        client,
        mock_db
    ):
        """Тест очистки смешанного контента (HTML + безопасный текст)."""
        # Настраиваем моки
        mock_get_user.return_value = {
            'id': 123,
            'name': 'Иван Петров',
            'username': 'ivan_petrov'
        }
        mock_get_quiz.return_value = {
            'id': 1,
            'lesson_id': 1,
            'title': 'Тест'
        }
        mock_get_questions.return_value = [
            {
                'id': 1,
                'text': 'Вопрос',
                'type': 'text'
            }
        ]
        mock_get_answers.return_value = []
        
        mock_db.insert_record.return_value = 1
        
        # Смешанный контент с HTML и безопасным текстом
        mixed_text = """
        <html>
            <head><title>Злой сайт</title></head>
            <body>
                <script>alert('XSS')</script>
                <h1>Мой опыт работы</h1>
                <p>Я работаю с криптовалютами уже 2 года.</p>
                <iframe src="javascript:alert('XSS')"></iframe>
                <p>Торгую на Binance и Coinbase.</p>
            </body>
        </html>
        """
        
        request_data = {
            "telegram_id": 456789,
            "quiz_id": 1,
            "answers": [
                {
                    "questionId": 1,
                    "answerText": mixed_text
                }
            ]
        }
        
        # Патчим базу данных в main
        with patch('main.db', mock_db):
            response = client.post("/api/save_attempt", json=request_data)
        
        # Проверяем успешный ответ
        assert response.status_code == 200
        
        # Проверяем, что HTML теги были удалены
        call_args = mock_db.insert_record.call_args_list
        user_answer_call = [call for call in call_args if call[0][0] == "user_answers"][0]
        
        params = user_answer_call[0][1]
        assert "answerText" in params
        answer_text = params["answerText"]
        
        # HTML теги должны быть удалены
        assert "<html>" not in answer_text
        assert "<head>" not in answer_text
        assert "<title>" not in answer_text
        assert "<body>" not in answer_text
        assert "<script>" not in answer_text
        assert "<h1>" not in answer_text
        assert "<p>" not in answer_text
        assert "<iframe>" not in answer_text
        
        # Полезный текст должен остаться
        assert "Мой опыт работы" in answer_text
        assert "Я работаю с криптовалютами уже 2 года" in answer_text
        assert "Торгую на Binance и Coinbase" in answer_text
        
        # JavaScript код должен быть удален
        assert "alert('XSS')" not in answer_text
        assert "javascript:" not in answer_text
    
    @patch('main.send_homework_notification')
    @patch('main.get_user_by_telegram_id')
    @patch('main.get_quiz_by_id')
    @patch('main.get_quiz_questions')
    @patch('main.get_quiz_answers')
    @pytest.mark.asyncio
    async def test_save_attempt_unicode_support(
        self,
        mock_get_answers,
        mock_get_questions,
        mock_get_quiz,
        mock_get_user,
        mock_send_notification,
        client,
        mock_db
    ):
        """Тест поддержки Unicode символов при очистке."""
        # Настраиваем моки
        mock_get_user.return_value = {
            'id': 123,
            'name': 'Иван Петров',
            'username': 'ivan_petrov'
        }
        mock_get_quiz.return_value = {
            'id': 1,
            'lesson_id': 1,
            'title': 'Тест'
        }
        mock_get_questions.return_value = [
            {
                'id': 1,
                'text': 'Вопрос',
                'type': 'text'
            }
        ]
        mock_get_answers.return_value = []
        
        mock_db.insert_record.return_value = 1
        
        # Unicode текст с эмодзи и кириллицей
        unicode_text = "Привет! 🌍 Мой опыт работы с криптовалютами составляет 2 года. 你好世界! Привіт, світ!"
        
        request_data = {
            "telegram_id": 456789,
            "quiz_id": 1,
            "answers": [
                {
                    "questionId": 1,
                    "answerText": unicode_text
                }
            ]
        }
        
        # Патчим базу данных в main
        with patch('main.db', mock_db):
            response = client.post("/api/save_attempt", json=request_data)
        
        # Проверяем успешный ответ
        assert response.status_code == 200
        
        # Проверяем, что Unicode символы сохранились
        call_args = mock_db.insert_record.call_args_list
        user_answer_call = [call for call in call_args if call[0][0] == "user_answers"][0]
        
        params = user_answer_call[0][1]
        assert "answerText" in params
        answer_text = params["answerText"]
        
        # Unicode символы должны сохраниться
        assert "Привет" in answer_text
        assert "🌍" in answer_text
        assert "Мой опыт работы с криптовалютами составляет 2 года" in answer_text
        assert "你好世界" in answer_text
        assert "Привіт, світ" in answer_text


if __name__ == '__main__':
    pytest.main([__file__, '-v'])
