#!/bin/bash

. ${BUILD_SOURCESDIRECTORY}/scripts/setEnv.sh
. ${SUIF_HOME}/01.scripts/commonFunctions.sh

if [ ! -f "${SASECUREINFO_SECUREFILEPATH}" ]; then
  echo "Secure file path not present: ${SASECUREINFO_SECUREFILEPATH}"
  exit 1
fi

echo "Sourcing secure information..."
chmod u+x "${SASECUREINFO_SECUREFILEPATH}"
. "${SASECUREINFO_SECUREFILEPATH}"

if [ -z ${SAG_AZ_SA_NAME+x} ]; then
  echo "Secure information has not been sourced correctly"
  exit 2
fi

. ${BUILD_SOURCESDIRECTORY}/scripts/setEnv.sh

if [ -z ${MY_sd+x} ]; then
  echo "Secure information has not been sourced correctly"
  exit 3
fi

echo "Mounting the given file share"
mkdir -p "$MY_sd"
sudo mount -t cifs "$AZ_SMB_PATH" "$MY_sd" -o "vers=3.0,username=$SAG_AZ_SA_NAME,password=$AZ_SM_SHARE_KEY,dir_mode=0777,file_mode=0777"
resultMount=$?
if [ $resultMount -ne 0 ]; then
  logE "Error mounting the images share, result $resultMount"
  exit 4
fi
