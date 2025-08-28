"""
Юнит-тесты для функции отправки данных в CRM
"""

import pytest
import asyncio
from unittest.mock import AsyncMock, patch, MagicMock
import sys
import os

# Добавляем путь к модулям backend
sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'backend'))

from misc import send_survey_to_crm, remove_timestamps


class TestSendSurveyToCRM:
    """Тесты для функции send_survey_to_crm"""
    
    @pytest.fixture
    def test_user(self):
        """Фикстура с тестовыми данными пользователя"""
        return {
            "telegram_id": 123456789,
            "username": "test_user",
            "first_name": "Тест",
            "last_name": "Пользователь"
        }
    
    @pytest.fixture
    def test_survey_data(self):
        """Фикстура с тестовыми данными опроса"""
        return [
            {
                "question": "Ваш возраст?",
                "answer": "25"
            },
            {
                "question": "Ваш опыт в трейдинге?",
                "answer": "Начинающий"
            },
            {
                "question": "Какую сумму планируете инвестировать?",
                "answer": "1000-5000 USD"
            }
        ]
    
    @pytest.fixture
    def test_level(self):
        """Фикстура с тестовыми данными уровня"""
        return {
            "id": 1,
            "name": "Начинающий"
        }
    
    @pytest.mark.asyncio
    async def test_send_survey_to_crm_success(self, test_user, test_survey_data, test_level):
        """Тест успешной отправки данных в CRM"""
        
        # Мокаем конфигурацию
        mock_config = MagicMock()
        mock_config.misc.crm_webhook_url = "https://test-crm.com/webhook"
        
        # Мокаем HTTP сессию
        mock_response = AsyncMock()
        mock_response.status = 200
        
        mock_session = AsyncMock()
        mock_session.__aenter__.return_value.post.return_value.__aenter__.return_value = mock_response
        
        with patch('misc.load_config', return_value=mock_config), \
             patch('aiohttp.ClientSession', return_value=mock_session):
            
            await send_survey_to_crm(test_user, test_survey_data, test_level)
            
            # Проверяем, что POST запрос был вызван с правильными параметрами
            mock_session.__aenter__.return_value.post.assert_called_once()
            call_args = mock_session.__aenter__.return_value.post.call_args
            
            assert call_args[0][0] == "https://test-crm.com/webhook"
            assert call_args[1]["headers"]["Content-Type"] == "application/json"
            
            # Проверяем структуру payload (плоский формат)
            payload = call_args[1]["json"]
            assert payload["telegram_id"] == 123456789
            assert payload["username"] == "test_user"
            assert payload["level"] == "Начинающий"
            assert payload["level_id"] == 1
            # Поля из опроса
            assert "name" in payload
            assert "age" in payload
            assert "phone" in payload
    
    @pytest.mark.asyncio
    async def test_send_survey_to_crm_no_webhook_url(self, test_user, test_survey_data, test_level):
        """Тест поведения при отсутствии webhook URL"""
        
        # Мокаем конфигурацию без webhook URL
        mock_config = MagicMock()
        mock_config.misc.crm_webhook_url = None
        
        with patch('misc.load_config', return_value=mock_config), \
             patch('misc.logger') as mock_logger:
            
            await send_survey_to_crm(test_user, test_survey_data, test_level)
            
            # Проверяем, что было записано предупреждение
            mock_logger.warning.assert_called_once_with("CRM webhook URL не настроен, пропускаем отправку в CRM")
    
    @pytest.mark.asyncio
    async def test_send_survey_to_crm_http_error(self, test_user, test_survey_data, test_level):
        """Тест обработки HTTP ошибки"""
        
        # Мокаем конфигурацию
        mock_config = MagicMock()
        mock_config.misc.crm_webhook_url = "https://test-crm.com/webhook"
        
        # Мокаем исключение при HTTP запросе
        with patch('misc.load_config', return_value=mock_config), \
             patch('aiohttp.ClientSession', side_effect=Exception("HTTP Error")), \
             patch('misc.logger') as mock_logger:
            
            await send_survey_to_crm(test_user, test_survey_data, test_level)
            
            # Проверяем, что была записана ошибка
            mock_logger.error.assert_called_once()
            error_call = mock_logger.error.call_args[0][0]
            assert "Ошибка при отправке данных в CRM" in error_call
    
    @pytest.mark.asyncio
    async def test_send_survey_to_crm_exception(self, test_user, test_survey_data, test_level):
        """Тест обработки исключения"""
        
        # Мокаем конфигурацию
        mock_config = MagicMock()
        mock_config.misc.crm_webhook_url = "https://test-crm.com/webhook"
        
        # Мокаем исключение при создании сессии
        with patch('misc.load_config', return_value=mock_config), \
             patch('aiohttp.ClientSession', side_effect=Exception("Connection error")), \
             patch('misc.logger') as mock_logger:
            
            await send_survey_to_crm(test_user, test_survey_data, test_level)
            
            # Проверяем, что была записана ошибка
            mock_logger.error.assert_called_once()
            error_call = mock_logger.error.call_args[0][0]
            assert "Ошибка при отправке данных в CRM" in error_call


class TestRemoveTimestamps:
    """Тесты для функции remove_timestamps"""
    
    def test_remove_timestamps_dict(self):
        """Тест удаления временных меток из словаря"""
        data = {
            "id": 1,
            "name": "test",
            "created_at": "2024-01-01",
            "updated_at": "2024-01-02",
            "nested": {
                "value": "test",
                "created_at": "2024-01-01"
            }
        }
        
        result = remove_timestamps(data)
        
        assert "created_at" not in result
        assert "updated_at" not in result
        assert result["id"] == 1
        assert result["name"] == "test"
        assert "created_at" not in result["nested"]
        assert result["nested"]["value"] == "test"
    
    def test_remove_timestamps_list(self):
        """Тест удаления временных меток из списка"""
        data = [
            {"id": 1, "created_at": "2024-01-01"},
            {"id": 2, "updated_at": "2024-01-02"},
            {"id": 3, "name": "test"}
        ]
        
        result = remove_timestamps(data)
        
        assert len(result) == 3
        assert "created_at" not in result[0]
        assert "updated_at" not in result[1]
        assert result[0]["id"] == 1
        assert result[1]["id"] == 2
        assert result[2]["name"] == "test"
    
    def test_remove_timestamps_primitive(self):
        """Тест обработки примитивных типов"""
        assert remove_timestamps("test") == "test"
        assert remove_timestamps(123) == 123
        assert remove_timestamps(True) == True
        assert remove_timestamps(None) == None


if __name__ == "__main__":
    pytest.main([__file__])
