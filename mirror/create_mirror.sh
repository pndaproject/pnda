#!/bin/bash -v
export DISTRO=$(cat /etc/*-release|grep ^ID\=|awk -F\= {'print $2'}|sed s/\"//g)

[[ -z ${MIRROR_BUILD_DIR} ]] && export MIRROR_BUILD_DIR=${PWD}
[[ -z ${MIRROR_OUTPUT_DIR} ]] && export MIRROR_OUTPUT_DIR=${PWD}/mirror-dist

function mirror_error {
    echo "ERROR: $1"
    exit -1
}

if [ "x$DISTRO" == "xrhel" -o "x$DISTRO" == "xcentos" ]; then
	echo "Use of Red Hat software is governed by your agreement with Red Hat."
	echo "In order to proceed, you must have a valid Red Hat subscription and software image on your system."

	read -p "Do you wish to proceed? [Yes/No]  " yn
	case $yn in
	  [Yy]* ) echo "Thanks";;
	  [Nn]* ) exit;;
	  * ) echo "Please answer yes or no.";;
	esac
fi

if [ "x$DISTRO" == "xrhel" -o "x$DISTRO" == "xcentos" ]; then
    $MIRROR_BUILD_DIR/create_mirror_rpm.sh
elif [ "x$DISTRO" == "xubuntu" ]; then
    $MIRROR_BUILD_DIR/create_mirror_deb.sh
fi

[[ $? -ne 0 ]] && mirror_error "Problem while creating os package mirror"

$MIRROR_BUILD_DIR/create_mirror_misc.sh
[[ $? -ne 0 ]] && mirror_error "Problem while creating misc package mirror"

$MIRROR_BUILD_DIR/create_mirror_cdh.sh
[[ $? -ne 0 ]] && mirror_error "Problem while creating cdh package mirror"

$MIRROR_BUILD_DIR/create_mirror_anaconda.sh
[[ $? -ne 0 ]] && mirror_error "Problem while creating anaconda package mirror"

$MIRROR_BUILD_DIR/create_mirror_hdp.sh
[[ $? -ne 0 ]] && mirror_error "Problem while creating hdp package mirror"

$MIRROR_BUILD_DIR/create_mirror_python.sh
[[ $? -ne 0 ]] && mirror_error "Problem while creating python package mirror"

$MIRROR_BUILD_DIR/create_mirror_apps.sh
[[ $? -ne 0 ]] && mirror_error "Problem while creating app package mirror"

exit 0
