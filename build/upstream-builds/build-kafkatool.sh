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


echo -n "shyaml: "
if [[ -z $(which shyaml) ]]; then
    error
else
    echo "OK"
fi

if [[ ${MODE} == "PNDA" ]]; then
    KT_VERSION=$(wget -qO- https://raw.githubusercontent.com/pndaproject/platform-salt/${ARG}/pillar/services.sls | shyaml get-value kafkatool.release_version)
elif [[ ${MODE} == "UPSTREAM" ]]; then
    KT_VERSION=${ARG}
fi

echo `pwd`
git clone https://github.com/airbnb/kafkat.git
mkdir -p pnda-build
mv kafkat kafka-tool-${KT_VERSION}
cd kafka-tool-${KT_VERSION}
git checkout tags/${KT_VERSION}
gem build kafkat.gemspec
mv kafkat*.gem kafkat-${KT_VERSION}.gem
cd ..
tar czf kafka-tool-${KT_VERSION}.tar.gz kafka-tool-${KT_VERSION}
mv kafka-tool-${KT_VERSION}.tar.gz pnda-build/
sha512sum pnda-build/kafka-tool-${KT_VERSION}.tar.gz > pnda-build/kafka-tool-${KT_VERSION}.tar.gz.sha512.txt
