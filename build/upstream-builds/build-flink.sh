#!/bin/bash
#
# This script supports:
#
#   Build to specific PNDA version
#       Pass "PNDA" as first parameter
#       Pass platform-salt branch or tag as second parameter (e.g. release/3.2)
#   Build specific upstream version
#       Pass "UPSTREAM" as first parameter
#       Pass upstream branch or tag as second parameter (e.g. 1.2.3.4)

MODE=${1}
ARG=${2}
HADOOP_DISTRIBUTION=${3}

EXCLUDES="-x test"
set -e
set -x

export LC_ALL=en_US.utf8

function error {
    echo "Not Found"
    echo "Please run the build dependency installer script"
    exit -1
}

echo -n "Java 1.8: "
if [[ $($JAVA_HOME/bin/javac -version 2>&1) != "javac 1.8"* ]]; then
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

echo -n "Apache Maven 3.0.5: "
if [[ $(mvn -version 2>&1) == *"Apache Maven 3.0.5"* ]]; then
    echo "OK"
else
    error
fi

if [[ ${MODE} == "PNDA" ]]; then
    FLINK_VERSION=$(wget -qO- https://raw.githubusercontent.com/pndaproject/platform-salt/${ARG}/pillar/services.sls | shyaml get-value flink.release_version)

elif [[ ${MODE} == "UPSTREAM" ]]; then
    FLINK_VERSION=${ARG}
fi

# Using apache-flink as a upstream project
wget https://github.com/apache/flink/archive/release-${FLINK_VERSION}.tar.gz
tar xzf release-${FLINK_VERSION}.tar.gz

# Build upstream gobblin
mkdir -p pnda-build


# Build the package using maven
cd flink-release-${FLINK_VERSION}
if [[ "${HADOOP_DISTRIBUTION}" == "CDH" ]]; then
    HADOOP_VERSION=$(wget -qO- https://raw.githubusercontent.com/pndaproject/platform-salt/${ARG}/pillar/services.sls | shyaml get-value cloudera.hadoop_version)
fi
if [[ "${HADOOP_DISTRIBUTION}" == "HDP" ]]; then
    HADOOP_VERSION=$(wget -qO- https://raw.githubusercontent.com/pndaproject/platform-salt/${ARG}/pillar/services.sls | shyaml get-value hdp.hadoop_version)
fi

mvn clean install -DskipTests -Pvendor-repos -Dhadoop.version="${HADOOP_VERSION}"

if [[ "${HADOOP_DISTRIBUTION}" == "HDP" ]]; then
    JAR=$(<../../../upstream-builds/dependencies/upstream-flink-hdp-dependencies.txt)
    FLINK_LIB_DIR="./flink-dist/target/flink-${FLINK_VERSION}-bin/flink-${FLINK_VERSION}/lib"
    if [ -d $FLINK_LIB_DIR ]; then
        wget $JAR -P $FLINK_LIB_DIR
    else
        error 
    fi
fi

tar -cvf flink-${FLINK_VERSION}-${HADOOP_DISTRIBUTION}.tar.gz -C ./flink-dist/target/flink-${FLINK_VERSION}-bin/flink-${FLINK_VERSION} .
mv ./flink-${FLINK_VERSION}-${HADOOP_DISTRIBUTION}.tar.gz ../pnda-build/
sha512sum ../pnda-build/flink-${FLINK_VERSION}-${HADOOP_DISTRIBUTION}.tar.gz > ../pnda-build/flink-${FLINK_VERSION}-${HADOOP_DISTRIBUTION}.tar.gz.sha512.txt



