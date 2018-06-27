# reserve Floating IPs

## Overview

Using this template you can reserve floating IPs that can be associated with ports later on.

## Usage

### Initial launch

Set the number of required FIPs in the parameter.

Create a stack with this template
```
$ openstack stack create -t reserve_floating_ips.yaml <new stackName>
```

### Upgrade/Changes

Adjust the number of required FIPs in the parameter.

Update the existing stack with this template
```
$ openstack stack update -t reserve_floating_ips.yaml <existing stackName>
```

## Code organisation

The file reserve_floating_ips.yaml references the resources in reserve_fip.yaml via the resource group. The property count controls the number of times the resources in reserve_fip.yaml will be created.

## Parameters

**public_network**
References the external network connected to the internet.

**number_of_fips**  
Defines number of fips to be created.
