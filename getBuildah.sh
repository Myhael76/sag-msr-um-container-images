#!/bin/sh
echo "===================> Updating base libraries..."
sudo apt-get -y update
echo "===================> Installing prerequisites..."
sudo apt-get install -y wget ca-certificates gnupg2
echo "===================> Installing buildah..."
sudo echo 'deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/ /' | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
sudo wget -nv https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/xUbuntu_20.04/Release.key -O /tmp/Release.key
sudo apt-key add - < /tmp/Release.key
sudo apt-get -y update -qq
sudo apt-get -qq -y install buildah
echo "===================> update.sh finished"
