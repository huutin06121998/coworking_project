FROM python:3.10-slim-buster

ENV APP_PORT=5153
ENV DB_USERNAME=postgres
ENV DB_PASSWORD=udacity
ENV DB_HOST=127.0.0.1
ENV DB_PORT=5432
ENV DB_NAME=coworking

USER root

WORKDIR /app

COPY analytics  /app/analytics

COPY db  /app/db

COPY ./requirements.txt requirements.txt
 

RUN pip install python-dotenv

# Dependencies are installed during build time in the container  
RUN pip install --upgrade pip && pip install -r /app/analytics/requirements.txt

EXPOSE 5153

CMD ["python", "/app/analytics/app.py"]
