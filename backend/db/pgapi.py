from datetime import datetime, timedelta
import os
import re
from typing import Any, Dict, Optional, Type, Union
from pydantic import BaseModel
import asyncpg
from asyncpg import Pool, Connection
import db.models as models
from logger import logger  # Импортируем логгер
import subprocess
import gzip
import shutil

from config import load_config


def sanitize_input(text: str, max_length: int = 512) -> str:
    """
    Очищает пользовательский ввод от опасных символов и тегов.
    
    Args:
        text: Исходный текст для очистки
        max_length: Максимальная длина текста
    
    Returns:
        Очищенный и обрезанный текст
    """
    if not text:
        return ""
    
    # Приводим к строке
    text = str(text)
    
    # Убираем HTML теги (включая script, style, iframe и др.)
    text = re.sub(r'<[^>]+>', '', text)
    
    # Убираем потенциально опасные символы
    dangerous_chars = ['<', '>', '&', ';', '[', ']', '(', ')', '=']
    for char in dangerous_chars:
        text = text.replace(char, '')
    
    # Убираем опасные SQL последовательности
    sql_dangerous = ['--', '/*', '*/', 'xp_', 'sp_', 'exec', 'execute']
    for pattern in sql_dangerous:
        text = text.replace(pattern, '')
    
    # Убираем множественные пробелы, но сохраняем переносы строк
    text = re.sub(r'[ \t]+', ' ', text)
    
    # Обрезаем до максимальной длины
    if len(text) > max_length:
        text = text[:max_length].rstrip()
    
    return text.strip()


def sanitize_data(data: dict, max_length: int = 512) -> dict:
    """
    Очищает все строковые значения в словаре от опасных символов.
    
    Args:
        data: Словарь с данными для очистки
        max_length: Максимальная длина для строковых полей
    
    Returns:
        Словарь с очищенными данными
    """
    if not isinstance(data, dict):
        return data
    
    cleaned_data = {}
    for key, value in data.items():
        if isinstance(value, str):
            cleaned_data[key] = sanitize_input(value, max_length)
        elif isinstance(value, dict):
            cleaned_data[key] = sanitize_data(value, max_length)
        elif isinstance(value, list):
            cleaned_data[key] = [sanitize_data(item, max_length) if isinstance(item, dict) else 
                                (sanitize_input(item, max_length) if isinstance(item, str) else item) 
                                for item in value]
        else:
            cleaned_data[key] = value
    
    return cleaned_data

class PGApi:
    def __init__(self):
        self.pool: Union[Pool, None] = None

    async def create(self):
        config = load_config("../.env")
        self.pool = await asyncpg.create_pool(
            host=config.db.host,
            database=config.db.database,
            user=config.db.user,
            password=config.db.password
        )

    async def create_with_env_path(self, env_path: str):
        """Создает подключение к БД с указанным путем к .env файлу. ИСПОЛЬЗУЕТСЯ ТОЛЬКО ДЛЯ ТЕСТОВ"""
        config = load_config(env_path)
        self.pool = await asyncpg.create_pool(
            host='localhost',
            database=config.db.database,
            user=config.db.user,
            password=config.db.password,
            port=config.db.port
        )

    async def close(self):
        """Закрывает пул подключений к БД"""
        if self.pool:
            await self.pool.close()
            self.pool = None

    async def execute(self, command, *args,
                      fetch: bool = False,
                      fetchval: bool = False,
                      fetchrow: bool = False,
                      execute: bool = False
                      ):
        """
        :param command: скуль запрос
        :param args: аргументы
        :param fetch: выгружаем все строки
        :param fetchval: выгружаем значение
        :param fetchrow: выгружаем одну строку
        :param execute: если не нужен возврат от функции, просто выполнение
        """
        async with self.pool.acquire() as connection:
            connection: Connection
            async with connection.transaction():
                if fetch:
                    result = await connection.fetch(command, *args)
                    result = [dict(r.items()) for r in result]
                    return result
                elif fetchval:
                    return await connection.fetchval(command, *args)
                elif fetchrow:
                    result = await connection.fetchrow(command, *args)
                    return dict(result) if result else None
                elif execute:
                    return await connection.execute(command, *args)

    @staticmethod
    def format_args(sql, parameters: dict, glue: str = " AND "):
        # TODO Кажется обработку parameters можно упразднить
        sql += glue.join([
            f"{item} = ${num}" for num, item in enumerate(parameters.keys(), start=1)
        ])
        return sql, list(parameters.values())

    async def get_record(self, table, params):
        sql = f"SELECT * FROM {table} WHERE "
        sql, params = self.format_args(sql, params)
        result = await self.execute(sql, *params, fetchrow=True)
        if result is None:
            return None
        return result

    async def get_field(self, table, field, params):
        sql = f"SELECT {field} FROM {table} WHERE "
        sql, params = self.format_args(sql, params)
        return await self.execute(sql, *params, fetchval=True)

    async def get_records(self, table, params=None):
        if params is None:
            params = {}
        sql = f"SELECT * FROM {table}"
        if params:
            sql += " WHERE "
            sql, params = self.format_args(sql, params)
        return await self.execute(sql, *params, fetch=True)

    async def insert_record(self, table_name: str, params: dict):
        # Автоматически очищаем все строковые данные перед вставкой
        cleaned_params = sanitize_data(params)
        
        keys = ', '.join(
            f"{item}" for item in cleaned_params.keys()
        )
        params_mask = ''
        sqlparams = []
        for num, val in enumerate(cleaned_params.values(), start=1):
            params_mask += f"${num}"
            if num != len(cleaned_params.values()):
                params_mask += ','
            sqlparams.append(val)
        sql = f"INSERT INTO {table_name} ({keys}) VALUES ({params_mask}) RETURNING id;"
        try:
            result = await self.execute(sql, *sqlparams, fetchval=True)
            return result
        except asyncpg.exceptions.UniqueViolationError:
            # Пытаемся найти существующую запись по уникальным полям
            existing_id = await self.get_field(table_name, 'id', cleaned_params)
            if existing_id is None:
                # Если не нашли, возвращаем None (запись уже существует, но мы не можем получить ID)
                logger.warning(f"Unique violation for {table_name}, but existing record not found")
                return None
            return existing_id

    async def update_record(self, table_name: str, recordid: int, params: dict):
        # Автоматически очищаем все строковые данные перед обновлением
        cleaned_params = sanitize_data(params)
        
        now = datetime.now()
        local_now = now.astimezone()
        local_tz = local_now.tzinfo
        cleaned_params['time_modified'] = datetime.now(local_tz)
        sql = f"UPDATE {table_name} SET "
        sql, sqlparams = self.format_args(sql, cleaned_params, ", ")
        sql += f" WHERE id = ${len(sqlparams) + 1};"
        sqlparams.append(recordid)
        await self.execute(sql, *sqlparams, execute=True)

    async def get_records_sql(self, sql: str, *args):
        return await self.execute(sql, *args, fetch=True)

    async def delete_records(self, table_name: str, params: dict = None):
        if params is None:
            await self.execute(f"DELETE FROM {table_name} WHERE TRUE", execute=True)
        else:
            sql = f"DELETE FROM {table_name} WHERE "
            sql, sqlparams = self.format_args(sql, params)
            await self.execute(sql, *sqlparams, execute=True)

    async def delete_record(self, table_name: str, record_id: int):
        """Удаляет одну запись по ID"""
        await self.execute(f"DELETE FROM {table_name} WHERE id = $1", record_id, execute=True)

    async def count_records(self, table: str, params=None):
        if params is None:
            params = {}
        sql = f"SELECT COUNT(id) AS count FROM {table}"
        if params:
            sql += " WHERE "
            sql, params = self.format_args(sql, params)
        return await self.execute(sql, *params, fetchval=True)

    async def record_exists(self, table: str, params):
        sql = f"SELECT EXISTS(SELECT 1 FROM {table} WHERE "
        sql, params = self.format_args(sql, params)
        sql += ')'
        return await self.execute(sql, *params, fetchval=True)

    async def backup_tables(self):
        await self.pool.copy_from_table('words', output='tgbot/db/words.csv', header=True, delimiter=';', format='csv')
        await self.pool.copy_from_table('users', output='tgbot/db/users.csv', header=True, delimiter=';', format='csv')

    async def restore_tables(self):
        await self.pool.copy_to_table('words', source='tgbot/db/words.csv', header=True, delimiter=';', format='csv')
        await self.pool.copy_to_table('users', source='tgbot/db/users.csv', header=True, delimiter=';', format='csv')


    async def create_all_tables(self):
        # Сопоставление типов Python с типами PostgreSQL
        type_mapping = {
            int: "BIGINT",
            str: "VARCHAR(255)",
            Optional[str]: "VARCHAR(255)",
            bool: "BOOLEAN",
            # Добавьте другие типы по необходимости
        }

        # Функция для генерации SQL-запроса на основе модели
        def generate_create_table_sql(model: Type[BaseModel]) -> str:
            fields = model.__annotations__
            table_name = model.__name__.lower() + "s"  # Преобразуем имя модели в множественное число

            columns = []
            for field_name, field_type in fields.items():
                sql_type = type_mapping.get(field_type)
                if sql_type is None:
                    raise ValueError(f"Тип {field_type} не поддерживается для поля {field_name}")

                # Добавляем дополнительные параметры для определенных полей
                constraints = ""
                if field_name == "id":
                    constraints += " PRIMARY KEY"
                elif "telegram_id" in field_name or "username" in field_name:
                    constraints += " UNIQUE NOT NULL"

                columns.append(f"{field_name} {sql_type}{constraints}")

            # Добавляем стандартные временные метки
            columns.extend([
                "time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP",
                "time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP"
            ])

            # Формируем финальный SQL-запрос
            columns_sql = ",\n".join(columns)
            return f"""CREATE TABLE IF NOT EXISTS {table_name} (
                        {columns_sql}
                    );"""

        # Проходимся по всем моделям в модуле models
        for name, obj in vars(models).items():
            if isinstance(obj, type) and issubclass(obj, BaseModel) and obj != BaseModel:
                # Генерируем SQL для каждой модели
                sql = generate_create_table_sql(obj)
                print(f"Executing SQL for {obj.__name__}:")
                print(sql)
                # Выполняем запрос
                await self.execute(sql, execute=True)


    async def create_db_dump(self, dump_dir: str = "./db_dumps"):
        """
        Создает дамп базы данных, сжимает его в архив и возвращает путь к архиву.
        :param dump_dir: Директория для сохранения дампа.
        :return: Путь к созданному архиву с дампом.
        """
        # Убедитесь, что директория для дампов существует
        os.makedirs(dump_dir, exist_ok=True)

        # Формируем имя файла дампа с текущей датой
        timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
        dump_file = os.path.join(dump_dir, f"db_dump_{timestamp}.sql")
        archive_file = os.path.join(dump_dir, f"db_dump_{timestamp}.sql.gz")

        # Загружаем конфигурацию
        config = load_config("../.env")

        # Устанавливаем переменную окружения PGPASSWORD
        os.environ["PGPASSWORD"] = config.db.password

        # Команда для создания дампа
        command = [
            "pg_dump",
            f"--host={config.db.host}",
            f"--username={config.db.user}",
            f"--dbname={config.db.database}",
            f"--file={dump_file}"
        ]

        try:
            # Выполняем команду через subprocess
            subprocess.run(command, check=True)
            logger.info(f"Дамп базы данных успешно создан: {dump_file}")
            
            # Сжимаем дамп в архив
            with open(dump_file, 'rb') as f_in:
                with gzip.open(archive_file, 'wb') as f_out:
                    shutil.copyfileobj(f_in, f_out)
            
            # Удаляем несжатый файл
            os.remove(dump_file)
            
            # Получаем размер архива
            archive_size = os.path.getsize(archive_file)
            archive_size_mb = archive_size / (1024 * 1024)
            
            logger.info(f"Дамп сжат в архив: {archive_file} (размер: {archive_size_mb:.2f} MB)")
            
            return archive_file
            
        except subprocess.CalledProcessError as e:
            logger.error(f"Ошибка при создании дампа базы данных: {e}")
            raise
        except Exception as e:
            logger.error(f"Ошибка при сжатии дампа: {e}")
            # Удаляем несжатый файл в случае ошибки
            if os.path.exists(dump_file):
                os.remove(dump_file)
            raise

    async def cleanup_old_dumps(self, dump_dir: str = "./db_dumps", keep_days: int = 7):
        """
        Удаляет старые дампы базы данных, оставляя только последние N дней.
        :param dump_dir: Директория с дампами.
        :param keep_days: Количество дней для хранения дампов.
        """
        try:
            if not os.path.exists(dump_dir):
                return
            
            current_time = datetime.now()
            # Используем timedelta для корректного вычитания дней
            cutoff_time = current_time - timedelta(days=keep_days)
            cutoff_time = cutoff_time.replace(hour=0, minute=0, second=0, microsecond=0)
            
            deleted_count = 0
            for filename in os.listdir(dump_dir):
                if filename.endswith('.sql.gz'):
                    file_path = os.path.join(dump_dir, filename)
                    file_time = datetime.fromtimestamp(os.path.getctime(file_path))
                    
                    if file_time < cutoff_time:
                        os.remove(file_path)
                        deleted_count += 1
                        logger.info(f"Удален старый дамп: {filename}")
            
            if deleted_count > 0:
                logger.info(f"Очистка завершена. Удалено {deleted_count} старых дампов.")
                
        except Exception as e:
            logger.error(f"Ошибка при очистке старых дампов: {e}")