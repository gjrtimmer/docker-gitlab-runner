
# datacore/gitlab-runner:1.7.1

Note: For synology NAS devices, which have docker support,
there is image available which conforms to the docker version
of synology. Current Synology NAS DSM 6.0.x is combined with Docker version 1.11.2
Docker 1.11.2 uses API version 1.23 while the latest docker-engine is already on API 1.24
Because this causes a API conflict; the ```datacore/gitlab-runner:latest``` image
cannot be used on a Synology NAS.

- [Introduction](#introduction)
  - [Contributing](#contributing)
  - [Issues](#issues)
  - [Changelog](Changelog.md)
- [Getting started](#getting-started)
  - [Installation](#installation)
  - [Quickstart](#quickstart)
  
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

## Quickstart

## Command-line arguments
