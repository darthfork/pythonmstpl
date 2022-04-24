.PHONY: build test dev local-test local-dev get-version lint-chart lint-dockerfile

include src/version.py

IMAGE		:= pythonmstpl
IMAGE_TEST 	:= test_pythonmstpl
PYTHON		:= /usr/bin/env python3
SRC		:= src
PACKAGE		:= pythonmstpl

all: build

get-version:
	@echo $(VERSION)

setup-venv:

symlink:
	@ln -sfn $(SRC) $(PACKAGE)

local-test: setup-venv
	$(PYTHON) -m venv .venv &&\
	source .venv/bin/activate && \
	pip install -e . &&\
	pytest

local-dev: setup-venv symlink
	$(PYTHON) -m venv .venv &&\
	source .venv/bin/activate && \
	pip install -e . &&\
	uvicorn pythonmstpl.app:app --port 5000 --reload

test:
	@docker build -t $(IMAGE_TEST):$(VERSION) --target test .

build:
	@docker build -t $(IMAGE):$(VERSION) --target build .

dev:
	@docker run -p 5000:5000 -it $(IMAGE):$(VERSION)

lint-dockerfile:
	@hadolint Dockerfile

lint-chart:
	@ct lint --lint-conf conf/lintconf.yaml --chart-yaml-schema conf/chart_schema.yaml
