# PNDA 3.6

PNDA release 3.6 comes with a couple of new features, a number of additions/improvements and various bug fixes.

### Modular PNDA CLI
The PNDA CLI is a new repo that offers an used to execute operational tasks on PNDA clusters.
The vision for this sub-project is that it eventually replaces all the individual 'template' repositories in PNDA with one common code base, presenting the end user with a unified interface to several different 'back ends'.
At present, the PNDA CLI supports two back ends:
- Creating PNDA on AWS using CloudFormation.
- Creating PNDA on an existing server cluster (PNDA can be installed using the PNDA CLI onto pre-existing machines. In this mode the Cloud Formation parts of the pnda-cli are disabled and it runs only the bootstrap and saltstack stages of PNDA creation).

As a consequence, the [pnda-aws-templates](#pnda-aws-templates) has been marked deprecated and will not be supported with this new release.

For more details refer to the [PNDA CLI](https://github.com/pndaproject/pnda-cli) repo.

### HDP support
Starting with this release, PNDA has been extended with an additional Hadoop distribution: The [Hortonworks HDP](https://hortonworks.com/products/data-center/hdp/) providing a wider choice of feature set, licensing or pricing.
The Hortonworks HDP distribution 100% open source and introduces some alternative technologies including:
 - Ambari for cluster monitoring, management, [additional UIs](https://docs.hortonworks.com/HDPDocuments/Ambari-2.5.1.0/bk_ambari-views/content/ch_understanding_ambari_views.html) and [setup](https://cwiki.apache.org/confluence/display/AMBARI/Blueprints).
 - Hive for MPP SQL queries instead of Impala.

For more details refer to the [Hadoop Distributions](https://github.com/pndaproject/pnda-guide/blob/develop/gettingstarted/hadoop_distro.md) guide.

### Notable additions or improvements include:
- support for CentOS as an alternative Linux distribution.
- support for creating the mirror and building pnda components from behind a non-transparent proxy.
- support for adding pyspark application dependencies
- addition of Kafkat as option for Kafka management.
- addition of developer and production users as default users of the platform.
- addition of OpenTSDB component in the PNDA console.
- addition of a new 'production' flavor (designed for larger, bare metal clusters).
- upgrade of Kafka(0.11), Logstash(5.2) and CDH(5.12). 
 
### Version Matrix
|Repository|Version|Date|
|---|---|---|
|[example-applications](#example-applications)|0.4.0|24 Nov 2017|
|[example-kafka-clients](#example-kafka-clients)|0.2.3|24 Nov 2017|
|[gobblin](#gobblin)|0.1.6|24 Nov 2017|
|[logstash-codec-pnda-avro](#logstash-codec-pnda-avro)|0.1.1|24 Nov 2017|
|[platform-console-backend](#platform-console-backend)|0.4.0|29 Jun 2017|
|[platform-console-frontend](#platform-console-frontend)|0.2.1|24 Nov 2017|
|[platform-data-mgmnt](#platform-data-mgmnt)|0.2.1|24 Nov 2017|
|[platform-deployment-manager](#platform-deployment-manager)|0.5.0|24 Nov 2017|
|[platform-libraries](#platform-libraries)|0.1.4|24 Nov 2017|
|[platform-package-repository](#platform-package-repository)|0.3.1|23 May 2017|
|[platform-salt](#platform-salt)|3.0.0|24 Nov 2017|
|[platform-salt-cloud](#platform-salt-cloud)|1.0.0|21 Oct 2016|
|[platform-testing](#platform-testing)|0.4.0|24 Nov 2017|
|[platform-tools](#platform-tools)|0.1.2|24 Nov 2017|
|[pnda](#pnda)|1.0.0|24 Nov 2017|
|[pnda-cli](#pnda-cli)|1.0.0|24 Nov 2017|
|[pnda-dib-elements](#pnda-dib-elements)|0.2.0|23 May 2017|
|[pnda-guide](#pnda-guide)|0.3.0|24 Nov 2017|
|[pnda-heat-templates](#pnda-heat-templates)|1.4.0|18 Dec 2017|

### Testing Matrix

#### Mirror/Build server
||mirror|build|
|---|---|---
|RHEL|PASSED|PASSED|
|Ubuntu|PASSED|PASSED|
|CentOS|PASSED|PASSED|

#### Using the ```pnda-cli``` on *existing machines* 
||production|
|---|---|
|RHEL, HDP|PASSED|

#### Using the ```pnda-cli``` on *AWS*
||pico|standard|
|---|---|---|
|RHEL, HDP|PASSED|PASSED|
|Ubuntu, HDP|PASSED|PASSED|
|RHEL, CDH|PASSED|PASSED|
|Ubuntu, CDH|PASSED|PASSED|

#### Using the ```heat-cli``` on *OpenStack* 
||pico|standard|
|---|---|---|
|RHEL, HDP|PASSED|PASSED|
|Ubuntu, HDP|PASSED|PASSED|
|RHEL, CDH|PASSED|PASSED|
|Ubuntu, CDH|PASSED|PASSED|

### Change Log
 
#### [example-applications](https://github.com/pndaproject/example-applications)
##### Changed
- PNDA-3401: Change the spark-batch(-python) to output in the user's directory.
 
##### Added
- PNDA-2445: Support for Hortonworks HDP hadoop distro.
 
##### Fixed
- PNDA-3419: update KSO data source to work with Kafka 0.11.0.0
- PNDA-3499: Cleanup CHANGELOG with missing release info.
 
#### [example-kafka-clients](https://github.com/pndaproject/example-kafka-clients)
##### Fixed
- PNDA-3499: Cleanup CHANGELOG with missing release info.
 
#### [gobblin](https://github.com/pndaproject/gobblin)
##### Changed
- PNDA-3304: Remove javadoc generation in all subprojects.
 
##### Fixed
- PNDA-3499: Cleanup CHANGELOG with missing release info.
 
#### [logstash-codec-pnda-avro](https://github.com/pndaproject/logstash-codec-pnda-avro)
##### Fixed
- PNDA-3499: Cleanup CHANGELOG with missing release info.
- PNDA-3082: Update README.md
 
#### [platform-console-backend](https://github.com/pndaproject/platform-console-backend)
- Unchanged in this PNDA release
 
#### [platform-console-frontend](https://github.com/pndaproject/platform-console-frontend)
##### Fixed:
- ISSUE-45: Added UI for opentsdb component with info, help, settings icons and color code for health status in console homepage.
 
##### Added:
- PNDA-2445: Support for Hortonworks HDP
 
#### [platform-data-mgmnt](https://github.com/pndaproject/platform-data-mgmnt)
##### Added:
- PNDA-2445: Support for Hortonworks HDP
 
##### Fixed
- PNDA-3427: Configure data-service with the webhdfs services.
 
#### [platform-deployment-manager](https://github.com/pndaproject/platform-deployment-manager)
##### Added:
- PNDA-3330: Change to use a default application user instead of the hdfs user.
- PNDA-2445: Support for Hortonworks HDP
 
#### [platform-libraries](https://github.com/pndaproject/platform-libraries)
##### Added
- PNDA-2445: Support for Hortonworks HDP hadoop distro.
 
#### [platform-package-repository](https://github.com/pndaproject/platform-package-repository)
- Unchanged in this PNDA release
 
#### [platform-salt](https://github.com/pndaproject/platform-salt)
##### Added
- PNDA-3330: Add default application user configuration to the deployment manager.
- PNDA-2982: Added support for adding pyspark application dependencies
- PNDA-1960: Make Kafkat available on nodes as option for Kafka management at CLI
- PNDA-2445: Support for Hortonworks HDP hadoop distro
- PNDA-2163: Support for OpenTSDB Platform testing
- PNDA-1788: Cloudera version can be set in the salt pillar
- PNDA-3314: Added new flavor for larger PNDAs called "production"
- PNDA-3484: Add CentOS support
- PNDA-3497: Add pillar config to set how many data directories to configure HDFS to use.
 
##### Changed
- PNDA-2965: Rename `cloudera_*` role grains to `hadoop_*`
- PNDA-3216: Uprev to logstash 5.2.2
- PNDA-3180: Limit orchestrate commands to new nodes only
- PNDA-3212: Link logstash install directory using salt file.symlink command as the cmd.run version was preventing logshipper/logserver upgrades
- PNDA-3249: Upgrade Kafka version to 0.11.0.0
- PNDA-3264: Use redis 3.2.10 on redhat
- PNDA-2884: Upgrade CDH and Cloudera Manager version 5.12.1
- PNDA-3380: Move opentsdb log to /var/log/pnda
- PNDA-3441: Cleanup warnings from create_notebook_dir.sh script
- PNDA-3451: Use existing MySQL for the Ambari database
- PNDA-2486: Move yarn local directories to /data0 to separate the data from the operating system partition.
 
##### Fixed
- PNDA-3499: Cleanup CHANGELOG with missing release info.
- PNDA-3213: fix issue on wrong checksum file name for logserver sls
- PNDA-3615: conda command now works 'out-of-the-box' with correct PATH additions
- PNDA-3216: Use new logstash plugin mechanism in 5.2.2 that actually works when offline
- PNDA-3111: Report failures up if opentsdb.hbase_tables fails
- PNDA-3309: use local gem installation for Kafka tool
- PNDA-3343: When expanding a cluster new datanodes are given a spark gateway role
- PNDA-3309: Write `CM_SETUP_SUCCESS` into a fixed directory
- PNDA-3369: fix issue on offsets topic replication factor on kafka configuration zhere default value is 3
- PNDA-3238: Add jupyter extensions to the kenel virtual environment.
- PNDA-3350: Fix dm.pem permission post deployment highstate.
- PNDA-3013: Fix issue on Keystone passwords with illegal XML characters (such as &) cause Hadoop setup to fail.
 
#### [platform-salt-cloud](https://github.com/pndaproject/platform-salt-cloud)
- Unchanged in this PNDA release
 
#### [platform-testing](https://github.com/pndaproject/platform-testing)
##### Added
- PNDA-ISSUE-42: opentsdb platform test to return empty list in causes field for good health in opentsdb.health metric
- PNDA-2445: Support for Hortonworks HDP hadoop distro
- PNDA-2163: Support for OpenTSDB Platform testing
- PNDA-3381: Support for multiple Kafka endpoints
 
#### [platform-tools](https://github.com/pndaproject/platform-tools)
##### Fixed
- PNDA-3499: Cleanup CHANGELOG with missing release info.
 
#### [pnda](https://github.com/pndaproject/pnda)
##### Added
- PNDA-3304: Add script to set a non-transparent proxy for the mirror build.
- PNDA-1960: Make Kafkat available on nodes as option for Kafka management at CLI
- PNDA-3484: Add CentOS Support
 
##### Changed
- PNDA-3216: Include Logstash 5.2.2 and updated plugin mechanism with fixed behaviour for offline installation
- PNDA-3264: Use redis 3.2.10 on redhat
- PNDA-3269: remove sudo on scripts as they should be run as root
- PNDA-3270: fix issue on Jupyter py2 deps
- PNDA-3289: Detect errors when building mirror and set exit code
- PNDA-3249: Upgrade Kafka version to 0.11.0.0
- PNDA-2884: Upgrade CDH and Cloudera Manager version 5.12.1
 
##### Fixed
- PNDA-3499: Cleanup CHANGELOG with missing release info.
- PNDA-3356: Include zip on deb mirror for HDP installation
- PNDA-3238: Add jupyter extensions to the kenel virtual environment.
- PNDA-3347: fix issue on HDP utils folder structure on ubuntu14
- upgrade OpenSSL versions
 
#### [pnda-cli](https://github.com/pndaproject/pnda-cli)
##### Added
- PNDA-3160: Added support for creating PNDA on existing server clusters
- PNDA-1960: Make Kafkat available on nodes as option for Kafka management at CLI
- PNDA-2955: Add pnda_env.yaml setting for choosing hadoop distro to install
- PNDA-3302: Upgrade edge flavor on pico
- PNDA-3218: Add iprejecter to enable offline env
- PNDA-3314: Add new flavor 'production' designed for larger, bare metal clusters
- PNDA-3484: Add CentOS support
 
##### Changed
- PNDA-3186: Refactored code into CLI for creating PNDAs on many platforms (pnda-cli)
- PNDA-2965: Rename `cloudera_*` role grains to `hadoop_*`
- PNDA-3215: Remove EPEL repository
- PNDA-3180: When expanding a cluster limit the operations to strictly required steps on specific nodes
- PNDA-3444: Disallow uppercase letters in the cluster names due to AMBARI-22361 affecting HDP.
 
##### Fixed
- PNDA-3499: Cleanup CHANGELOG with missing release info.
- PNDA-3200: socks_proxy script reuses existing ssh-agent instead of launching a new one if possible
- PNDA-3199: Make socks proxy script executable
- PNDA-3424: Add a retry to AWS API calls to work around SSL timeout errors
- PNDA-3377: fix issue on check config which required descriptor file
 
#### [pnda-dib-elements](https://github.com/pndaproject/pnda-dib-elements)
- Unchanged in this PNDA release
 
#### [pnda-guide](https://github.com/pndaproject/pnda-guide)
##### Changed
- Rewrote Provisioning section
- PNDA-2873: Documentation for the new Avro Codec
- PNDA-2839: Update Grafana documentation for default password
- PNDA-3167: Update flavor as this is m4 instead of m3
- PNDA-3231: Update SUMMARY in order to include all the provisioning parts
- PNDA-3302: upgrade edge flavor on pico
 
##### Added
- PNDA-3304: Add script to set a non-transparent proxy for the mirror build.
- PNDA-2726: Added example spark-batch and spark-streaming jobs in python
- PNDA-3208: Adding information on how to extend/manage Avro schema evolutions
 
#### [pnda-heat-templates](https://github.com/pndaproject/pnda-heat-templates)
##### Added:
- PNDA-2969: Allow hadoop distro to be set in `pnda_env.yaml`. Supported values are `HDP` and `CDH`.
- PNDA-2389: PNDA automatically reboots instances that need rebooting following kernel updates
 
##### Changed
- PNDA-3444: Disallow uppercase letters in the cluster names.
- PNDA-2965: Rename `cloudera_*` role grains to `hadoop_*`
- PNDA-3180: When expanding a cluster limit the operations to strictly required steps on specific nodes
- PNDA-3249: put mine configuration in pillar
- Issue-123: Fixed Jenkins GPG Key Added in package-install.sh file
 
##### Fixed
- PNDA-3499: Cleanup CHANGELOG with missing release info.
- PNDA-3524: remove beacons logic 
