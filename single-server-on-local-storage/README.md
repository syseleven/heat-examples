# single server on local storage

## Overview

Using this template you launch an instance on the SysEleven Stack local storage.  
Based on the selected flavor the network or local storage is selected.

You only need to configure your ssh key in the parameter section of the env file.

## Usage

### Configure parameter
Configure your ssh key in `example-env.yaml`.

### Launch stack
Create a stack with this template
```
$ openstack stack create -t example.yaml -e example-env.yaml <Stack Name>
```

### SSH Login
Login to the new instance
```
$ ssh syseleven@<instance IP>
```

## Parameters

**public_network**  
References the external network connected to the internet.

**flavor**  
Instance flavor to be used.

**ssh_keys**  
SSH key to be injected into the instance.