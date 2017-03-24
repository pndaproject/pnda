# PNDA Mirror 

Use these tools to download the 3rd party dependencies that PNDA uses during the orchestration process. 

## Quick Start

To simply run the entire mirror creation process -

```sh
sudo su
./create_mirror.sh
```

Note that .deb or .rpm dependencies will be created based on the host on which the script is run. Therefore, if the intention is to create PNDA on RHEL instances for example, please use a RHEL host to create the mirror.

This takes about 10 minutes to run and the output will be available in a directory named ```mirror-dist```.

## Mirror Modules

The different parts of the mirror can be created separately if required. The scripts to do this are -

```
create_mirror_deb.sh
create_mirror_rpm.sh
create_mirror_misc.sh
create_mirror_python.sh
create_mirror_anaconda.sh
create_mirror_cdh.sh
```

Note that, as above, the deb and rpm scripts are for use on Ubuntu or RHEL hosts respectively.

Each script creates it's output in a directory named for the respective mirror type -

```
mirror_deb
mirror_rpm
mirror_misc
mirror_python
mirror_anaconda
mirror_cloudera
```

## Stage on HTTP server

Create an ordinary HTTP server in the target environment or identify an existing server. The server must have connectivity with the PNDA cluster being provisioned. See [these tips](https://github.com/pndaproject/pnda/blob/develop/build/docs/EXAMPLES.md) for rapidly creating an HTTP server using a number of different approaches.

Next, copy the contents of ```mirror-dist``` to the document root of the HTTP server.

The final directory layout should resemble the following -

```
document-root
│
├── mirror_anaconda
│   ├── Anaconda-4.0.0-el7.parcel
│   ├── etc
│
├── mirror_deb
│   ├── acl_2.2.52-1_amd64.deb
│   ├── etc
│
├── etc

            
```


