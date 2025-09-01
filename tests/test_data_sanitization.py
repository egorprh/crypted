"""
Тесты для функционала очистки данных от опасных символов
"""

import pytest
import sys
import os

# Добавляем путь к backend для импорта
sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'backend'))

from db.pgapi import sanitize_input, sanitize_data


class TestDataSanitization:
    """Тесты для функций очистки данных."""
    
    def test_sanitize_input_basic(self):
        """Тест базовой очистки текста."""
        # Обычный текст без изменений
        assert sanitize_input("Привет, мир!") == "Привет, мир!"
        assert sanitize_input("123") == "123"
        assert sanitize_input("") == ""
        assert sanitize_input(None) == ""
    
    def test_sanitize_input_html_tags(self):
        """Тест удаления HTML тегов."""
        # HTML теги должны быть удалены
        assert sanitize_input("<script>alert('xss')</script>") == "alertxss"
        assert sanitize_input("<div>Текст</div>") == "Текст"
        assert sanitize_input("<p>Параграф</p>") == "Параграф"
        assert sanitize_input("<h1>Заголовок</h1>") == "Заголовок"
        assert sanitize_input("<iframe src='evil.com'></iframe>") == ""
        assert sanitize_input("<style>body{color:red}</style>") == "bodycolor:red"
    
    def test_sanitize_input_dangerous_chars(self):
        """Тест удаления опасных символов."""
        # Опасные символы должны быть удалены
        assert sanitize_input("Текст < с символом") == "Текст с символом"
        assert sanitize_input("Текст > с символом") == "Текст с символом"
        assert sanitize_input('Текст " в кавычках') == "Текст в кавычках"
        assert sanitize_input("Текст ' в кавычках") == "Текст в кавычках"
        assert sanitize_input("Текст & с амперсандом") == "Текст с амперсандом"
        assert sanitize_input("Текст; с точкой с запятой") == "Текст с точкой с запятой"
        assert sanitize_input("Текст { с скобкой") == "Текст с скобкой"
        assert sanitize_input("Текст } с скобкой") == "Текст с скобкой"
        assert sanitize_input("Текст [ с скобкой") == "Текст с скобкой"
        assert sanitize_input("Текст ] с скобкой") == "Текст с скобкой"
        assert sanitize_input("Текст ( с скобкой") == "Текст с скобкой"
        assert sanitize_input("Текст ) с скобкой") == "Текст с скобкой"
    
    def test_sanitize_input_multiple_spaces(self):
        """Тест удаления множественных пробелов и переносов строк."""
        # Множественные пробелы должны быть заменены одним, но переносы строк сохраняются
        assert sanitize_input("Текст    с    пробелами") == "Текст с пробелами"
        assert sanitize_input("Текст\nс\nпереносами") == "Текст\nс\nпереносами"
        assert sanitize_input("Текст\tс\tтабуляцией") == "Текст с табуляцией"
        assert sanitize_input("  Текст с пробелами в начале и конце  ") == "Текст с пробелами в начале и конце"
    
    def test_sanitize_input_length_limit(self):
        """Тест ограничения длины текста."""
        # Текст должен быть обрезан до максимальной длины
        long_text = "A" * 600  # 600 символов
        result = sanitize_input(long_text, max_length=512)
        assert len(result) == 512
        assert result == "A" * 512
        
        # Короткий текст не должен изменяться
        short_text = "Короткий текст"
        result = sanitize_input(short_text, max_length=512)
        assert result == short_text
    
    def test_sanitize_input_complex_html(self):
        """Тест очистки сложных HTML конструкций."""
        complex_html = """
        <html>
            <head>
                <title>Злой сайт</title>
                <script>alert('XSS Attack')</script>
                <style>body{background:red}</style>
            </head>
            <body>
                <div class="content">
                    <h1>Заголовок</h1>
                    <p>Параграф с <strong>жирным</strong> текстом</p>
                    <iframe src="javascript:alert('XSS')"></iframe>
                </div>
            </body>
        </html>
        """
        
        result = sanitize_input(complex_html)
        
        # HTML теги должны быть удалены
        assert "<" not in result
        assert ">" not in result
        assert "script" not in result
        assert "style" not in result
        assert "iframe" not in result
        
        # Полезный текст должен остаться
        assert "Злой сайт" in result
        assert "Заголовок" in result
        assert "Параграф с жирным текстом" in result
    
    def test_sanitize_input_xss_attempts(self):
        """Тест защиты от XSS атак."""
        xss_attempts = [
            "<script>alert('XSS')</script>",
            "javascript:alert('XSS')",
            "<img src=x onerror=alert('XSS')>",
            "<svg onload=alert('XSS')>",
            "<body onload=alert('XSS')>",
            "<iframe src=javascript:alert('XSS')></iframe>",
            "<object data=javascript:alert('XSS')></object>",
            "<embed src=javascript:alert('XSS')>",
            "<form action=javascript:alert('XSS')>",
            "<input onfocus=alert('XSS')>"
        ]
        
        for xss_attempt in xss_attempts:
            result = sanitize_input(xss_attempt)
            # HTML теги должны быть удалены
            assert "<" not in result
            assert ">" not in result
            # JavaScript код должен быть обезврежен (удалены опасные символы)
            # Проверяем, что опасные части удалены
            assert "=" not in result
            # Проверяем, что результат не содержит полных опасных конструкций
            assert "alert(" not in result
            assert "onerror" not in result
            assert "onload" not in result
            assert "onfocus" not in result
    
    def test_sanitize_input_sql_injection_attempts(self):
        """Тест защиты от SQL инъекций."""
        sql_attempts = [
            "'; DROP TABLE users; --",
            "' OR 1=1 --",
            "' UNION SELECT * FROM passwords --",
            "'; INSERT INTO users VALUES ('hacker', 'password'); --",
            "' OR '1'='1",
            "'; EXEC xp_cmdshell('dir'); --"
        ]
        
        for sql_attempt in sql_attempts:
            result = sanitize_input(sql_attempt)
            # Опасные символы должны быть удалены
            assert "'" not in result
            assert ";" not in result
            # Проверяем, что основные опасные символы удалены
            # Функция удаляет не все SQL конструкции, но основные опасные символы
            print(f"SQL attempt: {sql_attempt} -> Result: {result}")
    
    def test_sanitize_data_dict(self):
        """Тест очистки данных в словаре."""
        test_data = {
            'id': 1,
            'name': '<script>alert("xss")</script>Иван',
            'email': 'ivan@example.com',
            'bio': '<p>Биография с <strong>HTML</strong> тегами</p>',
            'age': 25,
            'active': True
        }
        
        result = sanitize_data(test_data)
        
        # ID, возраст и флаг не должны измениться
        assert result['id'] == 1
        assert result['age'] == 25
        assert result['active'] is True
        
        # Строковые поля должны быть очищены
        assert result['name'] == 'alertxssИван'
        assert result['email'] == 'ivan@example.com'
        assert result['bio'] == 'Биография с HTML тегами'
        
        # HTML теги должны быть удалены
        assert "<" not in result['name']
        assert "<" not in result['bio']
        assert ">" not in result['name']
        assert ">" not in result['bio']
    
    def test_sanitize_data_nested_dict(self):
        """Тест очистки вложенных словарей."""
        test_data = {
            'user': {
                'id': 1,
                'name': '<script>alert("xss")</script>Иван',
                'profile': {
                    'bio': '<p>Биография</p>',
                    'website': 'https://example.com'
                }
            },
            'settings': {
                'theme': 'dark',
                'notifications': True
            }
        }
        
        result = sanitize_data(test_data)
        
        # Вложенные словари должны быть очищены
        assert result['user']['name'] == 'alertxssИван'
        assert result['user']['profile']['bio'] == 'Биография'
        assert result['user']['profile']['website'] == 'https://example.com'
        assert result['settings']['theme'] == 'dark'
        assert result['settings']['notifications'] is True
        
        # HTML теги должны быть удалены
        assert "<" not in result['user']['name']
        assert "<" not in result['user']['profile']['bio']
    
    def test_sanitize_data_list(self):
        """Тест очистки списков."""
        test_data = {
            'users': [
                {'name': '<script>alert("xss")</script>Иван', 'age': 25},
                {'name': 'Мария', 'age': 30},
                '<p>Текст в списке</p>'
            ],
            'tags': ['<script>', 'python', '<strong>web</strong>']
        }
        
        result = sanitize_data(test_data)
        
        # Списки должны быть очищены
        assert result['users'][0]['name'] == 'alertxssИван'
        assert result['users'][1]['name'] == 'Мария'
        assert result['users'][1]['age'] == 30
        assert result['users'][2] == 'Текст в списке'
        assert result['tags'] == ['', 'python', 'web']
        
        # HTML теги должны быть удалены
        assert "<" not in result['users'][0]['name']
        assert "<" not in result['users'][2]
        assert "<" not in str(result['tags'])
    
    def test_sanitize_data_edge_cases(self):
        """Тест граничных случаев."""
        # Пустые структуры
        assert sanitize_data({}) == {}
        assert sanitize_data([]) == []
        assert sanitize_data(None) == None
        
        # Не словари
        assert sanitize_data("просто строка") == "просто строка"
        assert sanitize_data(123) == 123
        assert sanitize_data(True) == True
        
        # Смешанные типы
        mixed_data = {
            'string': '<p>HTML</p>',
            'number': 42,
            'boolean': False,
            'none': None,
            'list': [1, 2, 3],
            'dict': {'key': 'value'}
        }
        
        result = sanitize_data(mixed_data)
        assert result['string'] == 'HTML'
        assert result['number'] == 42
        assert result['boolean'] is False
        assert result['none'] is None
        assert result['list'] == [1, 2, 3]
        assert result['dict'] == {'key': 'value'}
    
    def test_sanitize_input_unicode(self):
        """Тест работы с Unicode символами."""
        unicode_text = "Привет, мир! 🌍 你好世界! Привіт, світ!"
        result = sanitize_input(unicode_text)
        
        # Unicode символы должны сохраниться
        assert "Привет" in result
        assert "мир" in result
        assert "🌍" in result
        assert "你好世界" in result
        assert "Привіт" in result
        assert "світ" in result
    
    def test_sanitize_input_special_characters(self):
        """Тест работы со специальными символами."""
        special_chars = "!@#$%^&*()_+-=[]{}|;:,.<>?/~`"
        result = sanitize_input(special_chars)
        
        # Опасные символы должны быть удалены
        assert "<" not in result
        assert ">" not in result
        assert ";" not in result
        assert "{" not in result
        assert "}" not in result
        assert "[" not in result
        assert "]" not in result
        assert "(" not in result
        assert ")" not in result
        
        # Безопасные символы должны остаться
        assert "!" in result
        assert "@" in result
        assert "#" in result
        assert "$" in result
        assert "%" in result
        assert "^" in result
        assert "*" in result
        assert "_" in result
        assert "+" in result
        assert "-" in result
        # Символ "=" теперь удаляется как опасный
        assert "|" in result
        assert ":" in result
        assert "," in result
        assert "." in result
        assert "?" in result
        assert "/" in result
        assert "~" in result
        assert "`" in result


if __name__ == '__main__':
    pytest.main([__file__, '-v'])
