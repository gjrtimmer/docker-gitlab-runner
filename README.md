[![build status](https://gitlab.timmertech.nl/docker/gitlab-runner/badges/master/pipeline.svg)](https://gitlab.timmertech.nl/docker/gitlab-runner/commits/master)
[![](https://images.microbadger.com/badges/image/datacore/gitlab-runner.svg)](https://microbadger.com/images/datacore/gitlab-runner)
[![](https://images.microbadger.com/badges/license/datacore/gitlab-runner.svg)](https://microbadger.com/images/datacore/gitlab-runner)

## Alpine Linux Gitlab Runner

- [Docker Registries](#docker-registries)
- [Source Repositories](#source-repositories)
- [Installation](#installation)
- [Components](#components)
- [Volumes](#volumes)
- [Configuration](#configuration)
  - [Gitlab Runner Options](#gitlab-runner-options)
  - [GitLab Runner SSH Options](#gitlab-runner-ssh-options)
  - [GitLab Runner Docker Options](#gitlab-runner-docker-options)

# Docker Registries

- `datacore/gitlab-runner:latest`
- `registry.timmertech.nl/docker/gitlab-runner:latest`

# Source Repositories

- [github.com](https://github.com/gjrtimmer/docker-gitlab-runner)
- [gitlab.timmertech.nl](https://gitlab.timmertech.nl/docker/gitlab-runner)

# Installation

<details>
<summary>Install from DockerHub</summary>
<p>

Download:

```bash
docker pull datacore/alpine-base:latest
```

Build:

```bash
docker build -t datacore/alpine-base https://github.com/gjrtimmer/docker-alpine-base
```

</p>
</details>

<br/>

<details>
<summary>Install from TimmerTech</summary>
<p>

Download:

```bash
docker pull registry.timmertech.nl/docker/gitlab-runner:latest
```

Build:

```bash
docker build -t datacore/gitlab-runner https://gitlab.timmertech.nl/docker/gitlab-runner
```

</p>
</details>

# Components

- gitlab-runner
- docker-engine
- docker-compose
- docker-machine

# Volumes

| Variable               | Default                           | Description                                |
| ---------------------- | --------------------------------- | ------------------------------------------ |
| `DATA`                 | /data                             | Data directory, persistent volume location |
| `CA_CERTIFICATES_PATH` | `GITLAB_RUNNER_DATA/certs/ca.crt` | Location for CA certificate file           |

# Configuration

## Gitlab Runner Options

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

## GitLab Runner SSH Options

| Variable            | Default | Description              |
| ------------------- | ------- | ------------------------ |
| `SSH_USER`          | -       | User name                |
| `SSH_PASSWORD`      | -       | User password            |
| `SSH_HOST`          | -       | Remote host              |
| `SSH_PORT`          | -       | Remote host port         |
| `SSH_IDENTITY_FILE` | -       | Identity file to be used |

## GitLab Runner Docker Options

| Variable       | Default       | Description             |
| -------------- | ------------- | ----------------------- |
| `DOCKER_IMAGE` | docker:latest | Docker image to be used |
