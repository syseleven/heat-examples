# single server with existing floating IP

## Overview

Using this template you launch an instance using an existing floating IP.
You only need to configure the ID of the existing floating IP in the parameter section of the main template.

## Known limitation

Due to a bug [1] this template does only work in region DBL, where the bug was fixed already.

[1] The heat resource type `OS::Neutron::FloatingIPAssociation` does not work properly in region CBK.

## Usage

### Get ID of existing floating IP

```shell
$ openstack floating ip list -c ID -c "Floating IP Address" -c "Fixed IP Address" -c Port -f table

+--------------------------------------+---------------------+------------------+--------------------------------------+
| ID                                   | Floating IP Address | Fixed IP Address | Port                                 |
+--------------------------------------+---------------------+------------------+--------------------------------------+
| 005fb469-0af4-4941-8555-a7beabbffcd7 | 185.56.133.228      | None             | None                                 |
| f385fb3d-4d70-40afa-82fc-abbffcf42de | 185.56.129.48       | 10.10.10.2       | 4bddb5fe-1962-4701-8aac-a1c0449aa45e |
+--------------------------------------+---------------------+------------------+--------------------------------------+
```

### Configure parameter

Configure the ID of the existing floating IP in `example-env.yaml`.

Replace ID_OF_FLOATING_IP_GOES_HERE with the floating IP ID.


### Launch stack

Create a stack with this template

```shell
openstack stack create -t example.yaml -e example-env.yaml <Stack Name>
```

## Parameters

**public_network**  
References the external network connected to the internet.

**fip**  
Defines the ID of the fip to be used for the instance port.

**image**  
Image to build the instance.

**flavor**  
Instance flavor to be used.

**ssh-key**  
SSH key to be injected into the instance.
