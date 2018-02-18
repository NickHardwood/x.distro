#!/bin/bash -e

### SERVER_KEY_PWD #############################################################

if [ -n "${SERVER_KEY_PWD_FILE}" ]; then

  # Get server private key passphrase
  if [ -e "${SERVER_KEY_PWD_FILE}" ]; then
    info "Using server private key passphrase from ${SERVER_KEY_PWD_FILE}"
    SERVER_KEY_PWD=$(cat ${SERVER_KEY_PWD_FILE})
  elif [ -z "${SERVER_KEY_PWD}" ]; then
    info "Creating random server private key passphrase"
    SERVER_KEY_PWD=$(openssl rand -hex 32)
  fi

  # Save server private key passphrase
  if [ ! -e "${SERVER_KEY_PWD_FILE}" ]; then
    info "Saving server private key passphrase to ${SERVER_KEY_PWD_FILE}"
    echo ${SERVER_KEY_PWD} > ${SERVER_KEY_PWD_FILE}
    if [ -n "${SERVER_KEY_FILE_OWNER}" ]; then
      debug "Changing owner of ${SERVER_KEY_PWD_FILE} to ${SERVER_KEY_FILE_OWNER}"
      chown ${SERVER_KEY_FILE_OWNER} ${SERVER_KEY_PWD_FILE}
    fi
    debug "Changing mode of ${SERVER_KEY_PWD_FILE} to ${SERVER_KEY_FILE_MODE}"
    chmod ${SERVER_KEY_FILE_MODE} ${SERVER_KEY_PWD_FILE}
  fi

fi

################################################################################
