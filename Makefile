.PHONY: help build test dev local-test local-dev get-version lint-chart lint-dockerfile

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

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":"}; {printf "\033[36m%-15s\033[0m %s\n", $$2, $$3}' | sed 's/## //g'

get-version:
	@echo $(VERSION)

setup-local-environment:
	@ln -sfn $(SRC) $(PACKAGE)
	@if [ ! -d "${CURDIR}/.venv" ]; then \
		$(PYTHON) -m venv $(PYENV); \
	fi
	@( . ${CURDIR}/.venv/bin/activate; \
	   pip install -r requirements.txt; \
	   pip install -e . )

test: ## Run tests
test: setup-local-environment
	$(PIP) install pytest
	$(PYTEST)

local-dev: ## Run local development server
local-dev: setup-local-environment
	$(PYBIN)/uvicorn pythonmstpl.app:app --port 5000 --reload

build: ## Build docker image
	@docker build -t $(IMAGE):$(VERSION) .

dev: ## Run locally built docker image
	@docker run -p 5000:5000 -it $(IMAGE):$(VERSION)

lint: ## Lint python source, Dockerfile, and Helm charts
lint: lint-dockerfile lint-chart lint-python

lint-python: setup-local-environment
	$(PIP) install pylint
	$(PYLINT) src --rcfile conf/pylint.conf

lint-dockerfile:
	@hadolint Dockerfile

lint-chart:
	@ct lint\
		--charts helm\
		--lint-conf conf/lintconf.yaml\
		--chart-yaml-schema conf/chart_schema.yaml
