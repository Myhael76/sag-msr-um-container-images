#!/bin/bash

. ${BUILD_SOURCESDIRECTORY}/scripts/setEnv.sh
. ${SUIF_HOME}/01.scripts/commonFunctions.sh
. ${SUIF_HOME}/01.scripts/installation/setupFunctions.sh
logI "SUIF env after sourcing:"
env | grep SUIF_ | sort

install(){
  logI "Installing MSR..."

  logEnv

  applySetupTemplate "${MY_MSR_template}"

  local installResult=$?

  if [ "${installResult}" -ne 0 ]; then
    logE "Installation failed, code ${installResult}"
    exit 1
  fi
}
install

