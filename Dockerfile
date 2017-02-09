FROM registry.timmertech.nl/docker/alpine-glibc:latest
MAINTAINER G.J.R. Timmer <gjr.timmer@gmail.com>

ARG BUILD_DATE
ARG VCS_REF

ARG DOCKER_ENGINE_VERSION=1.11.2-r1
ARG DOCKER_MACHINE_VERSION=0.9.0

LABEL \
	nl.timmertech.build-date=${BUILD_DATE} \
	nl.timmertech.name=gitlab-runner \
	nl.timmertech.vendor=timmertech.nl \
	nl.timmertech.vcs-url="https://github.com/GJRTimmer/docker-gitlab-runner.git" \
	nl.timmertech.vcs-ref=${VCS_REF} \
	nl.timmertech.license=MIT

RUN echo 'http://pkgs.timmertech.nl/main' >> /etc/apk/repositories && \
	echo 'http://nl.alpinelinux.org/alpine/v3.4/community'  >> /etc/apk/repositories && \
	echo 'http://nl.alpinelinux.org/alpine/v3.5/community'  >> /etc/apk/repositories && \
	wget -O /etc/apk/keys/gjr.timmer@gmail.com-5857d36d.rsa.pub http://pkgs.timmertech.nl/keys/gjr.timmer%40gmail.com-5857d36d.rsa.pub && \
	apk upgrade --update --no-cache && \
	apk add --no-cache --update \
		ca-certificates \
		wget \
		git \
		curl \
		openssh \
		bash \
		gcc \
		musl-dev \
		openssl \
		docker=${DOCKER_ENGINE_VERSION} && \
		py2-pip && \
	wget -q https://github.com/docker/machine/releases/download/v${DOCKER_MACHINE_VERSION}/docker-machine-Linux-x86_64 -O /usr/bin/docker-machine && \
	chmod +x /usr/bin/docker-machine && \
	pip install --upgrade pip && \
	pip install docker-compose && \
	sync
	
# EOF