.PHONY: build test dev local-test local-dev get-version lint-chart lint-dockerfile

include src/version.py

IMAGE		:= pythonmstpl
PYTHON		:= /usr/bin/env python3
SRC		:= src
PACKAGE		:= pythonmstpl
PYENV		:= ${CURDIR}/.venv
PYBIN		:= $(PYENV)/bin
PYTEST		:= $(PYBIN)/pytest

all: build

get-version:
	@echo $(VERSION)

setup-venv:
	@if [ ! -d "${CURDIR}/.venv" ]; then \
		$(PYTHON) -m venv $(PYENV); \
	fi
	@(  source ${CURDIR}/.venv/bin/activate; \
	   pip install -r requirements.txt; \
	   pip install -e . )

symlink:
	@ln -sfn $(SRC) $(PACKAGE)

local-test: symlink setup-venv
	$(PYTEST)

local-dev: symlink setup-venv
	$(PYBIN)/uvicorn pythonmstpl.app:app --port 5000 --reload

build:
	@docker build -t $(IMAGE):$(VERSION) .

dev:
	@docker run -p 5000:5000 -it $(IMAGE):$(VERSION)

lint-dockerfile:
	@hadolint Dockerfile

lint-chart:
	@ct lint --lint-conf conf/lintconf.yaml --chart-yaml-schema conf/chart_schema.yaml
