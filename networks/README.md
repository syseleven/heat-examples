# Networks

## Overview

With this example we demonstrate how to create a single network as well as two networks with one stack.

The separation of network and compute resources allows to create multiple stacks containing instances and 
volumes that are all connected to the same network. This can be useful if one uses the same network(s) 
for multiple groups of instances(servers) that need to run separately from other instance groups. 
Of course the same rule applies for single instances too.

## single network

- one network and subnet
- one router
- router <-> subnet bridge
- uplink to internet (ext-net)

### How to start this setup

You can start the stack using the usual command line:

```
openstack stack create -t 1.single-network.yaml <stackName>
```

## two networks

- two networks and subnets
- one router
- router <-> subnets bridge
- uplink to internet (ext-net)

### How to start this setup

You can start the stack using the usual command line:

```
openstack stack create -t 2.two-networks.yaml <stackName>
```

## Network IDs for further usage

### GUI
After a successful launch you can see the network ID in the stack output section in Horizon.

### CLI
You can get the the relevant output field including resource IDs using this command:
```
openstack stack show <stackName> -f table -c outputs
```
**Output example**  
```
+---------+--------------------------------------------------------------------------------+
| Field   | Value                                                                          |
+---------+--------------------------------------------------------------------------------+
| outputs | - description: This network ID can be used to connect ports with this network. |
|         |   output_key: networkinfo                                                      |
|         |   output_value: 'NETWORK_ONE_ID = 050bfd92-ba76-4eb6-9d49-b890acbf2a43         |
|         |                                                                                |
|         |     NETWORK_TWO_ID = c0c8ae9f-65c1-4e16-85b9-180abf392676                      |
|         |                                                                                |
|         |     '                                                                          |
|         |                                                                                |
+---------+--------------------------------------------------------------------------------+
 ```