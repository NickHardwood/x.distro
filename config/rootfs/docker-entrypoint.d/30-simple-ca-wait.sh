#!/bin/bash -e

### WAIT_FOR_SIMPLE_CA #########################################################

# Wait until the Simple CA service is started
if [ -n "${SIMPLE_CA_URL}" ]; then
    wait_for_url ${SIMPLE_CA_TIMEOUT:-60} ${SIMPLE_CA_URL}/ca.crt
fi

################################################################################
