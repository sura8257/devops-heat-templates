# generic-network.yaml

## Description
This heat template will deploy ```server_count``` number of servers as part of a resource group
These servers will be added to public, service and ```private_network```s


## Parameters

* Organization
  * Name: organization
  * Default: None
  * Description: Required: Chef organization

* Validation Key
  * Name: validation_key
  * Default: None
  * Description: Required: chef-client will attempt to use the private key assigned to the
chef-validator, located in /etc/chef/validation.pem. If, for any reason,
the chef-validator is unable to make an authenticated request to the
Chef server, the initial chef-client run will fail.

* Hostname Prefix
  * Name: prefix
  * Default: node
  * Description: The prefix to use for all server hostnames
* Chef Server URL
  * Name: chef_server_url
  * Default: empty string
  * Description: Optional: Chef Server URL. Defaults to None, but the BASH script will
infer the Managed Chef URL from the organization

* Run List
  * Name: run_list
  * Default: empty string
  * Description: Optional: Chef Run List. Will default to an empty string resulting in an empty run_list

* Server Group
  * Name: server_group
  * Default: default_group
  * Description: Set the group metadata for the servers.
* Private Network ID
  * Name: private_network
  * Description: The private network ID to connect the servers to
* Server Base Image
  * Name: server_image
  * Default: CentOS 6.5 (PVHVM)
  * Description: Server image to use for servers
  * Possible Values: ```CentOS 6.5 (PVHVM), Debian 7 (Wheezy) (PVHVM), Ubuntu 14.04 LTS (Trusty Tahr) (PVHVM)```
* Number of servers to deploy.
  * Name: server_count
  * Default: 1
  * Description: Must be between 0 and 100 servers.
* Server Flavor
  * Name: server_flavor
  * Default: 1 GB General Purpose v1
  * Description: Must be a valid Rackspace Cloud Server flavor for the region you have
selected to deploy into.

  * Possible Values: ```general1-1, general1-2, general1-4, general1-8, 1 GB General Purpose v1, 2 GB General Purpose v1, 4 GB General Purpose v1, 8 GB General Purpose v1, io1-15, io1-30, io1-60, io1-90, io1-120, 15 GB I/O v1, 30 GB I/O v1, 60 GB I/O v1, 90 GB I/O v1, 120 GB I/O v1```

## Resources to be deployed
* server_group_resource: OS::Heat::ResourceGroup

# Example Usage
```supernova heat-rc3 -x heat organization=fooorg -P validation_key=$(< ~/chef-repo/.chef/fooorg-validator.pem) -P prefix=node -P run_list='"recipe[rackops_rolebook]"' -P server_group=default_group -P server_image=CentOS 6.5 (PVHVM) -P server_count=1 -P server_flavor=1 GB General Purpose v1 --template-file generic-network.yaml stack-name ```
