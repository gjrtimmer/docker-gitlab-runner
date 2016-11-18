#!/bin/bash

# Set CA_CERTIFICATES_PATH
CA_CERTIFICATES_PATH=${CA_CERTIFICATES_PATH:-$GITLAB_CI_MULTI_RUNNER_DATA_DIR/certs/ca.crt}

generate_ssh_deploy_keys() {
	sudo -HEu ${GITLAB_RUNNER_USER} mkdir -p ${GITLAB_RUNNER_DATA}/.ssh/

	if [[ ! -e ${GITLAB_RUNNER_DATA}/.ssh/id_rsa || ! -e ${GITLAB_RUNNER_DATA}/.ssh/id_rsa.pub ]]; then
		echo -n "Generating SSH deploy keys..."
		rm -rf ${GITLAB_RUNNER_DATA}/.ssh/id_rsa ${GITLAB_RUNNER_DATA}/.ssh/id_rsa.pub
		sudo -HEu ${GITLAB_RUNNER_USER} ssh-keygen -t rsa -N "" -f ${GITLAB_RUNNER_DATA}/.ssh/id_rsa
		echo " [DONE]"

		echo -n "Your SSH deploy key is: "
		cat ${GITLAB_RUNNER_DATA}/.ssh/id_rsa.pub
		echo ""
	fi

	echo -n "Setting SSH Permissions..."
	chmod 600 ${GITLAB_RUNNER_DATA}/.ssh/id_rsa ${GITLAB_RUNNER_DATA}/.ssh/id_rsa.pub
	chmod 700 ${GITLAB_RUNNER_DATA}/.ssh
	chown -R ${GITLAB_RUNNER_USER}:${GITLAB_RUNNER_USER} ${GITLAB_RUNNER_DATA}/.ssh/
	echo " [DONE]"
}

# USERMAP UID/GID
# Taken from sameersbn/gitlab
map_uidgid() {
	USERMAP_ORIG_UID=$(id -u ${GITLAB_RUNNER_USER})
	USERMAP_ORIG_GID=$(id -g ${GITLAB_RUNNER_USER})
	USERMAP_GID=${USERMAP_GID:-${USERMAP_UID:-$USERMAP_ORIG_GID}}
	USERMAP_UID=${USERMAP_UID:-$USERMAP_ORIG_UID}
	
	if [[ ${USERMAP_UID} != ${USERMAP_ORIG_UID} ]] || [[ ${USERMAP_GID} != ${USERMAP_ORIG_GID} ]]; then
		echo -n "Mapping UID and GID for ${GITLAB_RUNNER_USER}:${GITLAB_RUNNER_USER} to ${USERMAP_UID}:${USERMAP_GID}..."
		groupmod -o -g ${USERMAP_GID} ${GITLAB_RUNNER_USER}
		sed -i -e "s|:${USERMAP_ORIG_UID}:${USERMAP_GID}:|:${USERMAP_UID}:${USERMAP_GID}:|" /etc/passwd
		find ${GITLAB_RUNNER_HOME} -path ${GITLAB_RUNNER_DATA}/\* -prune -o -print0 | xargs -0 chown -h ${GITLAB_RUNNER_USER}:
		echo " [DONE]"
	fi
}

create_data_dir() {
	echo -n "Creating DATA Directory..."
	mkdir -p ${GITLAB_RUNNER_DATA}
	chown ${GITLAB_RUNNER_USER}:${GITLAB_RUNNER_USER} ${GITLAB_RUNNER_DATA}
	echo " [DONE]"
}

update_ca_certificates() {
	if [[ -f ${CA_CERTIFICATES_PATH} ]]; then
		echo -n "Updating CA certificates..."
		cp "${CA_CERTIFICATES_PATH}" /usr/local/share/ca-certificates/ca.crt
		update-ca-certificates --fresh >/dev/null
		echo " [DONE]"
	fi
}

grant_access_to_docker_socket() {
	if [ -S /var/run/docker.sock ]; then
		echo -n "Configuring Docker Socket..."
		
		DOCKER_SOCKET_GID=$(stat -c %g  /var/run/docker.sock)
		DOCKER_SOCKET_GROUP=$(stat -c %G /var/run/docker.sock)
		
		if [[ ${DOCKER_SOCKET_GROUP} == "UNKNOWN" ]]; then
			DOCKER_SOCKET_GROUP=docker
			groupadd -g ${DOCKER_SOCKET_GID} ${DOCKER_SOCKET_GROUP}
		fi
		
		usermod -a -G ${DOCKER_SOCKET_GROUP} ${GITLAB_RUNNER_USER}
		echo " [DONE]"
	fi
}

configure_ci_runner() {
	if [[ ! -e ${GITLAB_RUNNER_DATA}/config.toml ]]; then
		if [[ -n ${CI_SERVER_URL} && -n ${RUNNER_TOKEN} && -n ${RUNNER_DESCRIPTION} && -n ${RUNNER_EXECUTOR} ]]; then
			sudo -HEu ${GITLAB_RUNNER_USER} \
			gitlab-runner register --config ${GITLAB_RUNNER_DATA}/config.toml \
			-n -u "${CI_SERVER_URL}" -r "${RUNNER_TOKEN}" --name "${RUNNER_DESCRIPTION}" --executor "${RUNNER_EXECUTOR}"
		else
			echo "Missing Required Parameter"
		fi
	else
		sudo -HEu ${GITLAB_RUNNER_USER} gitlab-runner register --config ${GITLAB_RUNNER_DATA}/config.toml
	fi
}

# allow arguments to be passed to gitlab-ci-multi-runner
if [[ ${1:0:1} = '-' ]]; then
	EXTRA_ARGS="$@"
	set --
elif [[ ${1} == gitlab-runner || ${1} == $(which gitlab-runner) ]]; then
	EXTRA_ARGS="${@:2}"
	set --
fi

# default behaviour is to launch gitlab-ci-multi-runner
if [[ -z ${1} ]]; then
	map_uidgid
	create_data_dir
	update_ca_certificates
	generate_ssh_deploy_keys
	grant_access_to_docker_socket
	configure_ci_runner

	start-stop-daemon --start \
		--chuid ${GITLAB_RUNNER_USER}:${GITLAB_RUNNER_USER} \
		--exec $(which gitlab-runner) -- run \
		--working-directory ${GITLAB_RUNNER_DATA} \
		--config ${GITLAB_RUNNER_DATA}/config.toml ${EXTRA_ARGS}
else
	exec "$@"
fi
