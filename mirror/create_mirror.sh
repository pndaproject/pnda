#!/bin/bash -v
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
$MIRROR_BUILD_DIR/create_mirror_hdp.sh
$MIRROR_BUILD_DIR/create_mirror_python.sh
