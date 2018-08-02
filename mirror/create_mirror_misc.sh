#!/bin/bash -ev
[[ -z ${MIRROR_BUILD_DIR} ]] && export MIRROR_BUILD_DIR=${PWD}
[[ -z ${MIRROR_OUTPUT_DIR} ]] && export MIRROR_OUTPUT_DIR=${PWD}/mirror-dist
source dependencies/versions.sh

STATIC_FILE_LIST=$(envsubst < ${MIRROR_BUILD_DIR}/dependencies/pnda-static-file-dependencies.txt)
PLUGIN_LIST=$(envsubst < ${MIRROR_BUILD_DIR}/dependencies/pnda-logstash-plugin-dependencies.txt)

source ${MIRROR_BUILD_DIR}/common/utils.sh

STATIC_FILE_DIR=$MIRROR_OUTPUT_DIR/mirror_misc
mkdir -p $STATIC_FILE_DIR
cd $STATIC_FILE_DIR
echo "$STATIC_FILE_LIST" | while read STATIC_FILE
do
    echo "$STATIC_FILE"
    robust_curl "$STATIC_FILE"
done
cat SHASUMS256.txt | grep node-v${NODE_VERSION}-linux-x64.tar.gz > node-v${NODE_VERSION}-linux-x64.tar.gz.sha1.txt
sha512sum je-${JE_VERSION}.jar > je-${JE_VERSION}.jar.sha512.txt
sha512sum Anaconda2-${ANACONDA_VERSION}-Linux-x86_64.sh > Anaconda2-${ANACONDA_VERSION}-Linux-x86_64.sh.sha512.txt

yum install -y java-1.7.0-openjdk
yum install -y postgresql-devel

cd /tmp
robust_curl https://artifacts.elastic.co/downloads/logstash/logstash-${LOGSTASH_VERSION}.tar.gz
tar zxf logstash-${LOGSTASH_VERSION}.tar.gz
rm logstash-${LOGSTASH_VERSION}.tar.gz
cd logstash-${LOGSTASH_VERSION}
# work around bug introduced in 5.1.1: https://discuss.elastic.co/t/5-1-1-plugin-installation-behind-proxy/70454
JARS_SKIP='true' bin/logstash-plugin install $PLUGIN_LIST
bin/logstash-plugin prepare-offline-pack $PLUGIN_LIST
chmod a+r logstash-offline-plugins-${LOGSTASH_VERSION}.zip
mv logstash-offline-plugins-${LOGSTASH_VERSION}.zip $STATIC_FILE_DIR/logstash-offline-plugins-${LOGSTASH_VERSION}.zip	
