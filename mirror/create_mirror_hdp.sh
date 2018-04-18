#!/bin/bash -ev
[[ -z ${MIRROR_BUILD_DIR} ]] && export MIRROR_BUILD_DIR=${PWD}
[[ -z ${MIRROR_OUTPUT_DIR} ]] && export MIRROR_OUTPUT_DIR=${PWD}/mirror-dist
source dependencies/versions.sh
source ${MIRROR_BUILD_DIR}/common/utils.sh

HDP_FILE_LIST=$(envsubst < ${MIRROR_BUILD_DIR}/dependencies/pnda-hdp-resources.txt)

HDP_REPO_FILE_DIR=$MIRROR_OUTPUT_DIR/mirror_hdp
mkdir -p $HDP_REPO_FILE_DIR
cd $HDP_REPO_FILE_DIR

echo "$HDP_FILE_LIST" | while read HDP_FILE
do
    echo $HDP_FILE
    robust_curl "$HDP_FILE"
done

tar zxf HDP-${HDP_VERSION}-centos7-rpm.tar.gz

mkdir -p HDP-UTILS-${HDP_UTILS_VERSION}/repos/centos7/
tar zxf HDP-UTILS-${HDP_UTILS_VERSION}-centos7.tar.gz -C "HDP-UTILS-${HDP_UTILS_VERSION}/repos/centos7/"

rm -f HDP-${HDP_VERSION}-centos7-rpm.tar.gz
rm -f HDP-UTILS-${HDP_UTILS_VERSION}-centos7.tar.gz
