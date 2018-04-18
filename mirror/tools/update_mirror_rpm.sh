#!/bin/bash
echo "Usage: ./update_mirror_rpm.sh /path/to/mirror_rpm a-package [another-package ...]"

yum install -y createrepo

RPM_REPO_DIR=${1}
mkdir -p $RPM_REPO_DIR
if [ "$#" -gt 1 ]; then
  yumdownloader --resolve --archlist=x86_64 --destdir $RPM_REPO_DIR ${@:2}
fi
createrepo --database $RPM_REPO_DIR
