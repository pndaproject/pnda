#!/bin/bash -ev
export DISTRO=$(cat /etc/*-release|grep ^ID\=|awk -F\= {'print $2'}|sed s/\"//g)

[[ -z ${MIRROR_BUILD_DIR} ]] && export MIRROR_BUILD_DIR=${PWD}
[[ -z ${MIRROR_OUTPUT_DIR} ]] && export MIRROR_OUTPUT_DIR=${PWD}/mirror-dist

export PYTHON_REQ_DIR=$MIRROR_BUILD_DIR/dependencies

if [ "x$DISTRO" == "xrhel" -o "x$DISTRO" == "xcentos" ]; then
    yum install -y libffi-devel python34-pip gcc
elif [ "x$DISTRO" == "xubuntu" ]; then
    apt-get -y update
    apt-get install -y libffi-dev python3-pip gcc
fi

curl -LOJ https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo pip2 install setuptools==34.2.0
sudo pip2 install github3.py
sudo easy_install-3.4 pip==9.0.1
sudo pip3 install setuptools==34.2.0
sudo rm get-pip.py

python $MIRROR_BUILD_DIR/tools/python_download_packages.py
python $MIRROR_BUILD_DIR/tools/python_index_generator.py
