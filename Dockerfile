FROM registry.timmertech.nl/docker/alpine-base:latest

ARG REMOTE_VERSION
ENV REMOTE_VERSION=${REMOTE_VERSION}

ARG TARGETARCH
RUN apk add --no-cache --force-overwrite --update \
    build-base \
    openssl \
    openssh \
    docker-cli \
    docker-cli-buildx \
    docker-cli-compose \
    shadow && \
    wget -O /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/v${REMOTE_VERSION}/binaries/gitlab-runner-linux-${TARGETARCH} && \
    chmod +x /usr/local/bin/gitlab-runner && \
    sed "s|ash|bash|" -i /etc/passwd && \
    update-ca-certificates

COPY rootfs/ /

ARG BUILD_DATE
ARG CI_PROJECT_NAME
ARG CI_PROJECT_URL
ARG VCS_REF
ARG DOCKER_IMAGE
ARG START_TIMEOUT=300000

ENV S6_KILL_FINISH_MAXTIME=${START_TIMEOUT} \
    HOME=/config

# Volume mapping
VOLUME [ "${HOME}" ]

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
