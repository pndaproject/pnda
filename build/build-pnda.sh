#!/bin/bash
#   Copyright (c) 2016 Cisco and/or its affiliates.
#   This software is licensed to you under the terms of the Apache License, Version 2.0
#   (the "License").
#   You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#   The code, technical concepts, and all information contained herein, are the property of
#   Cisco Technology, Inc.and/or its affiliated entities, under various laws including copyright,
#   international treaties, patent, and/or contract.
#   Any use of the material herein must be in accordance with the terms of the License.
#   All rights not expressly granted by the License are reserved.
#   Unless required by applicable law or agreed to separately in writing, software distributed
#   under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
#   ANY KIND, either express or implied.
#
# This script builds the packages needed to provision PNDA. These include:
#   PNDA components - source code that is part of PNDA e.g. platform-deployment-manager
#   Upstream projects - source code of projects that PNDA depends on e.g. Kafka Manager
#
# This script supports three use cases:
#
#   Build latest PNDA components & upstream projects to a given branch or tag
#     Pass "BRANCH" as first parameter
#     Pass PNDA branch or tag as the second parameter (e.g. develop)
#     PNDA components are built with the version specifier set to the branch or tag
#
#   Build master PNDA components & upstream projects at release X
#     Pass "RELEASE" as first parameter
#     Pass PNDA release tag as second parameter (e.g. release/3.2)
#     PNDA components are built with the version specifier set to corresponding component release (e.g. 0.1.2)
#
#   Build PNDA components & upstream projects to specific 'BOM'
#     Pass "BOM" as first parameter
#     Pass a file path as the second parameter (e.g. /home/alice/bomfile)
#     The file must contain a list of space delimited component/project version pairs
#
# Please refer to README.md in this directory for more details
#
# Note: this script uses bash 4 features and has been tested on Ubuntu 14.04

MODE=${1}
ARG=${2}

export DISTRO=$(cat /etc/*-release|grep ^ID\=|awk -F\= {'print $2'}|sed s/\"//g)
if [[ "${DISTRO}" == "rhel" ]]; then
  echo "Use of Red Hat software is governed by your agreement with Red Hat."
  echo "In order to proceed, you must have a valid Red Hat subscription and software image on your system."

  read -p "Do you wish to proceed? [Yes/No]  " yn
  case $yn in
      [Yy]* ) echo "Thanks";;
      [Nn]* ) exit;;
      * ) echo "Please answer yes or no.";;
  esac
fi

function invocation_error {
    echo "Incorrect invocation, please refer to notes at head of this script"
    exit -1
}

# List of PNDA components
#
declare -A bom=(
[platform-console-backend]=
[platform-console-frontend]=
[platform-data-mgmnt]=
[platform-deployment-manager]=
[platform-libraries]=
[platform-package-repository]=
[platform-testing]=
[platform-gobblin-modules]=
)

# List of upstream projects
#
declare -A upstream=(
[kafkamanager]=
[jupyterproxy]=
[kafkatool]=
[livy]=
[gobblin]=
[flink]=
)

function fill_bom {
    for repo in ${!bom[@]}
    do 
        bom[${repo}]=${1}
    done 
    
    for project in ${!upstream[@]}
    do 
        upstream[${project}]=${1}
    done 
}

function bom_error {
    echo "Malformed BOM, please refer to notes at head of this script"
    exit -1
}

if [[ ${MODE} == "BOM" ]]; then
    if [[ -z ${ARG} ]]; then
        invocation_error
    fi
    while read line
    do
        pair=($line)
        if [[ ${bom[${pair[0]}]+unassigned} ]]; then
            bom[${pair[0]}]=${pair[1]}
        elif [[ ${upstream[${pair[0]}]+unassigned} ]]; then
            upstream[${pair[0]}]=${pair[1]}
        else
            bom_error
        fi
    done < ${ARG}

elif [[ ${MODE} == "RELEASE" ]] || [[ ${MODE} == "BRANCH" ]]; then
    if [[ -z ${ARG} ]]; then
        invocation_error
    fi
    fill_bom ${ARG}

else
    invocation_error
fi

function prereq_error {
    echo "Not Found"
    echo "Please run the build dependency installer script"
    exit -1
}

echo -n "git: "
if [[ $(git --version 2>&1) == *"git version"* ]]; then
    echo "OK"
else
    prereq_error
fi

function build_error {
    echo "Build error"
    echo "Please determine the reason for the error, correct and re-run"
    exit -1
}

BASE=${PWD}

UPSTREAM_BUILDS=${BASE}/upstream-builds
PNDA_STAGE=${BASE}/pnda-stage
PNDA_DIST=${BASE}/pnda-dist
mkdir -p ${PNDA_DIST}
mkdir -p ${PNDA_STAGE}

cd ${PNDA_STAGE}

for repo in ${!bom[@]}
do
    git clone --branch ${bom[${repo}]} https://github.com/pndaproject/${repo}.git
    cd ${repo}
    if [[ ${MODE} == "RELEASE" ]]; then
        VERSION=$(git describe --abbrev=0 --tags)
    else
        VERSION=${bom[${repo}]}
    fi
    ./build.sh ${VERSION}
    [[ $? -ne 0 ]] && build_error
    cd ..
    mv ${repo}/pnda-build/* ${PNDA_DIST}/
done

for project in ${!upstream[@]}
do
    MODE="UPSTREAM"
    VERSION=$(echo ${upstream[${project}]} | grep -Po '(?<=^UPSTREAM\().*(?=\)$)')
    if [[ -z ${VERSION} ]]; then
        VERSION=${upstream[${project}]}
        MODE="PNDA"
    fi
    mkdir -p build-${project}
    cp ${UPSTREAM_BUILDS}/build-${project}.sh build-${project}/
    cd build-${project}
    ./build-${project}.sh ${MODE} ${VERSION}
    [[ $? -ne 0 ]] && build_error
    cd ..
    mv build-${project}/pnda-build/* ${PNDA_DIST}/
done

cd ${BASE}

