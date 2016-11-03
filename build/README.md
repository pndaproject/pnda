# PNDA Build Tools

In this directory you will find tools that install necessary build pre-requisites and produce set of components for use in provisioning PNDA clusters.

All scripts have been tested on the following environment -

- AWS m3.large instance (2 CPUs, 7.5GB memory and 32GB SSD storage)
- AMI: ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-20160714 (ami-ed82e39e)

## Preparing the build environment

The script ```install-build-tools.sh``` installs all the necessarily build prerequisites.

Run it with superuser privileges in the location that you wish to install your build tools.

For example

```sh
cd /home/builder
sudo su
./install-build-tools.sh
```

As well as installing all the required software, it may pause and ask the operator to carry out some configuration on the build environment, for example adjusting the contents of /etc/hosts.

Once it has finished, a file called ```set-pnda-env.sh``` will be found in the working directory. This script contains the necessary environment variables and other settings needed to carry out builds. It should either be added to the end of an initialization script such as /etc/environments so that these settings are available for every build, or invoked with each build.

## Building PNDA

The script ```build-pnda.sh``` supports three use cases and is invoked as superuser.

For example

```sh
cd pnda
sudo su
./build.sh RELEASE release/3.2
```
#### Build latest PNDA components & upstream projects to a given branch or tag
- Pass "BRANCH" as first parameter
- Pass PNDA branch or tag as the second parameter (e.g. develop)
- PNDA components are built with the version specifier set to the branch or tag

#### Build master PNDA components & upstream projects at release X
- Pass "RELEASE" as first parameter
- Pass PNDA release tag as second parameter (e.g. release/3.2)
- PNDA components are built with the version specifier set to corresponding component release (e.g. 0.1.2)

#### Build PNDA components & upstream projects to specific 'BOM'
- Pass "BOM" as first parameter
- Pass a file path as the second parameter (e.g. /home/alice/bomfile)
- The file must contain a list of space delimited component/project version pairs
- The file must contain one entry for each PNDA component, as per the list below
- The file must contain one entry for each upstream project, as per the list below
- The version can be any valid tag or branch specifier
- PNDA components are built with the version specifier set to corresponding component release (e.g. 0.1.2)

##### BOM builds and upstream projects 
- By default, the version specified is interpreted as a tag or branch on pndaproject/platform-salt that references the upstream project
- If the version is specified in the form UPSTREAM(version), the version is interpreted as a tag or branch on the upstream project

#### Example 1

Simple BOM specifying a list of component versions and upstream project kafkamanager at the version used by PNDA release/3.1.

```sh
       platform-console-backend 0.1.0
       platform-console-frontend master
       platform-data-mgmnt 0.1.2
       platform-deployment-manager 0.1.0
       platform-libraries 0.1.0
       platform-package-repository 0.1.2
       platform-testing 0.1.0
       gobblin 0.1.0
       kafkamanager release/3.1
```
#### Example 2

More complex BOM specifying various component versions, PNDA release versions and explicitly referencing a particular upstream version of the upstream project, kafkamanager.

```sh
       platform-console-backend 0.1.0
       platform-console-frontend master
       platform-data-mgmnt release/3.2
       platform-deployment-manager 0.1.0
       platform-libraries develop
       platform-package-repository 0.1.2
       platform-testing release/3.1
       gobblin 0.1.0
       kafkamanager UPSTREAM(1.3.2.4)
```

## Build Products

All build products are assembled in the directory ```pnda-dist```.

From here, they can be copied to an ordinary HTTP server as part of your CICD processes. Refer to the PNDA guide to understand how to configure your PNDA YAML configuration files to use an HTTP server to serve PNDA components during the provisioning process.

## Upstream Projects

At the time of writing we build one upstream project, Kafka Manager. Build scripts for upstream projects are found in the ```upstream-projects``` directory and are invoked as part of the PNDA build process as described above.

