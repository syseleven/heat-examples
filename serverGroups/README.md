# Simple resource group example

## Overview

Using this template you can start two instances organised which are organised as ResourceGroups

## Usage

    ```$ openstack stack create -t group.yaml <stackName> ```

    This will start two instances without access from public network. They are only meant as an example how you can organise a number of resources.

## Code organisation
    
    This example uses two files as input. These files are organised hierarchically, which means that the file group.yaml uses the file server.yaml as often, as the variable "count" states.

## Parameters

This example does not make use of parameters.
