#!/bin/bash -e

### EXEC_COMMAND ###############################################################

# Container is starting
if [ -n "${DOCKER_CONTAINER_START}" ]; then
  # Wait for another services
  : ${WAIT_FOR_TIMEOUT:=60}
  wait_for_dns ${WAIT_FOR_DNS_TIMEOUT:=${WAIT_FOR_TIMEOUT}} ${WAIT_FOR_DNS}
  wait_for_tcp ${WAIT_FOR_TCP_TIMEOUT:=${WAIT_FOR_TIMEOUT}} ${WAIT_FOR_TCP}
  wait_for_url ${WAIT_FOR_URL_TIMEOUT:=${WAIT_FOR_TIMEOUT}} ${WAIT_FOR_URL}

  # Run as specified user
  if [ -n "${DOCKER_USER}" ]; then
    set -- su-exec ${DOCKER_USER} "$@"
  fi
fi

### DOCKER_LOG #################################################################

# Default Docker log files owner
if [ -n "${DOCKER_USER}" ]; then
  : ${DOCKER_LOG_FILE_OWNER:=${DOCKER_USER}:${DOCKER_GROUP:-${DOCKER_USER}}}
fi

# Redirect logs to the Docker console
# - https://github.com/docker/docker/issues/6880#issuecomment-170214851
if [ -n "${DOCKER_LOG_FILE}" -a ! -e "${DOCKER_LOG_FILE}" ]; then
  info "Creating ${DOCKER_LOG_FILE}"
  mkfifo -m ${DOCKER_LOG_FILE_MODE:-600} ${DOCKER_LOG_FILE}
  if [ -n "${DOCKER_LOG_FILE_OWNER}" ]; then
    chown ${DOCKER_LOG_FILE_OWNER} ${DOCKER_LOG_FILE}
  fi
  cat <> ${DOCKER_LOG_FILE} &
fi
if [ -n "${DOCKER_ERR_FILE}" -a ! -e "${DOCKER_ERR_FILE}" ]; then
  info "Creating ${DOCKER_ERR_FILE}"
  mkfifo -m ${DOCKER_LOG_FILE_MODE:-600} ${DOCKER_ERR_FILE}
  if [ -n "${DOCKER_LOG_FILE_OWNER}" ]; then
    chown ${DOCKER_LOG_FILE_OWNER} ${DOCKER_ERR_FILE}
  fi
  cat <> ${DOCKER_ERR_FILE} 1>&2 &
fi

################################################################################
