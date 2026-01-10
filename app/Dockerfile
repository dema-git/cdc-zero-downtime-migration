FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && \
    apt-get install -y netcat-openbsd && \
    pip install --no-cache-dir sqlalchemy psycopg2-binary && \
    rm -rf /var/lib/apt/lists/*

COPY app/requirements.txt .
COPY scripts/wait-for-it.sh ./wait-for-it.sh

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN chmod +x ./wait-for-it.sh

CMD ["./wait-for-it.sh", "db_legacy:5432", "legacy", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
