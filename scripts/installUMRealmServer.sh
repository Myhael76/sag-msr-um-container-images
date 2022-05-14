#!/bin/bash

. ${BUILD_SOURCESDIRECTORY}/scripts/setEnv.sh
. ${SUIF_HOME}/01.scripts/commonFunctions.sh
. ${SUIF_HOME}/01.scripts/installation/setupFunctions.sh

logI "SUIF env before installation of MSR:"
env | grep SUIF_ | sort

logI "Installing Universal Messaging Realm Server"

applySetupTemplate "${MY_UM_template}"

local installResult=$?

if [ "${installResult}" -ne 0 ]; then
  logE "Installation failed, code ${installResult}"
  exit 1
fi

logI "Universal Messaging Realm Server installation successful"
