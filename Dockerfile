FROM ${PROXY}linuxserver/docker-compose:amd64-latest as compose-amd64

FROM registry.timmertech.nl/docker/alpine-glibc:latest

RUN echo 'http://nl.alpinelinux.org/alpine/edge/main'  >> /etc/apk/repositories && \
    echo 'http://nl.alpinelinux.org/alpine/edge/community'  >> /etc/apk/repositories && \
    apk add --no-cache --update \
    build-base \
    bash \
    findutils \
    ca-certificates \
    wget \
    curl \
    git \
    git-lfs \
    openssh \
    openssl \
    docker-cli \
    docker-compose \
    shadow && \
    wget -O /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64 && \
    chmod +x /usr/local/bin/gitlab-runner && \
    sed "s|ash|bash|" -i /etc/passwd

COPY --from=compose-amd64 /usr/local/bin/docker-compose /docker-compose/docker-compose_x86_64
COPY --from=compose-amd64 /usr/local/bin/docker /docker-compose/docker_x86_64
COPY root/ /

ARG BUILD_DATE
ARG CI_PROJECT_NAME
ARG CI_PROJECT_URL
ARG VCS_REF
ARG DOCKER_IMAGE
ARG START_TIMEOUT=300000

ENV S6_KILL_FINISH_MAXTIME=${START_TIMEOUT} \
    HOME=/config

# Volume mapping
VOLUME [ "/config" ]

LABEL \
    maintainer="G.J.R. Timmer <gjr.timmer@gmail.com>" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.build-date="${BUILD_DATE}" \
    org.label-schema.name=${CI_PROJECT_NAME} \
    org.label-schema.url="${CI_PROJECT_URL}" \
    org.label-schema.vcs-url="${CI_PROJECT_URL}.git" \
    org.label-schema.vcs-ref=${VCS_REF} \
    org.label-schema.docker.image="${DOCKER_IMAGE}" \
    org.label-schema.license=MIT

# EOF
