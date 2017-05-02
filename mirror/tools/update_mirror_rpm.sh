#!/bin/bash
echo "Usage: ./update_mirror_rpm.sh /path/to/mirror_rpm a-package [another-package ...]"
DISTRO=$(cat /etc/*-release|grep ^ID\=|awk -F\= {'print $2'}|sed s/\"//g)
if [ "x$DISTRO" != "xrhel" ]; then
    echo "Sorry, this script must be run on Redhat 7. To host an RPM mirror on a web server running another operating system, generate the files on Redhat and copy them over."
    exit 1
else
    yum install -y createrepo
fi
RPM_REPO_DIR=${1}
mkdir -p $RPM_REPO_DIR
if [ "$#" -gt 1 ]; then
  yumdownloader --resolve --archlist=x86_64 --destdir $RPM_REPO_DIR ${@:2}
fi
createrepo --database $RPM_REPO_DIR
