#!/bin/bash

. ${BUILD_SOURCESDIRECTORY}/scripts/setEnv.sh
. ${SUIF_HOME}/01.scripts/commonFunctions.sh

logI "Updating base libraries..."
sudo apt-get -y update
logI "Installing prerequisites..."
sudo apt-get install -y wget ca-certificates gnupg2 fuse-overlayfs
logI "Installing buildah..."
sudo echo 'deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/ /' | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
sudo wget -nv https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/xUbuntu_20.04/Release.key -O /tmp/Release.key
sudo apt-key add - < /tmp/Release.key
sudo apt-get -qq -y update
sudo apt-get -qq -y install buildah
logI "Machine prepared"
