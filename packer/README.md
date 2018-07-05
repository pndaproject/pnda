# Packer


## Pre requisites

1. Download [packer version 1.2.3](https://www.packer.io/downloads.html)

```sh
wget https://releases.hashicorp.com/packer/1.2.3/packer_1.2.3_linux_amd64.zip
unzip packer_1.2.3_linux_amd64.zip
```
Then, make sure that packer is on your $PATH.

2. Download a CentOS iso on put it on the iso folder, you can find links [here](http://isoredirect.centos.org/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1804.iso)

```sh
cd pnda/packer
mkdir iso
cd iso
wget http://mirror.ipserv.nl/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1804.iso
```

3. You will need the ovftool, for doing so, you need to download them on myVMWare here is the [link](https://my.vmware.com/group/vmware/details?downloadGroup=OVFTOOL430&productId=742) . If you already have VMWare Fusion, this is not required. Ensure that ovftool is on your $PATH.

4. Setup your environment
Copy the sample configuration file conf_exemple.json into your own configuration environment file:

```sh
cp conf_exemple.json myenv_conf.json
```

For the mirror image, you will require these parameters:

```json
...
    "username": "centos",
    "password": "centos",
    "pnda_repo": "https://github.com/pndaproject/pnda",
    "pnda_branch": "develop",
    "build_mode": "BRANCH",
    "build_arg": "develop"
...
```
So on the pnda repo, you will need to put the right branch you would like to build which need to be align also to the build mode and argument.
If you want to override some mirror variables, you must need to update the script mirror.sh as there is a place to put another value for AMBARI_REPO for example.

## SSH Key pair for cluster access
Create an SSH key pair for use when configuring the PNDA nodes as ```key_name```. 

```sh
ssh-keygen -b 2048 -t rsa -f key_name.pem -q -N ""
```

This file will be required later in the process in order to be able to ssh to cluster nodes. The private key ```key_name.pem``` should be place in the root of the pnda-cli directory. 

Ensure that key_name.pem has 0600 permissions. 

## Build the images for VMWare

### PNDA mirror template

Run the following command:
```sh
export PACKER_LOG=1
export PACKER_LOG_PATH=centos_mirror.log
sudo ./packer build -var-file=myenv_conf.json vmware/centos_mirror.json
```

#### PNDA base image

At the moment, we do only support one PNDA base image, but this could be enhance later in order to support multiple base images depending on the roles, such a specific one for datanode etc..

Run the following command:
```sh
ssh-keygen -b 2048 -t rsa -f key_name.pem -q -N ""
export PACKER_LOG=1
export PACKER_LOG_PATH=centos_base.log
./packer build -var-file=myenv_conf.json vmware/centos_base.json
export PACKER_LOG_PATH=centos_datanode.log
./packer build -var-file=myenv_conf.json vmware/centos_datanode.json
export PACKER_LOG_PATH=centos_kafka.log
./packer build -var-file=myenv_conf.json vmware/centos_kafka.json
```

## Build the AMI for AWS

### Configuration

In order to build the AMI in AWS, you will need to change the aws_* parameters of the file myenv_conf.json which are:

```json
...
"aws_access_key": "YYY",
"aws_secret_key": "YYY",
"aws_region": "YYY",
"aws_mirror_instance_type": "c5d.4xlarge",
"aws_base_instance_type": "c5d.4xlarge",
"aws_ami_name": "pnda",
"aws_ami_id": "ami-3548444c",
"aws_ami_os": "rhel",
"aws_ami_username": "ec2-user",
"aws_subnet_id": "xxxx",
"aws_ssh_keypair_name": "xxx",
"aws_ssh_private_key_file": "/xxx//key.pem",
"aws_ami_tags": "ci",
...
```
* aws_ami_id could be either ami-7c491f05 for RHEL 7.5 or ami-3548444c for CentOS 7.5, only for the base AMI, the mirror AMI should use the base AMI generated
* aws_ami_os should be either centos or rhel, in order to be use on the provisioning script ifname.sh
* aws_ami_username should be ec2-user on RHEL or centos for CentOS
* aws_ami_name could be then pnda, a timestamp suffix is automatically added to ensure that you've got an unique identifier
* aws_ami_tags is an extra tag setup on the AMI if needed, you can specify ci or something else if needed, helpful for filtering AMIs. For the mirror build, ensure to have a unique tag as this will be used on filtering the image on the second step to include PNDA components and start from the base mirror image

### PNDA base AMI
```sh
export PACKER_LOG=1
export PACKER_LOG_PATH=aws_base.log
./packer build -var-file=myenv_conf.json aws/base_image.json
```

### PNDA mirror AMI

The PNDA mirror AMI is split in 2 parts in order to optimize the build, so the first part is currently the mirror where we will run create_mirror.sh script and the second part will include the PNDA & upstream components. Do not forget to update the AMI id on your configuration as the AMI id previously generated.

Run the following command:
```sh
export PACKER_LOG=1
export PACKER_LOG_PATH=aws_mirror.log
./packer build -var-file=myenv_conf.json aws/centos_mirror.json
./packer build -var-file=myenv_conf.json aws/centos_mirror_build.json
```