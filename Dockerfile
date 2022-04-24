FROM alpine:3.15 as base

WORKDIR /app

COPY apk.list /app

RUN apk add --no-cache $(cat apk.list)

ARG USERNAME=darthfork

RUN groupadd -r ${USERNAME} && useradd --no-log-init -r -g ${USERNAME} -u 1000 ${USERNAME}

COPY requirements.txt /app
COPY src/ /app/pythonmstpl
COPY setup.py /app

RUN pip3 install --no-cache-dir --upgrade pip==22.0.4 &&\
    pip3 install --no-cache-dir -r requirements.txt &&\
    pip3 install --no-cache-dir -e .

USER 1000

FROM base as build

COPY conf/gunicorn.py /app

EXPOSE 5000

CMD ["gunicorn", "pythonmstpl.app:app", "--conf", "/app/gunicorn.py"]

HEALTHCHECK --interval=30s CMD curl --fail http://localhost:5000/v1/healthcheck || exit 1

# Test stage
FROM base as test

COPY test/ /app/test/
RUN pytest -p no:cacheprovider
