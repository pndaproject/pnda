#!/bin/bash -ev
export DISTRO=$(cat /etc/*-release|grep ^ID\=|awk -F\= {'print $2'}|sed s/\"//g)

if [[ "${DISTRO}" == "ubuntu" ]]; then
    apt-get install -y apt-transport-https curl
fi

[[ -z ${MIRROR_BUILD_DIR} ]] && export MIRROR_BUILD_DIR=${PWD}
[[ -z ${MIRROR_OUTPUT_DIR} ]] && export MIRROR_OUTPUT_DIR=${PWD}/mirror-dist
source ${MIRROR_BUILD_DIR}/common/utils.sh

HDP_FILE_LIST=$(<${MIRROR_BUILD_DIR}/dependencies/pnda-hdp-resources.txt)

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

tar zxf HDP-2.6.4.0-centos7-rpm.tar.gz
tar zxf HDP-2.6.4.0-ubuntu14-deb.tar.gz

# HDP utils directory structure was changed, so fix it up to match what PNDA is expecting
tar zxf HDP-UTILS-1.1.0.22-ubuntu14.tar.gz
mkdir -p HDP-UTILS-1.1.0.22/repos/
mv HDP-UTILS/ubuntu14/1.1.0.22 HDP-UTILS-1.1.0.22/repos/ubuntu14
rm -rf HDP-UTILS

# HDP utils directory structure was changed, so fix it up to match what PNDA is expecting
tar zxf HDP-UTILS-1.1.0.22-centos7.tar.gz
mkdir -p HDP-UTILS-1.1.0.22/repos/
mv HDP-UTILS/centos7/1.1.0.22 HDP-UTILS-1.1.0.22/repos/centos7
rm -rf HDP-UTILS

rm -f HDP-2.6.4.0-centos7-rpm.tar.gz
rm -f HDP-2.6.4.0-ubuntu14-deb.tar.gz
rm -f HDP-UTILS-1.1.0.22-centos7.tar.gz
rm -f HDP-UTILS-1.1.0.22-ubuntu14.tar.gz
