#!/bin/bash -ev
export DISTRO=$(cat /etc/*-release|grep ^ID\=|awk -F\= {'print $2'}|sed s/\"//g)

[[ -z ${MIRROR_BUILD_DIR} ]] && export MIRROR_BUILD_DIR=${PWD}
[[ -z ${MIRROR_OUTPUT_DIR} ]] && export MIRROR_OUTPUT_DIR=${PWD}/mirror-dist
source dependencies/versions.sh

RPM_PACKAGE_LIST=$(envsubst < ${MIRROR_BUILD_DIR}/dependencies/pnda-rpm-package-dependencies-${DISTRO}.txt)

RPM_REPO_DIR=$MIRROR_OUTPUT_DIR/mirror_rpm
[[ -z ${RPM_EXTRAS} ]] && export RPM_EXTRAS=rhui-REGION-rhel-server-extras
[[ -z ${RPM_OPTIONAL} ]] && export RPM_OPTIONAL=rhui-REGION-rhel-server-optional
RPM_EPEL=https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
MY_SQL_REPO=https://repo.mysql.com/yum/mysql-5.5-community/el/7/x86_64/
MY_SQL_REPO_KEY=https://repo.mysql.com/RPM-GPG-KEY-mysql
CLOUDERA_MANAGER_REPO=http://archive.cloudera.com/cm5/redhat/7/x86_64/cm/${CLOUDERA_MANAGER_VERSION}/
CLOUDERA_MANAGER_REPO_KEY=https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/RPM-GPG-KEY-cloudera
SALT_REPO=https://repo.saltstack.com/yum/redhat/7/x86_64/archive/${SALTSTACK_VERSION}
SALT_REPO_KEY=https://repo.saltstack.com/yum/redhat/7/x86_64/archive/${SALTSTACK_VERSION}/SALTSTACK-GPG-KEY.pub
SALT_REPO_KEY2=http://repo.saltstack.com/yum/redhat/7/x86_64/${SALTSTACK_REPO}/base/RPM-GPG-KEY-CentOS-7
[[ -z ${AMBARI_REPO} ]] && export AMBARI_REPO=http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/${AMBARI_VERSION}/ambari.repo
[[ -z ${AMBARI_LEGACY_REPO} ]] && export AMBARI_LEGACY_REPO=http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/${AMBARI_LEGACY_VERSION}/ambari.repo
[[ -z ${AMBARI_REPO_KEY} ]] && export AMBARI_REPO_KEY=http://public-repo-1.hortonworks.com/ambari/centos7/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins

yum install -y $RPM_EPEL || true
yum install -y yum-utils
yum-config-manager --enable $RPM_EXTRAS $RPM_OPTIONAL
yum-config-manager --add-repo $MY_SQL_REPO
yum-config-manager --add-repo $CLOUDERA_MANAGER_REPO
yum-config-manager --add-repo $SALT_REPO
yum-config-manager --add-repo $AMBARI_REPO

curl -LJ -o /etc/yum.repos.d/ambari-legacy.repo $AMBARI_LEGACY_REPO

rm -rf $RPM_REPO_DIR
mkdir -p $RPM_REPO_DIR

initdir=$PWD
cd $RPM_REPO_DIR
cp /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 $RPM_REPO_DIR
if [ "x$DISTRO" == "xrhel" ]; then
	# Not present on CentOS
	cp /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release $RPM_REPO_DIR
fi
curl -LOJf $MY_SQL_REPO_KEY
curl -LOJf $CLOUDERA_MANAGER_REPO_KEY
curl -LOJf $SALT_REPO_KEY
curl -LOJf $SALT_REPO_KEY2
curl -LOJf $AMBARI_REPO_KEY

# import repo keys
rpm --import *
cd $initdir
yum makecache
depstree=$(repoquery --requires --resolve --recursive --exactdeps ${RPM_PACKAGE_LIST}|sort -u)
RPM_PACKAGE_LIST_FULL="${RPM_PACKAGE_LIST} ${depstree}"
repotrack -p $RPM_REPO_DIR $RPM_PACKAGE_LIST_FULL ambari-metrics-hadoop-sink-${AMBARI_LEGACY_PACKAGE_VERSION}
repotrack -p $RPM_REPO_DIR ambari-metrics-hadoop-sink-${AMBARI_LEGACY_PACKAGE_VERSION}
yum install -y createrepo
createrepo --database $RPM_REPO_DIR
