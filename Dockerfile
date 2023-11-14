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

ARG START_TIMEOUT=300000
ENV S6_KILL_FINISH_MAXTIME=${START_TIMEOUT} \
    HOME=/config

# Volume mapping
VOLUME [ "${HOME}" ]

ARG BUILD_DATE
ARG CI_PROJECT_NAME
ARG CI_PROJECT_URL
ARG VCS_REF
ARG DOCKER_IMAGE

LABEL \
    maintainer="G.J.R. Timmer <gjr.timmer@gmail.com>" \
    build_version="${BUILD_DATE}" \
    org.opencontainers.image.authors="G.J.R. Timmer <gjr.timmer@gmail.com>" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.title="${CI_PROJECT_NAME}" \
    org.opencontainers.image.url="${CI_PROJECT_URL}" \
    org.opencontainers.image.documentation="${CI_PROJECT_URL}" \
    org.opencontainers.image.source="${CI_PROJECT_URL}.git" \
    org.opencontainers.image.ref.name=${VCS_REF} \
    org.opencontainers.image.revision=${VCS_REF} \
    org.opencontainers.image.base.name="registry.timmertech.nl/docker/alpine-base:latest" \
    org.opencontainers.image.licenses=MIT \
    org.opencontainers.image.vendor=timmertech.nl

# EOF
