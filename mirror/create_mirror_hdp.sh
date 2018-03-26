#!/bin/bash -ev
export DISTRO=$(cat /etc/*-release|grep ^ID\=|awk -F\= {'print $2'}|sed s/\"//g)

if [[ "${DISTRO}" == "ubuntu" ]]; then
    apt-get install -y apt-transport-https curl
fi

[[ -z ${MIRROR_BUILD_DIR} ]] && export MIRROR_BUILD_DIR=${PWD}
[[ -z ${MIRROR_OUTPUT_DIR} ]] && export MIRROR_OUTPUT_DIR=${PWD}/mirror-dist
source dependencies/versions.sh
source ${MIRROR_BUILD_DIR}/common/utils.sh

HDP_FILE_LIST=$(envsubst < ${MIRROR_BUILD_DIR}/dependencies/pnda-hdp-resources.txt)

HDP_REPO_FILE_DIR=$MIRROR_OUTPUT_DIR/mirror_hdp
mkdir -p $HDP_REPO_FILE_DIR
cd $HDP_REPO_FILE_DIR

echo "$HDP_FILE_LIST" | while read HDP_FILE
do
    echo $HDP_FILE
    robust_curl "$HDP_FILE"
done

if [ "x$DISTRO" == "xubuntu" ]; then
    apt-key adv --recv-keys --keyserver keyserver.ubuntu.com B9733A7A07513CAD
    apt-key export 'Jenkins (HDP Builds) <jenkin@hortonworks.com>' > hdp.gpg.key
fi

tar zxf HDP-${HDP_VERSION}-centos7-rpm.tar.gz
tar zxf HDP-${HDP_VERSION}-ubuntu14-deb.tar.gz

mkdir -p HDP-UTILS-${HDP_UTILS_VERSION}/repos/ubuntu14/
tar zxf HDP-UTILS-${HDP_UTILS_VERSION}-ubuntu14.tar.gz -C "HDP-UTILS-${HDP_UTILS_VERSION}/repos/ubuntu14/"
mkdir -p HDP-UTILS-${HDP_UTILS_VERSION}/repos/centos7/
tar zxf HDP-UTILS-${HDP_UTILS_VERSION}-centos7.tar.gz -C "HDP-UTILS-${HDP_UTILS_VERSION}/repos/centos7/"

rm -f HDP-${HDP_VERSION}-centos7-rpm.tar.gz
rm -f HDP-${HDP_VERSION}-ubuntu14-deb.tar.gz
rm -f HDP-UTILS-${HDP_UTILS_VERSION}-centos7.tar.gz
rm -f HDP-UTILS-${HDP_UTILS_VERSION}-ubuntu14.tar.gz
