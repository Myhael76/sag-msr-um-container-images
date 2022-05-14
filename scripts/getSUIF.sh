#!/bin/bash

. ${BUILD_SOURCESDIRECTORY}/scripts/setEnv.sh

mkdir -p "${SUIF_HOME}" "${SUIF_AUDIT_BASE_DIR}"
git clone -b "${SUIF_TAG}" --single-branch https://github.com/SoftwareAG/sag-unattented-installations.git "${SUIF_HOME}"
if [ $? ne 0 ]; then
  echo "ERROR downloading SUIF"
  exit 1
fi
if [ ! -f "${SUIF_HOME}/01.scripts/commonFunctions.sh" ]; then
  echo "SUIF clone unseccessful, cannot continue"
  exit 2
fi