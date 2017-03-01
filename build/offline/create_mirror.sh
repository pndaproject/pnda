# OPTIONS

# MIRROR_OUTPUT: Root folder to download files to for mirroring (no trailing slash)
export MIRROR_OUTPUT=mirror-dist

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

export DISTRO=$(cat /etc/*-release|grep ^ID\=|awk -F\= {'print $2'}|sed s/\"//g)
export THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ "x$DISTRO" == "xrhel" ]; then
    $THIS_DIR/create_mirror_rpm.sh
elif [ "x$DISTRO" == "xubuntu" ]; then
    $THIS_DIR/create_mirror_deb.sh
fi

$THIS_DIR/create_mirror_misc.sh
$THIS_DIR/create_mirror_cdh.sh
$THIS_DIR/create_mirror_anaconda.sh
$THIS_DIR/create_mirror_python.sh