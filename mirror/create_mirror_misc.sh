#!/bin/bash -ev
export DISTRO=$(cat /etc/*-release|grep ^ID\=|awk -F\= {'print $2'}|sed s/\"//g)

if [[ "${DISTRO}" == "ubuntu" ]]; then
    apt-get install -y apt-transport-https curl
fi

[[ -z ${MIRROR_BUILD_DIR} ]] && export MIRROR_BUILD_DIR=${PWD}
[[ -z ${MIRROR_OUTPUT_DIR} ]] && export MIRROR_OUTPUT_DIR=${PWD}/mirror-dist

STATIC_FILE_LIST=$(<${MIRROR_BUILD_DIR}/dependencies/pnda-static-file-dependencies.txt)
PLUGIN_LIST=$(<${MIRROR_BUILD_DIR}/dependencies/pnda-logstash-plugin-dependencies.txt)

STATIC_FILE_DIR=$MIRROR_OUTPUT_DIR/mirror_misc
mkdir -p $STATIC_FILE_DIR
cd $STATIC_FILE_DIR
echo "$STATIC_FILE_LIST" | while read STATIC_FILE
do
    echo $STATIC_FILE
    curl -LOJ $STATIC_FILE
done
cat SHASUMS256.txt | grep node-v6.10.2-linux-x64.tar.gz > node-v6.10.2-linux-x64.tar.gz.sha1.txt
sha512sum je-5.0.73.jar > je-5.0.73.jar.sha512.txt
sha512sum Anaconda2-4.0.0-Linux-x86_64.sh > Anaconda2-4.0.0-Linux-x86_64.sh.sha512.txt

if [ "x$DISTRO" == "xrhel" ]; then
    yum install -y java-1.7.0-openjdk
elif [ "x$DISTRO" == "xubuntu" ]; then
    apt-get install -y default-jre
fi

cd /tmp
curl -LOJ https://artifacts.elastic.co/downloads/logstash/logstash-5.0.2.tar.gz
tar zxf logstash-5.0.2.tar.gz
rm logstash-5.0.2.tar.gz
cd logstash-5.0.2
bin/logstash-plugin install $PLUGIN_LIST
bin/logstash-plugin pack
mv plugins_package.tar.gz $STATIC_FILE_DIR/logstash_plugins.tar.gz
