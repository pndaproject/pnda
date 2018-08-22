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

function build_error {
    echo "Build error"
    echo "Please determine the reason for the error, correct and re-run"
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

wget https://github.com/apache/incubator-gobblin/archive/gobblin_${GB_VERSION}.tar.gz
[[ $? -ne 0 ]] && error
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

# Add HDP Repositories to the gradle.
line_number=$(grep -n "repository.cloudera.com" defaultEnvironment.gradle |cut -f1 -d:)
line_number=$((line_number+2))
hdp_repo_1='\tmaven {\n\turl "http://repo.hortonworks.com/content/repositories/releases/"\n\t}'
hdp_repo_2='\tmaven {\n\turl "http://repo.hortonworks.com/content/repositories/jetty-hadoop/"\n\t}'
sed -i "$line_number"'i\'"$hdp_repo_1"'\n'"$hdp_repo_2" defaultEnvironment.gradle

if [[ "${HADOOP_DISTRIBUTION}" == "CDH" ]]; then
    HADOOP_VERSION=$(wget -qO- https://raw.githubusercontent.com/pndaproject/platform-salt/${ARG}/pillar/services.sls | shyaml get-value cloudera.hadoop_version)
fi
if [[ "${HADOOP_DISTRIBUTION}" == "HDP" ]]; then
    HADOOP_VERSION=$(wget -qO- https://raw.githubusercontent.com/pndaproject/platform-salt/${ARG}/pillar/services.sls | shyaml get-value hdp.hadoop_version)
fi

./gradlew build -Pversion="${GB_VERSION}-${HADOOP_DISTRIBUTION}-${HADOOP_VERSION}" -PhadoopVersion="${HADOOP_VERSION}" -PexcludeHadoopDeps -PexcludeHiveDeps ${EXCLUDES}
[[ $? -ne 0 ]] && build_error

mv ./build/gobblin-distribution/distributions/gobblin-distribution-${GB_VERSION}-${HADOOP_DISTRIBUTION}-${HADOOP_VERSION}.tar.gz ../pnda-build/
sha512sum ../pnda-build/gobblin-distribution-${GB_VERSION}-${HADOOP_DISTRIBUTION}-${HADOOP_VERSION}.tar.gz > ../pnda-build/gobblin-distribution-${GB_VERSION}-${HADOOP_DISTRIBUTION}-${HADOOP_VERSION}.tar.gz.sha512.txt
