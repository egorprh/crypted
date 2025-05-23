import asyncio
from datetime import datetime
import os
from typing import Any, Dict, Optional, Type, Union
from pydantic import BaseModel
import asyncpg
from asyncpg import Pool, Connection
import db.models as models
from logger import logger  # Импортируем логгер
import subprocess

from config import load_config

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
        keys = ', '.join(
            f"{item}" for item in params.keys()
        )
        params_mask = ''
        sqlparams = []
        for num, val in enumerate(params.values(), start=1):
            params_mask += f"${num}"
            if num != len(params.values()):
                params_mask += ','
            sqlparams.append(val)
        sql = f"INSERT INTO {table_name} ({keys}) VALUES ({params_mask}) RETURNING id;"
        try:
            return await self.execute(sql, *sqlparams, fetchval=True)
        except asyncpg.exceptions.UniqueViolationError:
            return await self.get_field(table_name, 'id', params)

    async def update_record(self, table_name: str, recordid: int, params: dict):
        now = datetime.now()
        local_now = now.astimezone()
        local_tz = local_now.tzinfo
        params['time_modified'] = datetime.now(local_tz)
        sql = f"UPDATE {table_name} SET "
        sql, sqlparams = self.format_args(sql, params, ", ")
        sql += f" WHERE id = ${len(sqlparams) + 1};"
        sqlparams.append(recordid)
        await self.execute(sql, *sqlparams, execute=True)

    async def get_records_sql(self, sql: str, *args):
        return await self.execute(sql, *args, fetch=True)

    async def delete_records(self, table_name: str):
        await self.execute(f"DELETE FROM {table_name} WHERE TRUE", execute=True)

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


    async def create_db_dump(self, dump_dir: str = "./db_dumps") -> bool:
        """Создаёт дамп БД с безопасной обработкой пароля и ошибок."""
        try:
            os.makedirs(dump_dir, exist_ok=True)
            timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
            dump_file = os.path.join(dump_dir, f"db_dump_{timestamp}.sql")
            
            config = load_config(os.path.abspath("../.env"))
            if not all([config.db.host, config.db.user, config.db.password, config.db.database]):
                raise ValueError("Неполная конфигурация БД")

            # Используем stdin для передачи пароля (если pg_dump поддерживает)
            command = [
                "pg_dump",
                f"--host={config.db.host}",
                f"--username={config.db.user}",
                f"--dbname={config.db.database}",
                f"--file={dump_file}"
            ]

            env = os.environ.copy()
            env["PGPASSWORD"] = config.db.password
            
            process = await asyncio.create_subprocess_exec(
                *command,
                env=env,
                stderr=asyncio.subprocess.PIPE
            )
            await process.wait()
            
            if process.returncode != 0:
                stderr = await process.stderr.read()
                logger.error(f"Ошибка pg_dump: {stderr.decode()}")
                return False
                
            logger.info(f"Дамп создан: {dump_file}")
            return True

        except Exception as e:
            logger.error(f"Ошибка: {e}", exc_info=True)
            return False