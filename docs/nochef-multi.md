# generic/nochef-multi.yaml

## Description
Resource group for ```resource_count``` number of servers


## Parameters

* Resource Name Prefix
  * Name: prefix
  * Default: node
  * Description: Used to generate names of resources
* Server Base Image
  * Name: server_image
  * Default: CentOS 6 (PVHVM)
  * Description: Server image to use for server servers
  * Possible Values: ```CentOS 6 (PVHVM), Debian 7 (Wheezy) (PVHVM), Ubuntu 14.04 LTS (Trusty Tahr) (PVHVM)```
* Resource Count
  * Name: resource_count
  * Default: 1
  * Description: Resource count to create in group
* Primary Network ID/Connected Network ID
  * Name: connected_network
  * Default: 00000000-0000-0000-0000-000000000000
  * Description: The network ID to connect the servers to, defaults to public net
* SSH Key Name
  * Name: ssh_key
  * Default: None
  * Description: The name of the SSH key to use as shown in the rackspace cloud portal
* Server Flavor
  * Name: server_flavor
  * Default: 1 GB General Purpose v1
  * Description: Must be a valid Rackspace Cloud Server flavor for the region you have
selected to deploy into.

  * Possible Values: ```general1-1, general1-2, general1-4, general1-8, 1 GB General Purpose v1, 2 GB General Purpose v1, 4 GB General Purpose v1, 8 GB General Purpose v1, io1-15, io1-30, io1-60, io1-90, io1-120, 15 GB I/O v1, 30 GB I/O v1, 60 GB I/O v1, 90 GB I/O v1, 120 GB I/O v1```

## Resources to be deployed
* resource_group: OS::Heat::ResourceGroup

# Example Usage
```supernova heat-rc3 -x heat stack-create -P prefix=node -P server_image=CentOS 6 (PVHVM) -P resource_count=1 -P ssh_key=None -P server_flavor=1 GB General Purpose v1 -f generic/nochef-multi.yaml -e env-2net.yaml stack-name ```
