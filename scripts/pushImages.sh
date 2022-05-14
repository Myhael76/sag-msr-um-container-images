#!/bin/bash

. ${BUILD_SOURCESDIRECTORY}/scripts/setEnv.sh
. ${SUIF_HOME}/01.scripts/commonFunctions.sh

logI "Getting service principal credentials..."
if [ ! -f "${SPCREDENTIALS_SECUREFILEPATH}" ]; then
  logE "Secure file path not present: ${SPCREDENTIALS_SECUREFILEPATH}"
  exit 1
fi

chmod u+x "${SPCREDENTIALS_SECUREFILEPATH}"
. "${SPCREDENTIALS_SECUREFILEPATH}"

if [ -z ${AZ_ACR_SP_ID+x} ]; then
  logE "Secure information has not been sourced correctly"
  exit 2
fi

logI "Logging in to repository ${AZ_ACR_URL}"
buildah login -u "${AZ_ACR_SP_ID}" -p "${AZ_ACR_SP_SECRET}" "${AZ_ACR_URL}"

logI "Tagging ${AZ_ACR_CANONICAL_CONTAINER_IMAGE_FULL_NAME} to ${AZ_ACR_CANONICAL_CONTAINER_IMAGE_FULL_NAME}-${MY_d}"
buildah tag "${AZ_ACR_CANONICAL_CONTAINER_IMAGE_FULL_NAME}" "${AZ_ACR_CANONICAL_CONTAINER_IMAGE_FULL_NAME}-${MY_d}"

logI "Pushing tag ${AZ_ACR_CANONICAL_CONTAINER_IMAGE_FULL_NAME}-${MY_d}"
buildah push "${AZ_ACR_CANONICAL_CONTAINER_IMAGE_FULL_NAME}-${MY_d}"

logI "Logging out"
buildah logout "${AZ_ACR_URL}"

logI "Push completed"