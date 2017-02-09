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
