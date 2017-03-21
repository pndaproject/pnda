#!/bin/bash -v
export DISTRO=$(cat /etc/*-release|grep ^ID\=|awk -F\= {'print $2'}|sed s/\"//g)

[[ -z ${MIRROR_BUILD_DIR} ]] && export MIRROR_BUILD_DIR=${PWD}
[[ -z ${MIRROR_OUTPUT_DIR} ]] && export MIRROR_OUTPUT_DIR=${PWD}/mirror-dist

DEB_PACKAGE_LIST=$(<${MIRROR_BUILD_DIR}/pnda-deb-package-dependencies.txt)

export DEBIAN_FRONTEND=noninteractive
DEB_REPO_DIR=$MIRROR_OUTPUT_DIR/mirror_deb

apt-get -y update
apt-get -y install apt-transport-https curl dpkg-dev debfoster rng-tools

echo 'deb [arch=amd64] https://archive.cloudera.com/cm5/ubuntu/trusty/amd64/cm/ trusty-cm5.9.0 contrib' > /etc/apt/sources.list.d/cloudera-manager.list
curl -L 'https://archive.cloudera.com/cm5/ubuntu/trusty/amd64/cm/archive.key' | apt-key add -

echo 'deb [arch=amd64] http://repo.saltstack.com/apt/ubuntu/14.04/amd64/archive/2015.8.11/ trusty main' > /etc/apt/sources.list.d/saltstack.list
curl -L 'http://repo.saltstack.com/apt/ubuntu/14.04/amd64/archive/2015.8.11/SALTSTACK-GPG-KEY.pub' | apt-key add -

echo 'deb [arch=amd64] https://deb.nodesource.com/node_6.x trusty main' > /etc/apt/sources.list.d/nodesource.list
curl -L 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key' | apt-key add -
apt-get -y update

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password your_password'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password your_password'
apt-get -y install $DEB_PACKAGE_LIST

rm -rf $DEB_REPO_DIR
mkdir -p $DEB_REPO_DIR
cd $DEB_REPO_DIR
apt-get download $DEB_PACKAGE_LIST
for DEB_PACKAGE in $DEB_PACKAGE_LIST
do
    apt-get download $(debfoster -d $DEB_PACKAGE | grep '^ ')
done

dpkg-scanpackages . /dev/null | tee Packages | gzip > Packages.gz

rngd -r /dev/urandom
cat > ~/gpg_ops <<EOF
Key-Type: 1
Key-Length: 2048
Subkey-Type: 1
Subkey-Length: 2048
Name-Real: info@pnda.io
Name-Email: info@pnda.io
Expire-Date: 0
EOF
gpg --batch --gen-key ~/gpg_ops
gpg --output $DEB_REPO_DIR/pnda.gpg.key --armor --export info@pnda.io
apt-ftparchive release . > Release
gpg --clearsign -o InRelease Release
gpg -abs -o Release.gpg Release
