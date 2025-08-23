"""
Unit тесты для функций работы с записями пользователей на курсы.
Тесты работают без поднятия базы данных и бэкенда.
"""

import unittest
from unittest.mock import Mock, AsyncMock, patch
from datetime import datetime, timedelta
import sys
import os
import logging

# Настройка логирования для тестов
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Добавляем путь к backend для импорта модулей
sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'backend'))

# Импортируем функции для тестирования
from enrollment import create_user_enrollment, update_user_enrollment, get_course_access_info, ENROLLMENT_STATUS_NOT_ENROLLED, ENROLLMENT_STATUS_ENROLLED


class TestEnrollmentFunctions(unittest.TestCase):
    """Тесты для функций работы с записями пользователей на курсы"""
    
    def setUp(self):
        """Настройка перед каждым тестом"""
        self.mock_db = Mock()
        self.mock_db.get_record = AsyncMock()
        self.mock_db.insert_record = AsyncMock()
        self.mock_db.update_record = AsyncMock()
    
    def tearDown(self):
        """Очистка после каждого теста"""
        pass
    
    @patch('enrollment.logger')
    async def test_create_user_enrollment_new_enrollment(self, mock_logger):
        """Тест создания новой записи пользователя на курс"""
        # Настройка моков
        self.mock_db.get_record.side_effect = [
            None,  # Запись не найдена
            {'id': 1, 'access_time': 24}  # Курс найден
        ]
        self.mock_db.insert_record.return_value = 123
        
        # Выполнение тестируемой функции
        result = await create_user_enrollment(self.mock_db, 1, 1)
        
        # Проверки
        self.assertTrue(result)
        self.mock_db.get_record.assert_called()
        self.mock_db.insert_record.assert_called_once()
        
        # Проверяем, что запись создана с правильными данными
        call_args = self.mock_db.insert_record.call_args[0]
        self.assertEqual(call_args[0], 'user_enrollment')
        enrollment_data = call_args[1]
        self.assertEqual(enrollment_data['user_id'], 1)
        self.assertEqual(enrollment_data['course_id'], 1)
        self.assertEqual(enrollment_data['status'], ENROLLMENT_STATUS_ENROLLED)
        self.assertIn('time_start', enrollment_data)
        self.assertIn('time_end', enrollment_data)
    
    @patch('enrollment.logger')
    async def test_create_user_enrollment_existing_enrollment(self, mock_logger):
        """Тест попытки создания записи, которая уже существует"""
        # Настройка моков - запись уже существует
        self.mock_db.get_record.return_value = {'id': 1, 'user_id': 1, 'course_id': 1}
        
        # Выполнение тестируемой функции
        result = await create_user_enrollment(self.mock_db, 1, 1)
        
        # Проверки
        self.assertTrue(result)
        self.mock_db.get_record.assert_called_once()
        self.mock_db.insert_record.assert_not_called()
        mock_logger.info.assert_called_with("Запись на курс 1 для пользователя 1 уже существует")
    
    @patch('enrollment.logger')
    async def test_create_user_enrollment_course_not_found(self, mock_logger):
        """Тест создания записи для несуществующего курса"""
        # Настройка моков
        self.mock_db.get_record.side_effect = [
            None,  # Запись не найдена
            None   # Курс не найден
        ]
        
        # Выполнение тестируемой функции
        result = await create_user_enrollment(self.mock_db, 1, 999)
        
        # Проверки
        self.assertFalse(result)
        mock_logger.error.assert_called_with("Курс 999 не найден")
        self.mock_db.insert_record.assert_not_called()
    
    @patch('enrollment.logger')
    async def test_create_user_enrollment_exception(self, mock_logger):
        """Тест обработки исключения при создании записи"""
        logger.info("Запуск теста обработки исключения при создании записи")
        
        # Настройка моков - вызываем исключение
        self.mock_db.get_record.side_effect = Exception("Database error")
        
        # Выполнение тестируемой функции
        result = await create_user_enrollment(self.mock_db, 1, 1)
        
        # Проверки
        self.assertFalse(result)
        mock_logger.error.assert_called_with("Ошибка при создании записи на курс: Database error")
        logger.info("Тест обработки исключения при создании записи завершен успешно")
    
    @patch('enrollment.logger')
    async def test_create_user_enrollment_access_time_zero(self, mock_logger):
        """Тест создания записи для курса с access_time = 0"""
        logger.info("Запуск теста создания записи для курса с access_time = 0")
        
        # Настройка моков - запись не найдена, курс с access_time = 0
        self.mock_db.get_record.side_effect = [
            None,  # Запись не найдена
            {'id': 1, 'access_time': 0}  # Курс найден с access_time = 0
        ]
        self.mock_db.insert_record.return_value = 123
        
        # Выполнение тестируемой функции
        result = await create_user_enrollment(self.mock_db, 1, 1)
        
        # Проверки
        self.assertTrue(result)
        self.mock_db.get_record.assert_called()
        self.mock_db.insert_record.assert_called_once()  # Запись должна создаваться с time_end = 0
        
        # Проверяем, что запись создана с правильными данными
        call_args = self.mock_db.insert_record.call_args[0]
        self.assertEqual(call_args[0], 'user_enrollment')
        enrollment_data = call_args[1]
        self.assertEqual(enrollment_data['user_id'], 1)
        self.assertEqual(enrollment_data['course_id'], 1)
        self.assertEqual(enrollment_data['status'], ENROLLMENT_STATUS_ENROLLED)
        self.assertEqual(enrollment_data['time_end'], 0)  # Бесконечная подписка
        self.assertIn('time_start', enrollment_data)
        
        mock_logger.info.assert_called_with("Курс 1 не имеет ограничений по времени (access_time = 0), создается бесконечная подписка")
        logger.info("Тест создания записи для курса с access_time = 0 завершен успешно")
    
    @patch('enrollment.logger')
    async def test_update_user_enrollment_no_enrollment(self, mock_logger):
        """Тест обновления записи, которая не существует"""
        # Настройка моков - запись не найдена
        self.mock_db.get_record.return_value = None
        
        # Выполнение тестируемой функции
        result = await update_user_enrollment(self.mock_db, 1, 1)
        
        # Проверки
        self.assertTrue(result)
        self.mock_db.get_record.assert_called_once()
        self.mock_db.update_record.assert_not_called()
        mock_logger.info.assert_called_with("Запись на курс 1 для пользователя 1 не найдена")
    
    @patch('enrollment.logger')
    @patch('enrollment.datetime')
    async def test_update_user_enrollment_time_not_expired(self, mock_datetime, mock_logger):
        """Тест обновления записи, время которой не истекло"""
        # Настройка моков
        current_time = datetime(2023, 1, 1, 12, 0, 0)
        future_time = current_time + timedelta(hours=5)
        
        mock_datetime.now.return_value = current_time
        self.mock_db.get_record.return_value = {
            'id': 1,
            'user_id': 1,
            'course_id': 1,
            'time_end': future_time,
            'status': ENROLLMENT_STATUS_ENROLLED
        }
        
        # Выполнение тестируемой функции
        result = await update_user_enrollment(self.mock_db, 1, 1)
        
        # Проверки
        self.assertTrue(result)
        self.mock_db.get_record.assert_called_once()
        self.mock_db.update_record.assert_not_called()
    
    @patch('enrollment.logger')
    @patch('enrollment.datetime')
    async def test_update_user_enrollment_time_expired(self, mock_datetime, mock_logger):
        """Тест обновления записи, время которой истекло"""
        # Настройка моков
        current_time = datetime(2023, 1, 1, 12, 0, 0)
        past_time = current_time - timedelta(hours=5)
        
        mock_datetime.now.return_value = current_time
        self.mock_db.get_record.return_value = {
            'id': 1,
            'user_id': 1,
            'course_id': 1,
            'time_end': past_time,
            'status': ENROLLMENT_STATUS_ENROLLED
        }
        
        # Выполнение тестируемой функции
        result = await update_user_enrollment(self.mock_db, 1, 1)
        
        # Проверки
        self.assertTrue(result)
        self.mock_db.get_record.assert_called_once()
        self.mock_db.update_record.assert_called_once_with(1, {'status': ENROLLMENT_STATUS_NOT_ENROLLED})
        mock_logger.info.assert_called_with("Время доступа к курсу 1 для пользователя 1 истекло, статус обновлен")
    
    @patch('enrollment.logger')
    async def test_update_user_enrollment_exception(self, mock_logger):
        """Тест обработки исключения при обновлении записи"""
        logger.info("Запуск теста обработки исключения при обновлении записи")
        
        # Настройка моков - вызываем исключение
        self.mock_db.get_record.side_effect = Exception("Database error")
        
        # Выполнение тестируемой функции
        result = await update_user_enrollment(self.mock_db, 1, 1)
        
        # Проверки
        self.assertFalse(result)
        mock_logger.error.assert_called_with("Ошибка при обновлении записи на курс: Database error")
        logger.info("Тест обработки исключения при обновлении записи завершен успешно")
    
    @patch('enrollment.logger')
    async def test_update_user_enrollment_time_end_zero(self, mock_logger):
        """Тест обновления записи с time_end = 0 (бесконечная подписка)"""
        logger.info("Запуск теста обновления записи с time_end = 0")
        
        # Настройка моков - запись с time_end = 0
        self.mock_db.get_record.return_value = {
            'id': 1,
            'user_id': 1,
            'course_id': 1,
            'time_end': 0,  # Бесконечная подписка
            'status': ENROLLMENT_STATUS_ENROLLED
        }
        
        # Выполнение тестируемой функции
        result = await update_user_enrollment(self.mock_db, 1, 1)
        
        # Проверки
        self.assertTrue(result)
        self.mock_db.get_record.assert_called_once()
        self.mock_db.update_record.assert_not_called()  # Статус не должен обновляться
        mock_logger.info.assert_called_with("Подписка на курс 1 для пользователя 1 бесконечная (time_end = 0)")
        logger.info("Тест обновления записи с time_end = 0 завершен успешно")
    
    @patch('enrollment.logger')
    async def test_get_course_access_info_enrolled(self, mock_logger):
        """Тест получения информации о доступе для записанного пользователя"""
        logger.info("Запуск теста получения информации о доступе для записанного пользователя")
        
        # Настройка моков
        current_time = datetime(2023, 1, 1, 12, 0, 0)
        time_end = current_time + timedelta(hours=5)
        
        self.mock_db.get_record.side_effect = [
            # update_user_enrollment - запись найдена
            {
                'id': 1,
                'user_id': 1,
                'course_id': 1,
                'time_end': time_end,
                'status': ENROLLMENT_STATUS_ENROLLED
            },
            # get_course_access_info - запись найдена
            {
                'id': 1,
                'user_id': 1,
                'course_id': 1,
                'time_end': time_end,
                'status': ENROLLMENT_STATUS_ENROLLED
            },
            # get_course_access_info - курс найден
            {'id': 1, 'access_time': 24}
        ]
        
        # Патчим datetime.now для предсказуемого результата
        with patch('enrollment.datetime') as mock_datetime:
            mock_datetime.now.return_value = current_time
            
            # Выполнение тестируемой функции
            result = await get_course_access_info(self.mock_db, 1, 1)
        
        # Проверки
        self.assertIsInstance(result, dict)
        self.assertIn('time_left', result)
        self.assertIn('user_enrolment', result)
        self.assertEqual(result['user_enrolment'], ENROLLMENT_STATUS_ENROLLED)
        self.assertEqual(result['time_left'], 5.0)  # 5 часов осталось
        
        logger.info(f"Результат: time_left={result['time_left']}, user_enrolment={result['user_enrolment']}")
        logger.info("Тест получения информации о доступе для записанного пользователя завершен успешно")
    
    @patch('enrollment.logger')
    async def test_get_course_access_info_not_enrolled(self, mock_logger):
        """Тест получения информации о доступе для незаписанного пользователя"""
        logger.info("Запуск теста получения информации о доступе для незаписанного пользователя")
        
        # Настройка моков
        self.mock_db.get_record.side_effect = [
            # update_user_enrollment - запись не найдена
            None,
            # get_course_access_info - запись не найдена
            None,
            # get_course_access_info - курс найден
            {'id': 1, 'access_time': 48}
        ]
        
        # Выполнение тестируемой функции
        result = await get_course_access_info(self.mock_db, 1, 1)
        
        # Проверки
        self.assertIsInstance(result, dict)
        self.assertIn('time_left', result)
        self.assertIn('user_enrolment', result)
        self.assertEqual(result['user_enrolment'], ENROLLMENT_STATUS_NOT_ENROLLED)
        self.assertEqual(result['time_left'], 48.0)  # Время доступа из курса
        
        logger.info(f"Результат: time_left={result['time_left']}, user_enrolment={result['user_enrolment']}")
        logger.info("Тест получения информации о доступе для незаписанного пользователя завершен успешно")
    
    @patch('enrollment.logger')
    async def test_get_course_access_info_unlimited_course(self, mock_logger):
        """Тест получения информации о доступе для курса без ограничений"""
        logger.info("Запуск теста получения информации о доступе для курса без ограничений")
        
        # Настройка моков
        self.mock_db.get_record.side_effect = [
            # update_user_enrollment - запись не найдена
            None,
            # get_course_access_info - запись не найдена
            None,
            # get_course_access_info - курс найден с access_time = 0
            {'id': 1, 'access_time': 0}
        ]
        
        # Выполнение тестируемой функции
        result = await get_course_access_info(self.mock_db, 1, 1)
        
        # Проверки
        self.assertIsInstance(result, dict)
        self.assertIn('time_left', result)
        self.assertIn('user_enrolment', result)
        self.assertEqual(result['user_enrolment'], ENROLLMENT_STATUS_NOT_ENROLLED)
        self.assertEqual(result['time_left'], -1)  # Специальное значение для бесконечного доступа
        
        logger.info(f"Результат: time_left={result['time_left']}, user_enrolment={result['user_enrolment']}")
        logger.info("Тест получения информации о доступе для курса без ограничений завершен успешно")


class TestEnrollmentConstants(unittest.TestCase):
    """Тесты для констант статусов подписки"""
    
    def test_enrollment_status_constants(self):
        """Тест значений констант статусов подписки"""
        self.assertEqual(ENROLLMENT_STATUS_NOT_ENROLLED, 0)
        self.assertEqual(ENROLLMENT_STATUS_ENROLLED, 1)


if __name__ == '__main__':
    # Запуск тестов
    unittest.main()
