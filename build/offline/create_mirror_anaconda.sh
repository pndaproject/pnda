#!/bin/bash -v

set -e

. create_mirror_common.sh

if [[ "${DISTRO}" == "ubuntu" ]]; then
    apt-get install -y apt-transport-https curl
fi

ANACONDA_REPO_FILE_LIST=$(<${MIRROR_BUILD_DIR}/pnda-cdh-repo-anaconda.txt)

ANACONDA_REPO_FILE_DIR=$MIRROR_OUTPUT_DIR/mirror_anaconda
mkdir -p $ANACONDA_REPO_FILE_DIR
cd $ANACONDA_REPO_FILE_DIR
echo "$ANACONDA_REPO_FILE_LIST" | while read ANACONDA_REPO_FILE
do
    echo $ANACONDA_REPO_FILE
    download $ANACONDA_REPO_FILE
done
