# PNDA 3.5

PNDA release 3.5 contains a number of improvements and bug fixes. 

### Offline installation

As you will see in the PNDA guide, we've revised the provisioning process in order to support offline installation. In the PNDA repository, you will find all the scripts necessary to retrieve the required resources from Internet during provisioning.
PNDA is working now in both offline and online environments although we retain the online option for development purposes.

### RedHat support

Another new feature is the support of RedHat within PNDA so you can now build a RHEL7 PNDA base image using pnda-dib-elements on OpenStack and if you run in AWS, you can use the RedHat AMI.
In term of deployment, we've revised platform-salt in order to make it generic so that OS specific versions / name / etc... are now defined in the pillars.

### General improvements

* Console performance
* Added Spark streaming applications


Please refer to the CHANGELOGs for a full list of fixes, changes and additions.
### Version Matrix
|Repository|Version|Date|
|---|---|---|
|[example-applications](#example-applications)|0.3.0|23 May 2017|
|[example-kafka-clients](#example-kafka-clients)|0.2.2|23 May 2017|
|[gobblin](#gobblin)|0.1.5|04 Jul 2017|
|[logstash-codec-pnda-avro](#logstash-codec-pnda-avro)|0.1.0|23 May 2017|
|[platform-console-backend](#platform-console-backend)|0.4.0|29 Jun 2017|
|[platform-console-frontend](#platform-console-frontend)|0.2.0|29 Jun 2017|
|[platform-data-mgmnt](#platform-data-mgmnt)|0.2.0|20 Jan 2017|
|[platform-deployment-manager](#platform-deployment-manager)|0.4.0|23 May 2017|
|[platform-libraries](#platform-libraries)|0.1.3|23 May 2017|
|[platform-package-repository](#platform-package-repository)|0.3.1|23 May 2017|
|[platform-salt](#platform-salt)|2.0.0|23 May 2017|
|[platform-salt-cloud](#platform-salt-cloud)|1.0.0|21 Oct 2016|
|[platform-testing](#platform-testing)|0.3.3|01 Aug 2017|
|[platform-tools](#platform-tools)|0.1.1|23 May 2017|
|[pnda](#pnda)|0.2.0|01 Aug 2017|
|[pnda-aws-templates](#pnda-aws-templates)|1.3.0|01 Aug 2017|
|[pnda-dib-elements](#pnda-dib-elements)|0.2.0|23 May 2017|
|[pnda-guide](#pnda-guide)|0.2.0|23 May 2017|
|[pnda-heat-templates](#pnda-heat-templates)|1.3.0|01 Aug 2017|
|[prod-logstash-codec-avro](#prod-logstash-codec-avro)|0.2.0|09 Sep 2016|
 
### Change Log
 
#### [example-applications](https://github.com/pndaproject/example-applications)
##### Changed
- PNDA-2700: Updated spark streaming example to work on RedHat.
 
##### Fixed
- PNDA-3051: Fixed timestamp generation for opentsdb datapoints
 
##### Added
- PNDA-2726: Added example spark-batch and spark-streaming jobs in python
 
#### [example-kafka-clients](https://github.com/pndaproject/example-kafka-clients)
##### Changed
- [ PNDA-2788 ]: Fixed issues on java sample code
 
#### [gobblin](https://github.com/pndaproject/gobblin)
##### Changed
- PNDA-3103: Accept any JDK1.8 to build
 
#### [logstash-codec-pnda-avro](https://github.com/pndaproject/logstash-codec-pnda-avro)
##### Added
- PNDA specific fix in order to make it compatible with the kafka output plugin
 
##### Fixed
- Fixed the decoder which expects a string
 
#### [platform-console-backend](https://github.com/pndaproject/platform-console-backend)
##### Added
- PNDA-2691: Allow offline installation
- PNDA-2374: Pin down specific dependencies
 
##### Changed
- PNDA-2682: Reviewed logging and routes
 
##### Fixed
- PNDA-3086: Only send notifications for metrics when they change (except health metrics)
- PNDA-2785: Pin compress to 1.3.0
 
#### [platform-console-frontend](https://github.com/pndaproject/platform-console-frontend)
##### Added:
- PNDA-2691: Refactor for offline installation
 
##### Changed
- PNDA-2827: Changed the display of the application metrics to lose the filter info.
- PNDA-3098: Sort kafka topics by name PNDA console.
 
##### Fixed
- PNDA-2374: Pin down specific dependencies
- PNDA-3016: When kafka topics have been deleted stop showing them in the PNDA console.
- PNDA-3086: Limit number of metrics shown on the metrics tab to 50, use the filter feature to show the others.
 
#### [platform-data-mgmnt](https://github.com/pndaproject/platform-data-mgmnt)
- Unchanged in this PNDA release
 
#### [platform-deployment-manager](https://github.com/pndaproject/platform-deployment-manager)
##### Added
- PNDA-2729: Added support for spark streaming jobs written in python (pyspark). Use `main_py` instead of `main_jar` in properties.json and specify additional files using `py_files`.
- PNDA-2784: Make tests pass on RedHat
 
##### Changed
- PNDA-2700: Spark streaming jobs no longer require upstart.conf or yarn-kill.py files, default ones are supplied by the deployment manager.
- PNDA-2782: Disabled Ubuntu-only test
 
#### [platform-libraries](https://github.com/pndaproject/platform-libraries)
##### Changed
- PNDA-2577: Revised python deps versions
- PNDA-2807: Update README.md in order to use yarn-client mode
 
#### [platform-package-repository](https://github.com/pndaproject/platform-package-repository)
##### Changed
- PNDA-2577: Revised python deps versions
- PNDA-2883: Added `auth_version` to `pr-config.json` to set the swift keystone auth version associated with `auth_url`
 
#### [platform-salt](https://github.com/pndaproject/platform-salt)
##### Added
- PNDA-2375: Isolate PNDA from breaking dependency changes
- PNDA-2456: Support for RedHat 7
- PNDA-2480: Added a per flavor pillar setting for kafka log retention (log.retention.bytes) set to 300MB (pico) 1GB (standard) to stop disks filling up on pico clusters.
- PNDA-2682: Revised console backend deployment
- Add a simple jupyter notebook
- Allow salt mine for all interfaces
 
##### Changed
- PNDA-2446: Download java with wget
- PNDA-2517: If Cloudera setup (cm_setup.py) fails, orchestrate can be re-run and cm_setup.py will attempt to continue from where it completed up to last time. Progress is recorded in /root/.CM_SETUP_SUCCESS which can be edited if manual control is required over the point to continue from.
- PNDA-2577: Use spur 0.3.20 for cm_setup.py
- PNDA-2596: Stop ingesting internal PNDA testbot topic
- PNDA-2672: Explicitly set CM API version number
- PNDA-2679: Set virtual env for impala-wrapper
- PNDA-2691: Install nodejs/npm from deb/rhel packages
- PNDA-2717: Remove pypi default URL
- PNDA-2721: Add spark gateway roles to datanodes
- PNDA-2756: Move Cloudera Manager installation in orchestrate stage instead of highstate stage
- PNDA-2758: Add a wait on elasticsearch running for kibana-dashboard
- PNDA-2787: Write cm_setup.log to /var/log/pnda instead of /tmp
- PNDA-2808: Install PNDA platform-libraries on all CDH nodes instead of just the jupyter node.
- PNDA-2810: Update boto library to 2.46.1 required to work with certain AWS regions (e.g. London)
- PNDA-2817: Remove cloudera-keys sls
- PNDA-2820: Refactoring of the installation of graphite-api
- PNDA-2883: add `auth_version` to `pr-config.json` to set the swift keystone auth version associated with `auth_url`
- PNDA-2885: Add gcc dependency for package-repository
- PNDA-2903: Install node.js from tar.gz instead of deb package
- PNDA-2966: Replace separate `install_sharedlib.py` with function in `cm_setup.py`
- PNDA-2964: Stop using ec2 grains during deployment as it's not needed anymore
- PNDA-2984: Upgrade JDK to 8u131
- PNDA-2881: Update Kafka Manager version to 1.3.3.6
- PNDA-2839: Update Grafana version to 4.2.0. Warning: the default pnda password has changed.
- PNDA-2841: Update Logstash version to 5.0.2 for PNDA logshipper/logserver
- PNDA-2838: Update OpenTSDB to version 2.3.0
- PNDA-3085: Set timezone to UTC (UTC by default but can be configured with ntp:timezone pillar)
- PNDA-3114: Install CDH platform testing modules after CDH has been set up.
- Update versions of cloudera manager and redis
- Add a flavor parameter to change kafka/zookeeper listening interface
- Install cloudera manager agents manually
- Explicitly set API version for CM
 
##### Fixed
- PNDA-2710: Remove online URL for logstash
- PNDA-2781 Fixes for redhat mirror usage
- PNDA-2874: Install correct snappy compression libraries, so avro files can be viewed in HUE again
- PNDA-3059: Use latest version of numerous base packages from distro
- PNDA-3112: Multiline log messages from file input
- PNDA-3129: Create log directory for gobblin which was missing and preventing log from being written.
- Update console-frontend owner to allow nginx to read files
- Update Elasticsearch/Kibana extraction to fix permission issues
 
#### [platform-salt-cloud](https://github.com/pndaproject/platform-salt-cloud)
- Unchanged in this PNDA release
 
#### [platform-testing](https://github.com/pndaproject/platform-testing)
##### Changed
- PNDA-3106: Publish per topic health
 
#### [platform-tools](https://github.com/pndaproject/platform-tools)
##### Changed
- PNDA-1810: Specify pip2 is to install hdfs
 
#### [pnda](https://github.com/pndaproject/pnda)
##### Added
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
 
##### Changed
- PNDA-2537: update mirror deb/rpm script in order to pinned top level version
- PNDA-2880: Pin 'sbt' to version 0.13.13
- PNDA-2894: Revise repo org and update documentation
- PNDA-2810: Update version of boto
- PNDA-2984: Upgrade JDK to 8u131
- Fix Cloudera dependencies at 5.9.0
 
##### Fixed
- PNDA-2717: Replace wget with curl
- Fix Anaconda version at 4.0.0
 
#### [pnda-aws-templates](https://github.com/pndaproject/pnda-aws-templates)
##### Added
- PNDA-2375: Isolate PNDA from breaking dependency change
- PNDA-2676: Support for redhat 7 in the bootstrap scripts. To use redhat set `OS_USER` to `ec2_user` and `imageId` to a redhat 7 AMI in pnda_env.yaml
- PNDA-2680: adding extra index url in pip configuration
- PNDA-2691: Add GPG key for nodejs repo
- PNDA-2706: Refactor template generation
- PNDA-2708: enable offline installation for python
- PNDA-2709: Use PNDA_MIRROR for RPMS, DEBS and misc files
- PNDA-2776: Wait on connectivity to cloud instances before trying to use them
- PNDA-2842: Add key based access to platform-salt git
- PNDA-2851: Add script to wait for ec2 grains
- PNDA-3147: Add dry-run option to CLI that can be used to dry-run the changes to the Cloud Formation stack for create and expand operations.
- Add online fallback for yum
 
##### Changed
- PNDA-2446: Place PNDA packages in root of PNDA_MIRROR
- PNDA-2717: Rename mirror paths
- PNDA-2802: Refactor saltmaster bootstrap code
- PNDA-2809: Update m3 instance type defaults to use the latest m4 family instead
- PNDA-2849: Limit how long we wait for host connectivity
- Remove minion install from salt-master script
- Include time and log level in console output
- Update git version in order to be align with deb mirror script
- Prioritize local mirror over original repo
 
##### Fixed
- PNDA-2758: Fix bootstrap for expand
- PNDA-2803: Remove duplicate salt-master restart commands
- PNDA-2851: Check for ec2 grains before running salt commands as sometimes the ec2 grain wasn't available when running highstate, but was when checked later on
- Fix pylint violations
- Fix issue on easy install configuration
 
#### [pnda-dib-elements](https://github.com/pndaproject/pnda-dib-elements)
##### Added
- PNDA-2741: New element to disable IPv6
- PNDA-2742: New element to bond eth0 and eth1 together
- PNDA-2780: New element executing https://github.com/dev-sec/ansible-os-hardening ansible role
- PNDA-2733: Add support for RHEL 
 
##### Changed
- Disable password expiration in os-hardening element
 
#### [pnda-guide](https://github.com/pndaproject/pnda-guide)
##### Added
- PNDA-2873: Documentation for the new Avro Codec
 
##### Changed
- PNDA-2875: Adjust references to 'package server', salt-cloud & ubuntu
- PNDA-2901: Refactor guide to replace creation section and remove repository READMEs
- Update README to reflect continuous updates
- Update Jupyter and JupyterHub versions
- Update platform_requirements.md
 
#### [pnda-heat-templates](https://github.com/pndaproject/pnda-heat-templates)
##### Added
- PNDA-3043: Added [mandatory] os_user parameter to pnda_env.yaml - the target platform specific operating system user/sudoer used to configure the cluster instances
- PNDA-2375: Isolate PNDA from breaking dependency changes
- PNDA-2456: Initial work to support for Redhat 7. Salt highstate and orchestrate run on a Redhat7 HEAT cluster with no errors but requires further testing and work
- PNDA-2680 adding extra index url in pip configuration
- PNDA-2708: Add pip index URL in order to enable offline installation
- PNDA-2709: Allow offline installation of ubuntu and redhat packages
- PNDA-2801: Add support for bare-metal deployment using the bmstandard flavor. Add support for distribution flavor providing kafka only cluser. Add documentation for baremetal deployment.
- PNDA-2801: Add offline support for distribution flavor
- PNDA-2878 Isolate PNDA from breaking dependency
- Add an hypervisor_count setting in the pnda_env file to enable Anti-Affinity feature in PNDA.
- Add ability to define a software config that applies a pre config script to all instances but bastion.
- A 'specific_config' parameter to 'pnda_env.yaml' in order to pass parameters to bootstrap scripts and salt pillar, in a generic way
- Example instackenv.json for bare metal
- Add code to make Salt-master listen on a specific VLAN interface
- Add functionality to simulate offline deployment and support pico flavor
- Add online fallback for yum
 
##### Changed
- PNDA-2446: Place PNDA packages in root of PNDA_MIRROR
- PNDA-2688: review pnda_env default values
- PNDA-2691: Use GPG key for nodejs repo
- PNDA-2696: Use PNDA_MIRROR for misc files
- PNDA-2717: Rename mirror paths
- PNDA-2819: fix issue on volume reference once create network is 0
- PNDA-2882: Only create package repo volume in standard flavour if the repo type is set to local
- PNDA-2883: Allow `keystone_auth_version` to be set in `pnda.yaml`
- fix issue on preconfig error as keystone auth version not needed
- Use 'requests' instead of 'tornado' to download files in salt
- Make saltmaster listen on eth0 by default
- Prioritize local mirror over original repo
 
##### Fixed
- PNDA-2804: Remove unused cloudera role on kafka instance
- PNDA-2916: Make number of kafka nodes variable for pico flavour
- PNDA-2833: pylint fixes
 
#### [prod-logstash-codec-avro](https://github.com/pndaproject/prod-logstash-codec-avro)
- Unchanged in this PNDA release
 
