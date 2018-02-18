#!/bin/bash -e

# TODO:
# - https://github.com/docker/docker/issues/8427
# - https://github.com/docker/docker/pull/26331

### DOCKER_INTROSPECTION #######################################################

# Docker introspection
if [ -S /var/run/docker.sock ]; then

  # Docker Swarm service task container
  DOCKER_SERVICE_NAME=$(
    curl -s --unix-socket /var/run/docker.sock http://localhost/containers/${HOSTNAME}/json |
    jq -r '.Config.Labels."com.docker.swarm.service.name" // empty'
  )
  if [ -n "${DOCKER_SERVICE_NAME}" ]; then
    DOCKER_SERVICE_ID=$(
      curl -s --unix-socket /var/run/docker.sock http://localhost/containers/${HOSTNAME}/json |
      jq -r '.Config.Labels."com.docker.swarm.service.id" // empty'
    )
    DOCKER_TASK_ID=$(
      curl -s --unix-socket /var/run/docker.sock http://localhost/containers/${HOSTNAME}/json |
      jq -r '.Config.Labels."com.docker.swarm.task.id" // empty'
    )
    # TODO: https://github.com/docker/docker/issues/28806
    DOCKER_TASK=$(
      curl -s --unix-socket /var/run/docker.sock http://localhost/containers/${HOSTNAME}/json |
      jq -r '.Config.Labels."com.docker.swarm.task.name" // empty'
    )
    DOCKER_TASK_NAME=$(
      echo ${DOCKER_TASK} |
      sed -E -e "s/\.${DOCKER_TASK_ID}//"
    )
    DOCKER_TASK_SLOT=$(
      echo ${DOCKER_TASK_NAME} |
      sed -E -e "s/^${DOCKER_SERVICE_NAME}\.?//"
    )
    DOCKER_HOST_ID=$(
      curl -s --unix-socket /var/run/docker.sock http://localhost/containers/${HOSTNAME}/json |
      jq -r '.Config.Labels."com.docker.swarm.node.id" // empty'
    )
    DOCKER_HOST_NAME=$(
      curl -s --unix-socket /var/run/docker.sock http://localhost/nodes/${DOCKER_NODE_ID} |
      tail -1 |
      jq -r ".Description.Hostname // empty"
    )

    info "Docker host name: ${DOCKER_HOST_NAME}"
    info "Docker service name: ${DOCKER_SERVICE_NAME}"
    info "Docker task name: ${DOCKER_TASK_NAME}"
  fi

  # Classic container
  DOCKER_CONTAINER_NAME=$(
    curl -s --unix-socket /var/run/docker.sock http://localhost/containers/${HOSTNAME}/json |
    jq -r '.Name // empty' |
    sed -E -e 's/^\///g'
  )
fi

### DOCKER_CONTAINER_NAME ######################################################

# Fallback to container ID
: ${DOCKER_CONTAINER_NAME:=${HOSTNAME}}

info "Docker container name: ${DOCKER_CONTAINER_NAME}"
debug "Docker IP address: $(
  ifconfig |
  egrep "<?inet>?" |
  sed -E "s/.*inet (addr:)?([^ ]*).*/\2/" |
  grep -v 127.0.0.1 |
  tr "\n" "," |
  sed -E "s/,$//"
)"

################################################################################
