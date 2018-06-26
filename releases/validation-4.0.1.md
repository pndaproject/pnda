# PNDA 4.0.1

### Validation Matrix

The following cluster types have been validated for this release.

|Infra|OS|OS Version|PNDA Flavor|Hadoop|Airgapped|
|---|---|---|---|---|---|
|AWS|Ubuntu|14.04|	Pico|	HDP|	Yes|
|AWS|RHEL|7.4|	Pico|	HDP|	Yes|
|AWS|Centos|	7.4|	Pico|	HDP|	Yes|
|AWS|Ubuntu|	14.04|	Standard|	HDP|	Yes|
|AWS|RHEL|	7.4|	Standard|	HDP|	Yes|
|AWS|Centos|	7.4|	Standard|	HDP|	Yes|
|AWS|Ubuntu|	14.04|	Pico|	CDH|	Yes|
|AWS|RHEL|	7.4|	Pico|	CDH|	Yes|
|AWS|Centos|	7.4|	Pico|	CDH|	Yes|
|AWS|Ubuntu|	14.04|	Standard|	CDH|	Yes|
|AWS|RHEL|	7.4|	Standard|	CDH|	Yes|
|AWS|Centos|	7.4|	Standard|	CDH|	Yes|
|Servers|RHEL|	7.4|	Custom|	HDP|	Yes|
|Servers|Centos|	7.4|	Custom|	HDP|	Yes|
|OpenStack|Ubuntu|	14.04|	Pico|	HDP|	Yes|
|OpenStack|Ubuntu|	14.04|	Standard|	HDP|	Yes|

## Notes

- **Infra**: Platform such as AWS or physical machines
- **OS**: Linux distribution
- **OS Version**: Distribution version
- **Flavor**: PNDA Flavor
- **Hadoop**: Hadoop distribution
- **Airgapped**: Provisioned in an environment without Internet access

Note that airgapped installation for AWS can be simulated by using the default settings in the 'connectivity' section of the pnda_env.yaml configuration file - i.e. set REJECT_OUTBOUND to YES, ADD_ONLINE_REPOS to NO and CLIENT_IP to your client address and PNDA will configure each node appropriately. For Openstack deployment, iptables to be configured in the Network node on the External network interface.

### Known issues

#### Servers or 'existing machines'

For "existing machines" style installations, the following JIRAs are relevant - 

- https://issues.pnda.io/browse/PNDA-4422
- https://issues.pnda.io/browse/PNDA-4413
- https://issues.pnda.io/browse/PNDA-4197
- https://issues.pnda.io/browse/PNDA-4731 
 
We recommend the following steps, prior to installing PNDA -

- Install the packages yum-utils & libaio
- Disable "firewall" service
- Set selinux mode to "permissive"

