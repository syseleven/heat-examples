# Minimal load-balanced setup

## Overview

This is a demonstration of the [LBaaSv2](https://docs.openstack.org/liberty/networking-guide/adv-config-lbaas.html) service.

With this example we demonstrate an LBaaS setup with the following features:

- a TCP load balancer
- Round Robin LB algorithm
- Health Monitor for LB pool members (upstream instances)
- a server group with dynamic number of servers
- every node installs Apache2 and PHP7.0 FPM via HEAT
- "Anyapp" as simple PHP application

## How to start this setup

You can start the stack using the usual command line:

```shell
openstack stack create -t lbstack.yaml --parameter key_name=<publicKeyName> <stackName>
```

## Assign security group to LB

After a successful launch the whole setup will not be reachable from the outside until
you bind a valid security group to the load balancer port[1].

To simplify this process the example gives you a vaild openstack command in the output section.

You can get the the relevant output field including resource IDs using this command:

```shell
openstack stack show <stackName> -f value -c outputs | grep -i 'port set'
```

Ports can be assigned as follows:

```shell
openstack port set --security-group <Security Group> <LoadBalander Port>
```

[1]Port-Updates can't be done in heat at the moment:
<https://blueprints.launchpad.net/heat/+spec/add-security-group-to-port>


## Open Anyapp

The Anyapp is reachable via `http://<loadbalancerIP>` and shows the IP of the currently-used backend server.
