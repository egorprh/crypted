import os
import psycopg2
from psycopg2 import sql
import gspread
import time
from dotenv import load_dotenv
from collections import defaultdict

class PostgresToSheetsSync:
    def __init__(self):
        load_dotenv()
        self.setup_postgres()
        self.setup_google_sheets()
        
    def setup_postgres(self):
        """Устанавливает соединение с PostgreSQL"""
        self.pg_conn = psycopg2.connect(
            host=os.getenv('PG_HOST'),
            database=os.getenv('PG_DB'),
            user=os.getenv('PG_USER'),
            password=os.getenv('PG_PASSWORD')
        )
        self.pg_view = os.getenv('PG_VIEW')
        
    def setup_google_sheets(self):
        """Настраивает подключение к Google Sheets"""
        try:
            self.gc = gspread.service_account(filename="creds.json")
            sheet_name = os.getenv('SHEET_NAME')
            worksheet_name = os.getenv('WORKSHEET_NAME')
            
            print(f"Подключаемся к таблице: '{sheet_name}', лист: '{worksheet_name}'")
            
            # Проверка доступных таблиц
            available_sheets = [sh.title for sh in self.gc.openall()]
            print(f"Доступные таблицы: {available_sheets}")
            
            if sheet_name not in available_sheets:
                raise ValueError(f"Таблица '{sheet_name}' не найдена")
            
            self.sheet = self.gc.open(sheet_name).worksheet(worksheet_name)
            print(f"Успешное подключение к листу: {self.sheet.title}")
            
        except Exception as e:
            print(f"Ошибка подключения к Google Sheets: {str(e)}")
            print("Проверьте:")
            print("1. Правильность названий таблицы и листа")
            print("2. Доступ сервисного аккаунта к таблице")
            print("3. Точное совпадение названий (регистр символов)")
            raise
        
    def fetch_transformed_data(self):
        """Получает и преобразует данные из PostgreSQL"""
        try:
            with self.pg_conn.cursor() as cursor:
                cursor.execute(f"""
                    SELECT 
                        user_id, 
                        telegram_id, 
                        username, 
                        first_name, 
                        last_name, 
                        user_registration_date,
                        question_text,
                        user_answer
                    FROM {self.pg_view}
                    ORDER BY user_id
                """)
                raw_data = cursor.fetchall()

            if not raw_data:
                print("Нет данных в PostgreSQL")
                return None, None

            # Преобразование данных
            users = defaultdict(dict)
            questions = set()

            print(len(raw_data))

            for row in raw_data:
                user_id = row[0]
                print(row)
                # Основная информация о пользователе
                if not users[user_id]:
                    users[user_id] = {
                        'user_id': user_id,
                        'telegram_id': row[1],
                        'username': row[2] or '',
                        'first_name': row[3] or '',
                        'last_name': row[4] or '',
                        'registration_date': row[5].strftime('%Y-%m-%d %H:%M:%S') if row[5] else '',
                    }
                
                # Обработка вопросов и ответов
                question_key = self.normalize_question(row[6])
                users[user_id][question_key] = row[7]
                questions.add(question_key)

            # Формируем заголовки и строки
            base_headers = [
                'user_id',
                'telegram_id',
                'username',
                'first_name',
                'last_name',
                'registration_date'
            ]
            question_headers = sorted(questions)
            headers = base_headers + question_headers

            rows = []
            for user in users.values():
                row = [user.get(h, '') for h in headers]
                rows.append(row)

            return headers, rows

        except Exception as e:
            print(f"Ошибка при получении данных: {str(e)}")
            raise
    
    def normalize_question(self, question_text):
        """Нормализует текст вопроса для использования как ключа"""
        return (question_text.lower()
                .replace(' ', '_')
                .replace('?', '')
                .replace('.', '')
                .replace(',', '')
                .replace('"', '')
                .replace("'", ''))
    
    def update_sheet_completely(self, headers, rows):
        """Полностью обновляет данные в Google Sheets с учетом нового API gspread"""
        try:
            # Очищаем лист (используем новый метод clear())
            self.sheet.clear()
            
            # 1. Подготовка данных для batch_update
            requests = []
            
            # 1.1. Добавляем заголовки
            requests.append({
                'range': 'A1',
                'values': [headers]
            })
            
            # 1.2. Добавляем данные (разбиваем на пакеты)
            batch_size = 100
            for i in range(0, len(rows), batch_size):
                batch = rows[i:i + batch_size]
                start_row = i + 2  # +2 потому что 1 строка - заголовки
                end_row = start_row + len(batch) - 1
                requests.append({
                    'range': f'A{start_row}:{chr(ord("A") + len(headers) - 1)}{end_row}',
                    'values': batch
                })
            
            # 2. Массовое обновление (один запрос к API)
            self.sheet.batch_update(requests)
            
            print(f"Таблица успешно обновлена. Всего строк: {len(rows)}")
            
        except Exception as e:
            print(f"Ошибка при обновлении таблицы: {str(e)}")
            raise
    
    def run(self):
        """Основной цикл синхронизации"""
        try:
            while True:
                try:
                    headers, rows = self.fetch_transformed_data()
                    if headers and rows:
                        self.update_sheet_completely(headers, rows)
                    
                    # Интервал проверки (по умолчанию 60 секунд)
                    time.sleep(int(os.getenv('CHECK_INTERVAL', 60)))
                    
                except Exception as e:
                    print(f"Ошибка в цикле синхронизации: {e}")
                    time.sleep(300)  # Ожидание 5 минут при ошибке
                    
        finally:
            self.pg_conn.close()
            print("Соединение с PostgreSQL закрыто")

if __name__ == "__main__":
    try:
        sync_service = PostgresToSheetsSync()
        sync_service.run()
    except KeyboardInterrupt:
        print("Синхронизация остановлена пользователем")
    except Exception as e:
        print(f"Критическая ошибка: {str(e)}")