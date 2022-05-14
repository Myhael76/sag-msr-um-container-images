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

containerize_Canonical(){
  logI "Conainerizing MS according to product default approach"
  cd "${SUIF_INSTALL_INSTALL_DIR}/IntegrationServer/docker"
  ./is_container.sh createLeanDockerfile
  cd "${SUIF_INSTALL_INSTALL_DIR}"
  logI "Building container"
  buildah \
    --storage-opt mount_program=/usr/bin/fuse-overlayfs \
    --storage-opt ignore_chown_errors=true \
    bud -f ./Dockerfile_IS --format docker -t "${AZ_ACR_CONTAINER_IMAGE_FULL_NAME}"
  local contResult=$?

  if [ "${contResult}" -ne 0 ]; then
    logE "Containerization failed, code ${contResult}"
    exit 1
  fi
}
containerize_Canonical

logI "Saving the audit"
tar cvzf "$MY_sd/sessions/$MY_crtDay/s_$MY_d.tgz" "${SUIF_AUDIT_BASE_DIR}"
