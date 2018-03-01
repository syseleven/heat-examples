# Minimal loadbalanced setup

## Overview

This is a demonstration of the [LBaaSv2](https://docs.openstack.org/liberty/networking-guide/adv-config-lbaas.html) service.

With this example we demonstrate a LBaaS setup with the following features:

- a tcp loadbalancer
- Round Robin lb algorithm
- Health Monitor for LB pool members (upstream instances)
- a server group with dynamic numbers of servers
- every node installs Apache2 and PHP7.0 FPM via HEAT
- "Anyapp" as simple PHP application

## How to start this setup

You can start the stack using the usual command line:

```
openstack stack create -t lbstack.yaml --parameter key_name=<publicKeyName> <stackName>
```

## Assign security group to LB

After a successfull launch the whole setup will not be reachable from the ouside until 
you bind a valid security group to the loadbalancer port[1].

To simplify this process the example gives you a vaild openstack command in the output section.

You can get the the relevant output field including ressource IDs using this command:

```
openstack stack show <stackName> -f value -c outputs | grep -i 'port set'
```

Ports can be assigned as follows:
```
openstack port set --security-group <Security Group> <LoadBalander Port>
```

[1]Port-Updates can't be done in heat at the moment:
https://blueprints.launchpad.net/heat/+spec/add-security-group-to-port


## Open Anyapp

The Anyapp is reachable via `http://<loadbalancerIP>` and shows the IP of the currently used backend server.
