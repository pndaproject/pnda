STATIC_FILE_LIST=$(<pnda-static-file-dependencies.txt)

STATIC_FILE_DIR=$MIRROR_OUTPUT/misc
mkdir -p $STATIC_FILE_DIR
cd $STATIC_FILE_DIR
echo "$STATIC_FILE_LIST" | while read STATIC_FILE
do
    echo $STATIC_FILE
    curl -L -O -J $STATIC_FILE
done