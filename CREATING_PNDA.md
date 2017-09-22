# Creating PNDA

## Overview

At the high level, the following steps are required to create a PNDA cluster.

1. Download 3rd party packages that PNDA uses during the orchestration process
2. Build the PNDA packages
3. Place all packages on a suitable HTTP server
4. Acquire templates for target infrastructure and PNDA SaltStack formulas
5. Start the PNDA orchestration process

## Before you start

Please refer to the [PNDA guide](https://github.com/pndaproject/pnda-guide/blob/develop/provisioning/platform_requirements.md) for guidance on how to prepare the target envirnonment for the PNDA cluster.

If your target environment is set up behind a non-transparent proxy, use the [proxy configuration tool](PROXY.md) to set up your target enviroment for using the proxy.

## Download packages

To enable offline installation, you need to build mirrors and indexes. Use the [mirror creation process](mirror/README.md) to download all the 3rd party dependencies that PNDA uses during the orchestration process. 

These will be assembled in a directory named ```mirror-dist```.

## Build PNDA

Use the [PNDA build process](build/README.md) to build all the PNDA packages at the required version.

These will be assembled in a directory named ```pnda-dist```.

## Stage on HTTP server

Create an ordinary HTTP server in the target environment or identify an existing server. The server must have connectivity with the PNDA cluster being provisioned. See [these tips](build/docs/EXAMPLES.md) for rapidly creating an HTTP server using a number of different approaches.
.

Next, copy the contents of ```mirror-dist``` and ```pnda-dist``` to the document root of the HTTP server.

The final directory layout should resemble the following -

```
document-root
│
├── console-backend-data-logger-develop.tar.gz
├── console-backend-data-logger-develop.tar.gz.sha512.txt
├── etc
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

## Acquire PNDA orchestration code

### Templates

If creating a cluster on OpenStack or on bare metal servers, acquire the [https://github.com/pndaproject/pnda-heat-templates](https://github.com/pndaproject/pnda-heat-templates) repository.
If creating a cluster on AWS, acquire the [https://github.com/pndaproject/pnda-aws-templates](https://github.com/pndaproject/pnda-aws-templates) repostiory.

The client machine on which these templates are located must have access to the orchestration engine - Heat in the case of OpenStack and CloudFormation in the case of AWS.

### SaltStack formulas

Acquire the [https://github.com/pndaproject/platform-salt](https://github.com/pndaproject/platform-salt) repository.

#### Heat

The machine on which this repository is located must have connectivity with the PNDA cluster being provisioned. 

For example, if the repository is placed on a machine called ```pnda-client``` then the PNDA cluster being provisioned must be able to access the repository using a URI such as ```ssh://user@pnda-client:/home/user/platform-salt```. Please refer to the documentation [here](https://github.com/pndaproject/pnda-heat-templates) for details of how to configure the correct SSH key for git to use during provisioning.

#### AWS

Place the SaltStack formulas repository on the client machine alongside the templates and use the ```PLATFORM_SALT_LOCAL``` option as documented [here](https://github.com/pndaproject/pnda-aws-templates).

## Create PNDA

Once all the assets are in place, proceed with the PNDA creation instructions found in the [PNDA guide](https://github.com/pndaproject/pnda-guide/blob/develop) and the templates repositories referenced above.
