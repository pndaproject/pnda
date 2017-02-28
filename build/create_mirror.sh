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
    RPM_REPO_DIR=$MIRROR_OUTPUT/rpms
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

    RPM_PACKAGE_LIST=$(<pnda-rpm-package-dependencies.txt)

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

    cp /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release $RPM_REPO_DIR
    curl $MY_SQL_REPO_KEY > $RPM_REPO_DIR/RPM-GPG-KEY-mysql
    curl $CLOUDERA_MANAGER_REPO_KEY > $RPM_REPO_DIR/RPM-GPG-KEY-cloudera
    curl https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7 > $RPM_REPO_DIR/RPM-GPG-KEY-EPEL-7
    curl $SALT_REPO_KEY > $RPM_REPO_DIR/SALTSTACK-GPG-KEY.pub
    curl $SALT_REPO_KEY2 > $RPM_REPO_DIR/RPM-GPG-KEY-CentOS-7
    cp /etc/pki/rpm-gpg/NODESOURCE-GPG-SIGNING-KEY-EL $RPM_REPO_DIR/NODESOURCE-GPG-SIGNING-KEY-EL

    #TODO yumdownloader doesn't always seem to download the full set of packages, for instance if git is installed, it won't download perl
    # packages correctly maybe because git already installed them. repotrack is meant to be better but I couldn't get that working.
    yumdownloader --resolve --archlist=x86_64 --destdir $RPM_REPO_DIR $RPM_PACKAGE_LIST
    createrepo --database $RPM_REPO_DIR

elif [ "x$DISTRO" == "xubuntu" ]; then
    export DEBIAN_FRONTEND=noninteractive
    DEB_REPO_DIR=$MIRROR_OUTPUT/debs

    DEB_PACKAGE_LIST=$(<pnda-deb-package-dependencies.txt)

    cat > /etc/apt/sources.list.d/cloudera-manager.list <<EOF
    deb [arch=amd64] https://archive.cloudera.com/cm5/ubuntu/trusty/amd64/cm/ trusty-cm5.9.0 contrib
EOF

    wget -O - 'https://archive.cloudera.com/cm5/ubuntu/trusty/amd64/cm/archive.key' | apt-key add -

    cat > /etc/apt/sources.list.d/saltstack.list <<EOF
    deb [arch=amd64] http://repo.saltstack.com/apt/ubuntu/14.04/amd64/archive/2015.8.11/ trusty main
EOF
    wget -O - 'http://repo.saltstack.com/apt/ubuntu/14.04/amd64/archive/2015.8.11/SALTSTACK-GPG-KEY.pub' | apt-key add -

    echo 'deb [arch=amd64] https://deb.nodesource.com/node_6.x trusty main' > /etc/apt/sources.list.d/nodesource.list
    wget -O - 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key' | apt-key add -

    apt-get -y update
    apt-get -y install dpkg-dev debfoster rng-tools

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
fi
