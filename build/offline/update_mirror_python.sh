#!/bin/bash
echo "Usage: ./update_mirror_python.sh /path/to/mirror_python a-package [another-package ...]"
DISTRO=$(cat /etc/*-release|grep ^ID\=|awk -F\= {'print $2'}|sed s/\"//g)
if [ "x$DISTRO" == "xrhel" ]; then
    yum install -y libffi-devel gcc
elif [ "x$DISTRO" == "xubuntu" ]; then
    apt-get -y update
    apt-get install -y libffi-dev gcc
fi

curl -LOJ https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo pip2 install setuptools==34.2.0

export MIRROR_OUTPUT_DIR=${1/\/mirror_python/}
if [ "$#" -gt 1 ]; then
python << END
import os
import subprocess

package_path=os.environ['MIRROR_OUTPUT_DIR']+"/mirror_python/packages"
# init directory
if not os.path.exists(package_path):
    os.makedirs(package_path)

for one_dep in "${@:2}".split():
    subprocess.call(["pip2","download", "--no-deps", one_dep,"--no-binary",":all:","-d",package_path])
END
fi

python python_index_generator.py
