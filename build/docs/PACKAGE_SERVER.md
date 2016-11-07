# Package Server

In order to make built components available during the PNDA provisioning process, they need to be staged in a location that is accessible from the target environment via HTTP. This location is termed the "Package Server" in the PNDA documentation.

## Existing CICD

Typically, your existing CICD system will already include the capability to host and serve build artifacts over HTTP. Simply copy the built components to the appropriate location.

## How to create a suitable HTTP server

In case you don't have an existing CICD system there are a number of ways to quickly create an HTTP server for this purpose.

### Apache HTTP Server on Ubuntu

To install Apache HTTP Server on Ubuntu 14.04, please refer to [these instructions](https://help.ubuntu.com/lts/serverguide/httpd.html) or see these [examples](EXAMPLES.md).

### Python

One of the simplest ways to create an throw-away HTTP server is described in the [Python documentation](https://docs.python.org/2/library/simplehttpserver.html). If you have built the components on an instance in the target cloud environment this can be one of the quickest ways to make them immediately available for PNDA provisioning. See these [examples](EXAMPLES.md).

### Vagrant

Vagrant is capable of creating virtual machines on both AWS and OpenStack cloud infrastructure and can be scripted to install Apache HTTP Server, for example.

Please refer to the [Vagrant documentation](https://www.vagrantup.com/docs/getting-started/provisioning.html) for more details or see these [examples](EXAMPLES.md).

### Docker

There is an Apache HTTP Server docker image. If you are familiar with docker this can be a quick way of creating a HTTP server.

Please refer to the [Docker documentation](https://hub.docker.com/_/httpd/) for more details or see these [examples](EXAMPLES.md).

## How to stage the build components

There are no special requirements for staging the build components. The simplest approach is to copy them all to the document root of your HTTP server.

## How to use the staged build components

Adjust the PNDA provisioning client configuration to refer to the location of the "Package Server" now hosting the built components as described [here](https://github.com/pndaproject/pnda-guide/blob/develop/provisioning/README.md).

