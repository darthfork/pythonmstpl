FROM alpine:3.12

WORKDIR /app

ARG USERNAME=darthfork

RUN apk add --no-cache python3-dev=3.8.10-r0 py3-pip=20.1.1-r0 shadow=4.8.1-r0\
                       pcre-dev=8.44-r0 build-base=0.5-r2 linux-headers=5.4.5-r1\
                       curl=7.77.0-r0

COPY requirements.txt /app
COPY setup.py /app
COPY conf/uwsgi.ini /app
COPY src/ /app/pythonmstpl

RUN pip3 install --no-cache-dir --upgrade pip==21.1.1 && pip3 install --no-cache-dir -r requirements.txt

RUN pip3 install --no-cache-dir -e .

RUN groupadd -r ${USERNAME} && useradd --no-log-init -r -g ${USERNAME} -u 1000 ${USERNAME}

USER 1000

EXPOSE 5000

CMD ["uwsgi", "--need-app", "--ini", "/app/uwsgi.ini"]

HEALTHCHECK --interval=30s CMD curl --fail http://localhost:5000/healthcheck || exit 1
