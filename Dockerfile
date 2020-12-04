FROM ubuntu:20.04

WORKDIR /app
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update &&\
    apt-get install -y python3 python3-pip libpcre3 libpcre3-dev

ADD requirements.txt /app
ADD setup.py /app
ADD conf/uwsgi.ini /app
ADD src/ /app/flask_uwsgi_docker

RUN pip3 install --upgrade pip && pip3 install -r requirements.txt

RUN pip3 install -e .

RUN groupadd -r abhishek && useradd --no-log-init -r -g abhishek -u 1000 abhishek

USER 1000

EXPOSE 5000

CMD ["uwsgi", "--need-app", "--ini", "/app/uwsgi.ini"]
