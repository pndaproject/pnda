#!/bin/bash -ev
export DISTRO=$(cat /etc/*-release|grep ^ID\=|awk -F\= {'print $2'}|sed s/\"//g)

[[ -z ${MIRROR_BUILD_DIR} ]] && export MIRROR_BUILD_DIR=${PWD}
[[ -z ${MIRROR_OUTPUT_DIR} ]] && export MIRROR_OUTPUT_DIR=${PWD}/mirror-dist

export PYTHON_REQ_DIR=$MIRROR_BUILD_DIR/dependencies

if [ "x$DISTRO" == "xrhel" ]; then
    yum install -y libffi-devel python34-pip gcc 2>&1 | tee -a yum-installer.log;
elif [ "x$DISTRO" == "xubuntu" ]; then
    apt-get -y update
    apt-get install -y libffi-dev python3-pip gcc 2>&1 | tee -a apt-installer.log;
fi

if [[ "${DISTRO}" == "ubuntu" ]]; then
    if grep -q "Unable to locate" "apt-installer.log"; then
        echo "Packages Unable to locate"
        echo $(cat apt-installer.log | grep "Unable to locate")
        exit -1;
    fi
    rm apt-installer.log
elif [[ "${DISTRO}" == "rhel" ]]; then
    if grep -q "No package" "yum-installer.log"; then
        echo "No package Available"
        echo $(cat yum-installer.log | grep "No package")
        exit -1;
    fi
    rm yum-installer.log
fi

curl -LOJf https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo pip2 install setuptools==34.2.0
sudo pip2 install github3.py
sudo easy_install-3.4 pip==9.0.1
sudo pip3 install setuptools==34.2.0
sudo rm get-pip.py

python $MIRROR_BUILD_DIR/tools/python_download_packages.py
python $MIRROR_BUILD_DIR/tools/python_index_generator.py
