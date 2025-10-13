# Базовый Python образ
FROM python:3.11-slim

# Устанавливаем PostgreSQL-клиент, сервер (для pg_dump) и зависимости для psycopg2
RUN apt-get update && apt-get install -y \
    postgresql-client \
    postgresql \
    libpq-dev \
    gcc \
    && apt-get clean

WORKDIR /app

# Копируем файлы проекта
COPY backend/requirements.txt /app/requirements.txt
COPY backend/ /app/backend/
COPY telegram_bot/ /app/telegram_bot/
COPY frontend/dist/ /app/frontend/dist/

# Устанавливаем зависимости
RUN pip install --no-cache-dir -r requirements.txt

# Добавляем telegram_bot в PYTHONPATH
ENV PYTHONPATH="/app/telegram_bot:/app/backend:${PYTHONPATH}"

# Делаем run.py исполняемым
RUN chmod +x /app/backend/run.py

# Запускаем приложение через run.py
CMD ["python3", "/app/backend/run.py"]