# Билдим фронт (React)
FROM node:18 AS frontend

WORKDIR /app
COPY frontend/ .
RUN npm install && npm run build

# Билдим бэк (FastAPI + Uvicorn)
FROM python:3.11

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY backend/ ./backend/
COPY --from=frontend /app/dist /frontend/dist
EXPOSE 8000

# Автосервер FastAPI + отдача фронта
CMD ["uvicorn", "backend.main:app", "--host", "0.0.0.0", "--port", "8000"]
