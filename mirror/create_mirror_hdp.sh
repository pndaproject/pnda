#!/bin/bash -v
export DISTRO=$(cat /etc/*-release|grep ^ID\=|awk -F\= {'print $2'}|sed s/\"//g)

if [[ "${DISTRO}" == "ubuntu" ]]; then
    apt-get install -y apt-transport-https curl
fi

[[ -z ${MIRROR_OUTPUT_DIR} ]] && export MIRROR_OUTPUT_DIR=${PWD}/mirror-dist


HDP_REPO_FILE_DIR=$MIRROR_OUTPUT_DIR/mirror_hdp
mkdir -p $HDP_REPO_FILE_DIR
cd $HDP_REPO_FILE_DIR

curl -LOJ http://public-repo-1.hortonworks.com/HDP/centos7/2.x/updates/2.6.0.3/HDP-2.6.0.3-centos7-rpm.tar.gz
curl -LOJ http://public-repo-1.hortonworks.com/HDP-UTILS-1.1.0.21/repos/centos7/HDP-UTILS-1.1.0.21-centos7.tar.gz
curl -LOJ http://public-repo-1.hortonworks.com/HDP/ubuntu14/2.x/updates/2.6.0.3/HDP-2.6.0.3-ubuntu14-deb.tar.gz
curl -LOJ http://public-repo-1.hortonworks.com/HDP-UTILS-1.1.0.21/repos/ubuntu14/HDP-UTILS-1.1.0.21-ubuntu14.tar.gz
tar zxf HDP-2.6.0.3-centos7-rpm.tar.gz
tar zxf HDP-2.6.0.3-ubuntu14-deb.tar.gz
tar zxf HDP-UTILS-1.1.0.21-ubuntu14.tar.gz
mkdir -p HDP-UTILS-1.1.0.21/repos/centos7/
tar zxf HDP-UTILS-1.1.0.21-centos7.tar.gz -C 'HDP-UTILS-1.1.0.21/repos/centos7/'
