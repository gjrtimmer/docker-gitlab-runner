FROM registry.timmertech.nl/docker/alpine-glibc:latest
MAINTAINER G.J.R. Timmer <gjr.timmer@gmail.com>

ARG BUILD_DATE
ARG VCS_REF

ARG DOCKER_ENGINE_VERSION=1.11.2-r1
ARG DOCKER_MACHINE_VERSION=0.9.0

ENV GITLAB_RUNNER_USER=gitlab-runner \
	GITLAB_RUNNER_HOME=/home/gitlab-runner
ENV GITLAB_RUNNER_DATA=${GITLAB_RUNNER_HOME}/data

LABEL \
	nl.timmertech.build-date=${BUILD_DATE} \
	nl.timmertech.name=gitlab-runner \
	nl.timmertech.vendor=timmertech.nl \
	nl.timmertech.vcs-url="https://github.com/GJRTimmer/docker-gitlab-runner.git" \
	nl.timmertech.vcs-ref=${VCS_REF} \
	nl.timmertech.license=MIT

RUN echo 'http://pkgs.timmertech.nl/main' >> /etc/apk/repositories && \
	echo 'http://nl.alpinelinux.org/alpine/v3.4/community'  >> /etc/apk/repositories && \
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
		sudo \
		shadow \
		docker=${DOCKER_ENGINE_VERSION} \
		py2-pip && \
	
	wget -q https://github.com/docker/machine/releases/download/v${DOCKER_MACHINE_VERSION}/docker-machine-Linux-x86_64 -O /usr/bin/docker-machine && \
	chmod +x /usr/bin/docker-machine && \
	
	pip install --upgrade pip && \
	pip install docker-compose
	
RUN wget -O /usr/bin/gitlab-ci-multi-runner https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-ci-multi-runner-linux-amd64 && \
	ln -s /usr/bin/gitlab-ci-multi-runner /usr/bin/gitlab-runner && \

	# Add user
	useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash && \
	
	# Link .ssh for permanent storage
	sudo -HEu ${GITLAB_RUNNER_USER} ln -sf ${GITLAB_RUNNER_DATA}/.ssh ${GITLAB_RUNNER_HOME}/.ssh && \
	
	# Link .docker for permanent storage for Docker Logins Private repositories
	sudo -HEu ${GITLAB_RUNNER_USER} ln -sf ${GITLAB_RUNNER_DATA}/.docker ${GITLAB_RUNNER_HOME}/.docker
	
VOLUME [ "${GITLAB_RUNNER_DATA}" ]
WORKDIR ${GITLAB_RUNNER_HOME}

# EOF