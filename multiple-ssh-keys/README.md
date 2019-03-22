# Multiple SSH keys

## Overview

Simple template for demo server with multiple ssh keys via environment file.

## Usage

`stack create -t server.yaml -e server-env.yaml <stackName>`

This will start an instances with access from public network.

## Parameters

**ssh_keys**  
SSH keys are defined in the parameter file `server-env.yaml`.
