"""
Тесты для функционала произвольных ответов (текстовых вопросов)
"""

import pytest
import sys
import os
from unittest.mock import AsyncMock, MagicMock, patch

# Добавляем путь к backend для импорта
sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'backend'))

from misc import send_homework_notification


class TestSendHomeworkNotification:
    """Тесты для функции send_homework_notification."""
    
    @pytest.fixture
    def mock_db(self):
        """Мок для объекта базы данных."""
        db = MagicMock()
        db.get_records_sql = AsyncMock()
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
    def mock_answers(self):
        """Тестовые данные ответов пользователя."""
        return [
            {
                'questionId': 1,
                'answerId': 5,
                'answerText': None
            },
            {
                'questionId': 2,
                'answerText': 'Мой опыт работы с криптовалютами составляет 2 года',
                'answerId': None
            },
            {
                'questionId': 3,
                'answerId': 8,
                'answerText': None
            }
        ]
    
    @pytest.fixture
    def mock_course_info(self):
        """Тестовые данные о курсе."""
        return [{'title': 'Основы криптовалют'}]
    
    @pytest.fixture
    def mock_lesson_info(self):
        """Тестовые данные об уроке."""
        return [{'title': 'Урок 2: Как выбрать биржу и пополнить счёт?'}]
    
    @pytest.fixture
    def mock_question_texts(self):
        """Тестовые данные текстов вопросов."""
        return {
            1: 'Какая биржа считается самой надежной?',
            2: 'Опишите ваш опыт работы с криптовалютами',
            3: 'Какой способ пополнения счета самый быстрый?'
        }
    
    @pytest.fixture
    def mock_answer_texts(self):
        """Тестовые данные текстов вариантов ответов."""
        return {
            5: 'Binance',
            8: 'Банковская карта'
        }
    
    @patch('notification_service.send_service_message')
    @pytest.mark.asyncio
    async def test_send_homework_notification_success(
        self, 
        mock_send_service, 
        mock_db, 
        mock_user, 
        mock_answers,
        mock_course_info,
        mock_lesson_info,
        mock_question_texts,
        mock_answer_texts
    ):
        """Тест успешной отправки уведомления о выполнении домашнего задания."""
        # Настраиваем моки
        mock_db.get_records_sql.side_effect = [
            mock_course_info,  # Первый вызов для получения информации о курсе
            mock_lesson_info,  # Второй вызов для получения информации об уроке
            [{'text': mock_question_texts[1]}],  # Третий вызов для вопроса 1
            [{'text': mock_question_texts[2]}],  # Четвертый вызов для вопроса 2
            [{'text': mock_question_texts[3]}],  # Пятый вызов для вопроса 3
            [{'text': mock_answer_texts[5]}],    # Шестой вызов для ответа 5
            [{'text': mock_answer_texts[8]}]     # Седьмой вызов для ответа 8
        ]
        
        # Вызываем тестируемую функцию
        await send_homework_notification(
            user=mock_user,
            quiz_id=2,
            course_id=1,
            answers=mock_answers,
            db=mock_db
        )
        
        # Проверяем, что функция send_service_message была вызвана
        mock_send_service.assert_called_once()
        
        # Получаем переданное сообщение
        sent_message = mock_send_service.call_args[0][0]
        
        # Проверяем структуру сообщения
        assert '📚 Пользователь @ivan_petrov выполнил задание в курсе "Основы криптовалют"' in sent_message
        assert 'Урок: Урок 2: Как выбрать биржу и пополнить счёт?' in sent_message
        assert '✍️ Ответы пользователя:' in sent_message
        
        # Проверяем, что все вопросы и ответы присутствуют
        assert '1. Какая биржа считается самой надежной?' in sent_message
        assert 'Ответ: Binance' in sent_message
        
        assert '2. Опишите ваш опыт работы с криптовалютами' in sent_message
        assert 'Ответ: Мой опыт работы с криптовалютами составляет 2 года' in sent_message
        
        assert '3. Какой способ пополнения счета самый быстрый?' in sent_message
        assert 'Ответ: Банковская карта' in sent_message
    
    @pytest.mark.asyncio
    async def test_send_homework_notification_only_text_answers(
        self, 
        mock_db, 
        mock_user,
        mock_course_info,
        mock_lesson_info
    ):
        """Тест отправки уведомления только с текстовыми ответами."""
        # Только текстовые ответы
        text_only_answers = [
            {
                'questionId': 1,
                'answerText': 'Мой ответ на первый вопрос',
                'answerId': None
            },
            {
                'questionId': 2,
                'answerText': 'Мой ответ на второй вопрос',
                'answerId': None
            }
        ]
        
        # Настраиваем моки
        mock_db.get_records_sql.side_effect = [
            mock_course_info,
            mock_lesson_info,
            [{'text': 'Первый вопрос'}],
            [{'text': 'Второй вопрос'}]
        ]
        
        with patch('notification_service.send_service_message') as mock_send_service:
            await send_homework_notification(
                user=mock_user,
                quiz_id=3,
                course_id=1,
                answers=text_only_answers,
                db=mock_db
            )
            
            # Проверяем, что уведомление отправлено
            mock_send_service.assert_called_once()
            
            sent_message = mock_send_service.call_args[0][0]
            
            # Проверяем, что текстовые ответы корректно отображаются
            assert '1. Первый вопрос' in sent_message
            assert 'Ответ: Мой ответ на первый вопрос' in sent_message
            assert '2. Второй вопрос' in sent_message
            assert 'Ответ: Мой ответ на второй вопрос' in sent_message
    
    @pytest.mark.asyncio
    async def test_send_homework_notification_only_quiz_answers(
        self, 
        mock_db, 
        mock_user,
        mock_course_info,
        mock_lesson_info
    ):
        """Тест отправки уведомления только с тестовыми ответами."""
        # Только тестовые ответы
        quiz_only_answers = [
            {
                'questionId': 1,
                'answerId': 5,
                'answerText': None
            },
            {
                'questionId': 2,
                'answerId': 8,
                'answerText': None
            }
        ]
        
        # Настраиваем моки
        mock_db.get_records_sql.side_effect = [
            mock_course_info,
            mock_lesson_info,
            [{'text': 'Первый тестовый вопрос'}],
            [{'text': 'Второй тестовый вопрос'}],
            [{'text': 'Вариант ответа 5'}],
            [{'text': 'Вариант ответа 8'}]
        ]
        
        with patch('notification_service.send_service_message') as mock_send_service:
            await send_homework_notification(
                user=mock_user,
                quiz_id=1,
                course_id=1,
                answers=quiz_only_answers,
                db=mock_db
            )
            
            # Проверяем, что уведомление отправлено
            mock_send_service.assert_called_once()
            
            sent_message = mock_send_service.call_args[0][0]
            
            # Проверяем, что тестовые ответы корректно отображаются
            assert '1. Первый тестовый вопрос' in sent_message
            assert 'Ответ: Вариант ответа 5' in sent_message
            assert '2. Второй тестовый вопрос' in sent_message
            assert 'Ответ: Вариант ответа 8' in sent_message
    
    @pytest.mark.asyncio
    async def test_send_homework_notification_mixed_answers(
        self, 
        mock_db, 
        mock_user,
        mock_course_info,
        mock_lesson_info
    ):
        """Тест отправки уведомления со смешанными типами ответов."""
        # Смешанные ответы
        mixed_answers = [
            {
                'questionId': 1,
                'answerId': 5,
                'answerText': None
            },
            {
                'questionId': 2,
                'answerText': 'Произвольный ответ пользователя',
                'answerId': None
            }
        ]
        
        # Настраиваем моки
        mock_db.get_records_sql.side_effect = [
            mock_course_info,
            mock_lesson_info,
            [{'text': 'Тестовый вопрос'}],
            [{'text': 'Текстовый вопрос'}],
            [{'text': 'Вариант ответа 5'}]
        ]
        
        with patch('misc.send_service_message') as mock_send_service:
            await send_homework_notification(
                user=mock_user,
                quiz_id=4,
                course_id=1,
                answers=mixed_answers,
                db=mock_db
            )
            
            # Проверяем, что уведомление отправлено
            mock_send_service.assert_called_once()
            
            sent_message = mock_send_service.call_args[0][0]
            
            # Проверяем, что оба типа ответов корректно отображаются
            assert '1. Тестовый вопрос' in sent_message
            assert 'Ответ: Вариант ответа 5' in sent_message
            assert '2. Текстовый вопрос' in sent_message
            assert 'Ответ: Произвольный ответ пользователя' in sent_message
    
    @pytest.mark.asyncio
    async def test_send_homework_notification_user_without_username(
        self, 
        mock_db, 
        mock_user,
        mock_course_info,
        mock_lesson_info
    ):
        """Тест отправки уведомления для пользователя без username."""
        # Пользователь без username
        user_without_username = {
            'id': 123,
            'name': 'Иван Петров',
            'telegram_id': 456789
            # username отсутствует
        }
        
        simple_answers = [
            {
                'questionId': 1,
                'answerText': 'Простой ответ',
                'answerId': None
            }
        ]
        
        # Настраиваем моки
        mock_db.get_records_sql.side_effect = [
            mock_course_info,
            mock_lesson_info,
            [{'text': 'Простой вопрос'}]
        ]
        
        with patch('notification_service.send_service_message') as mock_send_service:
            await send_homework_notification(
                user=user_without_username,
                quiz_id=5,
                course_id=1,
                answers=simple_answers,
                db=mock_db
            )
            
            # Проверяем, что уведомление отправлено
            mock_send_service.assert_called_once()
            
            sent_message = mock_send_service.call_args[0][0]
            
            # Проверяем, что используется ID пользователя вместо username
            assert '📚 Пользователь @123 выполнил задание' in sent_message
    
    @pytest.mark.asyncio
    async def test_send_homework_notification_course_info_not_found(
        self, 
        mock_db, 
        mock_user, 
        mock_answers
    ):
        """Тест обработки случая, когда информация о курсе не найдена."""
        # Мок возвращает пустой результат для курса
        mock_db.get_records_sql.return_value = []
        
        with patch('notification_service.send_service_message') as mock_send_service:
            await send_homework_notification(
                user=mock_user,
                quiz_id=999,
                course_id=999,
                answers=mock_answers,
                db=mock_db
            )
            
            # Проверяем, что уведомление НЕ отправлено
            mock_send_service.assert_not_called()
    
    @pytest.mark.asyncio
    async def test_send_homework_notification_lesson_info_not_found(
        self, 
        mock_db, 
        mock_user, 
        mock_answers,
        mock_course_info
    ):
        """Тест обработки случая, когда информация об уроке не найдена."""
        # Мок возвращает информацию о курсе, но не об уроке
        mock_db.get_records_sql.side_effect = [
            mock_course_info,  # Курс найден
            []                  # Урок не найден
        ]
        
        with patch('notification_service.send_service_message') as mock_send_service:
            await send_homework_notification(
                user=mock_user,
                quiz_id=999,
                course_id=1,
                answers=mock_answers,
                db=mock_db
            )
            
            # Проверяем, что уведомление НЕ отправлено
            mock_send_service.assert_not_called()
    
    @pytest.mark.asyncio
    async def test_send_homework_notification_question_text_not_found(
        self, 
        mock_db, 
        mock_user,
        mock_course_info,
        mock_lesson_info
    ):
        """Тест обработки случая, когда текст вопроса не найден."""
        simple_answers = [
            {
                'questionId': 999,
                'answerText': 'Ответ на неизвестный вопрос',
                'answerId': None
            }
        ]
        
        # Настраиваем моки
        mock_db.get_records_sql.side_effect = [
            mock_course_info,
            mock_lesson_info,
            []  # Текст вопроса не найден
        ]
        
        with patch('notification_service.send_service_message') as mock_send_service:
            await send_homework_notification(
                user=mock_user,
                quiz_id=6,
                course_id=1,
                answers=simple_answers,
                db=mock_db
            )
            
            # Проверяем, что уведомление отправлено
            mock_send_service.assert_called_once()
            
            sent_message = mock_send_service.call_args[0][0]
            
            # Проверяем, что используется заглушка для неизвестного вопроса
            assert '1. Вопрос 999' in sent_message
            assert 'Ответ: Ответ на неизвестный вопрос' in sent_message
    
    @pytest.mark.asyncio
    async def test_send_homework_notification_answer_text_not_found(
        self, 
        mock_db, 
        mock_user,
        mock_course_info,
        mock_lesson_info
    ):
        """Тест обработки случая, когда текст варианта ответа не найден."""
        quiz_answers = [
            {
                'questionId': 1,
                'answerId': 999,
                'answerText': None
            }
        ]
        
        # Настраиваем моки
        mock_db.get_records_sql.side_effect = [
            mock_course_info,
            mock_lesson_info,
            [{'text': 'Тестовый вопрос'}],
            []  # Текст варианта ответа не найден
        ]
        
        with patch('misc.send_service_message') as mock_send_service:
            await send_homework_notification(
                user=mock_user,
                quiz_id=7,
                course_id=1,
                answers=quiz_answers,
                db=mock_db
            )
            
            # Проверяем, что уведомление отправлено
            mock_send_service.assert_called_once()
            
            sent_message = mock_send_service.call_args[0][0]
            
            # Проверяем, что вопрос отображается, но ответ может быть пустым
            assert '1. Тестовый вопрос' in sent_message
            # Ответ может быть пустым или содержать заглушку
    
    @patch('misc.send_service_message')
    @pytest.mark.asyncio
    async def test_send_homework_notification_emoji_formatting(
        self, 
        mock_send_service, 
        mock_db, 
        mock_user, 
        mock_answers,
        mock_course_info,
        mock_lesson_info,
        mock_question_texts,
        mock_answer_texts
    ):
        """Тест корректного отображения эмодзи в уведомлении."""
        # Настраиваем моки
        mock_db.get_records_sql.side_effect = [
            mock_course_info,
            mock_lesson_info,
            [{'text': mock_question_texts[1]}],
            [{'text': mock_question_texts[2]}],
            [{'text': mock_question_texts[3]}],
            [{'text': mock_answer_texts[5]}],
            [{'text': mock_answer_texts[8]}]
        ]
        
        # Вызываем тестируемую функцию
        await send_homework_notification(
            user=mock_user,
            quiz_id=2,
            course_id=1,
            answers=mock_answers,
            db=mock_db
        )
        
        # Получаем переданное сообщение
        sent_message = mock_send_service.call_args[0][0]
        
        # Проверяем наличие всех эмодзи
        assert '📚' in sent_message  # Эмодзи для заголовка
        assert '✍️' in sent_message  # Эмодзи для ответов пользователя
        
        # Проверяем, что эмодзи находятся в правильных местах
        lines = sent_message.split('\n')
        assert lines[0].startswith('📚')  # Первая строка начинается с эмодзи
        assert '✍️ Ответы пользователя:' in lines[2]  # Третья строка содержит эмодзи ответов


if __name__ == '__main__':
    pytest.main([__file__, '-v'])
