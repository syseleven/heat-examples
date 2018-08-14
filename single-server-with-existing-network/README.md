# Single Server with existing network

## Overview

Using this template you launch an instance connecting it to an existing network.
You only need to configure the ID of the existing network in the parameter section of the main template.

## Usage

### Get ID of existing network

```shell
$ openstack network list -f table -c ID -c Name

+--------------------------------------+-----------------+
| ID                                   | Name            |
+--------------------------------------+-----------------+
| c98de335-4473-4731-92j5-f151de8b5cf0 | appserver-net   |
| caf8de33-1059-4473-a2c1-2a62d12294fa | ext-net         |
+--------------------------------------+-----------------+
```

### Configure parameter

Configure the ID of the existing network in `example-env.yaml`.

Replace ID_OF_NETWORK_GOES_HERE with the network ID.


### Launch stack

Create a stack with this template

```shell
openstack stack create -t example.yaml -e example-env.yaml <Stack Name>
```

### SSH Login

Login to the new instance

```shell
ssh syseleven@<instance IP>
```

## Parameters

**public_network**  
References the external network connected to the internet.

**net**  
Defines the ID of the network to connect the instance port to.

**image**  
Image to build the instance.

**flavor**  
Instance flavor to be used.

**ssh-key**  
SSH key to be injected into the instance.