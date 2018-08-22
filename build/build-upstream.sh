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
project=$1
version=$2
output_dir=$3
stage_dir=$4
upstream_builds_dir=$5
HADOOP_DISTRIBUTION=$6

function build_error {
    echo "Build error"
    echo "Please determine the reason for the error, correct and re-run"
    exit -1
}

echo building ${project}
cd ${stage_dir}
MODE="UPSTREAM"
VERSION=$(echo ${version} | grep -Po '(?<=^UPSTREAM\().*(?=\)$)')
if [[ -z ${VERSION} ]]; then
    VERSION=${version}
    MODE="PNDA"
fi
mkdir -p build-${project}
cp ${upstream_builds_dir}/*.sh build-${project}/
cd build-${project}
./build-${project}.sh ${MODE} ${VERSION} ${HADOOP_DISTRIBUTION} | tee ${stage_dir}/build-${project}.log
build_res=${PIPESTATUS[0]}
[[ $build_res -ne 0 ]] && build_error
mv ${stage_dir}/build-${project}/pnda-build/* ${output_dir}/
