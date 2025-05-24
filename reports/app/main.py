import os
import psycopg2
import gspread
import time
from dotenv import load_dotenv
from collections import defaultdict

# добавлять новые методы для других вкладок по тому же принципу:

# Создайте метод для получения данных (fetch_*_data())

# Добавьте новую вкладку в setup_google_sheets()

# Вызовите update_worksheet() с нужными параметрами

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
            self.spreadsheet = self.gc.open(os.getenv('SHEET_NAME'))
            
            # Получаем или создаем нужные вкладки
            self.survey_sheet = self._get_or_create_worksheet("Survey")
            self.users_sheet = self._get_or_create_worksheet("Users")
            self.courses_sheet = self._get_or_create_worksheet("Courses")
            
            print("Успешное подключение к Google Sheets")
            
        except Exception as e:
            print(f"Ошибка подключения к Google Sheets: {str(e)}")
            raise
        

    def _get_or_create_worksheet(self, worksheet_name):
        """Получает или создает вкладку с указанным именем"""
        try:
            worksheet = self.spreadsheet.worksheet(worksheet_name)
            print(f"Найдена существующая вкладка: {worksheet_name}")
            return worksheet
        except gspread.WorksheetNotFound:
            print(f"Создаем новую вкладку: {worksheet_name}")
            return self.spreadsheet.add_worksheet(title=worksheet_name, rows=1000, cols=20)
        

    def fetch_survey_data(self):
        """Получает и преобразует данные опроса из PostgreSQL"""
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
                print("Нет данных опроса в PostgreSQL")
                return None, None

            # Преобразование данных
            users = defaultdict(dict)
            questions = set()

            for row in raw_data:
                user_id = row[0]
                
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
            print(f"Ошибка при получении данных опроса: {str(e)}")
            raise
    
    def fetch_users_data(self):
        """Получает данные пользователей для вкладки Users"""
        try:
            with self.pg_conn.cursor() as cursor:
                cursor.execute("""
                    SELECT
                        id,
                        telegram_id,
                        username,
                        first_name,
                        last_name,
                        time_created
                    FROM users
                    ORDER BY id
                """)
                raw_data = cursor.fetchall()

            if not raw_data:
                print("Нет данных пользователей в PostgreSQL")
                return None, None

            # Формируем заголовки и строки
            headers = [
                'ID',
                'Telegram ID',
                'username',
                'first_name',
                'last_name',
                'registration_date'
            ]

            rows = []
            for row in raw_data:
                rows.append([
                    row[0],  # id
                    row[1],  # telegram_id
                    row[2] or '',  # username
                    row[3] or '',  # first_name
                    row[4] or '',  # last_name
                    row[5].strftime('%Y-%m-%d %H:%M:%S') if row[5] else ''  # registration_date
                ])

            return headers, rows

        except Exception as e:
            print(f"Ошибка при получении данных пользователей: {str(e)}")
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
    

    def update_worksheet(self, worksheet, headers, rows):
        """Обновляет указанную вкладку данными"""
        try:
            # Очищаем вкладку
            worksheet.clear()
            
            # Подготовка данных для batch_update
            requests = []
            
            # Добавляем заголовки
            requests.append({
                'range': 'A1',
                'values': [headers]
            })
            
            # Добавляем данные (разбиваем на пакеты)
            batch_size = 100
            for i in range(0, len(rows), batch_size):
                batch = rows[i:i + batch_size]
                start_row = i + 2  # +2 потому что 1 строка - заголовки
                end_row = start_row + len(batch) - 1
                requests.append({
                    'range': f'A{start_row}:{chr(ord("A") + len(headers) - 1)}{end_row}',
                    'values': batch
                })
            
            # Массовое обновление
            worksheet.batch_update(requests)
            
            print(f"Вкладка {worksheet.title} успешно обновлена. Всего строк: {len(rows)}")
            
        except Exception as e:
            print(f"Ошибка при обновлении вкладки {worksheet.title}: {str(e)}")
            raise
    

    def run(self):
        """Основной цикл синхронизации"""
        try:
            while True:
                try:
                    # Обновляем данные опроса
                    survey_headers, survey_rows = self.fetch_survey_data()
                    if survey_headers and survey_rows:
                        self.update_worksheet(self.survey_sheet, survey_headers, survey_rows)
                    
                    # Обновляем данные пользователей
                    users_headers, users_rows = self.fetch_users_data()
                    if users_headers and users_rows:
                        self.update_worksheet(self.users_sheet, users_headers, users_rows)
                    
                    # Интервал проверки
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