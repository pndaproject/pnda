#!/bin/bash
#
#   Copyright (c) 2016 Cisco and/or its affiliates.
#   This software is licensed to you under the terms of the Apache License, Version 2.0
#   (the "License").
#   You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#   The code, technical concepts, and all information contained herein, are the property of
#   Cisco Technology, Inc.and/or its affiliated entities, under various laws including copyright,
#   international treaties, patent, and/or contract.
#   Any use of the material herein must be in accordance with the terms of the License.
#   All rights not expressly granted by the License are reserved.
#   Unless required by applicable law or agreed to separately in writing, software distributed
#   under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
#   ANY KIND, either express or implied.
#
#   This script checks for and installs dependencies required to build PNDA on a Ubuntu 14.04 system.
#   For other systems, please refer to the installation instructions of the respective technologies.
#
#   JAVA_MIRROR - define this environment variable to download the Java JDK from an alternative location

SPARK_VERSION='1.6.0'

# Many Hadoop unit test tools depend on being able to correctly resolve the host to an address.
# Make sure the result of running hostname is present in the /etc/hosts file
#
export DISTRO=$(cat /etc/*-release|grep ^ID\=|awk -F\= {'print $2'}|sed s/\"//g)

echo "Checking system config"

if [[ -z $(grep `hostname` /etc/hosts) ]]; then
    echo "ERROR: The host on which you perform builds must be able to properly resolve itself in order to run Hadoop unit tests"
    echo "Please add the following entry to /etc/hosts"
    HOST=`hostname`
    echo "127.0.1.1 ${HOST}"
    exit -1
fi

if [ "x${DISTRO}" == "xrhel" ]; then
  echo "Use of Red Hat software is governed by your agreement with Red Hat."
  echo "In order to proceed, you must have a valid Red Hat subscription and software image on your system."

  read -p "Do you wish to proceed? [Yes/No]  " yn
  case $yn in
      [Yy]* ) echo "Thanks";;
      [Nn]* ) exit;;
      * ) echo "Please answer yes or no.";;
  esac
fi

if [ "x${DISTRO}" == "xrhel" -o "x$DISTRO" == "xcentos" ]; then
  yum install -y wget
fi


# Java 1.8.0_131
#
echo "Dependency check: Java JDK 1.8.0_131"

if [[ $($JAVA_HOME/bin/javac -version 2>&1) != "javac 1.8.0_131" ]]; then
    echo "WARN: Unable to find JDK 1.8.0_131, going to download it and set JAVA_HOME relative to ${PWD}"
    curl -LOJ -b oraclelicense=accept-securebackup-cookie "${JAVA_MIRROR:-http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz}"
    tar zxf jdk-8u131-linux-x64.tar.gz --no-same-owner
    export JAVA_HOME=${PWD}/jdk1.8.0_131
    export PATH=$JAVA_HOME/bin:${PATH}

    echo "JAVA_HOME set to ${JAVA_HOME}"
    echo "PATH adjusted to ${PATH}"
    echo
    echo "Please adjust these variables if required for your environment"
    echo "It's recommended that you append these lines to /etc/environment to make Java generally available"
    echo "export JAVA_HOME=${JAVA_HOME}"
    echo 'export PATH=${JAVA_HOME}/bin:$PATH'
else
    echo "Java found at ${JAVA_HOME}"
fi

[[ $($JAVA_HOME/bin/javac -version 2>&1) != "javac 1.8.0_131" ]] && exit -1

# Packages required to carry out builds and tests
#
echo "Dependency check: packages"

if [ "x${DISTRO}" == "xrhel" -o "x$DISTRO" == "xcentos" ]; then

    [[ -z ${RPM_EXTRAS} ]] && export RPM_EXTRAS=rhui-REGION-rhel-server-extras
    [[ -z ${RPM_OPTIONAL} ]] && export RPM_OPTIONAL=rhui-REGION-rhel-server-optional
    RPM_EPEL=https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    NODE_REPO=https://rpm.nodesource.com/pub_6.x/el/7/x86_64/nodesource-release-el7-1.noarch.rpm

    yum install -y $RPM_EPEL
    yum install -y yum-utils
    yum-config-manager --enable $RPM_EXTRAS $RPM_OPTIONAL

    RPM_TMP=$(mktemp || bail)
    wget -O ${RPM_TMP} ${NODE_REPO}
    rpm -i --nosignature --force ${RPM_TMP}

    (yum install -y python-devel \
                   cyrus-sasl-devel \
                   gcc \
                   gcc-c++ \
                   git \
                   nodejs \
                   bc \
                   curl \
                   pam-devel \
                   python-setuptools \
                   python-devel \
                   python2-pip \
                   ruby-devel \
                   parallel \
                   libaio) | tee -a yum-build-deps.log; cmd_result=${PIPESTATUS[0]} && if [ ${cmd_result} != '0' ]; then exit ${cmd_result}; fi
    if grep -q 'No package .* available.' "yum-build-deps.log"; then
        echo "missing rpm detected:"
        echo $(cat yum-build-deps.log | grep 'No package .* available.')
        exit -1
    fi

elif [[ "${DISTRO}" == "ubuntu" ]]; then

    echo 'deb [arch=amd64] https://deb.nodesource.com/node_6.x trusty main' > /etc/apt/sources.list.d/nodesource.list
    curl -L 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key' | apt-key add -

    apt-get update -y
    apt-get install -y python-dev \
                   libsasl2-dev \
                   gcc \
                   git \
                   nodejs \
                   bc \
                   curl \
                   python-setuptools \
                   apt-transport-https \
                   libpam0g-dev \
                   python-pip \
                   ruby-dev \
                   parallel \
                   libaio1 # Needed for Gobblin
fi

if [ ! -f /usr/bin/node ]; then
        echo " WARN: Missing /usr/bin/node, creating link"
        ln -s /usr/bin/nodejs /usr/bin/node
fi

# Scala Build Tool - sbt
#
echo "Dependency check: sbt"

if [ "x${DISTRO}" == "xrhel" -o "x$DISTRO" == "xcentos" ]; then

    wget -qO- https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo
    yum install sbt-0.13.9 -y

elif [[ "${DISTRO}" == "ubuntu" ]]; then

    if [ ! -f /etc/apt/sources.list.d/sbt.list ]; then
        echo "WARN: Unable to find sbt, going to install it"
        echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
        apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823
        apt-get update -y
        apt-get install sbt=0.13.13 -y
    else
        echo "sbt.list found in /etc/apt/sources.list.d"
    fi
fi

# Maven 3.0.5
# 
echo "Dependency check: maven 3.0.5"

if [[ $(mvn -version 2>&1) != *"Apache Maven 3.0.5"* ]]; then
        echo "WARN: Unable to find maven 3.0.5, going to download it and set up /etc/alternatives"
        wget https://archive.apache.org/dist/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz
        tar zxf apache-maven-3.0.5-bin.tar.gz
        mv apache-maven-3.0.5 /usr/share/
        rm /etc/alternatives/mvn
        ln -s /usr/share/apache-maven-3.0.5/bin/mvn /etc/alternatives/mvn
        ln -s /etc/alternatives/mvn /usr/bin
else
    echo "maven 3.0.5 found in /usr/share"
fi

# Patch mvn to always use a private .m2 directory as the .m2
# directory is not safe for concurrent access
cat > mvn-private-m2.sh <<'EOF'
#!/bin/bash
export MAVEN_OPTS="-Dmaven.repo.local=${PWD}/.m2"
/etc/alternatives/mvn $@
EOF
chmod a+x mvn-private-m2.sh
rm -rf /usr/bin/mvn
ln -s ${PWD}/mvn-private-m2.sh /usr/bin/mvn

# Python pip libraries used in builds and tests
# Firstly, bring pip and setuptools up to date
curl -LOJf https://bootstrap.pypa.io/get-pip.py
python get-pip.py
pip2 install --upgrade setuptools

pip2 install spur==0.3.12
pip2 install starbase==0.3.2
pip2 install happybase==1.0.0
pip2 install pyhs2==0.6.0
pip2 install pywebhdfs==0.4.0
pip2 install PyHDFS==0.1.2
pip2 install cm-api==8.0.0
pip2 install shyaml==0.4.1
pip2 install nose==1.3.7
pip2 install mock==2.0.0
pip2 install pylint==1.6.4
pip2 install python-swiftclient==3.1.0
pip2 install tornado==4.4.2
pip2 install tornado-cors==0.6.0
pip2 install Tornado-JSON==1.2.2
pip2 install boto==2.40.0
pip2 install impyla==0.13.8
pip2 install eventlet==0.19.0
pip2 install kazoo==2.2.1
pip2 install avro==1.8.1
pip2 install kafka-python==1.3.5
pip2 install prettytable==0.7.2
pip2 install pyhive==0.2.1
pip2 install thrift_sasl==0.2.1
# grunt-cli needs to be installed globally

[[ -e ~/tmp ]] && TMP_EXISTS=true

npm install -g grunt-cli

# The installation of grunt-cli leaves behind a ~/tmp directory owned by the invoker of the command. This is
# used by subsequent builds using grunt. This can cause problems if the installation is run as sudo and 
# subsequent builds are run as non-privileged users. Therefore, we set it to rwxrwxrwx access here if and only
# if it didn't already exist. If the user already had a ~/tmp directory the access permissions are left alone.
if [[ -z ${TMP_EXISTS} ]] && [[ -e ~/tmp ]]; then
    chmod -R 777 ~/tmp
fi

# Apache Spark
#
wget http://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop2.6.tgz
tar zxf spark-${SPARK_VERSION}-bin-hadoop2.6.tgz
export SPARK_HOME=${PWD}/spark-${SPARK_VERSION}-bin-hadoop2.6

# Finish up with advice to the user
#
echo "# Environment settings required for PNDA builds"  | tee ./set-pnda-env.sh
echo "export JAVA_HOME=${JAVA_HOME}" | tee -a ./set-pnda-env.sh
echo "export SPARK_HOME=${SPARK_HOME}" | tee -a ./set-pnda-env.sh
echo 'export PATH=${JAVA_HOME}/bin:${SPARK_HOME}:${PATH}' | tee -a ./set-pnda-env.sh
echo
echo "The above has been written to set-pnda-env.sh in ${PWD}"
chmod +x set-pnda-env.sh
