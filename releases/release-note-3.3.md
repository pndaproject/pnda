# PNDA 3.3

PNDA release 3.3 contains a number of improvements and bug fixes.

### New Hadoop version, including Spark 1.6

We've moved forward to CDH 5.9 which includes Spark 1.6 alongside many other bugs fixes and improvements. See the [Spark release notes](http://spark.apache.org/releases/spark-release-1-6-0.html) for more details on Spark 1.6 and refer to the [Cloudera site](https://www.cloudera.com/documentation/enterprise/release-notes/topics/cdh_rn_new_in_cdh_59.html) for details of other changes.

### New build system

Based on feedback we've completely rewritten the build system for PNDA, please refer to the new [pnda](https://github.com/pndaproject/pnda) repository for details.

### Robustness, scaling, upgrades & tuning

This release also introduces a number of other core improvements such as anti-affinity hints for OpenStack provisioning that ensures that HA services are properly distributed across compute nodes, better fail fast behaviour in the Salt provisioning process, improvements to support for scaling and upgrades, and more. Please refer to the Change Log below and the notes in the individual repositories for more details.

### Version Matrix
 
|Repository|Version|Date|
|---|---|---|
|[example-applications](#example-applications)|0.2.0|12 Dec 2016|
|[example-kafka-clients](#example-kafka-clients)|0.2.1|12 Dec 2016|
|[gobblin](#gobblin)|0.1.2|12 Dec 2016|
|[platform-console-backend](#platform-console-backend)|0.2.3|12 Dec 2016|
|[platform-console-frontend](#platform-console-frontend)|0.1.3|12 Dec 2016|
|[platform-data-mgmnt](#platform-data-mgmnt)|0.1.2|12 Dec 2016|
|[platform-deployment-manager](#platform-deployment-manager)|0.2.1|12 Dec 2016|
|[platform-libraries](#platform-libraries)|0.1.2|12 Dec 2016|
|[platform-package-repository](#platform-package-repository)|0.2.1|12 Dec 2016|
|[platform-salt](#platform-salt)|1.2.0|12 Dec 2016|
|[platform-salt-cloud](#platform-salt-cloud)|1.0.0|21 Oct 2016|
|[platform-testing](#platform-testing)|0.2.0|12 Dec 2016|
|[platform-tools](#platform-tools)|0.1.0|01 Jul 2016|
|[pnda](#pnda)|0.1.0|12 Dec 2016|
|[pnda-aws-templates](#pnda-aws-templates)|1.1.0|12 Dec 2016|
|[pnda-dib-elements](#pnda-dib-elements)|0.1.2|12 Dec 2016|
|[pnda-guide](#pnda-guide)|0.1.5|12 Dec 2016|
|[pnda-heat-templates](#pnda-heat-templates)|1.1.0|12 Dec 2016|
|[prod-logstash-codec-avro](#prod-logstash-codec-avro)|0.2.0|09 Sep 2016|
 
### Change Log
 
#### [example-applications](https://github.com/pndaproject/example-applications)
##### Added
- PNDA-2359 Move applications to CDH 5.9 which include spark streaming 1.6
- PNDA-2503 Remove explicit memory/vcore settings in apps
 
##### Fixed
- Change Kafka version to 0.10.0.1
- Pin assembly plugin to version 2.6
- Update assembly.xml file to add the id xml tag

#### [example-kafka-clients](https://github.com/pndaproject/example-kafka-clients)
##### Changed
- Put parsing of the extra magic number behind the 'useextra' flag
 
#### [gobblin](https://github.com/pndaproject/gobblin)
##### Added
- Basic checks on PNDA message after deserialization
 
##### Changed
- Externalized build logic from Jenkins to shell script so it can be reused
- Bumped Cloudera libraries to 5.9.0
 
#### [platform-console-backend](https://github.com/pndaproject/platform-console-backend)
##### Changed
- Externalized build logic from Jenkins to shell script so it can be reused
 
#### [platform-console-frontend](https://github.com/pndaproject/platform-console-frontend)
##### Changed
- PNDA-2340: All components appear on the curated view regardless of which components are actually provisioned
- Externalized build logic from Jenkins to shell script so it can be reused
 
#### [platform-data-mgmnt](https://github.com/pndaproject/platform-data-mgmnt)
##### Changed
- Datasets with empty source are ignored
- Externalized build logic from Jenkins to shell script so it can be reused
- Archive container in s3 or swift is created automatically by hdfs-cleaner
 
#### [platform-deployment-manager](https://github.com/pndaproject/platform-deployment-manager)
##### Changed
- Externalized build logic from Jenkins to shell script so it can be reused
- Refactored the information returned by the Application Detail API to include the YARN application state and also to return information for jobs that have ended. Made the implementation more performant by using the YARN Resource Manager REST API instead of the CLI.
 
#### [platform-libraries](https://github.com/pndaproject/platform-libraries)
##### Changed
- Externalized build logic from Jenkins to shell script so it can be reused
- PNDA-2441: Up Spark version to 1.6
 
#### [platform-package-repository](https://github.com/pndaproject/platform-package-repository)
##### Changed
- Externalized build logic from Jenkins to shell script so it can be reused
 
##### Fixed
- PNDA-2265: Fix logging config 
 
#### [platform-salt](https://github.com/pndaproject/platform-salt)
##### Added
- PNDA-2250: Provide tools that allow pnda infra to be rebooted and the services started again
- Aggregating redundant services into common VMs (anti-affinity on OpenStack)
 
##### Changed
- PNDA-2284: hdfs-cleaner creates the archive container it needs
- PNDA-1918: Simplify component paths 
- PNDA-2392: Refactor hue user creation 
- Update CDH to 5.9.0
- PNDA-1812: Add a re-apply config mode to cm_setup
- Merge general zookeeper/kafka white and black box tests
- PNDA-2487: Increase HBase heaps for CDH5.9 
 
##### Fixed
- PNDA-2231: Don't fail if the pnda user is already created in grafana 
- Change 'heap_dump_directory_free_space' warnings for PICO flavor
- Update logshipping for gobblin
- PNDA-2431: Reduce impala catalog server heap size for pico 
- Fix UTF8 issue on master-dataset
- PNDA-2434: Pin version of ES curator and specify full path 
- PNDA-2435: Reduce ES data retention for pico 
- Create a python virtualenv for platform testing
- PNDA-2488: Harmonize heap dump warning and reduce firehose size 
- Fix issue on DM config as OpenTSDB configuration should be IP:PORT not a link
- Alter YARN parameters to give 512MB map tasks
- PNDA-2487: Adjust hbase, yarn and mapred to better fit pico 
 
#### [platform-salt-cloud](https://github.com/pndaproject/platform-salt-cloud)
- Unchanged in this PNDA release
 
#### [platform-testing](https://github.com/pndaproject/platform-testing)
##### Changed
- Externalized build logic from Jenkins to shell script so it can be reused
- Merge kafka blackbox and whitebox & rename zookeeper_blackbox to zookeeper
 
#### [platform-tools](https://github.com/pndaproject/platform-tools)
- Unchanged in this PNDA release
 
#### [pnda](https://github.com/pndaproject/pnda)
##### First version
- Top level repository and build system for PNDA
 
#### [pnda-aws-templates](https://github.com/pndaproject/pnda-aws-templates)
##### Changed
- PNDA-2397: Generate the list of valid flavors dynamically. The valid values for the --branch parameter were hard coded, now they are generated based on the folder names under 'cloud-formation/'
- PNDA-2393: Update OS volume sizes for instances. Increase the standard size from 30 GB to 50 GB and for kafka from 50 GB to 150 GB.
 
##### Added
- PNDA-2142: Allow subnet IP ranges to be specified in pnda_env.yaml and used as parameters to the cloud formation templates
- PNDA-2142: Allow any parameters to be passed through to the cloud formation templates, two settings have changed their names because they are now directly passed through - AWS_IMAGE_ID > imageId and AWS_ACCESS_WHITELIST > whitelistSshAccess. Update these in pnda_env.yaml otherwise the default value in the cloud formation template will be used.
 
##### Fixed
- PNDA-2313: CLI fails fast if errors occur in individual commands. Capturing logs on the cloud instance with `command | tee` (PNDA-2266) caused the CLI to carry on if an error was returned by command, because the final exit code was set by tee.
- PNDA-2284: Use correct archive parameters to configure s3 archive credentials (the set of variables for the application package bucket were being used)
- PNDA-2420: Add missing tee to capture logs when running expand salt commands. This missing command also caused the expand operation to fail for standard flavor clusters.
 
#### [pnda-dib-elements](https://github.com/pndaproject/pnda-dib-elements)
##### Changed
- Moving bootloader element to elements directory
 
#### [pnda-guide](https://github.com/pndaproject/pnda-guide)
##### Changed
- PNDA-2222: Added a page covering the default UI login credentials 
- Clarify steps to get started/provision PNDA
- Update Platform Requirements section
 
#### [pnda-heat-templates](https://github.com/pndaproject/pnda-heat-templates)
##### Added
- PNDA-2159: Create a runfile containing structured info about run
- Added numerous comments to bootstrap scripts and templates as in-code documentation
- Added Anti Affinity hints to the nova scheduler
 
##### Changed
- PNDA-2262: If deploy key not found create one with a helpful message 
- PNDA-2386: Updates to volume sizes 
- PNDA-2387: Run a minion on the saltmaster instance 
- PNDA-2428: Mount disks using openstack IDs 
- PNDA-2430: Log volume consistency changes 
- Specify Anaconda mirror in PNDA YAML and make example mirror URIs consistent
 
##### Fixed
- Update doc to match new Cloudera version 5.9.0
- PNDA-2474: Execute PR volume logic conditionally 
 
#### [pnda-package-server-docker](https://github.com/pndaproject/pnda-package-server-docker)
- Deprecated. Please see the [pnda](https://github.com/pndaproject/pnda) repository
 
#### [prod-logstash-codec-avro](https://github.com/pndaproject/prod-logstash-codec-avro)
- Unchanged in this PNDA release
 
