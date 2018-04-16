# PNDA Build Tools

In this directory you will find tools that install necessary build pre-requisites and produce set of components for use in provisioning PNDA clusters.

All scripts have been tested on the following environment -

- AWS m3.large instance (2 CPUs, 7.5GB memory and 32GB SSD storage)
- AMI: CentOS 7 (ami-6e28b517)

## Preparing the build environment

The script ```install-build-tools.sh``` installs all the necessarily build prerequisites.

In case you are not in the AWS environment and you are using Redhat, you will need to override default RedHat repos by defining the following environment variables. The names should be subsituted with the appropriate names for your environment.

```
sudo su
export RPM_OPTIONAL=rhel-7-server-optional-rpms
export RPM_EXTRAS=rhel-7-server-extras-rpms
```

Run it with superuser privileges in the location that you wish to install your build tools.

For example

```sh
sudo su
cd /home/builder
./install-build-tools.sh
```

As well as installing all the required software, it may pause and ask the operator to carry out some configuration on the build environment, for example adjusting the contents of /etc/hosts.

Once it has finished, a file called ```set-pnda-env.sh``` will be found in the working directory. This script contains the necessary environment variables and other settings needed to carry out builds. It should either be added to the end of an initialization script such as ```/etc/bash.bashrc``` so that these settings are available for new shells, or it can be invoked with each build.

For example

```sh
sudo su
cat >> /etc/bash.bashrc
. /home/builder/set-pnda-env.sh
```

Your environment is now ready to build PNDA.

## Building PNDA

The script ```build-pnda.sh``` is invoked as a non-privileged user.

For example

```sh
cd pnda
./build-pnda.sh RELEASE release/3.2
```

#### Build master PNDA components & upstream projects at release X
- Pass "RELEASE" as first parameter
- Pass PNDA release tag as second parameter (e.g. release/3.2)
- PNDA components are built with the version specifier set to corresponding component release (e.g. 0.1.2)

#### Build latest PNDA components & upstream projects to a given branch or tag
- Pass "BRANCH" as first parameter
- Pass PNDA branch or tag as the second parameter (e.g. develop)
- PNDA components are built with the version specifier set to the branch or tag

It is also possible to build to a specific "bill of materials", please refer to [BOM builds](docs/ADVANCED.md) for details.

## Build Products

All build products are assembled in the directory ```pnda-dist```.

From here, they can be copied to an ordinary HTTP server as part of your CICD processes. Refer to the PNDA guide to understand how to configure your PNDA YAML configuration files to use an HTTP server to serve PNDA components during the provisioning process.

## Upstream Projects

Build scripts for upstream projects are found in the ```upstream-projects``` directory and are invoked automatically as part of the PNDA build process described above. At the time of writing we build one upstream project, Kafka Manager.


## Using the build products

Please refer to [these notes](docs/PACKAGE_SERVER.md) on staging the built components for use in provisioning PNDA clusters.
