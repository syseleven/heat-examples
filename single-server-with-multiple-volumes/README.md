# single server with multiple volumes

## Overview

Using this template you launch an instance with multiple volumes.   
This templates also shows how to enforce the attachment order for volumes to ensure correct mount points.

## Usage

### Configure parameter

Configure size of volumes in `example-env.yaml`.


### Launch stack
Create a stack with this template
```
$ openstack stack create -t example.yaml -e example-env.yaml <Stack Name>
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