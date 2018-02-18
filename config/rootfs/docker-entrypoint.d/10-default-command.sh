#!/bin/bash -e

### DEFAULT_COMMAND ############################################################

# First arg is option (-o or --option)
if [ "${1:0:1}" = '-' -a -n "${DOCKER_COMMAND}" ]; then
  info "Using default command ${DOCKER_COMMAND}"
	set -- ${DOCKER_COMMAND} "$@"
fi

# Command is not specified
if [[ ! $@ ]]; then
  info "Using default command ${DOCKER_COMMAND}"
	set -- ${DOCKER_COMMAND}
fi

################################################################################
