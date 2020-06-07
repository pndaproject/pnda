#!/bin/bash -ev
[[ -z ${MIRROR_BUILD_DIR} ]] && export MIRROR_BUILD_DIR=${PWD}
[[ -z ${MIRROR_OUTPUT_DIR} ]] && export MIRROR_OUTPUT_DIR=${PWD}/mirror-dist
source dependencies/versions.sh

RPM_EPEL=https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y $RPM_EPEL || true

export PYTHON_REQ_DIR=$MIRROR_BUILD_DIR/dependencies

(yum install -y libffi-devel postgresql-devel python34 python34-pip python-devel gcc) | tee -a yum-python-deps.log; cmd_result=${PIPESTATUS[0]} && if [ ${cmd_result} != '0' ]; then exit ${cmd_result}; fi
if grep -q 'No package .* available.' "yum-python-deps.log"; then
    echo "missing rpm detected:"
    echo $(cat yum-python-deps.log | grep 'No package .* available.')
    exit -1
fi

curl -sS -LOJf https://bootstrap.pypa.io/get-pip.py
python get-pip.py
pip2 install setuptools==39.1.0
pip2 install github3.py==1.1.0
pip3.4 install setuptools==39.1.0
rm get-pip.py

python $MIRROR_BUILD_DIR/tools/python_download_packages.py
python $MIRROR_BUILD_DIR/tools/python_index_generator.py
