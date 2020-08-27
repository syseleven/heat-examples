# Servers with directly attached public IP addresses

## Overview

Using this template you can deploy a group of servers with only external network and directly attached public IP addresses. This requires a dedicated network that customers can acquire upon request.

## Usage

```$ openstack stack create -t group.yaml -e group-env.yaml <stackName>```

## Code organisation

The file group.yaml references the resources in server.yaml via the resource group. The property count controls the number of times the resources in server.yaml will be instantiated.

## Parameters

  `dedicated_public_network`: specifies the dedicated network that the customer must have acquired before
  `servers_number`: specifies the number of servers to be built, default: 1
  `servers_flavor`: specifies the flavor to use for each server, default: m1c.tiny
  `servers_image`: specifies the image to initialize each server, default: Ubuntu Xenial 16.04 (2020-08-23)
  `ssh_pubkey_name`: specifies the name of a public ssh key previously uploaded to keystone
  `ssh_pubkeys`: specifies a list of public ssh keys directly

