#!/bin/bash
#
# This script supports two use cases:
#
#   Build Kafka Manager corresponding to specific PNDA version
#       Pass "PNDA" as first parameter
#       Pass platform-salt branch or tag as second parameter (e.g. release/3.2)
#   Build specific Kafka Manager version
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

echo -n "sbt: "
if [[ $(sbt about 2>&1) != *"This is sbt 0.13"* ]]; then
    error
else
    echo "OK"
fi

echo -n "shyaml: "
if [[ -z $(which shyaml) ]]; then
    error
else
    echo "OK"
fi

if [[ ${MODE} == "PNDA" ]]; then
    KM_VERSION=$(wget -qO- https://raw.githubusercontent.com/pndaproject/platform-salt/${ARG}/pillar/services.sls | shyaml get-value kafkamanager.release_version)
elif [[ ${MODE} == "UPSTREAM" ]]; then
    KM_VERSION=${ARG}
fi
    
wget https://github.com/yahoo/kafka-manager/archive/${KM_VERSION}.tar.gz
tar xzf ${KM_VERSION}.tar.gz

if [ ! -f ~/.sbt/0.13/local.sbt ]; then
	mkdir -p ~/.sbt/0.13
	echo 'scalacOptions ++= Seq("-Xmax-classfile-name","100")' >> ~/.sbt/0.13/local.sbt
fi

mkdir -p pnda-build
cd kafka-manager-${KM_VERSION}
sbt clean dist
cd ..
mv kafka-manager-${KM_VERSION}/target/universal/kafka-manager-${KM_VERSION}.zip pnda-build/
sha512sum pnda-build/kafka-manager-${KM_VERSION}.zip > pnda-build/kafka-manager-${KM_VERSION}.zip.sha512.txt

#kafkat build process
git clone https://github.com/airbnb/kafkat.git
cd kafkat
gem build kafkat.gemspec
cd ..
mkdir -p pnda-build
tar -cvzf kafkat.tar.gz kafkat
mv kafkat.tar.gz pnda-build/
sha512sum pnda-build/kafkat.tar.gz > pnda-build/kafkat.tar.gz.sha512.txt
