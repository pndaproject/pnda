#!/bin/bash -ev
export DISTRO=$(cat /etc/*-release|grep ^ID\=|awk -F\= {'print $2'}|sed s/\"//g)

[[ -z ${MIRROR_BUILD_DIR} ]] && export MIRROR_BUILD_DIR=${PWD}
[[ -z ${MIRROR_OUTPUT_DIR} ]] && export MIRROR_OUTPUT_DIR=${PWD}/mirror-dist
RPM_PACKAGE_LIST=$(<${MIRROR_BUILD_DIR}/dependencies/pnda-rpm-package-dependencies-${DISTRO}.txt)

RPM_REPO_DIR=$MIRROR_OUTPUT_DIR/mirror_rpm
[[ -z ${RPM_EXTRAS} ]] && export RPM_EXTRAS=rhui-REGION-rhel-server-extras
[[ -z ${RPM_OPTIONAL} ]] && export RPM_OPTIONAL=rhui-REGION-rhel-server-optional
RPM_EPEL=https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
MY_SQL_REPO=https://repo.mysql.com/yum/mysql-5.5-community/el/7/x86_64/
MY_SQL_REPO_KEY=https://repo.mysql.com/RPM-GPG-KEY-mysql
CLOUDERA_MANAGER_REPO=http://archive.cloudera.com/cm5/redhat/7/x86_64/cm/5.12.1/
CLOUDERA_MANAGER_REPO_KEY=https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/RPM-GPG-KEY-cloudera
SALT_REPO=https://repo.saltstack.com/yum/redhat/7/x86_64/archive/2015.8.11
SALT_REPO_KEY=https://repo.saltstack.com/yum/redhat/7/x86_64/archive/2015.8.11/SALTSTACK-GPG-KEY.pub
SALT_REPO_KEY2=http://repo.saltstack.com/yum/redhat/7/x86_64/2015.8/base/RPM-GPG-KEY-CentOS-7
AMBARI_REPO=http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.6.0.0/ambari.repo
AMBARI_REPO_KEY=http://public-repo-1.hortonworks.com/ambari/centos7/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins

yum install -y $RPM_EPEL || true
yum-config-manager --enable $RPM_EXTRAS $RPM_OPTIONAL
yum-config-manager --add-repo $MY_SQL_REPO
yum-config-manager --add-repo $CLOUDERA_MANAGER_REPO
yum-config-manager --add-repo $SALT_REPO
yum-config-manager --add-repo $AMBARI_REPO

rm -rf $RPM_REPO_DIR
mkdir -p $RPM_REPO_DIR

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

if [ "x$DISTRO" == "xcentos" ]; then
	rpm --import *
fi

yum install -y createrepo

#TODO yumdownloader doesn't always seem to download the full set of packages, for instance if git is installed, it won't download perl
# packages correctly maybe because git already installed them. repotrack is meant to be better but I couldn't get that working.
# yumdownloader also doesn't set its exit code when a package is not found, so this scans the log output for this case and manually exits with an error
(yumdownloader --resolve --archlist=x86_64 --destdir $RPM_REPO_DIR $RPM_PACKAGE_LIST 2>&1) | tee -a yum-downloader.log; cmd_result=${PIPESTATUS[0]} && if [ ${cmd_result} != '0' ]; then exit ${cmd_result}; fi
if grep -q 'No Match for argument' "yum-downloader.log"; then
    echo "missing rpm detected:"
    echo $(cat yum-downloader.log | grep 'No Match for argument')
    exit -1
fi
rm yum-downloader.log
createrepo --database $RPM_REPO_DIR
