FROM alpine:3.15

WORKDIR /app

COPY apk.list /app

RUN apk add --no-cache $(cat apk.list)

ARG USERNAME=darthfork

RUN groupadd -r ${USERNAME} && useradd --no-log-init -r -g ${USERNAME} -u 1000 ${USERNAME}

COPY requirements.txt /app
COPY setup.py /app
COPY conf/gunicorn.py /app
COPY src/ /app/pythonmstpl

RUN pip3 install --no-cache-dir --upgrade pip==22.0.4 &&\
    pip3 install --no-cache-dir -r requirements.txt &&\
    pip3 install --no-cache-dir -e .

USER 1000

EXPOSE 5000

CMD ["gunicorn", "pythonmstpl.app:app", "--conf", "/app/gunicorn.py"]

HEALTHCHECK --interval=30s CMD curl --fail http://localhost:5000/v1/healthcheck || exit 1
