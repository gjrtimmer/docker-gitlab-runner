all: build

build:
	@docker build --tag=$(shell cat REPOSITORY)/gitlab-runner .

release: build
	@docker build --tag=$(shell cat REPOSITORY)/gitlab-runner:$(shell cat VERSION) .