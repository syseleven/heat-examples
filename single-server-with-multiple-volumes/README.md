# single server with multiple volumes

## Overview

Using this template you launch an instance with multiple volumes. A volume for mysql and another for the webroot.  
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

**image**  
Image to build the instance.

**flavor**  
Instance flavor to be used.

**volume_size_db**  
Size of volume for DB.

**volume_size_www**  
Size of volume for webroot.

**ssh-key**  
SSH key to be injected into the instance.