#!/bin/bash -v

set -e

. create_mirror_common.sh

if [[ "${DISTRO}" == "ubuntu" ]]; then
    apt-get install -y apt-transport-https curl
fi

CLOUDERA_REPO_FILE_LIST=$(<${MIRROR_BUILD_DIR}/pnda-cdh-repo-cloudera.txt)

CLOUDERA_REPO_FILE_DIR=$MIRROR_OUTPUT_DIR/mirror_cloudera
mkdir -p $CLOUDERA_REPO_FILE_DIR
cd $CLOUDERA_REPO_FILE_DIR
echo "$CLOUDERA_REPO_FILE_LIST" | while read CLOUDERA_REPO_FILE
do
    echo $CLOUDERA_REPO_FILE
    curl -L -O -J $CLOUDERA_REPO_FILE
done
