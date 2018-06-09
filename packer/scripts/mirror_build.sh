#!/bin/sh
curl -LOJ $PNDA_REPO/archive/$PNDA_BRANCH.tar.gz
[[ $? -ne 0 ]] && mirror_error "Problem while getting $PNDA_REPO/archive/$PNDA_BRANCH.tar.gz"
PB=$PNDA_BRANCH
CANONICAL_PB=${PB/\\//-}
tar zxf pnda-$CANONICAL_PB.tar.gz
ln -s pnda-$CANONICAL_PB pnda

# Build the mirror
cd pnda/mirror
sudo mkdir -p /var/www/html/
export MIRROR_OUTPUT_DIR=/var/www/html
./create_mirror.sh << EOF
Yes
EOF

[[ $? -ne 0 ]] && mirror_error "Problem while creating mirror"

# Install build machine and component package server pre-reqs
USER=centos
yum install -y git httpd
chkconfig httpd on

bash -c "echo '127.0.1.1 $(hostname)' | cat >> /etc/hosts"
cd /home/${USER}

# Install build machine software
pnda/build/install-build-tools.sh << EOF
Yes
EOF

[[ $? -ne 0 ]] && mirror_error "Problem while creating mirror"

# Build PNDA software
source set-pnda-env.sh
cd pnda/build
./build-pnda.sh $BUILD_MODE $BUILD_ARG << EOF
Yes
EOF

# Stage built PNDA components on HTTP server
echo "Before copying to http server home"
ls -lah /var/www/html/
ls -lah /home/${USER}/pnda/build/pnda-dist/
mv /home/${USER}/pnda/build/pnda-dist/* /var/www/html/
#cp -r /home/${USER}/pnda/mirror/mirror-dist/* /var/www/html/

restorecon -r /var/www/html
sudo service httpd start
