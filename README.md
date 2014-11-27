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

### AutoScale

Create Autoscale Group and configuration:

```
$ heat stack-create -P organization=fooorg -P validation_key="$(< /path/to/.chef/fooorg-validator.pem)" --template-file /path/to/poc-hn-heat/autoscale/autoscale.yaml -P server_image=70d38a32-5f63-45df-a0e7-7e06fc89370a autoscale-test
```

**Attention!** Autoscale requires flavor and image id, it does not accept flavor
and image alias.

## Generic

Create *generic* stack:

```
$ heat stack-create test_generic -P organization=fooorg -P validation_key="$(< /path/to/.chef/fooorg-validator.pem)" --template-file /path/to/poc-hn-heat/generic/generic.yaml
```

### GlusterFS

Create GlusterFS stack:

```
heat stack-create heat-test-gluster -P "private_net_name=test_gluster" -P organization=fooorg -P validation_key="$(< /path/to/.chef/fooorg-validator.pem)" --template-file /path/to/poc-hn-heat/gluster/gluster-multi.yaml
```

Chef client is installed on Cloud Servers, and nodes added to Managed-Chef organisation.

### Redis

Create Redis master-slave stack:

```
heat stack-create hn-redis-a -P "prefix=hn-redis-a" \
-P organization=anzdevops \
-P validation_key="$(< ~/chef/racker_siso/anzdevops/chef-repo/.chef/anzdevops-validator.pem)"
-P redis_image="CentOS 6.5 (PVHVM)" -P role='"recipe[rackops_rolebook]"' \
--template-file ~/workspace/github.rackspace.com/anzdevops/poc-hn-heat/redis/redis-master-slave.yaml
```

### Delete stack

Just run:

```
$ heat stack-delete foo-stack
```

Alternatively abandon stack, and deletete resources manually:

```
$ heat stack-delete foo-stack
```

### Chef Client 'run_list'

Use *role* parameter:

```
-P role='"recipe[rackops_rolebook]"'
```
