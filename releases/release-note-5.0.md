# PNDA 5.0

Code name: Mammoth Drop Bear

PNDA 5.0 is a major release containing many improvement related to the deployment.

## Ubuntu

Ubuntu is not supported any longer. We're now focusing on RedHat-like Linux distributions.

## Perimeter security for user services

PNDA and Hadoop components are now secured behind the [Knox](https://knox.apache.org/) Application Gateway, and many components have been modified to support configurable authorization.

## Deployable to VMWare

PNDA is now deployable on VMWare with [Terraform](https://www.terraform.io/). It must still be considered as experimental feature as it as not been extensively tested.

## Name based node/service resolution

PNDA now heavily uses [Consul](https://www.consul.io/) as part of its service discovery mechanism. It opens up a lot of new possibilities that will be part of next releases.

## Revised ingest mechanics (API changes)

As part of [PDP-2](https://cwiki.pnda.io/pages/releaseview.action?pageId=1572878) Gobblin can now ingest data in protobuf and other formats. It is no longer necessary to apply an avro envelope to data.

## Apache Flink integration

As part of [PDP-3](https://cwiki.pnda.io/display/public/PNDA/PDP-3%3A+Support+for+Flink), [Flink](https://flink.apache.org/) can now be used as an alternative to Spark. It allows for stream processing at event level granularity and/or very low latency with more advanced windowing and other stream processing features that Spark doesn't currently offer.

## ONAP

PNDA will be part of the next [ONAP](https://www.onap.org/) release (Code name: Casablanca).
Hence some improvements have been made related to the mirror creation. It can now be built to a Docker container. As PNDA for ONAP primary deployment target is Openstack a few updates have also been made to the Heat templates and the pnda-cli.

### Version Matrix

|Repository|Version|Date|
|---|---|---|
|[example-applications](#example-applications)|1.0.0|28 Aug 2018|
|[example-kafka-clients](#example-kafka-clients)|0.2.3|24 Nov 2017|
|[logstash-codec-pnda-avro](#logstash-codec-pnda-avro)|0.1.1|24 Nov 2017|
|[platform-console-backend](#platform-console-backend)|2.0.0|28 Aug 2018|
|[platform-console-frontend](#platform-console-frontend)|2.0.0|28 Aug 2018|
|[platform-data-mgmnt](#platform-data-mgmnt)|0.3.0|28 Aug 2018|
|[platform-deployment-manager](#platform-deployment-manager)|2.0.0|28 Aug 2018|
|[platform-gobblin-modules](#platform-gobblin-modules)|1.0.0|28 Aug 2018|
|[platform-libraries](#platform-libraries)|0.2.0|28 Aug 2018|
|[platform-package-repository](#platform-package-repository)|1.0.0|28 Aug 2018|
|[platform-salt](#platform-salt)|5.0.0|02 Oct 2018|
|[platform-testing](#platform-testing)|1.0.0|28 Aug 2018|
|[platform-tools](#platform-tools)|1.0.0|28 Aug 2018|
|[pnda](#pnda)|2.0.0|10 Oct 2018|
|[pnda-cli](#pnda-cli)|2.0.0|28 Sep 2018|
|[pnda-dib-elements](#pnda-dib-elements)|0.3.0|11 Jun 2018|
|[pnda-guide](#pnda-guide)|0.5.0|28 Aug 2018|
|[pnda-heat-templates](#pnda-heat-templates)|1.5.1|11 Jun 2018|


### Testing Matrix

#### Mirror/Build server
||mirror|build|
|---|---|---
|RHEL|PASSED|PASSED|
|CentOS|PASSED|PASSED|
|Docker|PASSED|PASSED|

#### Using the ```pnda-cli``` on *existing machines*
||production|
|---|---|
|RHEL, HDP|NOT TESTED|

#### Using the ```pnda-cli``` on *AWS*
||pico|standard|
|---|---|---|
|RHEL, HDP|PASSED|PASSED|
|CentOS, HDP|PASSED|PASSED|
|Ubuntu (DEPRECATED), HDP|NOT TESTED|NOT TESTED|
|RHEL, CDH|NOT TESTED|NOT TESTED|
|Ubuntu, CDH|NOT TESTED|NOT TESTED|

### Change Log


#### [example-applications](https://github.com/pndaproject/example-applications)
##### Changed
- PNDA-4525: Deprecate Ubuntu 14.04
- PNDA-4503: update to use new platformlibs and new ingest mechanics
- PNDA-4654: Update kafka-python package version to 1.3.5
- PNDA-4468: Add references to the guide for Gobblin topic config
 
##### Added
- PNDA-4470: Adds a Traffic-Loss Analysis Spark2 python app to the example apps.
- PNDA-4502: Adds example flinks applications
- PNDA-4545: Add example Java Flink batch application
 
##### Fixed
- PNDA-4895: Modified topic name as defined in README
 
#### [example-kafka-clients](https://github.com/pndaproject/example-kafka-clients)
- Unchanged in this PNDA release
 
#### [logstash-codec-pnda-avro](https://github.com/pndaproject/logstash-codec-pnda-avro)
- Unchanged in this PNDA release
 
#### [platform-console-backend](https://github.com/pndaproject/platform-console-backend)
##### Fixed
- PNDA-4226: Expire sessions after inactivity rather than a fixed time period
- PNDA-4560: Provide identity to all deployment manager API calls
- PNDA-4754: Fix list of kafka topics to match what is currently present on kafka by removing old ones
 
##### Changed
- PNDA-4546: Pass user to Deployment Manager APIs as a URL parameter instead of in the body
- PNDA-4613: Rename user parameter for deployment manager API from user to user.name to match the default knox behaviour
- PNDA-4761: Pass server time with metrics response
 
#### [platform-console-frontend](https://github.com/pndaproject/platform-console-frontend)
##### Added
- PNDA-4560: Provide identity to all deployment manager operations
- PNDA-4221: Pagination selection for metrics page
- PNDA-4140: Display warning for outdated metrics
- PNDA-4754: Fix list of kafka topics to match what is currently present on kafka by removing old ones
 
##### Changed
- PNDA-4042: Sort application properties alphabetically
- PNDA-4546: Pass user to Deployment Manager APIs as a URL parameter instead of in the body
- PNDA-4613: Rename user parameter for deployment manager API from user to user.name to match the default knox behaviour
- PNDA-4768: Make HTTPFS endpoint available to console
- PNDA-4791: Set external KM link from config, not DM
- PNDA-4500: Redesigned application detailed summary and added flink application detailed summary
- PNDA-4799: Update versions for jquery=3.3.1, mustache=2.3.0 and moment=2.22.2
- PNDA-4755: Highlight outdated metric with gray
 
##### Fixed
- PNDA-4190: Set help link for cluster manager based on the hadoop distro in use
- PNDA-4431: Add basic console elements to represent Flink in PNDA
- PNDA-4012: Add application type in application summary view
- PNDA-4009: Better status naming in application detailed summary view
- PNDA-4234: Fix hive query cog link for HDP clusters
- PNDA-4133: Detect lack of health metric updates based on a timer rather than the absolute time to avoid the client clock having to match the server side
- PNDA-4019: Prevent loss of progress in the create application workflow when another application finishes deleting
- PNDA-4650: Fix expand and collapse for app property
- PNDA-4226: Expire sessions after inactivity rather than a fixed time period
- PNDA-4724: Code in console doesn't handle null causes properly
- PNDA-4750: Component status ages incorrect on Console front page
- PNDA-4766: Adjust Console links to Access Ambari services through Knox
- PNDA-4761: Display correct metric age
- PNDA-4809: fix opentsdb/dm cog redirect to logserver via knox
- PNDA-4756: Show metrics consistently in applications screen
- PNDA-3039: Organise Applications List on console
- PNDA-4833: On session invalidation user is not returned to login screen
 
#### [platform-data-mgmnt](https://github.com/pndaproject/platform-data-mgmnt)
##### Added:
- PNDA-4426: Added a config to control the log level for the dataset service
 
##### Fixed:
- PNDA-4879: Added command to create sub directories in s3 or swift
- PNDA-4897: S3 container create issue fixed at the time of data-archiving
- PNDA-4921 Dataset management not picking up 'topic=' datasets
 
#### [platform-deployment-manager](https://github.com/pndaproject/platform-deployment-manager)
##### Added
- PNDA-4560: Add authorization framework and authorize all API calls
- PNDA-4562: Supply user.name when calling package repository
 
##### Changed
- PNDA-4405: Require user and package fields in create application API
- PNDA-4389: Reject packages containing upstart.conf files
- PNDA-4525: Deprecate Ubuntu 14.04
- PNDA-4511: Use a config property to set which spark-submit command to call for spark streaming components
- PNDA-4398: Support Spark 2 for Oozie jobs
- PNDA-4546: Accept username as a URL parameter instead of in the request body and apply basic authorisation so only the user who created an application (or a special admin user defined in the dm-config file) can modify it
- PNDA-4613: Rename user parameter for deployment manager API from user to user.name to match the default knox behaviour
- PNDA-4560: Remove admin_user setting from unit tests
- PNDA-4500: Redesigned application detailed summary and added flink application detailed summary
 
##### Fixed
- PNDA-4218: Fix application deletion when app name is an HDFS username
- PNDA-4012: Add missing application type in application detailed summary
- PNDA-4009: Improve application status naming in application detailed summary
- PNDA-4237: Failure details provided in application summary info if an application fails to submit to YARN
- PNDA-4796: Flink-stop added to stop the flink applications properly
 
#### [platform-gobblin-modules](https://github.com/pndaproject/platform-gobblin-modules)
##### Added
- PNDA-4384: Add a Registry based Converter implementation
- PNDA-4464: Support for protobuf and user defined avro schemas for ingest
- PNDA-4553: Add configuration registry based on Gobblin configuration  
 
##### Fixed
- PNDA-4788: Apply static code analysis
- PNDA-4808: Gobblin not pulling data from Kafka
 
#### [platform-libraries](https://github.com/pndaproject/platform-libraries)
##### Changed
- PNDA-4503: Update platform-libraries to work with new ingest mechanics
 
#### [platform-package-repository](https://github.com/pndaproject/platform-package-repository)
##### Added
- PNDA-4562: Add authorization to API
 
##### Changed
- PNDA-4415: Use boto 2.48
 
##### Fixed
- PNDA-4669: Return HTTP 404 instead of 500 when a package is not found
 
#### [platform-salt](https://github.com/pndaproject/platform-salt)
##### Added
- PNDA-3673: Add consul service and agents
- PNDA-4428: Deploy & configure Flink
- PNDA-4417: Add fastavro library for more efficient avro handling in applications
- PNDA-4431: Add basic platform test & console elements for Flink
- PNDA-4432: Handle logging for Flink
- PNDA-4483: Log cleanup etc. Flink by hdfs-cleaner
- PNDA-4464: (PDP-2) Experimental support for protobuf and user defined avro schemas for ingest
- PNDA-4532: Add supervisor log for spark streaming applications to PNDA logshipper
- PNDA-4398: Support Spark 2 for Oozie jobs
- PNDA-4546: Define an admin user for the Deployment Manager who is authorised to modify any application
- PNDA-4558: Add Knox as gateway to cluster
- PNDA-4559: Add deployment-manager to knox topology
- PNDA-4588: Enable TLS on Knox if certificate is supplied
- PNDA-4563: Proxy package repository service via knox
- PNDA-4583: Configure knox to proxy hadoop services
- PNDA-4585: Proxy opentsdb query api through knox
- PNDA-4426: Added a config to control the log level for the dataset service
- PNDA-4697: Provision required elements for new users after a successful log in
- PNDA-4598: Configure PAM to use LDAP if an LDAP server is provided in the pillar
- PNDA-4578: Reverse proxy Jupyter & Grafana through gateway node
- PNDA-4569: Proxy PNDA console through knox
- PNDA-4643: Add TLS support for haproxy
- PNDA-4712: Use LDAP for Grafana authentication
- PNDA-4794: Flink reverse proxy via Knox
- PNDA-4853: Register nodes using Consul Catalog API so that they are not removed if the node fails
- PNDA-4517: Oozie ssh action support for flink batch jobs
 
##### Changed
- PNDA-4929: Rename folder used to stage application dependencies before syncing to HDFS from apps-packages to app-packages-hdfs-stage
- PNDA-4400: Update Anaconda to 5.1.0, remove Anaconda CDH parcel mirror and install Anaconda on CDH from a bundle in the same way as already done for HDP
- PNDA-4394: Add various libraries to app-packages so they are available 'out of the box' to PNDA users
- PNDA-4396: Update Kibana, Logstash and ElasticSearch to 6.2.1 for Log Server
- PNDA-4408: Update kafka-python to 1.3.5
- PNDA-4408: Update kafka to 0.11.0.2
- PNDA-4430: Handle mapping of users to yarn queues
- PNDA-4384: Use the PNDARegistryBasedConverter for gobblin in experimental mode
- PNDA-4122: Remove scalable ELK
- PNDA-4525: Deprecate Ubuntu 14.04
- PNDA-4511: Use a config property to set which spark-submit command the Deployment Manager calls for spark streaming components
- PNDA-4553: Remove experimental flag on PNDARegistryBasedConverter and add default topic config
- PNDA-4537: Graphite metrics retention set per-flavor
- PNDA-4503: Change jupyter data generation for using user permissions
- PNDA-4560: Remove admin_user setting from deployment-manager config
- PNDA-4386: Add option for services to register their own DNS entry
- PNDA-4075: Load the number of disks to use for hadoop datanodes from env-parameters.sls instead of being fixed per flavour
- PNDA-4673: Use HTTP transport instead of TCP transport for PyHive and use JDBC to query Hive because PyHive does not support HTTP transport
- PNDA-4693: Alter Knox to use PAM rather than LDAP
- PNDA-4544: Upgrade Flink to 1.4.2
- PNDA-4541: Compress yarn application logs into a tar.gz to prevent the number of files growing too large
- PNDA-4730: Create a base-services sls that encapsulates consul and ldap
- PNDA-4440: Upgrade Kafka from 0.11.0.2 to 1.1.0
- PNDA-4536: Make data directories used by Kafka configurable in env-parameters.sls instead of fixed per flavor
- PNDA-4779: Use TLS 1.2 between agents and server
- PNDA-4768: Set HTTPFS link from config similar to other links
- PNDA-4791: Enable links in console through knox to KM and ELK
- PNDA-4586: Disable default opentsdb ui
- PNDA-4818: Update Ambari to 2.7.0.0 and HDP to 2.6.5.0
- PNDA-4500: Redesigned application detailed summary and added flink application detailed summary
- PNDA-4837: Upgrade Grafana version to 5.1.3
- PNDA-4892: Remove kafkat
- PNDA-4909: Remove livy & sparkmagic
- PNDA-4858: Remove redundant Hive view code
- PNDA-4899: Introduce conditionality to produce build/mirror with only artefacts required
 
##### Fixed
- PNDA-4200: Fix missing matplotlib and dependencies for Jupyter python3 kernel
- PNDA-4399: Remove IPV6 dependency in nginx
- PNDA-4243: Fix update mode for HDP
- PNDA-4514: Fix issue on volume state which affects Ubuntu update
- PNDA-4045: Re-enable logstash multiline plugin for YARN application logs
- PNDA-4510: Logrotate fixed for /var/log/pnda
- PNDA-4604: Ensure re-runnability of Knox state
- PNDA-4422: Fix selinux SLS so that it's successful regardless of initial selinux state
- PNDA-4664: Start redis service before console backend services on system boot
- PNDA-4053: Ensure that /var/run/ambari-server is owned by ambari by setting the owner on reboot
- PNDA-4606: Append domain name if "search" string doesn't exist
- PNDA-4548: Flink Metric reporting for Graphite not working
- PNDA-4726: Make knox service name for console consistent everywhere
- PNDA-4722: Fix Knox rewrite rules for YARNUI and JOBHISTORYUI
- PNDA-4742: Knox failed to match yarn spark job history
- PNDA-4762: Support YARN resource manager HA mode
- PNDA-4766: Enable access to Ambari through Knox
- PNDA-4804: Fixed flink history service infinite 404 loop
- PNDA-4787: Remove unnecessary knox topologies that come by default
- PNDA-4809: Fix opentsdb/dm cog redirect to logserver via knox
- PNDA-4805: Reduce verbosity of routes through gateway
- PNDA-4813: Fix Ambari service quicklinks via knox proxy
- PNDA-4810: Introduced knox rewrite rules for KM parameterised URL
- PNDA-4797: ELK deployed twice in PICO Setup
- PNDA-4774: Remove MySQL server from ambari/cloudera-manager
- PNDA-4826: Spark2 history server (show incomplete applications)
- PNDA-4838: Fix Spark job description access through knox
- PNDA-4775: Internet not reached from deployed online cluster
- PNDA-4889: Modified user.sls to create group before user
- PNDA-4409: Correctly configure systemd supervisor for httpfs
- PNDA-4917: Permission denied to access Hbase rest and thrift logs
- PNDA-4860: Some logs coming into Kibana are big aggregated blob rather than time series
- PNDA-4874 Failed to execute jupyter notebook with PySpark2 kernel
 
#### [platform-testing](https://github.com/pndaproject/platform-testing)
##### Added
- PNDA-4431: Add basic platform test for Flink in PNDA
- PNDA-4754: Add new metric for list of available kafka topics
 
##### Changed
- PNDA-4408: Use kafka-python 1.3.5 in kafka test module
- PNDA-4481: Change Zookeeper status once loosing nodes when there is a zk quorum
- PNDA-4673: Use JDBC instead of PyHive to query Hive because PyHive does not support HTTP transport
- PNDA-4729: Remove unused per-topic health metric
- PNDA-4899: Introduce conditionality to produce build/mirror with only artefacts required
 
##### Fixed
- PNDA-4106: Console not reflecting which zookeeper is lost
- PNDA-4223: Limit data read in test by specifying end timestamp
- PNDA-4702: Mock popen to prevent unit tests attempting to use nc which may not be installed
- PNDA-4714: Clean up hive connection resources
 
#### [platform-tools](https://github.com/pndaproject/platform-tools)
##### Changed
- PNDA-4851: Added secure client code to allow bulk ingest via Knox
 
#### [pnda](https://github.com/pndaproject/pnda)
##### Added
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
 
##### Changed
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
 
##### Fixed
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
 
#### [pnda-cli](https://github.com/pndaproject/pnda-cli)
##### Added
- PNDA-3127: Post ingress compaction for Kafka datasets
- PNDA-4449: Add a consul_server grain
- PNDA-4428: Add Flink role grains
- PNDA-4452: Install curl in bootstrap phase
- PNDA-4489: Option to set the port to use on the command line when calling the socks proxy setup script
- PNDA-4450: Set name tags for CFN resources
- PNDA-4398: Support Spark 2 for Oozie jobs
- PNDA-4131: Heat backend to provision PNDA on OpenStack via pnda-cli
- PNDA-4588: Enable TLS on Knox if certificate is supplied
- PNDA-4075: Add settings in pnda-env.yaml to control the number and names of disks used for hadoop datanodes
- PNDA-4598: Add LDAP_SERVER to pnda-env.yaml
- PNDA-4416: Better example of how to configure NTP servers in example pnda-env-example.yaml
- PNDA-4536: Make data directories used by Kafka configurable in pnda-env.yaml
- PNDA-4554: Support for ESXi vSphere deployment using Terraform
- PNDA-4853: Check public key exists for terraform deployments
- PNDA-4904: Add a new command line parameter to specify an alternate configuration file
- PNDA-4905: Add --set parameter to override a specific field in config file 
 
##### Changed
- PNDA-4394: Remove Anaconda CDH parcel mirror as this is now installed from a bundle
- PNDA-4420: Pre-seed salt minion keys
- PNDA-4490: Update production.json example to match the production flavour
- PNDA-4122: Remove scalable ELK
- PNDA-4525: Deprecate Ubuntu 14.04
- PNDA-4530: Refactor pnda_env.yaml to reflect that pnda-cli is no longer AWS specific
- PNDA-4523: Write ssh config when starting CLI
- PNDA-4558: Modify topology to use gateway instead of bastion
- PNDA-4603: Don't indiscriminately assign every node in the cluster a public address
- PNDA-4559: Services ending in -internal will use internal IP addresses
- PNDA-4588: Add pnda-env.yaml settings for consul domains so they can be used to build the TLS certificates
- PNDA-4588: Default SECURITY_MODE to enforced to generate TLS certificates if not supplied by the user
- PNDA-4386: Remove internal services from pnda-cli
- PNDA-4599: Remove unused bastion bootstrap script and Correct OS volume size on gateway
- PNDA-4370: Refactor salt commands for both install and expand into a single function
- PNDA-4732: Remove security mode options so it is always 'enforced'
- PNDA-4733: Externalize cert generation into a helper tool
- PNDA-4818: Update Ambari to 2.7.0.0 and HDP to 2.6.5.0
- PNDA-4845: Add Public IP for pnda standard cluster in openstack
- PNDA-4765: Remove REJECT_OUTBOUND config. The PNDA mirror must be used for all dependencies
- PNDA-4892: Remove kafkat
 
##### Fixed
- PNDA-4415: Update PyYAML and requests
- PNDA-4203: Set up Consul DNS before running highstate and restart minions from pnda-cli after installing Consul
- PNDA-4453: Apply timeouts in thread.join
- PNDA-4448: Fixes to ADD_ONLINE_REPOS for redhat/centos
- PNDA-4498: Use wget instead of curl with apt-key
- PNDA-4441: Removed "extra-index-url" and "find_links" directives from pip and easy_install configurations
- PNDA-4624: Fix expand operation
- PNDA-4658: Fix cmd2 at version compatible with python2
- PNDA-4444: Detect "Failures:" in salt output to fail fast on error
- PNDA-4554: Remove centos user deletion from provisioners
- PNDA-4819: Wait for host connectivity before starting expand operation
- PNDA-4831: Failed to connect to LDAP server 
- PNDA-4741: Added floating ip to nodes other than data nodes for OpenStack
- PNDA-4797: ELK deployed twice in PICO Setup
- PNDA-4873: Increase root volume storage to 250GB for datanode instances
- PNDA-4775: Internet not reached from deployed online cluster
 
#### [pnda-dib-elements](https://github.com/pndaproject/pnda-dib-elements)
- Unchanged in this PNDA release
 
#### [pnda-guide](https://github.com/pndaproject/pnda-guide)
##### Changed
- PNDA-4009: Add application detailed summary guide
- PNDA-4525: Deprecate Ubuntu 14.04
- PNDA-4469: Add a section about Kafka topic creation from outside the cluster
- PNDA-4598: Update documentation for removal of pam_module pillar
- PNDA-4641: Updated PNDA Guide for provisioning PNDA on OpenStack
- PNDA-4599: Update guide for change from bastion to gateway
- PNDA-4440: Upgrade kafka from 0.11.0.2 to 1.1.0
- PNDA-4509: Fix the documentation to match the new cluster access
- PNDA-4818: Update Ambari to 2.7.0.0 and HDP to 2.6.5.0
- PNDA-4837: Upgrade Grafana from 4.2.0 to 5.1.3 
 
##### Added
- PNDA-4715: Add VMWare section in provisioning
- PNDA-4482: Update dataset compaction details in PNDA Guide
- PNDA-4733: Add documentation about securing the cluster perimeter
- PNDA-4468: Document new ingest mechanics
- PNDA-4827: Add a setup guide for installing PNDA with terraform
- PNDA-4501: Document Flink related features
 
##### Fixed
- PNDA-4884: OpenDaylight pnda-guide link takes to 404
 
#### [pnda-heat-templates](https://github.com/pndaproject/pnda-heat-templates)
- Unchanged in this PNDA release
 
## Maintainers and Contributors

And last but not least, we'd like to thank the maintainers and contributors (in no specific order):

- Trev Smith
- Jérémie Garnier
- James Clarke
- stephanesan
- Xiaoyu Chen

- Manasa
- Dharaneeshwaran Ravichandran
- chandan pal
- cloudwise
- Donald Hunter
- siddaramm
- Julien Barbot
- mrunmayeejog
- GaneshManal
- chandanpal
- Boopalan S
- Madhaiyan K
- Siddaram Sonar
- AbhilashS-MapleLabS
- shubhi0310
- Arvind Purohith
- Janarthanan Selvaraj
- deepamartin
- Hitesh Tiwari
- Piyush Pote
- Pavan Sudheendra
- Siddaram M Sonar
- sreekanthmaplelabs
- sushantpande
- Fabien Andrieux
- SivaMaplelabs
- Mike Mester

- Will
