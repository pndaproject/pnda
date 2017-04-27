#!/bin/bash
echo "Usage: ./update_mirror_deb.sh /path/to/mirror_deb a-package [another-package ...]"
DISTRO=$(cat /etc/*-release|grep ^ID\=|awk -F\= {'print $2'}|sed s/\"//g)
if [ "x$DISTRO" != "xubuntu" ]; then
    echo "Sorry, this script must be run on Ubuntu 14.04. To host a DEB mirror on a web server running another operating system, generate the files on Ubuntu and copy them over."
    exit 1
else
    export DEBIAN_FRONTEND=noninteractive
    apt-get -y update
    apt-get -y install dpkg-dev debfoster
fi
DEB_PACKAGE_LIST=${@:2}
DEB_REPO_DIR=${1}
mkdir -p $DEB_REPO_DIR
cd $DEB_REPO_DIR
if [ "$#" -gt 1 ]; then
  apt-get -y install $DEB_PACKAGE_LIST 
  apt-get download $DEB_PACKAGE_LIST
  for DEB_PACKAGE in $DEB_PACKAGE_LIST
  do
    DEBP=(${DEB_PACKAGE//=/ })
    apt-get download $(debfoster -d $DEBP | grep '^ ')
  done
fi
dpkg-scanpackages . /dev/null | tee Packages | gzip > Packages.gz

#If a new key is needed, do this to create one:
# rngd -r /dev/urandom
# cat > ~/gpg_ops <<EOF
# Key-Type: 1
# Key-Length: 2048
# Subkey-Type: 1
# Subkey-Length: 2048
# Name-Real: info@pnda.io
# Name-Email: info@pnda.io
# Expire-Date: 0
# EOF
# gpg --batch --gen-key ~/gpg_ops
# gpg --output $DEB_REPO_DIR/pnda.gpg.key --armor --export info@pnda.io

apt-ftparchive release . > Release
gpg --yes --clearsign -o InRelease Release
gpg --yes -abs -o Release.gpg Release
