[![build status](https://gitlab.timmertech.nl/docker/gitlab-runner/badges/master/build.svg)](https://gitlab.timmertech.nl/docker/gitlab-runner/commits/master)
[![](https://images.microbadger.com/badges/image/datacore/gitlab-runner.svg)](https://microbadger.com/images/datacore/gitlab-runner)
[![](https://images.microbadger.com/badges/version/datacore/gitlab-runner.svg)](https://microbadger.com/images/datacore/gitlab-runner)
[![](https://images.microbadger.com/badges/commit/datacore/gitlab-runner.svg)](https://microbadger.com/images/datacore/gitlab-runner)
[![](https://images.microbadger.com/badges/license/datacore/gitlab-runner.svg)](https://microbadger.com/images/datacore/gitlab-runner)

# Alpine Linux Gitlab Runner

- [Docker Registries](#docker-registries)
- [Source Repositories](#source-repositories)
- [Installation](#installation)
  - [DockerHub](#install-from-dockerhub)
  - [TimmerTech](#install-from-timmertech)
- [Components](#components)

# Docker Registries

 - ```datacore/gitlab-runner:latest``` (DockerHub)
 - ```registry.timmertech.nl/docker/gitlab-runner:latest``` (registry.timmertech.nl)


# Source Repositories

- [github.com](https://github.com/GJRTimmer/docker-gitlab-runner)
- [gitlab.timmertech.nl](https://gitlab.timmertech.nl/docker/gitlab-runner)


# Installation

## Install from DockerHub
Download:
```bash
docker pull datacore/gitlab-runner:latest
```

Build:
```bash
docker build -t datacore/gitlab-runner https://github.com/GJRTimmer/docker-gitlab-runner
```


## Install from timmertech

Download:
```bash
docker pull registry.timmertech.nl/docker/gitlab-runner:latest
```

Build:
```bash
docker build -t datacore/gitlab-runner https://gitlab.timmertech.nl/docker/gitlab-runner
```

# Components

 - gitlab-runner
 - docker-engine
 - docker-compose
 - docker-machine
 
# Volumes

| Variable | Default | Description |
|----------|---------|-------------|
| ```GITLAB_RUNNER_HOME``` | /home/gitlab-runner | Home Directory |
| ```GITLAB_RUNNER_DATA``` | /home/gitlab-ruunner/data | Data directory, persistent volume location |
| ```CA_CERTIFICATES_PATH``` | ```GITLAB_RUNNER_DATA/certs/ca.crt``` | Location for CA certificate file |
 
# Configuration

## General Options
| Variable | Default | Description |
|----------|---------|-------------|
| ```GR_UID``` | - | GitLab Runner UID |
| ```GR_GID``` | - | GitLab Runner GID |

## Gitlab Runner Options

| Variable | Default | Description |
|----------|---------|-------------|
| ```CI_SERVER_URL``` | - | CI URL; example: gitlab.com/ci |
| ```REGISTRATION_TOKEN``` | - | Gitlab Runner token |
| ```RUNNER_EXECUTOR``` | shell | Runner executor |
| ```RUNNER_NAME``` | gitlab-runner | Description of runner |
| ```RUNNER_TAG_LIST``` | - | Runner Tag list |
| ```RUNNER_PRE_CLONE_SCRIPT``` | - | Runner-specific command script executed before code is pulled |
| ```RUNNER_PRE_BUILD_SCRIPT``` | - | Runner-specific command script executed after code is pulled, just before build executes |
| ```RUNNER_DOCKER_IMAGE``` | docker:latest | Default docker image ton use if executor is docker |

## GitLab Runner SSH Options

| Variable | Default | Description |
|----------|---------|-------------|
| ```SSH_USER``` | - | User name |
| ```SSH_PASSWORD``` | - | User password |
| ```SSH_HOST``` | - | Remote host |
| ```SSH_PORT``` | - | Remote host port |
| ```SSH_IDENTITY_FILE``` | - | Identity file to be used |

## GitLab Runner Docker Options

| Variable | Default | Description |
|----------|---------|-------------|
| ```DOCKER_IMAGE``` | docker:latest | Docker image to be used |
