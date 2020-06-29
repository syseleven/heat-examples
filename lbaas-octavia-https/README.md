# Minimal https load-balanced setup

## Overview

This is a demonstration of the [Octavia LBaaS](https://docs.openstack.org/octavia/latest/reference/introduction.html) service.

With this example we demonstrate a load balancer setup with the following features:

- an HTTPS load balancer
- Round Robin LB algorithm
- Health Monitor for LB pool members (upstream instances)
- a server group with dynamic number of servers
- every node installs Apache2 and PHP7.0 FPM via HEAT
- "Anyapp" as simple PHP application

## Prepare for the setup

You need to have a certificate and the respective key present for executing the stack example

Therefor you need to place an existing certificate and key in this folder (db.crt,db.key) or you generate a self-signed certificate chain using openssl following e.g. [self-signed certificate](https://docs.scylladb.com/operating-scylla/security/generate_certificate/).

## How to start this setup

You can start the stack using the usual command line:

```shell
openstack stack create -t lbstack.yaml --parameter key_name=<publicKeyName> <stackName>
```

## Open Anyapp

The output section of the stack will show you the URL where you can reach the load-balanced setup.

You can get the the relevant output field using this command:

```shell
openstack stack show <stackName> -c outputs
```

The Anyapp is reachable via `https://<loadbalancerIP>` and shows the IP of the currently-used backend server.
