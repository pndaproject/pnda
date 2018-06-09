# Packer


## Pre requisites

1. Download [packer version 1.2.3](https://www.packer.io/downloads.html)

```sh
wget https://releases.hashicorp.com/packer/1.2.3/packer_1.2.3_linux_amd64.zip
unzip packer_1.2.3_linux_amd64.zip
```

2. Download a CentOS iso on put it on the iso folder, you can find links [here](http://isoredirect.centos.org/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1804.iso)

```sh
cd iso
wget http://mirror.ipserv.nl/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1804.iso
```

3. You will need the ovftool, for doing so, you need to download them on myVMWare here is the [link](https://my.vmware.com/group/vmware/details?downloadGroup=OVFTOOL430&productId=742) but if you already have VMWare Fusion, this is not required

4. Setup your environment
Copy the sample configuration file conf_exemple.json into your own configuration environment file:

```sh
cp conf_exemple.json myenv_conf.json
```

## SSH Key pair for cluster access
Create an SSH key pair for use when configuring the PNDA nodes as ```key_name```. 

```sh
ssh-keygen -b 2048 -t rsa -f key_name.pem -q -N ""
```

This file will be required later in the process in order to be able to ssh to cluster nodes. The private key ```key_name.pem``` should be place in the root of the pnda-cli directory. 

Ensure that key_name.pem has 0600 permissions. 

## Build the PNDA mirror template

Run the following command:
```sh
export PACKER_LOG=1
export PACKER_LOG_PATH=centos_mirror.log
sudo ./packer build -var-file=myenv_conf.json vmware_centos_mirror.json
```

## Build the PNDA base template

At the moment, we do only support one PNDA base image, but this could be enhance later in order to support multiple base images depending on the roles, such a specific one for datanode etc..

Run the following command:
```sh
ssh-keygen -b 2048 -t rsa -f key_name.pem -q -N ""
export PACKER_LOG=1
export PACKER_LOG_PATH=centos_base.log
./packer build -var-file=myenv_conf.json vmware_centos_base.json
export PACKER_LOG_PATH=centos_datanode.log
./packer build -var-file=myenv_conf.json vmware_centos_datanode.json
export PACKER_LOG_PATH=centos_kafka.log
./packer build -var-file=myenv_conf.json vmware_centos_kafka.json
```