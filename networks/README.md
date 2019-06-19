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

```shell
openstack stack create -t 1.single-network.yaml <stackName>
```

## two networks

- two networks and subnets
- one router
- router <-> subnets bridge
- uplink to internet (ext-net)

### How to start this setup

You can start the stack using the usual command line:

```shell
openstack stack create -t 2.two-networks.yaml <stackName>
```

## Network IDs for further usage

### GUI

After a successful launch you can see the network ID in the stack output section in Horizon.

### CLI

You can get the the relevant output field including resource IDs using this command:

```shell
openstack stack show <stackName> -f value -c outputs
```

#### Output example

```shell
[
  {
    "output_value": "edb0e670-8588-494a-b331-30c824c510c6",
    "output_key": "network_one_id",
    "description": "This network ID can be used to connect ports with this network."
  },
  {
    "output_value": "dab4483c-c4fe-4186-992b-4a5a9e0def21",
    "output_key": "network_two_id",
    "description": "This network ID can be used to connect ports with this network."
  }
]
 ```
