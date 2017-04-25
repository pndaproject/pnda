#!/bin/bash -v

set -e

. create_mirror_common.sh

if subscription-manager version|grep -q 'This system is currently not registered'; then
    echo "You are not running on a registered RedHat Server"
    echo "Please read: https://access.redhat.com/solutions/253273"
    exit 1
fi

RPM_PACKAGE_LIST=$(<${MIRROR_BUILD_DIR}/pnda-rpm-package-dependencies.txt)

RPM_REPO_DIR=$MIRROR_OUTPUT_DIR/mirror_rpm
RPM_EXTRAS=rhui-REGION-rhel-server-extras
RPM_OPTIONAL=rhui-REGION-rhel-server-optional
RPM_EPEL=https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
MY_SQL_REPO=https://repo.mysql.com/yum/mysql-5.5-community/el/7/x86_64/
MY_SQL_REPO_KEY=https://repo.mysql.com/RPM-GPG-KEY-mysql
CLOUDERA_MANAGER_REPO=http://archive.cloudera.com/cm5/redhat/7/x86_64/cm/5/
CLOUDERA_MANAGER_REPO_KEY=https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/RPM-GPG-KEY-cloudera
SALT_REPO=https://repo.saltstack.com/yum/redhat/7/x86_64/archive/2015.8.11
SALT_REPO_KEY=https://repo.saltstack.com/yum/redhat/7/x86_64/archive/2015.8.11/SALTSTACK-GPG-KEY.pub
SALT_REPO_KEY2=http://repo.saltstack.com/yum/redhat/7/x86_64/2015.8/base/RPM-GPG-KEY-CentOS-7
NODE_REPO=https://rpm.nodesource.com/pub_6.x/el/7/x86_64/nodesource-release-el7-1.noarch.rpm

yum install -y $RPM_EPEL
yum-config-manager --enable $RPM_EXTRAS $RPM_OPTIONAL

RPM_TMP=$(mktemp || bail)
curl -o ${RPM_TMP} ${NODE_REPO}
rpm -i --nosignature --force ${RPM_TMP}

yum-config-manager --add-repo $MY_SQL_REPO
yum-config-manager --add-repo $CLOUDERA_MANAGER_REPO
yum-config-manager --add-repo $SALT_REPO

yum install -y createrepo
rm -rf $RPM_REPO_DIR
mkdir -p $RPM_REPO_DIR

cd $RPM_REPO_DIR
cp /etc/pki/rpm-gpg/NODESOURCE-GPG-SIGNING-KEY-EL $RPM_REPO_DIR
cp /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 $RPM_REPO_DIR
cp /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release $RPM_REPO_DIR
download $MY_SQL_REPO_KEY
download $CLOUDERA_MANAGER_REPO_KEY
download $SALT_REPO_KEY
download $SALT_REPO_KEY2

#TODO yumdownloader doesn't always seem to download the full set of packages, for instance if git is installed, it won't download perl
# packages correctly maybe because git already installed them. repotrack is meant to be better but I couldn't get that working.
yumdownloader --resolve --archlist=x86_64 --destdir $RPM_REPO_DIR $RPM_PACKAGE_LIST
createrepo --database $RPM_REPO_DIR
