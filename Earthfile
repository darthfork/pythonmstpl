VERSION 0.6
FROM alpine:3.15
WORKDIR /app
ARG USERNAME=darthfork

deps:
    COPY apk.list /app
    RUN apk add --no-cache $(cat apk.list)
    RUN pip3 install --no-cache-dir --upgrade pip==22.0.4

build:
    FROM +deps
    COPY setup.py /app
    COPY src/ /app/pythonmstpl
    RUN pip3 install --no-cache-dir -e .

container:
    FROM +build
    ARG --required TAG
    COPY conf/gunicorn.py /app
    RUN groupadd -r ${USERNAME} && useradd --no-log-init -r -g ${USERNAME} -u 1000 ${USERNAME}
    USER 1000
    CMD ["gunicorn", "pythonmstpl.app:app", "--conf", "/app/gunicorn.py"]
    HEALTHCHECK --interval=30s CMD curl --fail http://localhost:5000/v1/healthcheck || exit 1
    SAVE IMAGE pythonmstpl:${TAG}
