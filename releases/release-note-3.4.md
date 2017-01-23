# PNDA 3.4

PNDA release 3.4 contains a number of improvements and bug fixes. 

### ElasticSearch and Logstash clusters

The main additional feature is that you can now create an ElasticSearch cluster as part of a PNDA cluster.

Right now, this feature is only available for AWS deployments. We're working on support for OpenStack and this will appear in a future release.

### Dependency management

All Python components are now executed in their own virtualenv in order to avoid library conflicts and all dependencies are explicitly pinned to specific versions. This means that different roles on a particular node can have similar dependencies at different versions and the provisioning process is insulated from unexpected upstream package changes, something which has proved problematic in the past.

### General improvements

* Deployment manager stores application packages in HDFS instead of HBASE
* The console displays more information about deployment manager errors
* Gobblin is run as user 'pnda' instead of 'gobblin', the files created in HDFS are now owned by 'pnda:pnda' instead of 'gobblin:pnda'

Please refer to the CHANGELOGs for a full list of fixes, changes and additions.

### Version Matrix
 
|Repository|Version|Date|
|---|---|---|
|[example-applications](#example-applications)|0.2.0|12 Dec 2016|
|[example-kafka-clients](#example-kafka-clients)|0.2.1|12 Dec 2016|
|[gobblin](#gobblin)|0.1.3|20 Jan 2017|
|[platform-console-backend](#platform-console-backend)|0.3.0|20 Jan 2017|
|[platform-console-frontend](#platform-console-frontend)|0.1.4|02 Jan 2017|
|[platform-data-mgmnt](#platform-data-mgmnt)|0.2.0|20 Jan 2017|
|[platform-deployment-manager](#platform-deployment-manager)|0.3.0|20 Jan 2017|
|[platform-libraries](#platform-libraries)|0.1.2|12 Dec 2016|
|[platform-package-repository](#platform-package-repository)|0.3.0|20 Jan 2017|
|[platform-salt](#platform-salt)|1.3.0|20 Jan 2017|
|[platform-salt-cloud](#platform-salt-cloud)|1.0.0|21 Oct 2016|
|[platform-testing](#platform-testing)|0.3.0|20 Jan 2017|
|[platform-tools](#platform-tools)|0.1.0|01 Jul 2016|
|[pnda](#pnda)|0.1.1|20 Jan 2017|
|[pnda-aws-templates](#pnda-aws-templates)|1.2.0|20 Jan 2017|
|[pnda-dib-elements](#pnda-dib-elements)|0.1.2|12 Dec 2016|
|[pnda-guide](#pnda-guide)|0.1.5|20 Jan 2017|
|[pnda-heat-templates](#pnda-heat-templates)|1.2.0|20 Jan 2017|
|[prod-logstash-codec-avro](#prod-logstash-codec-avro)|0.2.0|09 Sep 2016|
 
### Change Log
 
#### [example-applications](https://github.com/pndaproject/example-applications)
- Unchanged in this PNDA release
 
#### [example-kafka-clients](https://github.com/pndaproject/example-kafka-clients)
- Unchanged in this PNDA release
 
#### [gobblin](https://github.com/pndaproject/gobblin)
##### Fixed
- PNDA-2521: Exits on first build error
 
#### [platform-console-backend](https://github.com/pndaproject/platform-console-backend)
##### Changed
- PNDA-2499: The response body from the Deployment Manager is returned to the caller. Console will now display more helpful error messages.
 
#### [platform-console-frontend](https://github.com/pndaproject/platform-console-frontend)
- Unchanged in this PNDA release
 
#### [platform-data-mgmnt](https://github.com/pndaproject/platform-data-mgmnt)
##### Changed
- PNDA-2485: Pinned all python libraries to strict version numbers
 
#### [platform-deployment-manager](https://github.com/pndaproject/platform-deployment-manager)
##### Fixed
- PNDA-2498: Application package data is now stored in HDFS with a reference to the path only held in the HBase record. This prevents HBase being overloaded with large packages (100MB+).
 
##### Changed
- PNDA-2485: Pinned all python libraries to strict version numbers
- PNDA-2499: Return all exceptions to API caller
 
#### [platform-libraries](https://github.com/pndaproject/platform-libraries)
- Unchanged in this PNDA release
 
#### [platform-package-repository](https://github.com/pndaproject/platform-package-repository)
##### Changed
- PNDA-2485: Pinned all python libraries to strict version numbers
 
#### [platform-salt](https://github.com/pndaproject/platform-salt)
##### Added
- PNDA-2533: Ability to create an ElasticSearch cluster for external usage
- A new motd when login to nodes via SSH
 
##### Changed
- PNDA-2121: Improve jupyter sls files
- PNDA-2239: The 'pnda' user and 'pnda' group are able to write/delete files written by Gobblin which now runs as 'pnda' user instead of 'gobblin' user
- PNDA-2467: Put platform-data-mgmt in a virtualenv
- PNDA-2468: Put platform-deployment manager in a virtualenv
- PNDA-2469: Put platform-package-repository in a virtualenv
- PNDA-2484: Put hdfs-cleaner in a virtualenv
- PNDA-2485: Pin all versions of pnda python components and upgrade the version of libraries
- PNDA-2489: Remove _modules/zk.py file and move it to _modules/pnda.py and do simple REST queries instead of using cm-api
- PNDA-2542: Put elastic-search-curator in a virtualenv
- PNDA-2544: Download Zookeeper from top level mirror instead of US mirror
- PNDA-2547: Put impala-shell in a virtualenv
- PNDA-2550: kibana dashboard are now imported without elasticdump, which simplifies the installation
- PNDA-2551: Put Jupyter python components in a virtualenv
- PNDA-2552: Put graphite of the console in a virtualenv
- PNDA-2560: Put cm_setup cloudera installation script in a virtualenv
- PNDA-2598: Put pnda_restart script in a virtualenv
 
##### Fixed
- PNDA-2494: Concurrency issue during deployment related to master dataset creation
- PNDA-2498: Deployment-manager was passing the wrong thrift server to the Happybase library
- PNDA-2511: Pin version of nodejs to avoid installation failure of kibana
- PNDA-2543: Make the creation of the cloudera manager external database idempotent
 
#### [platform-salt-cloud](https://github.com/pndaproject/platform-salt-cloud)
- Unchanged in this PNDA release
 
#### [platform-testing](https://github.com/pndaproject/platform-testing)
##### Changed
- PNDA-2485: Pinned all python libraries to strict version numbers
 
#### [platform-tools](https://github.com/pndaproject/platform-tools)
- Unchanged in this PNDA release
 
#### [pnda](https://github.com/pndaproject/pnda)
##### Changed
- Updated dependencies for build tools
 
#### [pnda-aws-templates](https://github.com/pndaproject/pnda-aws-templates)
##### Fixed
- PNDA-2595: xvdc volume mounted on /var/log/pnda instead of /var/log/panda
 
##### Added
- PNDA-2043: The CLI now checks for salt error and halt execution if found
- PNDA-2533: Ability to create an ElasticSearch cluster for external usage
- PNDA-2571: Work to allow, future, Offline installation
 
#### [pnda-dib-elements](https://github.com/pndaproject/pnda-dib-elements)
- Unchanged in this PNDA release
 
#### [pnda-guide](https://github.com/pndaproject/pnda-guide)
##### Changed
- PNDA-2493: Align AWS and OpenStack flavors
- Updated platform_requirements.md
- Updated producer instructions
 
##### Fixed
- PNDA-2553: Paths in platformlibs examples
 
#### [pnda-heat-templates](https://github.com/pndaproject/pnda-heat-templates)
##### Changed
- PNDA-2493: Align openstack and AWS flavors
 
##### Fixed
- PNDA-2475: Fix the way to handle package repository configuration
- Bad data type the 'name_servers' parameter to 'comma_delimited_list'
 
#### [prod-logstash-codec-avro](https://github.com/pndaproject/prod-logstash-codec-avro)
- Unchanged in this PNDA release
 
