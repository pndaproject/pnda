# PNDA 3.2

PNDA release 3.2 contains a number of improvements and bug fixes.

### Flavors

The main focus of this release is a major refactoring of how PNDA handles different profiles for different infrastructure - "flavors". Please refer to the [pnda-aws-templates](#pnda-aws-templates) and [pnda-heat-templates](#pnda-heat-templates) repositories for more details. 

We've added a new flavor to demonstrate the new organization, named "pico". This is a very small profile suitable for evaluating and learning about PNDA on minimal infrastructure.

### Example Applications

We've consolidated the example applications into one repository, [example-applications](#example-applications).

We've also added some new examples - including a package that includes both a simple batch job and an accompanying Jupyter notebook, and a demonstration of how to launch and run the popular H2O data science platform.

### Upgraded Technologies

In order to benefit from upstream bug fixes the version of Salt used has been moved to 2015.8.11.

### Version Matrix
 
|Repository|Version|Date|
|---|---|---|
|[example-applications](#example-applications)|0.1.0|21 Oct 2016|
|[example-kafka-clients](#example-kafka-clients)|0.2.0|07 Sep 2016|
|[gobblin](#gobblin)|0.1.1|13 Sep 2016|
|[platform-console-backend](#platform-console-backend)|0.2.1|21 Oct 2016|
|[platform-console-frontend](#platform-console-frontend)|0.1.2|21 Oct 2016|
|[platform-data-mgmnt](#platform-data-mgmnt)|0.1.1|13 Sep 2016|
|[platform-deployment-manager](#platform-deployment-manager)|0.2.0|21 Oct 2016|
|[platform-libraries](#platform-libraries)|0.1.1|09 Sep 2016|
|[platform-package-repository](#platform-package-repository)|0.2.0|21 Oct 2016|
|[platform-salt](#platform-salt)|1.0.0|21 Oct 2016|
|[platform-salt-cloud](#platform-salt-cloud)|1.0.0|21 Oct 2016|
|[platform-testing](#platform-testing)|0.1.1|13 Sep 2016|
|[platform-tools](#platform-tools)|0.1.0|01 Jul 2016|
|[pnda-aws-templates](#pnda-aws-templates)|1.0.0|21 Oct 2016|
|[pnda-dib-elements](#pnda-dib-elements)|0.1.1|21 Oct 2016|
|[pnda-guide](#pnda-guide)|0.1.3|21 Oct 2016|
|[pnda-heat-templates](#pnda-heat-templates)|1.0.0|21 Oct 2016|
|[pnda-package-server-docker](#pnda-package-server-docker)|0.1.1|21 Oct 2016|
|[prod-logstash-codec-avro](#prod-logstash-codec-avro)|0.2.0|09 Sep 2016|
 
### Change Log
 
#### [example-applications](https://github.com/pndaproject/example-applications)
##### Added
- h2o-launcher application to run h2o data science platform
- literary-word-count-app to run a classic wordcount
- Spark streaming example app that consumes from Kafka and writes to HBase
- Spark batch example app that consumes Gobblin produced Avro datasets from HDFS and produces Parquet for use with Impala
- Spark streaming example app that consumes from Kafka and writes to OpenTSDB
- Jupyter notebook example that shows some simple network data manipulation
 
#### [example-jupyter-notebooks](https://github.com/pndaproject/example-jupyter-notebooks)
- Deprecated, applications are now found in [example-applications](https://github.com/pndaproject/example-applications)
 
#### [example-kafka-clients](https://github.com/pndaproject/example-kafka-clients)
- Unchanged in this PNDA release
 
#### [example-kafka-spark-opentsdb-app](https://github.com/pndaproject/example-kafka-spark-opentsdb-app)
- Deprecated, applications are now found in [example-applications](https://github.com/pndaproject/example-applications)
 
#### [example-spark-batch](https://github.com/pndaproject/example-spark-batch)
- Deprecated, applications are now found in [example-applications](https://github.com/pndaproject/example-applications)
 
#### [example-spark-streaming](https://github.com/pndaproject/example-spark-streaming)
- Deprecated, applications are now found in [example-applications](https://github.com/pndaproject/example-applications)
 
#### [gobblin](https://github.com/pndaproject/gobblin)
- Unchanged in this PNDA release
 
#### [platform-console-backend](https://github.com/pndaproject/platform-console-backend)
##### Fixed
- PNDA-2120: Rotate console backend log files to prevent disk filling up
 
#### [platform-console-frontend](https://github.com/pndaproject/platform-console-frontend)
##### Changes
- PNDA-2272: Only show links to parts of the system which are present to allow modularisation of PNDA
 
#### [platform-data-mgmnt](https://github.com/pndaproject/platform-data-mgmnt)
- Unchanged in this PNDA release
 
#### [platform-deployment-manager](https://github.com/pndaproject/platform-deployment-manager)
##### Added
- PNDA-2233 Jupyter notebook plugin added to deployment manager
 
#### [platform-libraries](https://github.com/pndaproject/platform-libraries)
- Unchanged in this PNDA release
 
#### [platform-package-repository](https://github.com/pndaproject/platform-package-repository)
##### Added
- PNDA-1211: add FS repository as backend storage
 
#### [platform-salt](https://github.com/pndaproject/platform-salt)
##### Added
- Multi-flavor mechanism, with pico flavor
- PNDA-2320 Kafka manager port is now in pillar
- PNDA-2272 review formulas in order to ensure no issue on deployment even if there is not all roles
- PNDA-2233 Jupyter notebook plugin added to deployment manager
 
##### Fixed
- Some logs were not in /var/log/pnda and so, were not shipped to the logserver
- The 'bulk' directory in HDFS is now owned by the 'pnda' user
- Prevent Gobblin from ingesting internal kafka __consumer_offsets topic

##### Changed
- ntp:servers pillar default was removed, but can still be set

#### [platform-salt-cloud](https://github.com/pndaproject/platform-salt-cloud)
##### Changed
- PNDA-2114: Updated role grains to the new set matching platform-salt
- Install salt minions version 2015.8.11 

#### [platform-testing](https://github.com/pndaproject/platform-testing)
- Unchanged in this PNDA release
 
#### [platform-tools](https://github.com/pndaproject/platform-tools)
- Unchanged in this PNDA release
 
#### [pnda-aws-templates](https://github.com/pndaproject/pnda-aws-templates)
##### Added
- PNDA-2113: Pico flavor for small footprint clusters suitable for development or learning
- PNDA-2266: Save provisioning logs on the cloud instances in the /home/ubuntu folder
- PNDA-2275: '-b' branch CLI parameter to select a branch of platform-salt to use
- PNDA-2276: Allow a local copy of platform-salt to be used instead of a git URL to clone
- PNDA-2159: Additional .run log file saved in cli/logs

##### Changed
- PNDA-2325: Use single pnda_env.yaml file instead of client_env.sh and pnda_env.sh
- PNDA-2272: Move to Salt 2015.8.11 in order to get the fix on orchestrate #33467

##### Fixed
- PNDA-2333: Allow multiple clusters to be created in parallel from the same clone of pnda-aws-templates

#### [pnda-dib-elements](https://github.com/pndaproject/pnda-dib-elements)
##### Added
- Instructions to build a PNDA image from CentOS
- TripleO and heat-templates repositories as sub-modules
- A new environment variable to specify an alternate Ubuntu mirror
- A new element to fix network interfaces naming
 
##### Fixed
- sed command to update Cloud-init configuration file

#### [pnda-guide](https://github.com/pndaproject/pnda-guide)
##### Changed
- Clarifications and improvements to many areas for 3.2 release
 
#### [pnda-heat-templates](https://github.com/pndaproject/pnda-heat-templates)
##### Changed
- PNDA-2272: move to Salt 2015.8.11 in order to get the fix on orchestrate #33467
- PNDA-1211: Add the ability to manage swift / s3 / volume / sshfs or local for package repository backend storage
- PNDA-2248: Refactor heat template provisioning to enable flavors to be deployable on bare metal - firstly 'pico'
- The optional 'NtpServers' option can be set in the pnda_env.yaml configuration file if the default servers are not reachable

#### [pnda-package-server-docker](https://github.com/pndaproject/pnda-package-server-docker)
##### Changed
- PNDA-2326: launch the build script automatically and make the jdk available through http
 
#### [prod-logstash-codec-avro](https://github.com/pndaproject/prod-logstash-codec-avro)
- Unchanged in this PNDA release
 
