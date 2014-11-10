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

create a stack:

```
heat stack-create heat-test-gluster -P "gluster_server_count=4" -P "private_net_name=test_gluster" --template-file gluster-multi.yaml
heat stack-delete heat-test-gluster
```

