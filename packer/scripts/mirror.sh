#!/bin/bash

function mirror_error {
    echo "ERROR: $1"
    exit -1
}

curl -LOJ $PNDA_REPO/archive/$PNDA_BRANCH.tar.gz
[[ $? -ne 0 ]] && mirror_error "Problem while getting $PNDA_REPO/archive/$PNDA_BRANCH.tar.gz"
PB=$PNDA_BRANCH
CANONICAL_PB=${PB/\\//-}
tar zxf pnda-$CANONICAL_PB.tar.gz
ln -s pnda-$CANONICAL_PB pnda

# Update env if required
source /tmp/mirror_env.sh

# Build the mirror
cd pnda/mirror
sudo mkdir -p /var/www/html/
export MIRROR_OUTPUT_DIR=/var/www/html
./create_mirror.sh << EOF
Yes
EOF

[[ $? -ne 0 ]] && mirror_error "Problem while creating mirror"

# cleaning up pnda
sudo rm -rf /home/${OS_USER}/pnda*
