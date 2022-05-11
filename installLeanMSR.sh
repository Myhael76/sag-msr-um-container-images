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
template="MSR/1011/lean"
fixTag="22-05-11"

export SUIF_INSTALL_IMAGE_FILE="/tmp/products.zip"
export SUIF_PATCH_FIXES_IMAGE_FILE="/tmp/fixes.zip"

exports(){
  export SUIF_FIXES_DATE_TAG="$crtDay"
  export SUIF_DEBUG_ON=1
  export SUIF_SDC_ONLINE_MODE=0 # tell SUIF we are not connected to SDC, but using our own images
  # we'll work with local binaries, as the mount may have low IOPS
  export SUIF_INSTALL_INSTALLER_BIN=/tmp/installer.bin
  export SUIF_PATCH_SUM_BOOSTSTRAP_BIN=/tmp/sum-bootstrap.bin
  export SUIF_ONLINE_MODE=0
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

mountImagesShare(){
  logI "Mounting the given file share"
  mkdir -p "$sd"
  sudo mount -t cifs "$AZ_SMB_PATH" "$sd" -o "vers=3.0,username=$SAG_AZ_SA_NAME,password=$AZ_SM_SHARE_KEY,dir_mode=0777,file_mode=0777"
  resultMount=$?
  if [ $resultMount -ne 0 ]; then
    logE "Error mounting the images share, result $resultMount"
    exit 4
  fi
  logI "Creating work folder and assuring shared folders (${binDir})"
  mkdir -p "${binDir}" "$wd" "$sd/sessions/$crtDay"
  touch "${binDir}/lastMountTime"
}
mountImagesShare

# TODO: current code always expects a fixes image, to add the option not to
assureBinaries(){
  if [ ! -f "${installerSharedBin}" ]; then
    logE "Installer Binary must exist in the share: ${installerSharedBin}"
    exit 1
  fi
  logI "Copying installer binary from the share"
  cp "${installerSharedBin}" "${SUIF_INSTALL_INSTALLER_BIN}"
  logI "Installer binary copied"


  if [ ! -f "${sumBootstrapSharedBin}" ]; then
    logE "SUM Bootstrap binary must exist in the share: ${sumBootstrapSharedBin}"
    exit2
  fi
  logI "Copying sum bootstrap binary from the share"
  cp "${sumBootstrapSharedBin}" "${SUIF_PATCH_SUM_BOOSTSTRAP_BIN}"

  logI "Installer binary copied"
  chmod u+x "${SUIF_INSTALL_INSTALLER_BIN}"
  chmod u+x "${SUIF_PATCH_SUM_BOOSTSTRAP_BIN}"
}
assureBinaries

assureSUM(){
  export SUIF_SUM_HOME=/tmp/sumv11
  mkdir -p "${SUIF_SUM_HOME}"
  bootstrapSum "${SUIF_PATCH_SUM_BOOSTSTRAP_BIN}" "" "${SUIF_SUM_HOME}"
}
assureSUM

assureProductImages(){
  local SHARED_INSTALL_IMAGE_FILE="$sd/products/${template}/products.zip"
  local SHARED_PATCH_FIXES_IMAGE_FILE="$sd/fixes/${template}/${fixTag}/fixes.zip"

  if [ ! -f "${SHARED_INSTALL_IMAGE_FILE}" ]; then
    logE "Products image file must exist in the share: ${SHARED_INSTALL_IMAGE_FILE}"
    exit 3
  fi
  logI "Copying installer binary from the share"
  cp "${SHARED_INSTALL_IMAGE_FILE}" "${SUIF_INSTALL_IMAGE_FILE}"
  logI "Installer binary copied"

  if [ ! -f "${SHARED_PATCH_FIXES_IMAGE_FILE}" ]; then
    logE "Fixes image file must exist in the share: ${SHARED_PATCH_FIXES_IMAGE_FILE}"
    exit 4
  fi
  logI "Copying installer binary from the share"
  cp "${SHARED_PATCH_FIXES_IMAGE_FILE}" "${SUIF_PATCH_FIXES_IMAGE_FILE}"
  logI "Installer binary copied"
}
assureProductImages

install(){
  logI "Installing MSR..."
  export SUIF_INSTALL_INSTALL_DIR=/tmp/MSR
  export SUIF_SAG_USER_NAME=sag
  export SUIF_PATCH_AVAILABLE=1
  export SUIF_SETUP_TEMPLATE_MSR_LICENSE_FILE="${MSRLICENSE_SECUREFILEPATH}"
  export SUIF_INSTALL_TIME_ADMIN_PASSWORD=manage01

  logEnv

  applySetupTemplate "${template}"
}
install

containerize(){
  cd "${SUIF_INSTALL_INSTALL_DIR}/IntegrationServer/docker"
  ./is_container.sh createLeanDockerfile
  find "${SUIF_INSTALL_INSTALL_DIR}" -type f -name Dockerfile
}
containerize

finally(){
  logI "Saving the audit"
  tar cvzf "$sd/sessions/$crtDay/s_$d.tgz" "${SUIF_AUDIT_BASE_DIR}"
  logI "Unmounting the shared images folder"
  sudo umount "$sd"
  logI "Unmounted, result is $?"
}
finally