#!/bin/bash -ev
export DISTRO=$(cat /etc/*-release|grep ^ID\=|awk -F\= {'print $2'}|sed s/\"//g)

[[ -z ${MIRROR_BUILD_DIR} ]] && export MIRROR_BUILD_DIR=${PWD}
[[ -z ${MIRROR_OUTPUT_DIR} ]] && export MIRROR_OUTPUT_DIR=${PWD}/mirror-dist

export PYTHON_REQ_DIR=$MIRROR_BUILD_DIR/dependencies

if [ "x$DISTRO" == "xrhel" -o "x$DISTRO" == "xcentos" ]; then
    yum install -y libffi-devel python34-pip python-devel gcc
elif [ "x$DISTRO" == "xubuntu" ]; then
    apt-get -y update
    apt-get install -y libffi-dev python3-pip gcc
fi

curl -LOJf https://bootstrap.pypa.io/get-pip.py
python get-pip.py
pip2 install setuptools==34.2.0
pip2 install github3.py
python3 get-pip.py
pip3 install setuptools==34.2.0
rm get-pip.py

python $MIRROR_BUILD_DIR/tools/python_download_packages.py
python $MIRROR_BUILD_DIR/tools/python_index_generator.py
