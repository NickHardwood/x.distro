#!/bin/bash -e

### DIR_LOCATIONS ##############################################################

# Default directory locations
: ${CA_CRT_DIR:=/etc/ssl/certs}
: ${SERVER_CRT_DIR:=/etc/ssl/certs}
: ${SERVER_KEY_DIR:=/etc/ssl/private}

### CA_CRT #####################################################################

# Default CA certificate file location
if [ -e /run/secrets/ca.crt ]; then
  : ${CA_CRT_FILE:=/run/secrets/ca.crt}
else
  : ${CA_CRT_FILE:=${CA_CRT_DIR}/ca.crt}
fi

### CA_CRT_BUNDLE ##############################################################

# CentOS/Fedora/RHEL trusted CA certificates bundle
if [ -e /etc/pki/tls/certs/ca-bundle.crt ]; then
  : ${CA_CRT_BUNDLE_FILE:=/etc/pki/tls/certs/ca-bundle.crt}
fi
# Default trusted CA certificates bundle
: ${CA_CRT_BUNDLE_FILE:=/etc/ssl/certs/ca-certificates.crt}

### CA_USER ####################################################################

# Default CA user name file location
if [ -e /run/secrets/ca_user.name ]; then
  : ${CA_USER_NAME_FILE:=/run/secrets/ca_user.name}
else
  : ${CA_USER_NAME_FILE:=${SERVER_KEY_DIR}/ca_user.name}
fi

# Default CA user password file location
if [ -e /run/secrets/ca_user.pwd ]; then
  : ${CA_USER_PWD_FILE:=/run/secrets/ca_user.pwd}
else
  : ${CA_USER_PWD_FILE:=${SERVER_KEY_DIR}/ca_user.pwd}
fi

### SERVER_CRT #################################################################

# Default server certificate subject
: ${SERVER_CRT_SUBJECT:=/CN=${DOCKER_CONTAINER_NAME}}

# Default server host name
: ${SERVER_CRT_HOST:=${DOCKER_HOST_NAME}}

# Default server certificate file location
if [ -e /run/secrets/server.crt ]; then
  : ${SERVER_CRT_FILE:=/run/secrets/server.crt}
else
  : ${SERVER_CRT_FILE:=${SERVER_CRT_DIR}/server.crt}
fi

# Default server private key file location
if [ -e /run/secrets/server.key ]; then
  : ${SERVER_KEY_FILE:=/run/secrets/server.key}
else
  : ${SERVER_KEY_FILE:=${SERVER_KEY_DIR}/server.key}
fi

# Set default server private key passphrase file location only if file exist
if [ -e /run/secrets/server.pwd ]; then
  : ${SERVER_KEY_PWD_FILE:=/run/secrets/server.pwd}
elif [ -e ${SERVER_KEY_DIR}/server.pwd ]; then
  : ${SERVER_KEY_PWD_FILE:=${SERVER_KEY_DIR}/server.pwd}
fi

### FILE_PERMISSIONS ###########################################################

# Default server certificate, private key and passphrase files owner
: ${DOCKER_GROUP:=${DOCKER_USER}}
: ${SERVER_KEY_FILE_USER:=${DOCKER_USER}}
: ${SERVER_KEY_FILE_GROUP:=${DOCKER_GROUP}}
if [ -n "${SERVER_KEY_FILE_USER}" -a -n "${SERVER_KEY_FILE_GROUP}}" ]; then
  SERVER_KEY_FILE_OWNER="${SERVER_KEY_FILE_USER}:${SERVER_KEY_FILE_GROUP}"
fi
: ${SERVER_CRT_FILE_USER:=${DOCKER_USER}}
: ${SERVER_CRT_FILE_GROUP=${DOCKER_GROUP}}
if [ -n "${SERVER_CRT_FILE_USER}" -a -n "${SERVER_CRT_FILE_GROUP}}" ]; then
  SERVER_CRT_FILE_OWNER="${SERVER_CRT_FILE_USER}:${SERVER_CRT_FILE_GROUP}"
fi

# Default server certificate, private key and passphrase files mode
: ${SERVER_CRT_FILE_MODE:=444}
: ${SERVER_KEY_FILE_MODE:=440}

################################################################################
