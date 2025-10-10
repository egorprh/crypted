#!/usr/bin/env python3
"""
Скрипт для запуска всех тестов системы уведомлений
"""

import sys
import os
import subprocess
import argparse

# Добавляем корень проекта в sys.path
PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)

def run_tests(test_type="all", verbose=False, performance=False):
    """Запускает тесты уведомлений"""
    
    # Базовые аргументы pytest
    cmd = ["python3", "-m", "pytest"]
    
    if verbose:
        cmd.append("-v")
    else:
        cmd.append("-q")
    
    # Выбор тестов в зависимости от типа
    if test_type == "all":
        cmd.extend([
            "test_notifications_comprehensive.py",
            "test_notifications_custom.py",
            "test_notifications_integration.py"
        ])
        if performance:
            cmd.append("test_notifications_performance.py")
    elif test_type == "comprehensive":
        cmd.append("test_notifications_comprehensive.py")
    elif test_type == "custom":
        cmd.append("test_notifications_custom.py")
    elif test_type == "integration":
        cmd.append("test_notifications_integration.py")
    elif test_type == "performance":
        cmd.append("test_notifications_performance.py")
        cmd.append("-s")  # Для вывода print statements
    else:
        print(f"Неизвестный тип тестов: {test_type}")
        return False
    
    # Дополнительные опции
    cmd.extend([
        "--tb=short",  # Краткий вывод ошибок
        "--strict-markers",  # Строгая проверка маркеров
        "--disable-warnings",  # Отключение предупреждений
        "-x",  # Остановка на первой ошибке
        "--maxfail=1"  # Максимум 1 неудача
    ])
    
    print(f"Запуск команды: {' '.join(cmd)}")
    print("-" * 50)
    
    try:
        result = subprocess.run(cmd, cwd=os.path.dirname(__file__))
        return result.returncode == 0
    except Exception as e:
        print(f"Ошибка при запуске тестов: {e}")
        return False

def main():
    parser = argparse.ArgumentParser(description="Запуск тестов системы уведомлений")
    parser.add_argument(
        "--type",
        choices=["all", "comprehensive", "custom", "integration", "performance"],
        default="all",
        help="Тип тестов для запуска"
    )
    parser.add_argument(
        "--verbose", "-v",
        action="store_true",
        help="Подробный вывод"
    )
    parser.add_argument(
        "--performance", "-p",
        action="store_true",
        help="Включить тесты производительности (только с --type all)"
    )
    parser.add_argument(
        "--list", "-l",
        action="store_true",
        help="Показать список доступных тестов"
    )
    
    args = parser.parse_args()
    
    if args.list:
        print("Доступные тесты:")
        print("1. comprehensive - Основные функциональные тесты")
        print("   - Создание уведомлений для разных уровней")
        print("   - Дедупликация уведомлений")
        print("   - Уведомления об окончании доступа")
        print("   - Разделение по telegram_id")
        print()
        print("2. custom - Кастомные тесты с моками")
        print("   - Тестирование с FakeDB (без реальной БД)")
        print("   - Проверка resolve_message_text")
        print("   - Тестирование текстов уведомлений")
        print()
        print("3. integration - Интеграционные тесты")
        print("   - Интеграция с API save_level")
        print("   - Консистентность данных")
        print("   - Очистка при удалении пользователей")
        print("   - Граничные случаи")
        print()
        print("4. performance - Тесты производительности")
        print("   - Массовое создание уведомлений")
        print("   - Конкурентное создание")
        print("   - Производительность запросов")
        print("   - Использование памяти")
        print()
        print("4. all - Все тесты (по умолчанию)")
        return
    
    print(f"Запуск тестов типа: {args.type}")
    if args.performance and args.type == "all":
        print("Включены тесты производительности")
    print()
    
    success = run_tests(
        test_type=args.type,
        verbose=args.verbose,
        performance=args.performance
    )
    
    if success:
        print("\n✅ Все тесты прошли успешно!")
        sys.exit(0)
    else:
        print("\n❌ Некоторые тесты завершились с ошибками")
        sys.exit(1)

if __name__ == "__main__":
    main()
