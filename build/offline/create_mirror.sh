# OPTIONS

# MIRROR_OUTPUT: Root folder to download files to for mirroring (no trailing slash)
MIRROR_OUTPUT=/var/pnda/mirror

# MIRROR USAGE:

# To use the rpm mirror:
#   yum-config-manager --add-repo http://x.x.x.x/rpms
#   rpm --import http://x.x.x.x/rpms/RPM-GPG-KEY-mysql/RPM-GPG-KEY-redhat-release
#   rpm --import http://x.x.x.x/rpms/RPM-GPG-KEY-mysql
#   rpm --import http://x.x.x.x/rpms/RPM-GPG-KEY-cloudera
#   rpm --import http://x.x.x.x/rpms/RPM-GPG-KEY-EPEL-7
#   rpm --import http://x.x.x.x/rpms/SALTSTACK-GPG-KEY.pub
#   rpm --import http://x.x.x.x/rpms/RPM-GPG-KEY-CentOS-7

# To use the deb mirror
#   cat > /etc/apt/sources.list.d/local.list <<EOF
#   deb http://x.x.x.x/debs/ ./
#   EOF
#   wget -O - http://x.x.x.x/debs/pnda.gpg.key | apt-key add -
#   apt-get update

DISTRO=$(cat /etc/*-release|grep ^ID\=|awk -F\= {'print $2'}|sed s/\"//g)

if [ "x$DISTRO" == "xrhel" ]; then
    create_mirror_rpm.sh
elif [ "x$DISTRO" == "xubuntu" ]; then
    create_mirror_deb.sh
fi

create_mirror_misc.sh
create_mirror_cdh.sh
create_mirror_anaconda.sh