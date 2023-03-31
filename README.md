[![build status](https://gitlab.timmertech.nl/docker/gitlab-runner/badges/main/pipeline.svg)](https://gitlab.timmertech.nl/docker/gitlab-runner/commits/main)

# gitlab-runner

> ## **Auto Update**
>
> Auto Update
> This image will be automatically updated every week.
>
> The current ubuntu version is written to the container label org.label-schema.ubuntu-version

- [Source Repositories](#source-repositories)
- [Installation](#installation)
  - [Download](#download)
  - [Build](#build)
- [Components](#components)
- [Volumes](#volumes)
- [Configuration](#configuration)
  - [Gitlab Runner Options](#gitlab-runner-options)
  - [GitLab Runner SSH Options](#gitlab-runner-ssh-options)
  - [GitLab Runner Docker Options](#gitlab-runner-docker-options)

## Source Repositories

- [github.com](https://github.com/gjrtimmer/docker-gitlab-runner)

## Installation

### Download

```bash
docker pull gjrtimmer/gitlab-runner:latest
```

### Build

```bash
docker build -t gjrtimmer/gitlab-runner https://github.com/gjrtimmer/docker-gitlab-runner
```


## Components

- gitlab-runner
- docker-cli
- docker-compose

## Volumes

| Variable               | Default                           | Description                                |
| ---------------------- | --------------------------------- | ------------------------------------------ |
| `DATA`                 | /data                             | Data directory, persistent volume location |
| `CA_CERTIFICATES_PATH` | `GITLAB_RUNNER_DATA/certs/ca.crt` | Location for CA certificate file           |

## Configuration

### Gitlab Runner Options

| Variable                  | Default       | Description                                                                              |
| ------------------------- | ------------- | ---------------------------------------------------------------------------------------- |
| `CI_SERVER_URL`           | -             | CI URL; example: gitlab.com/ci                                                           |
| `REGISTRATION_TOKEN`      | -             | Gitlab Runner token                                                                      |
| `RUNNER_EXECUTOR`         | shell         | Runner executor                                                                          |
| `RUNNER_NAME`             | gitlab-runner | Runner name                                                                              |
| `RUNNER_TAG_LIST`         | -             | Runner Tag list                                                                          |
| `RUNNER_PRE_CLONE_SCRIPT` | -             | Runner-specific command script executed before code is pulled                            |
| `RUNNER_PRE_BUILD_SCRIPT` | -             | Runner-specific command script executed after code is pulled, just before build executes |
| `RUNNER_DOCKER_IMAGE`     | docker:latest | Default docker image ton use if executor is docker                                       |

### GitLab Runner SSH Options

| Variable            | Default | Description              |
| ------------------- | ------- | ------------------------ |
| `SSH_USER`          | -       | User name                |
| `SSH_PASSWORD`      | -       | User password            |
| `SSH_HOST`          | -       | Remote host              |
| `SSH_PORT`          | -       | Remote host port         |
| `SSH_IDENTITY_FILE` | -       | Identity file to be used |

### GitLab Runner Docker Options

| Variable       | Default       | Description             |
| -------------- | ------------- | ----------------------- |
| `DOCKER_IMAGE` | docker:latest | Docker image to be used |
