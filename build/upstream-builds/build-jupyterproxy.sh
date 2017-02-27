#!/bin/bash
#
# This script supports two use cases:
#
#   Build to specific PNDA version
#       Pass "PNDA" as first parameter
#       Pass platform-salt branch or tag as second parameter (e.g. release/3.2)
#   Build specific upstream version
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

echo -n "npm: "
NPM_VERSION=$(npm --version 2>&1)
if [[ ${NPM_VERSION} == "1.3"* ]] || [[ ${NPM_VERSION} == "3.5.2" ]] || [[ ${NPM_VERSION} == "3.10"* ]]; then
    echo "OK"
else
    error
fi

echo -n "shyaml: "
if [[ -z $(which shyaml) ]]; then
    error
else
    echo "OK"
fi

if [[ ${MODE} == "PNDA" ]]; then
    JP_VERSION=$(wget -qO- https://raw.githubusercontent.com/pndaproject/platform-salt/${ARG}/pillar/services.sls | shyaml get-value jupyterproxy.release_version)
elif [[ ${MODE} == "UPSTREAM" ]]; then
    JP_VERSION=${ARG}
fi

wget https://github.com/jupyterhub/configurable-http-proxy/archive/${JP_VERSION}.tar.gz
tar xzf ${JP_VERSION}.tar.gz

mkdir -p pnda-build
cd configurable-http-proxy-${JP_VERSION}
npm install
cd ..
tar zcf jupyterproxy-${JP_VERSION}.tar.gz configurable-http-proxy-${JP_VERSION}
mv jupyterproxy-${JP_VERSION}.tar.gz pnda-build/
sha512sum pnda-build/jupyterproxy-${JP_VERSION}.tar.gz > pnda-build/jupyterproxy-${JP_VERSION}.tar.gz.sha512.txt
