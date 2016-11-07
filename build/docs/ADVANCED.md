# Advanced PNDA build scenarios

It is possible to use build-pnda.sh to build PNDA components & upstream projects to specific "bill of materials".

- Pass "BOM" as first parameter
- Pass a file path as the second parameter (e.g. /home/alice/bomfile)
- The file must contain a list of space delimited component/project version pairs
- The file must contain one entry for each PNDA component
- The file must contain one entry for each upstream project
- The version can be any valid tag or branch specifier
- PNDA components are built with the version specifier set to corresponding component release (e.g. 0.1.2)
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
|gobblin| 
       
|Upstream Projects|
|---|
|kafkamanager|

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
```

More complex BOM specifying various component versions, PNDA release versions and explicitly referencing a particular upstream version of the upstream project, kafkamanager.

```sh
       platform-console-backend 0.1.0
       platform-console-frontend master
       platform-data-mgmnt release/3.2
       platform-deployment-manager 0.1.0
       platform-libraries develop
       platform-package-repository 0.1.2
       platform-testing release/3.1
       gobblin 0.1.0
       kafkamanager UPSTREAM(1.3.2.4)
```

Invocation example.

```sh
sudo su
cd pnda
./build-pnda.sh BOM bomfile
```
