#!/bin/bash -v
ANACONDA_REPO_FILE_LIST=$(<pnda-cdh-repo-anaconda.txt)

ANACONDA_REPO_FILE_DIR=$MIRROR_OUTPUT/mirror_anaconda
mkdir -p $ANACONDA_REPO_FILE_DIR
cd $ANACONDA_REPO_FILE_DIR
echo "$ANACONDA_REPO_FILE_LIST" | while read ANACONDA_REPO_FILE
do
    echo $ANACONDA_REPO_FILE
    curl -L -O -J $ANACONDA_REPO_FILE
done
