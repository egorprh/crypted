#!/usr/bin/env python3
"""
Скрипт для запуска всех unit тестов.
"""

import unittest
import sys
import os

# Добавляем путь к backend для импорта модулей
sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'backend'))

def run_tests():
    """Запускает все тесты"""
    # Находим все тестовые файлы
    test_loader = unittest.TestLoader()
    test_suite = test_loader.discover(os.path.dirname(__file__), pattern='test_*.py')
    
    # Запускаем тесты
    test_runner = unittest.TextTestRunner(verbosity=2)
    result = test_runner.run(test_suite)
    
    # Возвращаем код выхода
    return 0 if result.wasSuccessful() else 1

if __name__ == '__main__':
    exit_code = run_tests()
    sys.exit(exit_code)
