#!/bin/bash -ev
export DISTRO=$(cat /etc/*-release|grep ^ID\=|awk -F\= {'print $2'}|sed s/\"//g)

[[ -z ${MIRROR_BUILD_DIR} ]] && export MIRROR_BUILD_DIR=${PWD}
[[ -z ${MIRROR_OUTPUT_DIR} ]] && export MIRROR_OUTPUT_DIR=${PWD}/mirror-dist

ANACONDA_REPO_FILE_LIST=$(<${MIRROR_BUILD_DIR}/dependencies/pnda-cdh-repo-anaconda.txt)

ANACONDA_REPO_FILE_DIR=$MIRROR_OUTPUT_DIR/mirror_anaconda
mkdir -p $ANACONDA_REPO_FILE_DIR
cd $ANACONDA_REPO_FILE_DIR

if [[ "${DISTRO}" == "ubuntu" ]]; then
    apt-get install -y apt-transport-https curl 2>&1 | tee -a apt-installer.log;
    if grep -q "Unable to locate" "apt-installer.log"; then
        echo "Packages Unable to locate"
        echo $(cat apt-installer.log | grep "Unable to locate")
        exit -1;
    fi
    rm apt-installer.log
fi

echo "$ANACONDA_REPO_FILE_LIST" | while read ANACONDA_REPO_FILE
do
    echo $ANACONDA_REPO_FILE
    curl -LOJ $ANACONDA_REPO_FILE
done
