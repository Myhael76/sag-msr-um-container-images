#!/bin/bash

. ${BUILD_SOURCESDIRECTORY}/scripts/setEnv.sh
. ${SUIF_HOME}/01.scripts/commonFunctions.sh

SHARED_INSTALL_IMAGE_FILE="$MY_sd/products/${MY_MSR_template}/products.zip"
SHARED_PATCH_FIXES_IMAGE_FILE="$MY_sd/fixes/${MY_MSR_template}/${MY_fixTag}/fixes.zip"

if [ ! -f "${SHARED_INSTALL_IMAGE_FILE}" ]; then
  logE "Products image file must exist in the share: ${SHARED_INSTALL_IMAGE_FILE}"
  exit 1
fi
logI "Copying products image from the share"
cp "${SHARED_INSTALL_IMAGE_FILE}" "${SUIF_INSTALL_IMAGE_FILE}"
logI "Products image copied"

if [ ! -f "${SHARED_PATCH_FIXES_IMAGE_FILE}" ]; then
  logE "Fixes image file must exist in the share: ${SHARED_PATCH_FIXES_IMAGE_FILE}"
  exit 2
fi
logI "Copying fixes image from the share"
cp "${SHARED_PATCH_FIXES_IMAGE_FILE}" "${SUIF_PATCH_FIXES_IMAGE_FILE}"
logI "Fixes image copied"
