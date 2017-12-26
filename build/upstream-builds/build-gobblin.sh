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
#   Here,
#       We clone the entire apache gobblin-incubator repository.
#       Add the gobblin-PNDA classes from dependency classes in the apache gobblin as a module.
#       Build the gobblin-PNDA jar along with other dependencies from the apache.

MODE=${1}
ARG=${2}

EXCLUDES="-x test"
set -e
set -x

export LC_ALL=en_US.utf8
HADOOP_VERSION=2.6.0-cdh5.9.0

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


if [[ ${MODE} == "PNDA" ]]; then
    GB_VERSION=$(wget -qO- https://raw.githubusercontent.com/pndaproject/platform-salt/${ARG}/pillar/services.sls | shyaml get-value gobblin.release_version)

elif [[ ${MODE} == "UPSTREAM" ]]; then
    GB_VERSION=${ARG}
fi

# Download the upstream and pnda-gobblin repository
git clone https://github.com/pndaproject/platform-gobblin-modules.git
wget https://github.com/apache/incubator-gobblin/archive/gobblin_${GB_VERSION}.tar.gz
tar xzf gobblin_${GB_VERSION}.tar.gz

# Build upstream gobblin
mkdir -p pnda-build

cd incubator-gobblin-gobblin_${GB_VERSION}
if ! fgrep -q 'tasks.withType(Javadoc).all { enabled = false }' build.gradle; then
cat >> build.gradle << EOF
subprojects {
  tasks.withType(Javadoc).all { enabled = false }
}
EOF
fi

./gradlew build -Pversion="${GB_VERSION}" -PhadoopVersion="${HADOOP_VERSION}" -PexcludeHadoopDeps -PexcludeHiveDeps ${EXCLUDES}
mv gobblin-distribution-${GB_VERSION}.tar.gz ../platform-gobblin-modules/

# Build PNDA gobblin modules
cd ../platform-gobblin-modules
tar xvf gobblin-distribution-${GB_VERSION}.tar.gz
rm gobblin-distribution-${GB_VERSION}.tar.gz
./gradlew build -Pversion="${GB_VERSION}"
cp -rvf ./build/libs/* ./gobblin-dist/lib/
rm -rf ./build/libs/*
tar -cvf gobblin-distribution-${GB_VERSION}.tar.gz ./gobblin-dist
mv gobblin-distribution-${GB_VERSION}.tar.gz ../pnda-build/
cd ..
sha512sum pnda-build/gobblin-distribution-${GB_VERSION}.tar.gz > pnda-build/gobblin-distribution-${GB_VERSION}.tar.gz.sha512.txt

