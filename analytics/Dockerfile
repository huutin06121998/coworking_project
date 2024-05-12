FROM public.ecr.aws/docker/library/python:3.11-alpine

ENV FLASK_RUN_HOST=0.0.0.0

WORKDIR /app/analytics

RUN apk update && \
    apk add \
    pcre \
    pcre-dev \
    build-base \
    gcc \
    linux-headers \
    openssl \
    libffi-dev

COPY requirements.txt .

RUN pip3 install -r requirements.txt

COPY . .

CMD python app.py