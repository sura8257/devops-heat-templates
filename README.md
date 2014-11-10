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
heat stack-create heat-test-gluster -P "private_net_name=test_gluster" -P organization=anzdevops -P validation_key="$(< .chef/anzdevops-validator.pem)" --template-file ~/workspace/github.rackspace.com/anzdevops/poc-hn-heat/gluster-multi.yaml
```

Chef client is installed on Cloud Servers, and nodes added to Managed-Chef organisation.

Delete stack:

```
$ heat stack-delete heat-test-gluster
```

