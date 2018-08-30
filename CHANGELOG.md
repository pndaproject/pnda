# Change Log
All notable changes to this project will be documented in this file.

## [Unreleased]

## [2.0.0] 2018-08-28
### Added
- PNDA-3673: Added consul resources to mirror build
- PNDA-4427: Add Flink software to PNDA build and mirror processes
- PNDA-4452: Add curl to mirror
- PNDA-4417: Add fastavro to list of python dependencies
- PNDA-4558: Add Knox 1.0.0 to mirror
- PNDA-4598: Add ldap client rpm packages to mirror
- PNDA-4643: Enable TLS and other options/optimizations support in haproxy
- PNDA-4736: Create code to create base AMI for use in EC2
- PNDA-4774: Add mysql-community-client dependency
- PNDA-4888: Docker support for mirror

### Changed
- PNDA-4400: Update Anaconda to 5.1.0, remove Anaconda CDH parcel mirror as both HDP and CDH now install Anaconda from a bundle
- PNDA-4394: Add various libraries to app-packages so they are available 'out of the box' to PNDA users
- PNDA-4396: Update Kibana, Logstash and ElasticSearch to 6.2.1 for Log Server
- PNDA-4408: Update kafka-python to 1.3.5
- PNDA-4408: Update kafka to 0.11.0.2
- PNDA-4410: Allow rpm repo names to be set using environment variables
- PNDA-4415: Update Boto to 2.48.0
- PNDA-4515: Retry Kafka Manager build on failure
- PNDA-4122: Remove scalable ELK
- PNDA-4525: Deprecate Ubuntu 14.04
- PNDA-4673: Provide python JDBC libraries instead of PyHive in the python mirror
- PNDA-4440: Upgrade Kafka from 0.11.0.2 to 1.1.0
- PNDA-4818: Update Ambari to 2.7.0.0 and HDP to 2.6.5.0
- PNDA-4837: Update Grafana version to 5.1.3
- PNDA-4892: Remove kafkat
- PNDA-4909: Remove livy and sparkmagic 
- PNDA-4899: Introduce conditionality to produce build/mirror with only artefacts required

### Fixed
- PNDA-4891: Pin version of grunt-cli at 1.2.0 to avoid it changing when new versions are released
- PNDA-4200: Fix missing matplotlib and dependencies for Jupyter python3 kernel
- PNDA-4412: When creating the python mirror, ensure that the epel repo is enabled
- PNDA-4413: Install yum-utils in mirror and build scripts
- PNDA-4441: Specify tornado version and update kafka-python version in build deps
- PNDA-4217: Exit cleanly whether sourced or executed
- PNDA-4549: Failed to build Kafka-manager
- PNDA-4666: Account for new dir structure inside HDP-UTILS
- PNDA-4608: Mismatch setuptools version in mirror and build
- PNDA-4759: DRYer implentation that allows use of CentOS or RHEL
- PNDA-4764: Adding OS_USER parameter for the mirror script on packer
- PNDA-4708: Update OpenSSL versions for RHEL 7.5
- PNDA-4753: Flink build failed but overall build continues
- PNDA-4930: Fix BOM file based builds

## [1.1.0] 2018-02-10
### Added
- PNDA-3562: Add pam-devel for PAM authentication on PNDA console frontend
- PNDA-2832: Jupyter %sql magic support
- PNDA-1899: Scala Spark Jupyter Integration
- PNDA-3133: Remove Gobblin fork and use release distribution instead.
- PNDA-3549: Include common jar and egg dependencies used by applications that run on PNDA
- PNDA-3128: Add kafka-python (new version) and avro python packages to app-packages

### Changed
- PNDA-3579: Ignore files generated on install build tools step
- PNDA-3530: Ambari version 2.6.0.0 and HDP version 2.6.3.0
- PNDA-3483: Zookeeper version 3.4.11
- PNDA-4043: Update HDP to version 2.6.4.0

### Fixed
- PNDA-3578: RPM repo can be overridden before running mirror scripts in case of non AWS environment
- Forked: Remove conditional key import
- PNDA-4176: Static file dependencies are not retried properly during mirror creation

## [1.0.0] 2017-11-24
### Added
- PNDA-3304: Add script to set a non-transparent proxy for the mirror build.
- PNDA-1960: Make Kafkat available on nodes as option for Kafka management at CLI
- PNDA-3484: Add CentOS Support

### Changed
- PNDA-3216: Include Logstash 5.2.2 and updated plugin mechanism with fixed behaviour for offline installation
- PNDA-3264: Use redis 3.2.10 on redhat
- PNDA-3269: remove sudo on scripts as they should be run as root
- PNDA-3270: fix issue on Jupyter py2 deps
- PNDA-3289: Detect errors when building mirror and set exit code
- PNDA-3249: Upgrade Kafka version to 0.11.0.0
- PNDA-2884: Upgrade CDH and Cloudera Manager version 5.12.1

### Fixed
- PNDA-3499: Cleanup CHANGELOG with missing release info.
- PNDA-3356: Include zip on deb mirror for HDP installation
- PNDA-3238: Add jupyter extensions to the kenel virtual environment.
- PNDA-3347: fix issue on HDP utils folder structure on ubuntu14
- upgrade OpenSSL versions

## [0.2.0] 2017-08-01
### Added
- PNDA-2452: Add high level overview of creating PNDA
- PNDA-2691: Add jupyterproxy upstream project
- PNDA-2693: Script to setup RPM and DEB package mirrors
- PNDA-2782: Support RHEL builds
- PNDA-2836: Scripts to update existing deb, rpm and python mirrors with new packages
- PNDA-2843: Specify explicit versions for all python modules
- PNDA-2874: Add snappy compression libraries for deb and rpm mirrors
- PNDA-2903: Obtain nodejs as tar.gz instead of deb/rpm
- PNDA-2944: Add RedHat license checks
- Add graphite-api packages for offline
- Synchronize the package index files after adding new sources
### Changed
- PNDA-2537: update mirror deb/rpm script in order to pinned top level version
- PNDA-2880: Pin 'sbt' to version 0.13.13
- PNDA-2894: review repo org and update documentation
- PNDA-2810: Update version of boto
- PNDA-2984: Upgrade JDK to 8u131
- Fix Cloudera dependencies at 5.9.0
### Fixed
- PNDA-2717: Replace wget with curl
- Fix Anaconda version at 4.0.0

### Added
- PNDA-2445: Support for Hortonworks HDP hadoop distro.

## [0.1.1] 2017-01-20
### Changed
- Updated dependencies for build tools

## [0.1.0] 2016-12-12
### First version
- Top level repository and build system for PNDA
