#!/bin/bash

function mirror_error {
    echo "ERROR: $1"
    exit -1
}

TARBALL=pnda.tar.gz

rm -rf $TARBALL pnda
curl -LsS -o $TARBALL $PNDA_REPO/archive/$PNDA_BRANCH.tar.gz
[[ $? -ne 0 ]] && mirror_error "Problem while getting $PNDA_REPO/archive/$PNDA_BRANCH.tar.gz"

mkdir pnda
tar zxf $TARBALL --strip-components=1 -C pnda

# Build the mirror
cd pnda/mirror
sudo mkdir -p /var/www/html/
export MIRROR_OUTPUT_DIR=/var/www/html
./create_mirror.sh -d $HADOOP_DISTRIBUTION -r << EOF
Yes
EOF

[[ $? -ne 0 ]] && mirror_error "Problem while creating mirror"

# cleaning up pnda
sudo rm -rf /home/${OS_USER}/pnda*
