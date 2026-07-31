FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1 \
    PORT=8080

WORKDIR /app

COPY requirements.txt .

RUN pip install \
    --no-cache-dir \
    --requirement requirements.txt

COPY main.py logging_config.py ./

RUN useradd \
    --create-home \
    --uid 10001 \
    appuser

USER appuser

CMD exec gunicorn \
    --bind ":${PORT}" \
    --workers 1 \
    --threads 8 \
    --timeout 0 \
    main:app