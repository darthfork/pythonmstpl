FROM alpine:3.14

WORKDIR /app

ARG USERNAME=darthfork

RUN apk add --no-cache python3-dev=3.9.5-r1 py3-pip=20.3.4-r1 shadow=4.8.1-r0\
                       pcre-dev=8.44-r0 build-base=0.5-r2 linux-headers=5.10.41-r0\
                       curl=7.78.0-r0

RUN groupadd -r ${USERNAME} && useradd --no-log-init -r -g ${USERNAME} -u 1000 ${USERNAME}

COPY requirements.txt /app
COPY setup.py /app
COPY conf/uwsgi.ini /app
COPY src/ /app/pythonmstpl

RUN pip3 install --no-cache-dir --upgrade pip==21.1.3 && pip3 install --no-cache-dir -r requirements.txt

RUN pip3 install --no-cache-dir -e .

USER 1000

EXPOSE 5000

CMD ["uwsgi", "--need-app", "--ini", "/app/uwsgi.ini"]

HEALTHCHECK --interval=30s CMD curl --fail http://localhost:5000/healthcheck || exit 1
