FROM sameersbn/ubuntu:latest
MAINTAINER "G.J.R. Timmer <gjr.timmer@gmail.com>"

# Update Image
RUN apt-get update -y && \
	apt-get upgrade -y && \
	apt-get install -y ca-certificates wget apt-transport-https vim && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Install docker-engine and docker-compose
# Runner will access the docker of the host through
# a binded docker socket
RUN echo "deb https://apt.dockerproject.org/repo ubuntu-`lsb_release -cs` main" | tee /etc/apt/sources.list.d/docker.list && \
	apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
	apt-get update && \
	apt-get install -y docker-engine docker-compose
