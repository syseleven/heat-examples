# Single server with existing security group

## Overview

Using this template you launch an instance using an existing security group.
You only need to configure the ID of the existing security group in the parameter section of the main template.

## Usage

### Get ID of existing security group

```shell
$ openstack security group list -f table -c ID -c Name

+--------------------------------------+----------------------------------------------------------------------+
| ID                                   | Name                                                                 |
+--------------------------------------+----------------------------------------------------------------------+
| 8975c4c4-abbc-4e53-aaec-f0447d27b1f9 | Allow SSH and Ping - allow incoming traffic for tcp port 22 and icmp |
| fd688375-77c4-42ea-b69e-a7481d27bf36 | default                                                              |
+--------------------------------------+----------------------------------------------------------------------+
```

### Configure parameter

Configure the ID of the existing security group in `example-env.yaml`.

Replace ID_OF_SECURITY_GROUP_GOES_HERE with the security group ID.


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

**security_group**  
Defines the ID of the security group to be used for the instance port.

**image**  
Image to build the instance.

**flavor**  
Instance flavor to be used.

**ssh-key**  
SSH key to be injected into the instance.
