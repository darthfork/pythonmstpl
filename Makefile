.PHONY: build version

include src/version.py

IMAGE		:= pythonmstpl
PYTHON		:= /usr/bin/env python3
SRC		:= src
PACKAGE		:= pythonmstpl

all: build

build:
	@docker build -t $(IMAGE):$(VERSION) .

dev:
	@docker run -p 5000:5000 -it $(IMAGE):$(VERSION)

lint-dockerfile:
	@hadolint Dockerfile

lint-chart:
	@ct lint --lint-conf conf/lintconf.yaml --chart-yaml-schema conf/chart_schema.yaml

symlink:
	@ln -sfn $(SRC) $(PACKAGE)

local-dev: symlink
	$(PYTHON) -m venv .venv && \
	source .venv/bin/activate && \
	pip install -e . &&\
	uvicorn pythonmstpl.app:app --port 5000 --reload
