# Базовый Python образ
FROM python:3.11-slim

# Устанавливаем PostgreSQL-клиент
RUN apt-get update && apt-get install -y postgresql-client && apt-get clean

WORKDIR /app

# Копируем файлы проекта
COPY requirements.txt /app/
COPY backend/ /app/backend/
COPY frontend/dist/ /app/frontend/dist/
COPY logs/ /app/logs/

# Устанавливаем зависимости
RUN pip install --no-cache-dir -r requirements.txt

# Делаем run.py исполняемым
RUN chmod +x /app/backend/run.py

# Запускаем приложение через run.py
CMD ["python3", "/app/backend/run.py"]