.PHONY: build version

include src/version.py

IMAGE	:= flask_uwsgi_docker

all: build

build:
	@docker build -t $(IMAGE):$(VERSION) .

dev:
	@docker run -p 5000:5000 -it $(IMAGE):$(VERSION)
