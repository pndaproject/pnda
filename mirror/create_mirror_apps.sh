[[ -z ${MIRROR_OUTPUT_DIR} ]] && export MIRROR_OUTPUT_DIR=${PWD}/mirror-dist
STATIC_FILE_DIR=$MIRROR_OUTPUT_DIR/mirror_apps
mkdir -p $STATIC_FILE_DIR
cd $STATIC_FILE_DIR
cp $MIRROR_OUTPUT_DIR/mirror_python/packages/kafka-python-1.3.5.tar.gz ./
[[ $? -ne 0 ]] && echo "Error copying kafka-python" && exit -1
cp $MIRROR_OUTPUT_DIR/mirror_python/packages/avro-1.8.1.tar.gz ./
[[ $? -ne 0 ]] && echo "Error copying avro-python" && exit -1
CANDIDATES=(`ls $STATIC_FILE_DIR/*`)
for c in ${CANDIDATES[*]}
do
    tar zxf $c
    [[ $? -ne 0 ]] && echo "Error extracting ${c}" && exit -1
    rm -rf $c
    filename="${c/%.tar.gz/}"
    cd "$filename"
    python setup.py bdist_egg
    [[ $? -ne 0 ]] && echo "Error creating egg file for ${c}" && exit -1
    egg_file=(`ls dist/*.egg`)
    cp $egg_file .././
    rm -rf "$filename"
    cd ..
done
