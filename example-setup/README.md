# Distributed Setup with load balancer, database server and a dynamic number of application servers.

## Overview

With this example we demonstrate a cluster setup with the following features:

- a load balancer
- a server group with dynamic number of servers
- a database server
- a bastion host

![Setup overview](img/setup_overview.png)

These servers are provisioned only with cloud-init/ shell scripts. For service discovery we use consul.

- Any node installs consul via cloud-init/ a simple shell script.
- Any node joins a cluster with the first three nodes in the internal network range.
- Consul ACLs are protected by a master token which is randomly generated.
The master token can be found in the stack metadata:

```
openstack stack show <stack_name> -f value -c outputs
```

Any node has service checks, that announce its services to the whole cluster.
The load balancer for example distributes requests across all application servers, if their checks are green.

If the bastion host (called "servicehost") and the load balancer as proxy are completely deployed you can gain an overview of your setup using the consul webui. The webui is reachable via http://\<loadbalancerIP\>:8080

## How to start this setup

* add your public SSH key to clustersetup-env.yaml
* Start the setup:

```
openstack stack create -t clustersetup.yaml -e clustersetup-env.yaml <stack_name>
```

## After successful stack creation you can log in with
```
openstack server ssh --option "ForwardAgent=yes" -l syseleven servicehost0
```

From there you can jump to any of your nodes. An example:
```
ssh lb0.node.consul
```
