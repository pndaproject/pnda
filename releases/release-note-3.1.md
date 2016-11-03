# PNDA 3.1

PNDA release 3.1 contains a number of bug fixes and improvements. 

### Open PNDA metrics

PNDA metrics that were previously available only through the PNDA console are now also available via the [Graphite API](http://graphite-api.readthedocs.io/en/latest/). 

This enables straightforward integration of many third party metrics tools for exploring operational data. 

To demonstrate this capability we've added a default dashboard to the PNDA Grafana instance that visualizes some metrics of interest.

### Upgraded technologies

Kafka been upgraded to version [0.10.0.1](https://archive.apache.org/dist/kafka/0.10.0.1/RELEASE_NOTES.html) which brings a number of improvements in the [area of security](http://kafka.apache.org/documentation.html#security) and introduces [Kafka Streams](https://kafka.apache.org/0100/javadoc/org/apache/kafka/streams/kstream/KStream.html).

Zookeeper has been upgraded to version [3.4.6](https://zookeeper.apache.org/doc/r3.4.6/releasenotes.html) which fixes a number of stability issues relating to the formation of quora in various error scenarios.

OpenTSDB has been upgraded to version [2.2.0](http://opentsdb.net/docs/build/html/index.html) and Grafana has been upgraded to [3.1.1](https://github.com/grafana/grafana/blob/master/CHANGELOG.md#311-2016-08-01), providing better support for time series data.

Kafka Manager has been upgraded to version [1.3.1.6](https://github.com/yahoo/kafka-manager), including a number of bug fixes.

The recommended version of Logstash for data collection has been changed to [2.3.4](https://www.elastic.co/guide/en/logstash/2.3/index.html), which has been tested with the improved security in Kafka 0.10.

### Provisioning on AWS

We've added support for provisioning PNDA in AWS using [CloudFormation](https://aws.amazon.com/documentation/cloudformation/) templates.

### Version Matrix
 
|Repository|Version|Date|
|---|---|---|
|[example-jupyter-notebooks](#example-jupyter-notebooks)|0.1.1|09 Sep 2016|
|[example-kafka-clients](#example-kafka-clients)|0.2.0|07 Sep 2016|
|[example-kafka-spark-opentsdb-app](#example-kafka-spark-opentsdb-app)|0.1.1|07 Sep 2016|
|[example-spark-batch](#example-spark-batch)|0.1.0|01 Jul 2016|
|[example-spark-streaming](#example-spark-streaming)|0.1.0|01 Jul 2016|
|[gobblin](#gobblin)|0.1.1|13 Sep 2016|
|[platform-console-backend](#platform-console-backend)|0.2.0|07 Sep 2016|
|[platform-console-frontend](#platform-console-frontend)|0.1.1|13 Sep 2016|
|[platform-data-mgmnt](#platform-data-mgmnt)|0.1.1|13 Sep 2016|
|[platform-deployment-manager](#platform-deployment-manager)|0.1.1|13 Sep 2016|
|[platform-libraries](#platform-libraries)|0.1.1|09 Sep 2016|
|[platform-package-repository](#platform-package-repository)|0.1.1|07 Sep 2016|
|[platform-salt](#platform-salt)|0.2.0|07 Sep 2016|
|[platform-salt-cloud](#platform-salt-cloud)|0.1.1|07 Sep 2016|
|[platform-testing](#platform-testing)|0.1.1|13 Sep 2016|
|[platform-tools](#platform-tools)|0.1.0|01 Jul 2016|
|[pnda-aws-templates](#pnda-aws-templates)|0.1.0|07 Sep 2016|
|[pnda-dib-elements](#pnda-dib-elements)|0.1.0|01 Jul 2016|
|[pnda-guide](#pnda-guide)|0.1.2|09 Sep 2016|
|[pnda-heat-templates](#pnda-heat-templates)|0.2.0|07 Sep 2016|
|[pnda-package-server-docker](#pnda-package-server-docker)|0.1.0|01 Jul 2016|
|[prod-logstash-codec-avro](#prod-logstash-codec-avro)|0.2.0|09 Sep 2016|
 
### Change Log

#### [example-jupyter-notebooks](https://github.com/pndaproject/example-jupyter-notebooks)
##### Fixed
- Clarified documentation around flavours
- Removed explicit inclusion of platformlibs-0.6.8-py2.7.egg, instead now relying on Anaconda to bring this in
 
#### [example-kafka-clients](https://github.com/pndaproject/example-kafka-clients)
##### Changed
- Security support. Kafka clients have the option to use SASL_SSL or plain authentication.
 
#### [example-kafka-spark-opentsdb-app](https://github.com/pndaproject/example-kafka-spark-opentsdb-app)
##### Fixed
- PNDA-729: Fixed a defect in the sample data source program that not reset a buffer correctly
 
#### [example-spark-batch](https://github.com/pndaproject/example-spark-batch)
##### First version
- Run workflow as a sub-workflow to work around bug in CDH 5.5 for Oozie spark actions (failing because the jar was not the expected size).
- First release of example batch app - including workflow and coordinator variants.
 
#### [example-spark-streaming](https://github.com/pndaproject/example-spark-streaming)
##### First version
- First release of example streaming app
 
#### [gobblin](https://github.com/pndaproject/gobblin)
##### Changed
- Enhanced CI support
 
#### [platform-console-backend](https://github.com/pndaproject/platform-console-backend)
##### Changed
- PNDA-820: Historical metric support. Console backend stores a timeseries of metric values in graphite
 
##### Fixed
- PNDA-1980: Debug output adjusted to prevent console backend log files growing very large
 
#### [platform-console-frontend](https://github.com/pndaproject/platform-console-frontend)
##### Changed
- Enhanced CI support
 
#### [platform-data-mgmnt](https://github.com/pndaproject/platform-data-mgmnt)
##### Changed
- Enhanced CI support
 
#### [platform-deployment-manager](https://github.com/pndaproject/platform-deployment-manager)
##### Changed
- Improvements to documentation
- Enhanced CI support
 
#### [platform-libraries](https://github.com/pndaproject/platform-libraries)
##### Changed
- Project renamed to PNDA
 
##### Added
- Jenkinsfile for CI
 
#### [platform-package-repository](https://github.com/pndaproject/platform-package-repository)
##### Changed
- PNDA-1811. Added timeout parameter to swift connection
- Enhancements to CI
 
#### [platform-salt](https://github.com/pndaproject/platform-salt)
##### Added
- Install Jupyter-Spark extension
- Add default Grafana dashboards for PNDA metrics
- PNDA-2010 Create Graphite datasource
- Add a simple minimal notebook to explain basic Jupyter usage
- Create PNDA OpenTSDB default datasource in Grafana
- PNDA-820 Added graphite formula to salt
 
##### Fixed
- PNDA-2022 Re-raise exceptions from cm_setup for fail fast behaviour
- PNDA-2009 Tell upstart to not log console output of data-logger
- PNDA-1933 CM setup waits on cloudera manager being available
- Do not use http download for cloudera manager
- Clean ups to Grafana states
- Clean ups to OpenTSDB states
- Clean ups to Jupyter states
 
##### Changed
- PNDA-2012 Update to Grafana 3.1.1
- PNDA-1485 Update OpenTSDB to 2.2.0
- PNDA-2016 Update Zookeeper to 3.4.6
- Update Kafka Manager to 1.3.1.6
- Update Kafka to 0.10.0.1
- Use saltenv instead of env in anticipation of upcoming Salt Boron
- Automatically set test topic replication based on broker cluster size
- Make the pnda user home directory configurable
- For AWS, launch PNDA on private network
- PNDA-1923 Add the yarn daemon and application logs to logserver
- PNDA-2005 Add a state that creates a PNDA test topic on Kafka instead of using KM 
 
#### [platform-salt-cloud](https://github.com/pndaproject/platform-salt-cloud)
##### Changed
- Install salt minions version 2015.8.10
- Update the CLI banner
 
#### [platform-testing](https://github.com/pndaproject/platform-testing)
##### Changed
- Enhanced CI support
 
#### [platform-tools](https://github.com/pndaproject/platform-tools)
##### First version
- Tools for working with PNDA
 
#### [pnda-aws-templates](https://github.com/pndaproject/pnda-aws-templates)
##### First version
- Resources for launching PNDA on AWS
 
#### [pnda-dib-elements](https://github.com/pndaproject/pnda-dib-elements)
##### First version
- Tools for creating PNDA images
 
#### [pnda-guide](https://github.com/pndaproject/pnda-guide)
##### Changed
- Set grafana version to 3.1.1
- Add details and links about AWS provisioning using CloudFormation
- Add technology versions page to guide
- Update Kafka security with details about SASL_SSL & ACL
 
#### [pnda-heat-templates](https://github.com/pndaproject/pnda-heat-templates)
##### Changed
- Display Heat stack events while resizing a cluster
- Add the capability to configure an alternate Anaconda Parcels mirror
 
#### [pnda-package-server-docker](https://github.com/pndaproject/pnda-package-server-docker)
##### First version
- Create a package server container for provisioning PNDA
 
#### [prod-logstash-codec-avro](https://github.com/pndaproject/prod-logstash-codec-avro)
##### Changed
- Target Logstash version for the codec plugin is now 2.3.4, which supports secured connections with Kafka
 
