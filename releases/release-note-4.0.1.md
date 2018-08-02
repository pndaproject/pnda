# PNDA 4.0.1

This is bug fix release, mostly consisting of backports addressing a number of issues found in PNDA 4.0.

Please refer to [this table](validation-4.0.1.md) to understand what infrastrutures, operating systems, Hadoop distributions and configurations have been validated for this release. 

### Version Matrix
|Repository|Version|Date|
|---|---|---|
|[example-applications](#example-applications)|0.5.0|10 Feb 2018|
|[example-kafka-clients](#example-kafka-clients)|0.2.3|24 Nov 2017|
|[logstash-codec-pnda-avro](#logstash-codec-pnda-avro)|0.1.1|24 Nov 2017|
|[platform-console-backend](#platform-console-backend)|1.0.0|10 Feb 2018|
|[platform-console-frontend](#platform-console-frontend)|1.0.0|10 Feb 2018|
|[platform-data-mgmnt](#platform-data-mgmnt)|0.2.2|10 Feb 2018|
|[platform-deployment-manager](#platform-deployment-manager)|1.0.1|11 Jun 2018|
|[platform-gobblin-modules](#platform-gobblin-modules)|0.1.0|10 Feb 2018|
|[platform-libraries](#platform-libraries)|0.1.5|10 Feb 2018|
|[platform-package-repository](#platform-package-repository)|0.3.2|10 Feb 2018|
|[platform-salt](#platform-salt)|4.0.1|11 Jun 2018|
|[platform-testing](#platform-testing)|0.5.0|10 Feb 2018|
|[platform-tools](#platform-tools)|0.1.2|24 Nov 2017|
|[pnda](#pnda)|1.1.1|11 Jun 2018|
|[pnda-cli](#pnda-cli)|1.1.1|11 Jun 2018|
|[pnda-dib-elements](#pnda-dib-elements)|0.3.0|11 Jun 2018|
|[pnda-guide](#pnda-guide)|0.4.0|10 Feb 2018|
|[pnda-heat-templates](#pnda-heat-templates)|1.5.1|11 Jun 2018|


### Change Log


#### [example-applications](https://github.com/pndaproject/example-applications)
- Unchanged in this PNDA release
 
#### [example-kafka-clients](https://github.com/pndaproject/example-kafka-clients)
- Unchanged in this PNDA release
 
#### [logstash-codec-pnda-avro](https://github.com/pndaproject/logstash-codec-pnda-avro)
- Unchanged in this PNDA release
 
#### [platform-console-backend](https://github.com/pndaproject/platform-console-backend)
- Unchanged in this PNDA release
 
#### [platform-console-frontend](https://github.com/pndaproject/platform-console-frontend)
- Unchanged in this PNDA release
 
#### [platform-data-mgmnt](https://github.com/pndaproject/platform-data-mgmnt)
- Unchanged in this PNDA release
 
#### [platform-deployment-manager](https://github.com/pndaproject/platform-deployment-manager)
##### Fixed
- PNDA-4511: Make spark-submit a configurable cli
 
#### [platform-gobblin-modules](https://github.com/pndaproject/platform-gobblin-modules)
- Unchanged in this PNDA release
 
#### [platform-libraries](https://github.com/pndaproject/platform-libraries)
- Unchanged in this PNDA release
 
#### [platform-package-repository](https://github.com/pndaproject/platform-package-repository)
- Unchanged in this PNDA release
 
#### [platform-salt](https://github.com/pndaproject/platform-salt)
##### Fixed
- PNDA-4443: Fix infinite loop in the wrapper for centos
- PNDA-4511: Refactor the yarn client cli wrappers to manipulate the PATH env

#### [platform-testing](https://github.com/pndaproject/platform-testing)
- Unchanged in this PNDA release
 
#### [platform-tools](https://github.com/pndaproject/platform-tools)
- Unchanged in this PNDA release
 
#### [pnda](https://github.com/pndaproject/pnda)
##### Fixed
- PNDA-4441: Specify tornado version and update kafka-python version in build deps
- PNDA-4507: Update pip and setuptools before python installation
- PNDA-4608: Mismatch setuptools version in mirror and build
- PNDA-4622: Update OpenSSL version for CentOS
- PNDA-4666: Account for new dir structure inside HDP-UTILS
- PNDA-4706: Ubuntu Build: mock package fails to install
- PNDA-4707: HDP Cluster creation fails with Ubuntu in AWS
 
#### [pnda-cli](https://github.com/pndaproject/pnda-cli)
##### Fixed
- PNDA-4441: Removed "extra-index-url" and "find_links" directives so pip and easy_install use mirror only
 
#### [pnda-dib-elements](https://github.com/pndaproject/pnda-dib-elements)
##### Fixed
- PNDA-4538: Update git submodules and python pip versions
- PNDA-4046: Correct subscription links in README
 
#### [pnda-guide](https://github.com/pndaproject/pnda-guide)
- Unchanged in this PNDA release
 
#### [pnda-heat-templates](https://github.com/pndaproject/pnda-heat-templates)
##### Fixed
- PNDA-4441: Removed "extra-index-url" and "find_links" directives so pip and easy_install use mirror only
