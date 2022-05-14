#!/bin/bash

. ${BUILD_SOURCESDIRECTORY}/scripts/setEnv.sh
. ${SUIF_HOME}/01.scripts/commonFunctions.sh

SHARED_INSTALL_IMAGE_FILE="$MY_sd/products/${MY_UM_template}/products.zip"
SHARED_PATCH_FIXES_IMAGE_FILE="$MY_sd/fixes/${MY_UM_template}/${MY_fixTag}/fixes.zip"

if [ ! -f "${SHARED_INSTALL_IMAGE_FILE}" ]; then
  logE "Products image file must exist in the share: ${SHARED_INSTALL_IMAGE_FILE}"
  exit 1
fi
logI "Copying installer binary from the share"
cp "${SHARED_INSTALL_IMAGE_FILE}" "${SUIF_INSTALL_IMAGE_FILE}"
logI "Installer binary copied"

if [ ! -f "${SHARED_PATCH_FIXES_IMAGE_FILE}" ]; then
  logE "Fixes image file must exist in the share: ${SHARED_PATCH_FIXES_IMAGE_FILE}"
  exit 2
fi
logI "Copying installer binary from the share"
cp "${SHARED_PATCH_FIXES_IMAGE_FILE}" "${SUIF_PATCH_FIXES_IMAGE_FILE}"
logI "Installer binary copied"