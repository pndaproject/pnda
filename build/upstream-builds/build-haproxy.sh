#!/bin/bash
#
# This script supports two use cases:
#
#   Build HAProxy corresponding to specific PNDA version
#       Pass "PNDA" as first parameter
#       Pass platform-salt branch or tag as second parameter (e.g. release/3.2)
#   Build specific HAProxy version
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
    HA_VERSION=$(wget -qO- https://raw.githubusercontent.com/pndaproject/platform-salt/${ARG}/pillar/services.sls | shyaml get-value haproxy.release_version)
elif [[ ${MODE} == "UPSTREAM" ]]; then
    HA_VERSION=${ARG}
fi

wget https://www.haproxy.org/download/1.8/src/haproxy-${HA_VERSION}.tar.gz
tar xzf haproxy-${HA_VERSION}.tar.gz

mkdir -p pnda-build
cd haproxy-${HA_VERSION}
make \
  TARGET=linux2628 CPU=generic CC=gcc CFLAGS="-O2 -g -fno-strict-aliasing -DTCP_USER_TIMEOUT=18" \
  USE_LINUX_TPROXY=1 USE_ZLIB=1 USE_REGPARM=1 USE_OPENSSL=1 USE_PCRE=1

cd ..
tar czf haproxy-${HA_VERSION}.tar.gz haproxy-${HA_VERSION}
mv haproxy-${HA_VERSION}.tar.gz pnda-build/
sha512sum pnda-build/haproxy-${HA_VERSION}.tar.gz > pnda-build/haproxy-${HA_VERSION}.tar.gz.sha512.txt
