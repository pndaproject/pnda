#!/bin/bash -v
export PYTHON_REQ_DIR=$THIS_DIR/requirements

if [ "x$DISTRO" == "xrhel" ]; then
    yum install -y libffi-devel python34-pip gcc
elif [ "x$DISTRO" == "xubuntu" ]; then
    apt-get install -y libffi-dev python3-pip gcc
fi

curl -LOJ https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo pip2 install setuptools==34.2.0
sudo pip2 install github3.py
sudo easy_install3 pip==9.0.1
sudo pip3 install setuptools==34.2.0
sudo rm get-pip.py

python $THIS_DIR/python_download_packages.py
python $THIS_DIR/python_index_generator.py