"""
Тесты для вспомогательных функций в misc.py
"""

import pytest
import sys
import os

# Добавляем путь к backend для импорта
sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'backend'))

from misc import remove_timestamps


class TestRemoveTimestamps:
    """Тесты для функции remove_timestamps."""
    
    def test_remove_timestamps_from_dict(self):
        """Тест удаления временных меток из словаря."""
        test_data = {
            'id': 1,
            'name': 'test',
            'time_created': '2023-01-01',
            'time_modified': '2023-01-02',
            'created_at': '2023-01-03',
            'updated_at': '2023-01-04'
        }
        
        result = remove_timestamps(test_data)
        
        # Проверяем, что временные метки удалены
        assert 'time_created' not in result
        assert 'time_modified' not in result
        assert 'created_at' not in result
        assert 'updated_at' not in result
        
        # Проверяем, что остальные поля остались
        assert result['id'] == 1
        assert result['name'] == 'test'
    
    def test_remove_timestamps_from_nested_dict(self):
        """Тест удаления временных меток из вложенного словаря."""
        test_data = {
            'id': 1,
            'nested': {
                'time_created': '2023-01-01',
                'time_modified': '2023-01-02',
                'value': 'test'
            }
        }
        
        result = remove_timestamps(test_data)
        
        # Проверяем, что временные метки удалены из вложенного словаря
        assert 'time_created' not in result['nested']
        assert 'time_modified' not in result['nested']
        assert result['nested']['value'] == 'test'
    
    def test_remove_timestamps_from_list(self):
        """Тест удаления временных меток из списка."""
        test_data = [
            {'id': 1, 'time_created': '2023-01-01'},
            {'id': 2, 'time_modified': '2023-01-02'},
            {'id': 3, 'name': 'test'}
        ]
        
        result = remove_timestamps(test_data)
        
        # Проверяем, что временные метки удалены из всех элементов списка
        assert 'time_created' not in result[0]
        assert 'time_modified' not in result[1]
        assert result[0]['id'] == 1
        assert result[1]['id'] == 2
        assert result[2]['name'] == 'test'
    
    def test_remove_timestamps_from_complex_structure(self):
        """Тест удаления временных меток из сложной структуры данных."""
        test_data = {
            'courses': [
                {
                    'id': 1,
                    'title': 'Course 1',
                    'time_created': '2023-01-01',
                    'lessons': [
                        {
                            'id': 1,
                            'title': 'Lesson 1',
                            'time_modified': '2023-01-02'
                        }
                    ]
                }
            ],
            'config': {
                'time_created': '2023-01-03',
                'setting': 'value'
            }
        }
        
        result = remove_timestamps(test_data)
        
        # Проверяем, что временные метки удалены на всех уровнях
        assert 'time_created' not in result['courses'][0]
        assert 'time_modified' not in result['courses'][0]['lessons'][0]
        assert 'time_created' not in result['config']
        
        # Проверяем, что остальные данные остались
        assert result['courses'][0]['title'] == 'Course 1'
        assert result['courses'][0]['lessons'][0]['title'] == 'Lesson 1'
        assert result['config']['setting'] == 'value'
    
    def test_remove_timestamps_no_timestamps(self):
        """Тест функции с данными без временных меток."""
        test_data = {
            'id': 1,
            'name': 'test',
            'value': 123
        }
        
        result = remove_timestamps(test_data)
        
        # Проверяем, что данные не изменились
        assert result == test_data
    
    def test_remove_timestamps_empty_data(self):
        """Тест функции с пустыми данными."""
        # Пустой словарь
        assert remove_timestamps({}) == {}
        
        # Пустой список
        assert remove_timestamps([]) == []
        
        # None
        assert remove_timestamps(None) is None
        
        # Строка
        assert remove_timestamps("test") == "test"
        
        # Число
        assert remove_timestamps(123) == 123


if __name__ == "__main__":
    pytest.main([__file__])
