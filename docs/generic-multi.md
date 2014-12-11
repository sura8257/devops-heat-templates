# generic/generic-multi.yaml

## Description
Resource group for ```resource_count``` number of servers

## Parameters

* Resource Count
  * Name: resource_count
  * Default: 1
  * Description: Resource count to create in group

* Validation Key
  * Name: validation_key
  * Default: None
  * Description: Required: chef-client will attempt to use the private key assigned to the
    chef-validator, located in /etc/chef/validation.pem. If, for any reason,
    the chef-validator is unable to make an authenticated request to the
    Chef server, the initial chef-client run will fail.

* Resource Name Prefix
  * Name: prefix
  * Default: node
  * Description: Used to generate names of resources

* Chef Server URL
  * Name: chef_server_url
  * Default: empty string
  * Description: Optional: Chef Server URL. Defaults to None, but the BASH script will
infer the Managed Chef URL from the organization

* Run List
  * Name: run_list
  * Default: empty string
  * Description: Optional: Chef Run List. Will default to an empty string resulting in an empty run_list

* Organization
  * Name: organization
  * Default: None
  * Description: Required: Chef organization

* Primary Network ID/Connected Network ID
  * Name: connected_network
  * Default: 00000000-0000-0000-0000-000000000000
  * Description: The network ID to connect the servers to, defaults to public net

* Server Flavor
  * Name: server_flavor
  * Default: 1 GB General Purpose v1
  * Description: Must be a valid Rackspace Cloud Server flavor for the region you have
    selected to deploy into.
  * Possible Values: ```general1-1, general1-2, general1-4, general1-8, 1 GB General Purpose v1, 2 GB General Purpose v1, 4 GB General Purpose v1, 8 GB General Purpose v1, io1-15, io1-30, io1-60, io1-90, io1-120, 15 GB I/O v1, 30 GB I/O v1, 60 GB I/O v1, 90 GB I/O v1, 120 GB I/O v1```

* Server Base Image
  * Name: server_image
  * Default: CentOS 6.5 (PVHVM)
  * Description: Server image to use for server servers
  * Possible Values: ```CentOS 6.5 (PVHVM), Debian 7 (Wheezy) (PVHVM), Ubuntu 14.04 LTS (Trusty Tahr) (PVHVM)```

## Resources to be deployed
* resource_group: OS::Heat::ResourceGroup

# Example Usage
```supernova heat-rc3 -x heat stack-create -P resource_count=1 -P validation_key="$(< ~/chef-repo/.chef/anzdevops-validator.pem)" -P prefix=node -P run_list='"recipe[rackops_rolebook]"' -P organization=anzdevops -f generic/generic-multi.yaml -e env-2net.yaml stack-name ```
