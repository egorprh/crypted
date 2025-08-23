#!/usr/bin/env python3
"""
Скрипт для запуска всех тестов.
"""

import sys
import os
import subprocess
from pathlib import Path

def run_tests():
    """Запускает все тесты."""
    # Добавляем backend в sys.path для импорта модулей
    backend_path = Path(__file__).parent.parent / "backend"
    if str(backend_path) not in sys.path:
        sys.path.insert(0, str(backend_path))
    
    # Автоматически находим все тестовые файлы
    tests_dir = Path(__file__).parent
    test_files = []
    
    for file_path in tests_dir.glob("test_*.py"):
        if file_path.is_file() and file_path.name != "__init__.py":
            test_files.append(file_path.name)
    
    # Сортируем файлы для предсказуемого порядка запуска
    test_files.sort()
    
    print(f"🔍 Найдено {len(test_files)} тестовых файлов:")
    for test_file in test_files:
        print(f"   - {test_file}")
    print()
    
    # Запускаем pytest для всех найденных тестов
    for test_file in test_files:
        test_path = tests_dir / test_file
        print(f"\n=== Запуск тестов из {test_file} ===")
        result = subprocess.run([
            sys.executable, "-m", "pytest", str(test_path), "-v"
        ], cwd=backend_path)
        
        if result.returncode != 0:
            print(f"❌ Тесты в {test_file} завершились с ошибками")
            return False
        else:
            print(f"✅ Тесты в {test_file} прошли успешно")
    
    print("\n🎉 Все тесты завершены успешно!")
    return True

if __name__ == "__main__":
    success = run_tests()
    sys.exit(0 if success else 1)
