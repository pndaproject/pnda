#!/bin/bash
#
# This script supports two use cases:
#
#   Build Livy corresponding to specific PNDA version
#       Pass "PNDA" as first parameter
#       Pass platform-salt branch or tag as second parameter (e.g. release/3.2)
#   Build specific Livy version
#       Pass "UPSTREAM" as first parameter
#       Pass upstream branch or tag as second parameter (e.g. 1.2.3.4)
#

MODE=${1}
ARG=${2}

function error {
    echo "Not Found"
    echo "Please run the build dependency installer script"
    exit -1
}


echo -n "shyaml: "
if [[ -z $(which shyaml) ]]; then
    error
else
    echo "OK"
fi

if [[ ${MODE} == "PNDA" ]]; then
    LV_VERSION=$(wget -qO- https://raw.githubusercontent.com/pndaproject/platform-salt/${ARG}/pillar/services.sls | shyaml get-value livy.release_version)
elif [[ ${MODE} == "UPSTREAM" ]]; then
    LV_VERSION=${ARG}
fi


# Building Livy requires specific version of setuptools (>=30.0.0). Upgrading setuptools to latest version as existing version does not match the specification.
pip2 install setuptools --upgrade

wget https://github.com/cloudera/livy/archive/v${LV_VERSION}.tar.gz
tar xzf v${LV_VERSION}.tar.gz

mkdir -p pnda-build
cd livy-${LV_VERSION}
mvn -e package -DskipTests

cd ..
tar czf livy-${LV_VERSION}.tar.gz livy-${LV_VERSION}
mv livy-${LV_VERSION}.tar.gz pnda-build/
sha512sum pnda-build/livy-${LV_VERSION}.tar.gz > pnda-build/livy-${LV_VERSION}.tar.gz.sha512.txt
