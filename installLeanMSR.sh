#!/bin/bash

# local variables
SUIF_TAG="v.0.0.3-temp"
d=$(date +%y-%m-%dT%H.%M.%S_%3N)
crtDay=$(date +%y-%m-%d)
wd="/tmp/work_$d" # our work directory
sd="/tmp/share"   # share directory - images
binDir="$sd/bin"
installerSharedBin="$binDir/installer.bin"
sumBootstrapSharedBin="$binDir/sum-bootstrap.bin"

exports(){
  export SUIF_FIXES_DATE_TAG="$crtDay"
  export SUIF_DEBUG_ON=1
  export SUIF_SDC_ONLINE_MODE=0 # tell SUIF we are not connected to SDC, but using our own images
  # we'll work with local binaries, as the mount may have low IOPS
  export SUIF_INSTALL_INSTALLER_BIN=/tmp/installer.bin
  export SUIF_PATCH_SUM_BOOSTSTRAP_BIN=/tmp/sum-bootstrap.bin
}
exports

getSUIF(){
  export SUIF_HOME=/tmp/SUIF
  export SUIF_AUDIT_BASE_DIR=/tmp/SUIF_AUDIT
  mkdir -p "${SUIF_HOME}" "${SUIF_AUDIT_BASE_DIR}"
  pushd .
  cd /tmp/SUIF
  git clone -b "${SUIF_TAG}" --single-branch https://github.com/SoftwareAG/sag-unattented-installations.git "${SUIF_HOME}"
  popd
  if [ ! -f "${SUIF_HOME}/01.scripts/commonFunctions.sh" ]; then
    echo "SUIF clone unseccessful, cannot continue"
    exit 3
  fi
}
getSUIF
. ${SUIF_HOME}/01.scripts/commonFunctions.sh
. ${SUIF_HOME}/01.scripts/installation/setupFunctions.sh
logI "SUIF cloned in folder ${SUIF_HOME} and sourced"
logI "SUIF env after sourcing:"
env | grep SUIF_ | sort

sourceSecrets(){
  if [ ! -f "${SECRETS_SECUREFILEPATH}" ]; then
    echo "Secure file path not present: ${SECRETS_SECUREFILEPATH}"
    exit 1
  fi

  logI "Sourcing secure information..."
  chmod u+x "${SECRETS_SECUREFILEPATH}"
  . "${SECRETS_SECUREFILEPATH}"

  if [ -z ${SAG_AZ_SA_NAME+x} ]; then
    echo "Secure information has not been sourced correctly"
    exit 2
  fi
}
sourceSecrets

