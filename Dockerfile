FROM registry.timmertech.nl/docker/alpine-glibc:latest
MAINTAINER G.J.R. Timmer <gjr.timmer@gmail.com>

ARG BUILD_DATE
ARG VCS_REF

ARG DOCKER_ENGINE_VERSION=1.11.2-r1
ARG DOCKER_MACHINE_VERSION=0.9.0

ENV GITLAB_RUNNER_DATA=/data
	
LABEL \
	nl.timmertech.build-date=${BUILD_DATE} \
	nl.timmertech.name=gitlab-runner \
	nl.timmertech.vendor=timmertech.nl \
	nl.timmertech.vcs-url="https://github.com/GJRTimmer/docker-gitlab-runner.git" \
	nl.timmertech.vcs-ref=${VCS_REF} \
	nl.timmertech.license=MIT

RUN echo 'http://nl.alpinelinux.org/alpine/v3.4/community'  >> /etc/apk/repositories && \
	apk upgrade --update --no-cache && \
	apk add --no-cache --update \
		bash \
		ca-certificates \
		wget \
		curl \
		git \
		openssh \
		gcc \
		musl-dev \
		openssl \
		docker=${DOCKER_ENGINE_VERSION} \
		py2-pip && \
	
	wget -q https://github.com/docker/machine/releases/download/v${DOCKER_MACHINE_VERSION}/docker-machine-Linux-x86_64 -O /usr/bin/docker-machine && \
	chmod +x /usr/bin/docker-machine && \
	chmod g+x /etc && \
	
	pip install --upgrade pip && \
	pip install docker-compose
	
RUN wget -O /usr/bin/gitlab-ci-multi-runner https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-ci-multi-runner-linux-amd64 && \
	chmod +x /usr/bin/gitlab-ci-multi-runner && \
	ln -s /usr/bin/gitlab-ci-multi-runner /usr/bin/gitlab-runner && \
	
	# Set Bash as default shell for root
	sed "s|ash|bash|" -i /etc/passwd && \
	
	# Link .ssh for permanent storage
	ln -sf ${GITLAB_RUNNER_DATA}/.ssh ~/.ssh && \
	
	# Link .docker for permanent storage for Docker Logins Private repositories
	ln -sf ${GITLAB_RUNNER_DATA}/.docker ~/.docker

COPY rootfs/ /

VOLUME [ "${GITLAB_RUNNER_DATA}" ]

# EOF