FROM registry.timmertech.nl/docker/alpine-glibc:latest

ARG BUILD_DATE
ARG VCS_REF
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

ENV GITLAB_RUNNER_DATA=/data \
    S6_KILL_FINISH_MAXTIME=${START_TIMEOUT}

RUN echo 'http://nl.alpinelinux.org/alpine/edge/community'  >> /etc/apk/repositories && \
    apk upgrade --update --no-cache && \
    apk add --no-cache --update --virtual libs \
    musl-dev \
    libffi-dev \
    python3-dev \
    openssl-dev && \
    apk add --no-cache --update \
    build-base \
    bash \
    ca-certificates \
    wget \
    curl \
    git \
    git-lfs \
    openssh \
    openssl \
    docker \
    python3 \
    py3-pip && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
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
    ln -sf ${GITLAB_RUNNER_DATA}/.docker ~/.docker && \
    apk del libs

COPY rootfs/ /

VOLUME [ "${GITLAB_RUNNER_DATA}" ]
