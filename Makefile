.PHONY: build version

include src/version.py

IMAGE	:= pythonmstpl

all: build

build:
	@docker build -t $(IMAGE):$(VERSION) .

dev:
	@docker run -p 5000:5000 -it $(IMAGE):$(VERSION)

lint-dockerfile:
	@hadolint Dockerfile

lint-chart:
	@ct lint --lint-conf conf/lintconf.yaml --chart-yaml-schema conf/chart_schema.yaml
