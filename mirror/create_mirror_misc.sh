#!/bin/bash -ev
export DISTRO=$(cat /etc/*-release|grep ^ID\=|awk -F\= {'print $2'}|sed s/\"//g)

if [[ "${DISTRO}" == "ubuntu" ]]; then
    apt-get install -y apt-transport-https curl
fi

[[ -z ${MIRROR_BUILD_DIR} ]] && export MIRROR_BUILD_DIR=${PWD}
[[ -z ${MIRROR_OUTPUT_DIR} ]] && export MIRROR_OUTPUT_DIR=${PWD}/mirror-dist

export ANACONDA_VERSION="5.1.0"

STATIC_FILE_LIST=$(<${MIRROR_BUILD_DIR}/dependencies/pnda-static-file-dependencies.txt)
PLUGIN_LIST=$(<${MIRROR_BUILD_DIR}/dependencies/pnda-logstash-plugin-dependencies.txt)
source ${MIRROR_BUILD_DIR}/common/utils.sh

STATIC_FILE_DIR=$MIRROR_OUTPUT_DIR/mirror_misc
mkdir -p $STATIC_FILE_DIR
cd $STATIC_FILE_DIR
echo "$STATIC_FILE_LIST" | while read STATIC_FILE
do
    eval echo "$STATIC_FILE"
    eval robust_curl "$STATIC_FILE"
done
cat SHASUMS256.txt | grep node-v6.10.2-linux-x64.tar.gz > node-v6.10.2-linux-x64.tar.gz.sha1.txt
sha512sum je-5.0.73.jar > je-5.0.73.jar.sha512.txt
sha512sum Anaconda2-${ANACONDA_VERSION}-Linux-x86_64.sh > Anaconda2-${ANACONDA_VERSION}-Linux-x86_64.sh.sha512.txt

if [ "x$DISTRO" == "xrhel" -o "x$DISTRO" == "xcentos" ]; then
    yum install -y java-1.7.0-openjdk
    yum install -y postgresql-devel
elif [ "x$DISTRO" == "xubuntu" ]; then
    apt-get install -y default-jre
    apt-get install -y libpq-dev
fi

cd /tmp
LOGSTASH_VERSION=6.2.1
robust_curl https://artifacts.elastic.co/downloads/logstash/logstash-${LOGSTASH_VERSION}.tar.gz
tar zxf logstash-${LOGSTASH_VERSION}.tar.gz
rm logstash-${LOGSTASH_VERSION}.tar.gz
cd logstash-${LOGSTASH_VERSION}
# work around bug introduced in 5.1.1: https://discuss.elastic.co/t/5-1-1-plugin-installation-behind-proxy/70454
JARS_SKIP='true' bin/logstash-plugin install $PLUGIN_LIST
bin/logstash-plugin prepare-offline-pack $PLUGIN_LIST
chmod a+r logstash-offline-plugins-${LOGSTASH_VERSION}.zip
mv logstash-offline-plugins-${LOGSTASH_VERSION}.zip $STATIC_FILE_DIR/logstash-offline-plugins-${LOGSTASH_VERSION}.zip	
