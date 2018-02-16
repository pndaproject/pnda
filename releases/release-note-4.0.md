# PNDA 4.0

PNDA 4.0 is a major release containing a number of new features, improvements and bug fixes.

### Multi-user awareness, resource management & security

In preparation for upcoming work on PNDA security, right across the platform we've introduced multi-user awareness where previously a single 'pnda' user was assumed. 

Whether you're using Jupyter notebooks, delivering applications via the Deployment Manager APIs, using the PNDA console or any of the Spark, Hive, HBase or other shells, PNDA will carry out work on behalf of a specific user and map that work based on the user to queues in YARN using a configurable mechanism - see the [PNDA guide](https://github.com/pndaproject/pnda-guide/blob/0.4/resourcemanagement/README.md) for details.

Also on the security front there's a mechanism for uploading certificates and keys for securing web services on PNDA, and the PNDA Console has a brand new login screen.

These improvements have necessitated significant changes that have affected APIs so please read the CHANGELOGs below carefully for anything that may affect you directly.

### Spark 2

For HDP clusters we now support Spark 2 alongside Spark 1 in Jupyter, Deployment Manager and shells, and this works with the above mechanisms to assign users and groups to resource allocations.

### Ingest

The mechanics for handling ingest have undergone signifcant revision. We've dropped our fork of the Gobblin project and instead now deploy the current latest Gobblin release (0.11.0). The PNDA specific modules for handling ingest have been factored out into a new PNDA component, and we're using a new Kafka deserializer and packing algorithm to reduce the number of small files on the system. 

In addition to this we're also including a compaction process that can be configured in conjuction with the existing ingest to generate a separate, compacted tree. Together with the existing PNDA Data Management functionality these tools can be used to organize a policy to migrate older data towards compacted and compressed archives before eventual removal from the system.

### And more...

As usual, there are a long list of bug fixes and other improvements since the last release, please refer to the CHANGELOGs and commit logs for more details.


#### Updated technologies

- Kafka Manager is now at 1.3.3.15
- HDP is now at 2.6.4.0
- Zookeeper is now at 3.4.11

### Deprecated repositories

We've decided to deprecate the following repositories.

- gobblin
- platform-salt-cloud
- pnda-aws-templates (this functionality is available through pnda-cli)

### Version Matrix
|Repository|Version|Date|
|---|---|---|
|[example-applications](#example-applications)|0.5.0|10 Feb 2018|
|[example-kafka-clients](#example-kafka-clients)|0.2.3|24 Nov 2017|
|[logstash-codec-pnda-avro](#logstash-codec-pnda-avro)|0.1.1|24 Nov 2017|
|[platform-console-backend](#platform-console-backend)|1.0.0|10 Feb 2018|
|[platform-console-frontend](#platform-console-frontend)|1.0.0|10 Feb 2018|
|[platform-data-mgmnt](#platform-data-mgmnt)|0.2.2|10 Feb 2018|
|[platform-deployment-manager](#platform-deployment-manager)|1.0.0|10 Feb 2018|
|[platform-gobblin-modules](#platform-gobblin-modules)|0.1.0|10 Feb 2018|
|[platform-libraries](#platform-libraries)|0.1.5|10 Feb 2018|
|[platform-package-repository](#platform-package-repository)|0.3.2|10 Feb 2018|
|[platform-salt](#platform-salt)|4.0.0|10 Feb 2018|
|[platform-testing](#platform-testing)|0.5.0|10 Feb 2018|
|[platform-tools](#platform-tools)|0.1.2|24 Nov 2017|
|[pnda](#pnda)|1.1.0|10 Feb 2018|
|[pnda-cli](#pnda-cli)|1.1.0|10 Feb 2018|
|[pnda-dib-elements](#pnda-dib-elements)|0.2.0|23 May 2017|
|[pnda-guide](#pnda-guide)|0.4.0|10 Feb 2018|
|[pnda-heat-templates](#pnda-heat-templates)|1.5.0|10 Feb 2018|


### Testing Matrix

#### Mirror/Build server
||mirror|build|
|---|---|---
|RHEL|Validated|Validated|
|Ubuntu|Validated|Validated|
|CentOS|Validated|Validated|

#### Using the ```pnda-cli``` on *existing machines* 
||production|
|---|---|
|RHEL, HDP|Validated|

#### Using the ```pnda-cli``` on *AWS*
||pico|standard|
|---|---|---|
|RHEL, HDP|Validated|Validated|
|Ubuntu, HDP|Validated|Validated|
|RHEL, CDH|Validated|Validated|
|Ubuntu, CDH|Validated|Validated|

#### Using the ```heat-cli``` on *OpenStack*

PNDA on OpenStack is designated as experimental in PNDA 4.0. We plan to do further work on this platform in future releases given sufficient community interest and support.

### Change Log


#### [example-applications](https://github.com/pndaproject/example-applications)
##### Changed
- PNDA-3555: Use /pnda/deployment as expected HDFS library location.
- PNDA-3549: Remove jar and egg dependencies used by spark-streaming-python application that run on PNDA that are now included by default.
- PNDA-1899: Changed notes to reflect addition of Scala to supported languages in Jupyter (experimental)
 
##### Added
- PNDA-3479: Added an example application that uses the Spark2 Structured Streaming API
 
##### Fixed
- PNDA-3402: fix build issue on KSO app
 
#### [example-kafka-clients](https://github.com/pndaproject/example-kafka-clients)
- Unchanged in this PNDA release
 
#### [logstash-codec-pnda-avro](https://github.com/pndaproject/logstash-codec-pnda-avro)
- Unchanged in this PNDA release
 
#### [platform-console-backend](https://github.com/pndaproject/platform-console-backend)
##### Added
- PNDA-439: Support deploying/running app as specific user
- PNDA-3562: Add PAM authentication
- PNDA-3596: Use passportjs for managing authentication
- PNDA-2834: Actual application status by deployment manager
 
##### Changed
- PNDA-3601: Disable emailtext in Jenkins file and replace it with notifier stage and job
- PNDA-3624: Update Login API
 
##### Fixed
- PNDA-3609: Use passport on socketio and put the secret in configuration file
- PNDA-3626: Use the secure cookie information to create an application.
- PNDA-3635: Fix issue on socketio by using session store to Redis
- PNDA-3622: Stop the build if a command failed
 
#### [platform-console-frontend](https://github.com/pndaproject/platform-console-frontend)
##### Added:
- PNDA-439: Support deploying/running app as specific user
- PNDA-2834: Added pop-up for displaying status of each sub-component of each application on applications page.
- PNDA-3562: Add PAM authentication
- PNDA-3100: Organize Kafka topics especially when there are a lot of topics
 
##### Changed:
- PNDA-3601: Disable emailtext in Jenkins file and replace it with notifier stage and job
- PNDA-3596: Review authentication since passportjs used in console backend
 
##### Fixed
- PNDA-3609: Back to login if authentication failed / browser restart
- PNDA-3622: Stop the build if a command failed
 
#### [platform-data-mgmnt](https://github.com/pndaproject/platform-data-mgmnt)
##### Changed:
- PNDA-3601: Disable emailtext in Jenkins file and replace it with notifier stage and job
 
#### [platform-deployment-manager](https://github.com/pndaproject/platform-deployment-manager)
##### Added:
- PNDA-439: Support deploying/running app as specific user
- PNDA-2834: Better and more detailed application status reporting
- PNDA-3654: Support for spark2 streaming applications
- PNDA-4007: Ability to specify default queue configuration for oozie components
 
##### Changed
- PNDA-3555: Place files in HDFS for packages and applications under `/pnda/system/deployment-manager/<packages|applications>`.
- PNDA-3601: Disable emailtext in Jenkins file and replace it with notifier stage and job
 
##### Fixed
- PNDA-3354: Fix error causing exception to appear in log when trying to deploy packages that do not exist
- PNDA-2282: Improved reporting in error scenarios
- PNDA-3613: Deployment manager tests require sudo to run but should not
- PNDA-4056: Automatically sync environment descriptor
 
#### [platform-gobblin-modules](https://github.com/pndaproject/platform-gobblin-modules)
##### Added
- PNDA-3133: Remove Gobblin fork and replace with release distribution and new PNDA component library
 
#### [platform-libraries](https://github.com/pndaproject/platform-libraries)
##### Changed
- PNDA-3601: Disable emailtext in Jenkins file and replace it with notifier stage and job
- PNDA-3237: Don't rdd.cache() as this has implications and should be left up to the client
- PNDA-4216: Handle PEP-440 name normalization in build artefact
 
#### [platform-package-repository](https://github.com/pndaproject/platform-package-repository)
##### Changed
- PNDA-3601: disable emailtext in Jenkins file and replace it with notifier stage and job
 
#### [platform-salt](https://github.com/pndaproject/platform-salt)
##### Added
- PNDA-3127: Post ingress compaction for Kafka datasets
- PNDA-3562: Enable PAM authentication on PNDA console frontend
- PNDA-3580: Add spark cli that implements a user/group placement policy.
- PNDA-2832: Jupyter %sql magic support.
- PNDA-3478: Added support for Spark2 on HDP
- PNDA-3345: Provide the app_packages HDFS location (from Pillar) to applications deployed with DM
- PNDA-3548: Upgrade Kafka manager to version 1.3.3.15
- PNDA-3527: Add dev/prod queues to YARN CDH config.
- PNDA-3528: Add some pillars for the resource manager and used in the dm-config.
- PNDA-2834: Application status reported by DM / console should indicate real status of application
- PNDA-3126: Create files from multiple Kafka partitions.
- PNDA-3273: Capture spark metrics for all applications
- PNDA-3630: Added EXPERIMENTAL flag section to pillar which is initially only used to include Jupyter Scala support
- PNDA-3128: Add kafka-python (new version) and avro python packages to app-packages
- PNDA-3623: Add support for configuring Jupyter with SSL cert/key.
- PNDA-3550: Add a pyspark2 Jupyter kernel for HDP clusters to allow Jupyter to use Spark 2
- PNDA-3549: Include common jar and egg dependencies used by applications that run on PNDA
- PNDA-3654: Add wrapper functions for the Hive and Beeline cli
 
##### Changed
- PNDA-3545: Configure Hive and Hive2 Ambari views to run as the hdfs super user
- PNDA-3555: Use /pnda/deployment as HDFS library location
- PNDA-3583: Hadoop distro is now part of grains
- PNDA-2540: Stop supplying 'cloud-user' as the default operating system user as this is deployment specific and must be supplied in the pnda-env.yaml
- PNDA-1899: Scala Spark Jupyter Integration
- PNDA-3530: Ambari version 2.6.0.0 and HDP version 2.6.3.0
- PNDA-3518: Reduce log output in hadoop_setup.log on HDP by only logging task details on state change
- PNDA-3487: Manage tmpfs in volume mapping
- PNDA-3483: Zookeeper version 3.4.11
- PNDA-3600: Make the spark/MR cli wrapper the master system cli.
- PNDA-3581: Create a mapping table for the Fair Scheduler queue setup (CDH) of PNDA-3527.
- PNDA-3529: Make Jupyter use the system spark cli.
- PNDA-3582: Create a mapping table for the Capacity Scheduler queue setup (HDP) from PNDA-3526.
- PNDA-4043: Update HDP to version 2.6.4.0
- PNDA-4016: Use file.append instead of cmd.run in httpfs.sls
- PNDA-3542: Modify deployment manager plugins to execute commands as the supplied user
- PNDA-3133: Remove Gobblin fork and use release distribution instead
- PNDA-3515: Move all hadoop app data to a sensible directory for app data like /mnt and not /data0
 
##### Fixed
- PNDA-3573: Remove eth0 default value on kafka
- PNDA-3553: Configure PNDA log aggregation to use HDP specific paths when collecting hadoop service logs on HDP
- PNDA-3535: Make ambari server sls idempotent
- PNDA-3323: Clean up files for all users in hdfs_cleaner
- PNDA-3521: Fix issue on push/getting DM keys
- PNDA-3428: Daemonize HDP HBase services
- PNDA-3530: Update yarn resource manager config to include both resource managers for webapp settings in the standard flavor
- PNDA-3574: Make hdp.oozie_libs sls idempotent
- PNDA-3651: Fix HDP capacity scheduler's ACL settings
- PNDA-4029: Allow YARN RM to view task logs
- PNDA-4056: Expanded Data Nodes not being recognized in Deployment Manager
- PNDA-3360: Remove skip_verify on hadoop-httpfs for hdp ubuntu clusters
- PNDA-3519: Failure to copy some files to Hadoop during setup
 
#### [platform-testing](https://github.com/pndaproject/platform-testing)
##### Added
- PNDA-3391: Add more metrics to kafka plugin which is now managed in a by a JMX config file
 
##### Changed
- PNDA-3601: Disable emailtext in Jenkins file and replace it with notifier stage and job
- PNDA-2282: Improved error reporting for Deployment Manager tests
 
##### Fixed
- PNDA-3257: Code quality improvements
 
#### [platform-tools](https://github.com/pndaproject/platform-tools)
- Unchanged in this PNDA release
 
#### [pnda](https://github.com/pndaproject/pnda)
##### Added
- PNDA-3562: Add pam-devel for PAM authentication on PNDA console frontend
- PNDA-2832: Jupyter %sql magic support
- PNDA-1899: Scala Spark Jupyter Integration
- PNDA-3133: Remove Gobblin fork and use release distribution instead.
- PNDA-3549: Include common jar and egg dependencies used by applications that run on PNDA
- PNDA-3128: Add kafka-python (new version) and avro python packages to app-packages
 
##### Changed
- PNDA-3579: Ignore files generated on install build tools step
- PNDA-3530: Ambari version 2.6.0.0 and HDP version 2.6.3.0
- PNDA-3483: Zookeeper version 3.4.11
- PNDA-4043: Update HDP to version 2.6.4.0
 
##### Fixed
- PNDA-3578: RPM repo can be overridden before running mirror scripts in case of non AWS environment
- Forked: Remove conditional key import
- PNDA-4176: Static file dependencies are not retried properly during mirror creation
 
#### [pnda-cli](https://github.com/pndaproject/pnda-cli)
##### Added
- PNDA-3127: Post ingress compaction for Kafka datasets
- PNDA-3299: Support multiple NTP servers properly
- PNDA-3599: Console output indicating any cloud formation stack errors
- PNDA-3598: Add a pre-check to validate the AWS region
- PNDA-3511: Export a bundle of resources used during provisioning to `cli/logs/<cluster>_<time>_bootstrap-resources.tar.gz` to help an operator with later operations tasks such as a recreating a failed node.
- PNDA-3630: Added EXPERIMENTAL flag to pnda_env.yaml which is initially only used to include Jupyter Scala support
- PNDA-3623: Add support for configuring Jupyter with SSL cert/key.
 
##### Changed
- PNDA-3583: Hadoop distro is now part of grains
- PNDA-3365: Remove unnecessary explicit hostfile setup on bastion
- PNDA-3530: Ambari version 2.6.0.0 and HDP version 2.6.3.0
- PNDA-3487: /tmp is now tmpfs for production
- PNDA-3602: Update boto requirement to 2.48.0 for updated ec2 region support
- PNDA-4043: Update HDP to version 2.6.4.0
- PNDA-4052: Add log volume to jupyter node in standard flavor
- PNDA-4186: Deprecated PNDA-MINE_FUNCTIONS_NETWORK_IP_ADDRS_NIC field from pnda_env YAML
- PNDA-4179: Removed interface setup code from bootstrap scripts, expected to be done during infra preparation
- PNDA-4615: Major refactor into clearly separated back-ends to execute orchestration on different platforms
- PNDA-3524: Beacon related logic removed from codebase
 
##### Fixed
- PNDA-3534: Make iptables injection script idempotent.
- PNDA-3552: Creation time improvements for large clusters when there is no bastion.
- Fork: Fixed issue with missing /etc/cloud directory failing install on baremetal
- PNDA-3629: Allow void arguments for specific invocation combinations e.g. no need to specify separate node counts for server cluster installs
- PNDA-4191: Salt rendering error for standard flavor in kafka settings.sls
- PNDA-3563: When the available volumes do not match the expected configuration defined in volume-config.yaml output a sensible error message at an early stage before doing anything to the disks
- PNDA-3553: Yarn resource manager logs and potentially others not aggregated on HDP
- PNDA-3537: If option missed and running in automation, resulting prompt causes EOF error to propagate to user
- PNDA-3512: Expand (with today's feature set) should work for server clusters/production
- PNDA-3559: existing machines def files use wrong node types: 'cdh-xxx' instead of 'hadoop-xxx'
 
#### [pnda-dib-elements](https://github.com/pndaproject/pnda-dib-elements)
- Unchanged in this PNDA release
 
#### [pnda-guide](https://github.com/pndaproject/pnda-guide)
##### Changed
- PNDA-2540: Stop supplying 'cloud-user' as the default operating system user as this is deployment specific and must be supplied in the pnda-env.yaml
- PNDA-3601: Disable emailtext in Jenkins file and replace it with notifier stage and job
- PNDA-4043: Update HDP to version 2.6.4.0
- PNDA-4110: Build proxy documentation edits
- PNDA-3555: Stop using locations under /user for PNDA 'system' functions
- PNDA-3663: Move governance and contribution guidelines to pnda-guide
- PNDA-3483: Allow dynamic zookeeper ip resolution 
- PNDA-3548: upgrade KM to 1.3.3.15
 
##### Fixed
- PNDA-3295: fix missing links on SUMMARY
 
##### Added
- PNDA-3585: Add documentation about the PNDA queue placement policy
 
#### [pnda-heat-templates](https://github.com/pndaproject/pnda-heat-templates)
##### Changed
- PNDA-3583: Hadoop distro is now part of grains
- Issue-143: Added pnda_internal_network and pnda_ingest_network as grains.
- Issue-144: Added param "hadoop_distro" to mgr1 node template for pico flavor.
- Issue-145: Added "hadoop.distro" grain to saltmaster_install bootstrap script.
- Issue-146: Updated new path of "hdp_core_stack_repo" in saltmaster_install bootstarp script.
- PNDA-4043: Update HDP to version 2.6.4.0
- PNDA-3524: Removed beacon related logic from codebase

 
