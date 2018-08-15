# Single server with multiple volumes

## Overview

Using this template you launch an instance with multiple volumes. A volume for mysql and another for the webroot.  
This template also shows how to enforce the attachment order for volumes to ensure correct mount points.  

## Usage

### Configure parameter

Configure the size of volumes in `example-env.yaml`.


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

**image**  
Image used to build the instance.

**flavor**  
Instance flavor to be used.

**volume_size_db**  
Size of the volume for database.

**volume_size_www**  
Size of the volume for webroot.

**ssh-key**  
SSH key to be injected into the instance.