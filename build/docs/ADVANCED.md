# Advanced PNDA build scenarios

It is possible to use build-pnda.sh to build PNDA components & upstream projects to specific "bill of materials".

- Pass "BOM" as first parameter
- Pass a file path as the second parameter (e.g. /home/alice/bomfile)
- The file must contain a list of space delimited component/project version pairs
- The file must contain one entry for each PNDA component
- The file must contain one entry for each upstream project
- The version can be any valid tag or branch specifier
- PNDA components are built with the version specifier set to the version specified in the BOM file (e.g. develop, 0.1.2, etc)
- Upstream projects are built with the version specifier set as follows:
 - By default, the version specified is interpreted as a tag or branch on pndaproject/platform-salt that references the upstream project
 - Optionally, the version can be specified in the form UPSTREAM(version). This is interpreted as a tag or branch on the upstream project

**Valid values for components and upstream projects**

|PNDA Components|
|---|
|platform-console-backend|
|platform-console-frontend|
|platform-data-mgmnt|
|platform-deployment-manager|
|platform-libraries|
|platform-package-repository| 
|platform-testing|  
|platform-gobblin-modules|
       
|Upstream Projects|
|---|
|kafkamanager|
|jupyterproxy|
|livy|
|gobblin|
|flink|

#### Examples

Simple BOM specifying a list of component versions and upstream project kafkamanager at the version used by PNDA release/3.1.

```sh
       platform-console-backend 0.1.0
       platform-console-frontend 0.1.0
       platform-data-mgmnt 0.1.2
       platform-deployment-manager 0.1.0
       platform-libraries 0.1.0
       platform-package-repository 0.1.2
       platform-testing 0.1.0
       gobblin 0.1.0
       kafkamanager release/3.1
       jupyterproxy release/3.1
```

More complex BOM specifying various component versions, PNDA release versions and explicitly referencing particular upstream versions of the upstream projects.

```sh
       platform-console-backend 0.1.0
       platform-console-frontend develop
       platform-data-mgmnt develop
       platform-deployment-manager 0.1.0
       platform-libraries develop
       platform-package-repository 0.1.2
       platform-testing develop
       kafkamanager UPSTREAM(1.3.2.4)
       jupyterproxy UPSTREAM(1.3.1)
       livy UPSTREAM(0.3.0)
       gobblin UPSTREAM(0.11.0)
       flink UPSTREAM(1.4.0)
```

Invocation example.

```sh
cd pnda
./build-pnda.sh BOM bomfile
```

