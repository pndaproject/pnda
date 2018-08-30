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
repo=$1
mode=$2
branch=$3
output_dir=$4
stage_dir=$5
hadoop_flavor=$6

function build_error {
    echo "Build error"
    echo "Please determine the reason for the error, correct and re-run"
    exit -1
}

echo building ${repo}:${branch} in ${mode} mode
cd ${stage_dir}
git clone --branch ${branch} https://github.com/pndaproject/${repo}.git
cd ${repo}
if [[ ${mode} == "RELEASE" ]]; then
    VERSION=$(git describe --abbrev=0 --tags)
else
    VERSION=${branch}
fi
./build.sh ${VERSION} ${hadoop_flavor} | tee ${stage_dir}/build-${repo}.log
build_res=${PIPESTATUS[0]}
[[ $build_res -ne 0 ]] && build_error
cd ..
mv ${repo}/pnda-build/* ${output_dir}/
