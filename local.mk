.PHONY: dev

PYTHON 	:= /usr/bin/env python3
SRC	:= src
PACKAGE	:= flask_uwsgi_docker

all: dev

symlink:
	@ln -sfn $(SRC) $(PACKAGE)

dev: symlink
	$(PYTHON) -m venv .venv && \
	source .venv/bin/activate && \
	pip install -r requirements.txt && \
	pip install -e . &&\
	uwsgi --need-app --ini conf/uwsgi.ini
