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

# Many Hadoop unit test tools depend on being able to correctly resolve the host to an address.
# Make sure the result of running hostname is present in the /etc/hosts file
#
echo "Checking system config"

if [[ -z $(grep `hostname` /etc/hosts) ]]; then
    echo "ERROR: The host on which you perform builds must be able to properly resolve itself in order to run Hadoop unit tests"
    echo "Please add the following entry to /etc/hosts"
    HOST=`hostname`
    echo "127.0.0.1 ${HOST}"
    exit -1
fi

# Java 1.8.0_74
#
echo "Dependency check: Java JDK 1.8.0_74"

if [[ $($JAVA_HOME/bin/javac -version 2>&1) != "javac 1.8.0_74" ]]; then
    echo "WARN: Unable to find JDK 1.8.0_74, going to download it and set JAVA_HOME relative to ${PWD}"
    if [[ -z ${JAVA_MIRROR} ]]; then
        JAVA_URL="http://download.oracle.com/otn-pub/java/jdk/8u74-b02/jdk-8u74-linux-x64.tar.gz"
    else
        JAVA_URL=${JAVA_MIRROR}
    fi  
    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" ${JAVA_URL}
    tar zxf jdk-8u74-linux-x64.tar.gz --no-same-owner
    export JAVA_HOME=${PWD}/jdk1.8.0_74
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

[[ $($JAVA_HOME/bin/javac -version 2>&1) != "javac 1.8.0_74" ]] && exit -1

# apt-get packages required to carry out builds and tests
#
echo "Dependency check: apt-get packages"

apt-get update -y
apt-get install -y python-dev libsasl2-dev gcc git nodejs npm=1.3.10~dfsg-1 gradle=1.4-2ubuntu1 curl python-setuptools apt-transport-https python-pip

if [ ! -f /usr/bin/node ]; then
        echo " WARN: Missing /usr/bin/node, creating link"
        ln -s /usr/bin/nodejs /usr/bin/node
fi

# Scala Build Tool - sbt
# 
echo "Dependency check: sbt"

if [ ! -f /etc/apt/sources.list.d/sbt.list ]; then
        echo "WARN: Unable to find sbt, going to install it"
        echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
        apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823
        apt-get update -y
        apt-get install sbt -y
else
    echo "sbt.list found in /etc/apt/sources.list.d"
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

# Python pip libraries used in builds and tests
#
pip install spur==0.3.12
pip install starbase==0.3.2
pip install happybase==0.9
pip install pyhs2==0.6.0
pip install pywebhdfs==0.4.0
pip install PyHDFS==0.1.2
pip install cm-api==8.0.0
pip install shyaml==0.4.1
pip install nose==1.3.7
pip install mock==2.0.0
pip install pylint==1.6.4
pip install python-swiftclient==3.1.0
pip install tornado-cors==0.6.0
pip install Tornado-JSON==1.2.2
pip install boto==2.40.0
pip install setuptools==28.8.0 --upgrade
pip install impyla==0.13.8
pip install eventlet==0.19.0
pip install kazoo==2.2.1
pip install avro==1.8.1
pip install kafka-python==0.9.4

# nodejs build tools
#
npm install -g grunt

# Apache Spark
#
wget http://archive.apache.org/dist/spark/spark-1.5.0/spark-1.5.0-bin-hadoop2.6.tgz
tar zxf spark-1.5.0-bin-hadoop2.6.tgz
export SPARK_HOME=${PWD}/spark-1.5.0-bin-hadoop2.6

# Finish up with advice to the user
#
echo "# Environment settings required for PNDA builds"  | tee ./set-pnda-env.sh
echo "export JAVA_HOME=${JAVA_HOME}" | tee -a ./set-pnda-env.sh
echo "export SPARK_HOME=${SPARK_HOME}" | tee -a ./set-pnda-env.sh
echo 'export PATH=${JAVA_HOME}/bin:${SPARK_HOME}:${PATH}' | tee -a ./set-pnda-env.sh
echo
echo "The above has been written to set-pnda-env.sh in ${PWD}"
chmod +x set-pnda-env.sh
