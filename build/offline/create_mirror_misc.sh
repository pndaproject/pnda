#!/bin/bash -v

set -e

. create_mirror_common.sh

if [[ "${DISTRO}" == "ubuntu" ]]; then
    apt-get install -y apt-transport-https curl
fi

STATIC_FILE_LIST=$(<${MIRROR_BUILD_DIR}/pnda-static-file-dependencies.txt)
PLUGIN_LIST=$(<${MIRROR_BUILD_DIR}/pnda-logstash-plugin-dependencies.txt)

STATIC_FILE_DIR=$MIRROR_OUTPUT_DIR/mirror_misc
mkdir -p $STATIC_FILE_DIR
cd $STATIC_FILE_DIR
echo "$STATIC_FILE_LIST" | while read STATIC_FILE
do
    echo $STATIC_FILE
    download $STATIC_FILE
done

if [ "x$DISTRO" == "xrhel" ]; then
    yum install -y java-1.7.0-openjdk
elif [ "x$DISTRO" == "xubuntu" ]; then
    apt-get install -y default-jre
fi

cd /tmp
download https://download.elastic.co/logstash/logstash/logstash-1.5.4.tar.gz
tar zxf logstash-1.5.4.tar.gz
rm logstash-1.5.4.tar.gz
cd logstash-1.5.4
bin/plugin install $PLUGIN_LIST
tar zcf logstash_plugins.tar.gz Gemfile vendor/bundle/jruby/1.9/
mv logstash_plugins.tar.gz $STATIC_FILE_DIR
