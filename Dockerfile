FROM registry.timmertech.nl/docker/alpine-glibc:latest

ARG BUILD_DATE
ARG VCS_REF
ARG DOCKER_ENGINE=18.09.1-r0
ARG DOCKER_MACHINE=0.16.1
ARG START_TIMEOUT=300000

LABEL \
    maintainer="G.J.R. Timmer <gjr.timmer@gmail.com>" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name=gitlab-runner \
    org.label-schema.vendor=timmertech.nl \
    org.label-schema.url="https://gitlab.timmertech.nl/docker/gitlab-runner" \
    org.label-schema.vcs-url="https://gitlab.timmertech.nl/docker/gitlab-runner.git" \
    org.label-schema.vcs-ref=${VCS_REF} \
    nl.timmertech.license=MIT

ENV DOCKER_ENGINE_VERSION=${DOCKER_ENGINE} \
    DOCKER_MACHINE_VERSION=${DOCKER_MACHINE} \
    GITLAB_RUNNER_DATA=/data \
    S6_KILL_FINISH_MAXTIME=${START_TIMEOUT}

RUN echo '@community http://nl.alpinelinux.org/alpine/edge/community'  >> /etc/apk/repositories && \
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
    docker@community=${DOCKER_ENGINE_VERSION} \
    py2-pip && \
    wget -q https://github.com/docker/machine/releases/download/v${DOCKER_MACHINE_VERSION}/docker-machine-Linux-x86_64 -O /usr/bin/docker-machine && \
    chmod +x /usr/bin/docker-machine && \
    chmod g+x /etc && \
    pip install --upgrade pip && \
    pip install docker-compose && \
    wget -O /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64 && \
    chmod +x /usr/local/bin/gitlab-runner && \
    # Set Bash as default shell for root
    sed "s|ash|bash|" -i /etc/passwd && \
    # Link .ssh for permanent storage
    ln -sf ${GITLAB_RUNNER_DATA}/.ssh ~/.ssh && \
    # Link .docker for permanent storage for Docker Logins Private repositories
    ln -sf ${GITLAB_RUNNER_DATA}/.docker ~/.docker

COPY rootfs/ /

VOLUME [ "${GITLAB_RUNNER_DATA}" ]
