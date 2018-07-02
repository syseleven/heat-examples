# Reserve Floating IPs

## Overview

Using this template you launch an instance connecting it to an existing network. You only need to configure the ID of the existing network in the parameter 
section of the main template.

## Usage

### Initial launch

Configure the ID of the existing network in the parameter.

Create a stack with this template
```
$ openstack stack create -t 1.1_reserve_floating_ips.yaml <new stackName>
```

## Code organisation

The file 1.1_reserve_floating_ips.yaml references the resources in 1.2_reserve_fip.yaml via the resource group. The property count controls the number of times the resources in reserve_fip.yaml will be created.

## Parameters

**public_network**  
References the external network connected to the internet.

**number_of_fips**  
Defines number of fips to be created.

## Outputs

**list_fips_via_cli**  
Provides the command that can be used to show a list of all floating IPs within the current project.

**overview**  
Shows a table containing all reserved FIPs and their current association status.

**overview_json**  
Shows json code containing all reserved FIPs and their current association status.