FROM alpine:3.12

WORKDIR /app

ARG USERNAME=darthfork

RUN apk update &&\
    apk add python3-dev py3-pip shadow pcre-dev build-base linux-headers

ADD requirements.txt /app
ADD setup.py /app
ADD conf/uwsgi.ini /app
ADD src/ /app/flask_uwsgi_docker

RUN pip3 install --upgrade pip && pip3 install -r requirements.txt

RUN pip3 install -e .

RUN groupadd -r ${USERNAME} && useradd --no-log-init -r -g ${USERNAME} -u 1000 ${USERNAME}

USER 1000

EXPOSE 5000

CMD ["uwsgi", "--need-app", "--ini", "/app/uwsgi.ini"]
