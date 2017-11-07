#!/bin/bash -ev
export DISTRO=$(cat /etc/*-release|grep ^ID\=|awk -F\= {'print $2'}|sed s/\"//g)

if [[ "${DISTRO}" == "ubuntu" ]]; then
    apt-get install -y apt-transport-https curl
fi

[[ -z ${MIRROR_BUILD_DIR} ]] && export MIRROR_BUILD_DIR=${PWD}
[[ -z ${MIRROR_OUTPUT_DIR} ]] && export MIRROR_OUTPUT_DIR=${PWD}/mirror-dist

HDP_FILE_LIST=$(<${MIRROR_BUILD_DIR}/dependencies/pnda-hdp-resources.txt)

HDP_REPO_FILE_DIR=$MIRROR_OUTPUT_DIR/mirror_hdp
mkdir -p $HDP_REPO_FILE_DIR
cd $HDP_REPO_FILE_DIR

echo "$HDP_FILE_LIST" | while read HDP_FILE
do
    echo $HDP_FILE
    curl -LOJf --retry 5 --retry-max-time 0 $HDP_FILE
done

tar zxf HDP-2.6.0.3-centos7-rpm.tar.gz
tar zxf HDP-2.6.0.3-ubuntu14-deb.tar.gz
mkdir -p HDP-UTILS-1.1.0.21/repos/ubuntu14/
tar zxf HDP-UTILS-1.1.0.21-ubuntu14.tar.gz -C 'HDP-UTILS-1.1.0.21/repos/ubuntu14/'
mkdir -p HDP-UTILS-1.1.0.21/repos/centos7/
tar zxf HDP-UTILS-1.1.0.21-centos7.tar.gz -C 'HDP-UTILS-1.1.0.21/repos/centos7/'
