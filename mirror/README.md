# PNDA Mirror
Use these tools to download the 3rd party dependencies that PNDA uses during the orchestration process.

## Quick Start

In case you are not in the AWS environment and you are using Redhat, you will need to override default RedHat repos by defining the following environment variables. The names should be subsituted with the appropriate names for your environment.

```
sudo su
export RPM_OPTIONAL=rhel-7-server-optional-rpms
export RPM_EXTRAS=rhel-7-server-extras-rpms
```

Depending of the Hadoop distribution you choose, you must specify `HDP` (HortonWorks) or `CDH` (Cloudera)

To run the entire mirror creation process for HortonWorks -

```sh
sudo su
./create_mirror.sh -d HDP
```

In order that create_mirror.sh obtains the correct set of dependencies for the image that PNDA will be deployed on, create_mirror.sh **must** be run on a **clean instance** of the **same image** that PNDA will be deployed on.

This takes about 20 minutes to run and the output will be available in a directory named ```mirror-dist```.

## Mirror Modules

The different parts of the mirror can be created separately if required. The scripts to do this are -

```
create_mirror_apps.sh
create_mirror_rpm.sh
create_mirror_misc.sh
create_mirror_python.sh
create_mirror_cdh.sh
create_mirror_hdp.sh
```

Each script creates it's output in a directory named for the respective mirror type -

```
mirror_apps
mirror_rpm
mirror_misc
mirror_python
mirror_cloudera
mirror_hdp
```

## Updating the mirror

If you want to update an existing mirror with newer packages, use the update scripts in the tools folder and/or the python scripts (see [Python Mirror Maintenance](docs/PYTHON_ADVANCED.md))
