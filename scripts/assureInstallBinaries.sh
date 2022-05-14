#!/bin/bash

. ${BUILD_SOURCESDIRECTORY}/scripts/setEnv.sh
. ${SUIF_HOME}/01.scripts/commonFunctions.sh

if [ ! -f "${MY_installerSharedBin}" ]; then
  logE "Installer Binary must exist in the share: ${MY_installerSharedBin}"
  exit 1
fi
logI "Copying installer binary from the share"
cp "${MY_installerSharedBin}" "${SUIF_INSTALL_INSTALLER_BIN}"
logI "Installer binary copied"


if [ ! -f "${MY_sumBootstrapSharedBin}" ]; then
  logE "SUM Bootstrap binary must exist in the share: ${MY_sumBootstrapSharedBin}"
  exit2
fi
logI "Copying sum bootstrap binary from the share"
cp "${MY_sumBootstrapSharedBin}" "${SUIF_PATCH_SUM_BOOSTSTRAP_BIN}"

logI "Installer binary copied"
chmod u+x "${SUIF_INSTALL_INSTALLER_BIN}"
chmod u+x "${SUIF_PATCH_SUM_BOOSTSTRAP_BIN}"
