devops heat templates
===========

Heat templates for devops automation 

## Quickstart

Install Heat client:

```
$ pip install python-heatclient
```

Export environment variables:

```
export OS_AUTH_TOKEN=XXX
export OS_USERNAME=XXX
export OS_TENANT_ID=XXX
export OS_NO_CLIENT_AUTH=1
export HEAT_URL=https://syd.orchestration.api.rackspacecloud.com/v1/XXX
```

check if Heat is happy:

```
$ heat stack-list
```

## Environment File

Two environemt files are available for use ```env-2net.yaml``` and ```env-3net.yaml``` these will cause the generic/*-multi.yaml templates to use either the 2net or 3net templates.

- env-2net.yaml can be used in the following scenarios:
  - RackConnect v3
    - Specify connected_network as the RCv3 network UUID you want the servers to use
  - Non-RackConnected
    - Servers will connect to public network and service network by default **without** specifying connected_network
    - If connected_network is specified: the public net on the instance will be replaced with the specified network
- env-3net.yaml can be used in the following scenarios:
  - RackConnect v3 **NOT COMPATIBLE***
  - Non-RackConnected
    - Servers which need to connect to public, service and a private network (use the connected_network variable to specify the private network)

- No environment file is required for autoscale templates

### AutoScale

Create Autoscale Group and configuration:

```
$ heat stack-create -P organization=FOOORG -P validation_key="$(< /path/to/.chef/fooorg-validator.pem)" -f /path/to/autoscale/autoscale.yaml -P server_image=70d38a32-5f63-45df-a0e7-7e06fc89370a autoscale-test
```

**Attention!** Autoscale requires flavor and image id, *it does not accept flavor
and image alias*.

## Multi Generic

[Specification Doc](docs/generic-multi.md)

Create *generic* stack with multiple servers connected to *Public* and *Private* networks:

```
$ heat stack-create -P organization=FOOORG -P validation_key="$(< /path/to/.chef/fooorg-validator.pem)" -f generic/chef-multi.yaml -P run_list='"recipe[rackops_rolebook]"' -e env-2net.yaml -P resource_count=2 -P prefix=generic-test-01 generic-test-01
```

Create *generic* stack with multiple servers connected to *Public*, *Private* and *Custom* networks:

```
$ heat stack-create -P prefix=FOOORG -P organization=FOOORG -P validation_key="$(< /path/to/.chef/fooorg-validator.pem)" -P run_list='"recipe[rackops_rolebook]"' -f generic/chef-multi.yaml -P resource_count=1 -P connected_network=056e7b19-5099-404b-be00-51d8b4d47a17 -e env-3net.yaml generic-test-02
```

## Multi CBS Attached Servers

Typical use cases are servers which benefit from a dedicated block-storage device, e.g. MySQL or GlusterFS nodes.

[Specification Doc](docs/cbs-multi.md)

Create CBS+Server stack:

```
$ heat stack-create -P organization=FOOORG -P validation_key="$(< /path/to/.chef/fooorg-validator.pem)" -f generic/cbs-chef-multi.yaml -P run_list='"recipe[rackops_rolebook]"' -e env-2net.yaml -P resource_count=2 -P prefix=cbs-test-01 cbs-test-01
```

To connect servers to *Public*, *Private* and *Custom* networks see *Multi Generic* section.

## Delete stack

Just run:

```
$ heat stack-delete foo-stack
```

Alternatively abandon stack, and deletete resources manually:

```
$ heat stack-abandon foo-stack
```

## Chef integration

### Chef Client "run_list"

Use *run_list** parameter:

```
-P run_list='"recipe[rackops_rolebook]"'
```
