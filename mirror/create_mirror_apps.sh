#!/bin/bash -ev
[[ -z ${MIRROR_OUTPUT_DIR} ]] && export MIRROR_OUTPUT_DIR=${PWD}/mirror-dist
[[ -z ${MIRROR_BUILD_DIR} ]] && export MIRROR_BUILD_DIR=${PWD}
source dependencies/versions.sh

STATIC_FILE_DIR=$MIRROR_OUTPUT_DIR/mirror_apps
mkdir -p $STATIC_FILE_DIR
cd $STATIC_FILE_DIR

STATIC_FILE_LIST_APP=$(envsubst < ${MIRROR_BUILD_DIR}/dependencies/pnda-static-file-app-dependencies.txt)
cd $STATIC_FILE_DIR
echo "$STATIC_FILE_LIST_APP" | while read STATIC_FILE
do
    IFS=', ' read -r -a appdata <<< $STATIC_FILE
    if [ "${appdata[0]}" = "python" ] ; then
        curl -LOJf --retry 5 --retry-max-time 0 "${appdata[1]}"
        file=$(echo ${appdata[1]} | rev | cut -d/ -f1 | rev)
        tar zxf $file
        rm -f $file
        filename="${file/%.tar.gz/}"
        cd "$filename"
        python setup.py bdist_egg
        egg_file=(`ls dist/*.egg`)
        cp $egg_file .././
        cd ..
        rm -rf "$filename"
    elif [ "${appdata[0]}" = "java" ] ; then
        curl -LOJf --retry 5 --retry-max-time 0 "${appdata[1]}"
    else
        echo "unknow type dependency"
        exit -1
    fi
done