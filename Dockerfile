FROM alpine:3.15

WORKDIR /app

RUN apk add --no-cache python3-dev=3.9.7-r4 py3-pip=20.3.4-r1 shadow=4.8.1-r1\
                       pcre-dev=8.45-r1 build-base=0.5-r2 linux-headers=5.10.41-r0\
                       curl=7.80.0-r0

ARG USERNAME=darthfork

RUN groupadd -r ${USERNAME} && useradd --no-log-init -r -g ${USERNAME} -u 1000 ${USERNAME}

COPY setup.py /app
COPY conf/gunicorn.py /app
COPY src/ /app/pythonmstpl

RUN pip3 install --no-cache-dir --upgrade pip==21.3.1 &&\
    pip3 install --no-cache-dir -e .

USER 1000

EXPOSE 5000

CMD ["gunicorn", "pythonmstpl.app:app", "--conf", "/app/gunicorn.py"]

HEALTHCHECK --interval=30s CMD curl --fail http://localhost:5000/v1/healthcheck || exit 1
