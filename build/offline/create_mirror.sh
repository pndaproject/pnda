#!/bin/bash -v
# MIRROR USAGE:

# To use the rpm mirror:
#   yum-config-manager --add-repo http://x.x.x.x/mirror_rpm
#   rpm --import http://x.x.x.x/mirror_rpm/RPM-GPG-KEY-mysql/RPM-GPG-KEY-redhat-release
#   rpm --import http://x.x.x.x/mirror_rpm/RPM-GPG-KEY-mysql
#   rpm --import http://x.x.x.x/mirror_rpm/RPM-GPG-KEY-cloudera
#   rpm --import http://x.x.x.x/mirror_rpm/RPM-GPG-KEY-EPEL-7
#   rpm --import http://x.x.x.x/mirror_rpm/SALTSTACK-GPG-KEY.pub
#   rpm --import http://x.x.x.x/mirror_rpm/RPM-GPG-KEY-CentOS-7

# To use the deb mirror
#   cat > /etc/apt/sources.list.d/local.list <<EOF
#   deb http://x.x.x.x/mirror_deb/ ./
#   EOF
#   wget -O - http://x.x.x.x/mirror_deb/pnda.gpg.key | apt-key add -
#   apt-get update

# MIRROR_BUILD_DIR: Base directory containing mirror creation scripts 
# MIRROR_OUTPUT_DIR: Root folder to download files to for mirroring (no trailing slash)
export DISTRO=$(cat /etc/*-release|grep ^ID\=|awk -F\= {'print $2'}|sed s/\"//g)

[[ -z ${MIRROR_BUILD_DIR} ]] && export MIRROR_BUILD_DIR=${PWD}
[[ -z ${MIRROR_OUTPUT_DIR} ]] && export MIRROR_OUTPUT_DIR=${PWD}/mirror-dist

if [ "x$DISTRO" == "xrhel" ]; then
    $MIRROR_BUILD_DIR/create_mirror_rpm.sh
elif [ "x$DISTRO" == "xubuntu" ]; then
    $MIRROR_BUILD_DIR/create_mirror_deb.sh
fi

$MIRROR_BUILD_DIR/create_mirror_misc.sh
$MIRROR_BUILD_DIR/create_mirror_cdh.sh
$MIRROR_BUILD_DIR/create_mirror_anaconda.sh
$MIRROR_BUILD_DIR/create_mirror_python.sh
