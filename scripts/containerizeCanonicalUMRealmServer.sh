#!/bin/bash

. ${BUILD_SOURCESDIRECTORY}/scripts/setEnv.sh
. ${SUIF_HOME}/01.scripts/commonFunctions.sh

logI "Containerizing UM Realm Server according to product default approach"

cp "${BUILD_SOURCESDIRECTORY}/buildCtx/um1"/* "${SUIF_INSTALL_INSTALL_DIR}"/

cd "${SUIF_INSTALL_INSTALL_DIR}"
logI "Building container"
buildah \
  --storage-opt mount_program=/usr/bin/fuse-overlayfs \
  --storage-opt ignore_chown_errors=true \
  bud \
    --build-arg __instance_name=${SUIF_WMSCRIPT_NUMRealmServerNameID} \
    --build-arg __data_dir=${SUIF_WMSCRIPT_NUMDataDirID} \
    --format docker \
    -t "${AZ_ACR_CANONICAL_UMRS_CONTAINER_IMAGE_FULL_NAME}"

contResult=$?
if [ "${contResult}" -ne 0 ]; then
  logE "Containerization failed, code ${contResult}"
  exit 1
fi

logI "Canonical container image created successfully"
