#!/bin/bash -v
CLOUDERA_REPO_FILE_LIST=$(<pnda-cdh-repo-cloudera.txt)

CLOUDERA_REPO_FILE_DIR=$MIRROR_OUTPUT/mirror_cloudera
mkdir -p $CLOUDERA_REPO_FILE_DIR
cd $CLOUDERA_REPO_FILE_DIR
echo "$CLOUDERA_REPO_FILE_LIST" | while read CLOUDERA_REPO_FILE
do
    echo $CLOUDERA_REPO_FILE
    curl -L -O -J $CLOUDERA_REPO_FILE
done
