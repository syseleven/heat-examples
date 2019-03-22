# CloudInit

## Overview

Simple template to deploy a single compute instance with external network (login will be possible via SSH). It deploys a single unix user and ssh-public-keys.
To be able to access the machine a security group gets deployed to allow ssh. Keep in mind, that the default 'ubuntu' or 'ec2-user' won't get deployed.

## Usage

`openstack stack create -t userExample.yaml -e userExampleEnv.yaml <stackName>`

This will start an instances with access from public network.


## Parameters

This example does not make use of parameters.
