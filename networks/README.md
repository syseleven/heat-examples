# Networks

## Overview

With this example we demonstrate how to create a single network as well as two networks with one stack.

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
openstack stack show <stackName> -f value -coutputs | grep -i 'output_value'
```