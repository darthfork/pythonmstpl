.PHONY: build test dev local-test local-dev get-version lint-chart lint-dockerfile

include src/version.py

IMAGE		:= pythonmstpl
PYTHON		:= /usr/bin/env python3
SRC		:= src
PACKAGE		:= pythonmstpl
PYENV		:= ${CURDIR}/.venv
PYBIN		:= $(PYENV)/bin
PIP		:= $(PYBIN)/pip
PYTEST		:= $(PYBIN)/pytest
PYLINT		:= $(PYBIN)/pylint

all: build

get-version:
	@echo $(VERSION)

setup-venv: symlink
	@if [ ! -d "${CURDIR}/.venv" ]; then \
		$(PYTHON) -m venv $(PYENV); \
	fi
	@( . ${CURDIR}/.venv/bin/activate; \
	   pip install -r requirements.txt; \
	   pip install -e . )

symlink:
	@ln -sfn $(SRC) $(PACKAGE)

test: setup-venv
	$(PIP) install pytest
	$(PYTEST)

local-dev: setup-venv
	$(PYBIN)/uvicorn pythonmstpl.app:app --port 5000 --reload

build:
	@docker build -t $(IMAGE):$(VERSION) .

dev:
	@docker run -p 5000:5000 -it $(IMAGE):$(VERSION)

lint: lint-dockerfile lint-chart lint-python

lint-python: setup-venv
	$(PIP) install pylint
	$(PYLINT) src --rcfile conf/pylint.conf

lint-dockerfile:
	@hadolint Dockerfile

lint-chart:
	@ct lint\
		--charts helm\
		--lint-conf conf/lintconf.yaml\
		--chart-yaml-schema conf/chart_schema.yaml
