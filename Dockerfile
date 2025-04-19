# Билдим бэк (FastAPI + Uvicorn)
FROM python:latest

WORKDIR /app/

COPY requirements.txt /app/
RUN pip install -r requirements.txt

COPY backend/ /app/
COPY frontend/dist /frontend/dist
EXPOSE 8000

#Автосервер FastAPI + отдача фронта
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
