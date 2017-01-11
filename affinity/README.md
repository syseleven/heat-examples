# Servergroups with affinity example

## Overview

Using this template you can control the host on which instances are started via `OS::Heat::ServerGroup`.

## Usage

```$ openstack stack create -t servergroups.yaml <stackName> ```

This will start four instances without access from public network. They are only meant as an example how to use affinity with server groups.

## Code organisation

The file servergroups.yaml references the resources in server.yaml via the resource group and defines affinity policies via server groups.

## Parameters

This example does not make use of parameters.
