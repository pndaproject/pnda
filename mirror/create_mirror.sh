#!/bin/bash -v
#
# This script creates the mirror needed to provision PNDA.
#
# Please refer to README.md in this directory for more details
#
# Note: this script uses bash 4 features

HADOOP_DISTRIBUTION=${1}
export DISTRO=$(cat /etc/*-release|grep ^ID\=|awk -F\= {'print $2'}|sed s/\"//g)

[[ -z ${MIRROR_BUILD_DIR} ]] && export MIRROR_BUILD_DIR=${PWD}
[[ -z ${MIRROR_OUTPUT_DIR} ]] && export MIRROR_OUTPUT_DIR=${PWD}/mirror-dist

function invocation_error {
    echo "Incorrect invocation, please refer to notes at head of this script"
    exit -1
}

[[ -z ${HADOOP_DISTRIBUTION} ]] && invocation_error

if [ "x$DISTRO" == "xrhel" ]; then
	echo "Use of Red Hat software is governed by your agreement with Red Hat."
	echo "In order to proceed, you must have a valid Red Hat subscription and software image on your system."

	read -p "Do you wish to proceed? [Yes/No]  " yn
	case $yn in
	  [Yy]* ) echo "Thanks";;
	  [Nn]* ) exit;;
	  * ) echo "Please answer yes or no.";;
	esac
fi

$MIRROR_BUILD_DIR/create_mirror_rpm.sh
[[ $? -ne 0 ]] && mirror_error "Problem while creating os package mirror"

$MIRROR_BUILD_DIR/create_mirror_misc.sh
[[ $? -ne 0 ]] && mirror_error "Problem while creating misc package mirror"

if [[ 'CDH' == ${HADOOP_DISTRIBUTION} ]]; then
  $MIRROR_BUILD_DIR/create_mirror_cdh.sh
  [[ $? -ne 0 ]] && mirror_error "Problem while creating cdh package mirror"
fi
if [[ 'HDP' == ${HADOOP_DISTRIBUTION} ]]; then
  $MIRROR_BUILD_DIR/create_mirror_hdp.sh
  [[ $? -ne 0 ]] && mirror_error "Problem while creating hdp package mirror"
fi

$MIRROR_BUILD_DIR/create_mirror_python.sh
[[ $? -ne 0 ]] && mirror_error "Problem while creating python package mirror"

$MIRROR_BUILD_DIR/create_mirror_apps.sh
[[ $? -ne 0 ]] && mirror_error "Problem while creating app package mirror"

exit 0
