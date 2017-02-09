FROM registry.timmertech.nl/docker/alpine-glibc:latest
MAINTAINER G.J.R. Timmer <gjr.timmer@gmail.com>

ARG BUILD_DATE
ARG VCS_REF

LABEL \
	nl.timmertech.build-date=${BUILD_DATE} \
	nl.timmertech.name=gitlab-runner \
	nl.timmertech.vendor=timmertech.nl \
	nl.timmertech.vcs-url="https://github.com/GJRTimmer/docker-gitlab-runner.git" \
	nl.timmertech.vcs-ref=${VCS_REF} \
	nl.timmertech.license=MIT

# EOF