#!/bin/bash -e

### TRUSTED_CA_CERTS ###########################################################

# Add CA certificate to trusted CA's bundle
if [ -n "${CA_CRT_FILE}" -a -e "${CA_CRT_FILE}" ]; then
  CA_CRT_HASH_FILE="/etc/ssl/certs/$(openssl x509 -hash -noout -in ${CA_CRT_FILE}).0"
  if [ ! -e "${CA_CRT_HASH_FILE}" ]; then
    if [ "$(dirname ${CA_CRT_FILE})" != "/etc/ssl/certs" ]; then
      info "Creating link /etc/ssl/certs/$(basename ${CA_CRT_FILE}) => ${CA_CRT_FILE}"
      ln -s ${CA_CRT_FILE} /etc/ssl/certs/$(basename ${CA_CRT_FILE})
    fi
    info "Creating link ${CA_CRT_HASH_FILE} => ${CA_CRT_FILE}"
    ln -s ${CA_CRT_FILE} ${CA_CRT_HASH_FILE}
    info "Adding ${CA_CRT_FILE} to ${CA_CRT_BUNDLE_FILE}"
    cat ${CA_CRT_FILE} >> ${CA_CRT_BUNDLE_FILE}
  fi
fi

################################################################################
