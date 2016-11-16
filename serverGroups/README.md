# Simple resource group example

## Overview

Using this template you can start two instances organised which are organised as `OS::Heat::ResourceGroups`.

## Usage

    ```$ openstack stack create -t group.yaml <stackName> ```

    This will start two instances without access from public network. They are only meant as an example how you can organise a number of resources.

## Code organisation
    
    The file group.yaml references the resources in server.yaml via the resource group. The property count controls the number of times the resources in server.yaml will be instantiated.

## Parameters

This example does not make use of parameters.
