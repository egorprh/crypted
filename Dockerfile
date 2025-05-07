# Базовый Python образ
FROM python:3.11-slim

# Устанавливаем PostgreSQL-клиент
RUN apt-get update && apt-get install -y postgresql-client && apt-get clean

WORKDIR /app
COPY /logs/app.log /app/logs/app.log
COPY backend/ /app/
COPY requirements.txt /app/

RUN pip install --no-cache-dir -r requirements.txt

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
