poc-hn-heat
===========

Heat templates for poc-hn gluster components

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
$ heat stack-create -P organization=fooorg -P validation_key="$(< /path/to/.chef/fooorg-validator.pem)" -f /path/to/poc-hn-heat/autoscale/autoscale.yaml -P server_image=70d38a32-5f63-45df-a0e7-7e06fc89370a autoscale-test
```

**Attention!** Autoscale requires flavor and image id, it does not accept flavor
and image alias.

## Multi Generic

[Specification Doc](docs/generic-multi.md)

Create *generic* stack with multiple servers:

```
$ supernova heat-rc3 -x heat stack-create -P organization=anzdevops -P validation_key="$(< /path/to/.chef/anzdevops-validator.pem)" -f generic/generic-multi.yaml -P run_list='"recipe[rackops_rolebook]"' -e env-2net.yaml -P resource_count=2 -P prefix=generic-test-01 generic-test-01
```

### Multi CBS Attached Servers

[Specification Doc](docs/cbs-multi.md)

Create CBS+Server stack:

```
supernova heat-rc3 -x heat stack-create -P organization=anzdevops -P validation_key="$(< /path/to/.chef/anzdevops-validator.pem)" -f generic/cbs-multi.yaml -P run_list='"recipe[rackops_rolebook]"' -e env-2net.yaml -P resource_count=2 -P prefix=cbs-test-01 cbs-test-01
```

### Delete stack

Just run:

```
$ heat stack-delete foo-stack
```

Alternatively abandon stack, and deletete resources manually:

```
$ heat stack-abandon foo-stack
```

### Chef Client 'run_list'

Use *run_list** parameter:

```
-P run_list='"recipe[rackops_rolebook]"'
```
