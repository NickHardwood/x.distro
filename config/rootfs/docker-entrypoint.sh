#!/bin/bash -e

################################################################################

# Lock against parallel run
exec 100</docker-entrypoint.sh
flock -x 100

# Run extra entrypoints
if [ -e /docker-entrypoint.d ]; then
  for DOCKER_ENTRYPOINT in /docker-entrypoint.d/*.sh; do
    . ${DOCKER_ENTRYPOINT}
  done
  unset DOCKER_ENTRYPOINT
fi

# Unlock
flock -u 100

################################################################################

info "Executing command: $(printf "[%s]", "$@")"
exec "$@"

################################################################################
