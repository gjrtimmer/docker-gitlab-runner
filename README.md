
# datacore/gitlab-runner:1.7.1-1

> **Note**: For synology NAS devices, there is image available which conforms to the docker version
of synology. Current Synology NAS DSM 6.0.x is combined with Docker version 1.11.2.


- [Introduction](#introduction)
  - [Contributing](#contributing)
  - [Issues](#issues)
  - [Changelog](Changelog.md)
- [Getting started](#getting-started)
  - [Installation](#installation)
    - [Synology](#synology)
  - [Quickstart](#quickstart)
  - [Command-line arguments](#command-line-arguments)
  - [Persistence](#persistence)
  - [Deploy Keys](#deploy-keys)
  - [Trusting SSL Server Certificates](#trusting-ssl-server-certificates)
  - [Host UID / GID Mapping](#host-uid--gid-mapping)
  - [Docker Executor](#docker-executor)
  - [Configuration Options](#configuration-options)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
  
# Introduction

## Contributing

If you find this image useful here's how you can help:

- Send a pull request with your awesome features and bug fixes
- Help users resolve their [issues](../../issues?q=is%3Aopen+is%3Aissue).

## Issues

Before reporting your issue please try updating Docker to the latest version and check if it resolves the issue. Refer to the Docker [installation guide](https://docs.docker.com/installation) for instructions.

SELinux users should try disabling SELinux using the command `setenforce 0` to see if it resolves the issue.

If the above recommendations do not help then [report your issue](../../issues/new) along with the following information:

- Output of the `docker version` and `docker info` commands
- The `docker run` command or `docker-compose.yml` used to start the image. Mask out the sensitive bits.
- Please state if you are using [Boot2Docker](http://www.boot2docker.io), [VirtualBox](https://www.virtualbox.org), etc.

# Getting started

## Installation
Automated builds of the image are available on [Dockerhub](https://hub.docker.com/r/datacore/gitlab-runner) and is the recommended method of installation.

```bash
docker pull datacore/gitlab-runner:1.7.1
```

Alternatively you can build the image yourself.

```bash
docker build -t datacore/gitlab-runner https://github.com/GJRTimmer/docker-gitlab-runner
```

### Synology
For use on a Synology NAS use the following for installation.

```bash
docker pull datacore/gitlab-runner:syno-1.7.1
```

Alternatively you can build the Synology image yourself.

```bash
docker build -t datacore/syno-1.7.1 https://github.com/GJRTimmer/docker-gitlab-runner#synology
```

## Quickstart

A runner must be registerd with a GitLab environment before it can receive any jobs to process.
This registration is configured with 4 environment variables.

| Parameter | Description |
|-----------|-------------|
| `CI_SERVER_URL` | The url of the gitlab environment where to register.<br>A runner must register with the gitlab CI module located at GITLAB_HOSTNAME/ci<br>Example: http://git.example.com/ci |
| `RUNNER_TOKEN` | This can either be the shared runner token which can be found at http://GITLAB_HOSTNAME/admin/runners or it can be a project specific token which will assign this runner to a specific project. |
| `RUNNER_EXECUTOR` | Executor mode for this runner. This image is designed to be used either as exector `shell` or as executor `docker`. |
| `RUNNER_DESCRIPTION` | Description for this runner. |

```bash
docker run --name gitlab-runner -d --restart=always \
  --volume /srv/docker/gitlab-runner:/home/gitlab-runner/data \
  --env='CI_SERVER_URL=http://git.example.com/ci' --env='RUNNER_TOKEN=xxxxxxxxx' \
  --env='RUNNER_DESCRIPTION=myrunner' --env='RUNNER_EXECUTOR=shell' \
  datacore/gitlab-runner:1.7.1
```

Update the values of `CI_SERVER_URL`, `RUNNER_TOKEN` and `RUNNER_DESCRIPTION` in the above command. These variables are required to be entered before starting the image. The registration process for this image has been set to non-interactive.

## Command-line arguments

You can customize the launch command by specifying arguments to `gitlab-runner` on the `docker run` command. For example the following command prints the help menu of `gitlab-runner` command:

```bash
docker run --name gitlab-runner -it --rm \
  --volume /srv/docker/gitlab-runner:/home/gitlab-runner/data \
  datacore/gitlab-runner:1.7.1 --help
```

## Persistence

For the image to preserve its state across container shutdown and startup you should mount a volume at `/home/gitlab-runner/data`.

SELinux users should update the security context of the host mountpoint so that it plays nicely with Docker:


```bash
mkdir -p /srv/docker/gitlab-runner
chcon -Rt svirt_sandbox_file_t /srv/docker/gitlab-runner
```

## Deploy Keys

At first run the image automatically generates SSH deploy keys which are installed at `/home/gitlab-runner/data/.ssh` of the persistent data store. You can replace these keys with your own if you wish to do so.

You can use these keys to allow the runner to gain access to your private git repositories over the SSH protocol.

> **NOTE**
>
> - The deploy keys are generated without a passphrase.
> - If your CI jobs clone repositories over SSH, you will need to build the ssh known hosts file which can be done in the build steps using, for example, `ssh-keyscan github.com | sort -u - ~/.ssh/known_hosts -o ~/.ssh/known_hosts`.

## Trusting SSL Server Certificates

If your GitLab server is using self-signed SSL certificates then you should make sure the GitLab server's SSL certificate is trusted on the runner for the git clone operations to work.

The runner is configured to look for trusted SSL certificates at `/home/gitlab-runner/data/certs/ca.crt`. This path can be changed using the `CA_CERTIFICATES_PATH` enviroment variable.

Create a file named `ca.crt` in a `certs` folder at the root of your persistent data volume. The `ca.crt` file should contain the root certificates of all the servers you want to trust.

## Docker Executor

This image can run as a `docker` executor. However it's designed to use the host's docker socket and not docker-in-docker. This requires the host docker socket to be mounted at `/var/run/docker.sock` in the image. See the advanced example on how to use this.

## Host UID / GID Mapping

Per default the container is configured to run gitlab as a newly created user. The host possibly uses this ids for different purposes leading to unfavorable effects. From the host it appears as if the mounted data volumes are owned by the host's user/group `1000`.

Also the container processes seem to be executed as the host's user/group `1000`. The container can be configured to map the `uid` and `gid` to different ids on host by passing the environment variables `USERMAP_UID` and `USERMAP_GID`. 

## Configuration Options

| Parameter | Description |
|-----------|-------------|
| `CA_CERTIFICATES_PATH` | Location for trusted SSL Certificates. |
| `CI_SERVER_URL` | The url of the gitlab environment where to register.<br>A runner must register with the gitlab CI module located at GITLAB_HOSTNAME/ci<br>Example: http://git.example.com/ci |
| `RUNNER_TOKEN` | This can either be the shared runner token which can be found at http://GITLAB_HOSTNAME/admin/runners or it can be a project specific token which will assign this runner to a specific project. |
| `RUNNER_EXECUTOR` | Executor mode for this runner. This image is designed to be used either as exector `shell` or as executor `docker`. |
| `RUNNER_DESCRIPTION` | Description for this runner. |
| `RUNNER_TAG_LIST` | Assign tags to runner, this will cause the runner to process only jobs which have matching tags. Tags are COMMA ',' seperated. |
| `RUNNER_PRE_BUILD_SCRIPT` | Script to run before every build. See tips and tricks on how to use it. |
| `RUNNER_DOCKER_IMAGE` | Default docker image to use, REQUIRED when using docker as executor. |
| `DOCKER_NETWORK_MODE` | Use provided docker network. |
| `DOCKER_DISABLE_CACHE` | Disable cache mode. This will cleanup any stopped container. |
| `DOCKER_VOLUMES` | Additional volumes to be mounted for build container, can be used for `RUNNER_PRE_BUILD_SCRIPT`. See tips and tricks. |
| `USERMAP_UID` | USER ID to map files to. |
| `USERMAP_GID` | User GID to map files to. |


# Maintenance

## Shell Access

For debugging and maintenance purposes you may want access the containers shell. If you are using Docker version `1.3.0` or higher you can access a running containers shell by starting `bash` using `docker exec`:

```bash
docker exec -it gitlab-runner bash
```
