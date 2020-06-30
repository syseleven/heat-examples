# Minimal https load-balanced setup

## Overview

This is a demonstration of the [Octavia LBaaS](https://docs.openstack.org/octavia/latest/reference/introduction.html) service.

With this example we demonstrate a load balancer setup with the following features:

- an HTTPS load balancer
- certificate stored using the Barbican service
- Round Robin LB algorithm
- Health Monitor for LB pool members (upstream instances)
- a server group with dynamic number of servers
- every node installs Apache2 and PHP7.0 FPM via HEAT
- "Anyapp" as simple PHP application

## Prepare for the setup

You need to have a certificate and the respective key present before creating the stack.
By default the certificate and key files are expected as db.crt and db.key here in this folder.
You may generate a self-signed certificate chain using openssl following e.g. [self-signed certificate](https://docs.scylladb.com/operating-scylla/security/generate_certificate/).

## How to start this setup

You can start the stack using the usual command line:

```shell
openstack stack create -t lbstack.yaml --parameter key_name=<publicKeyName> <stackName>
```

where `publicKeyName` is the name of an existing key pair used for the installation of the backend VMs.

## Open Anyapp

The output section of the stack will show you the URL where you can reach the load-balanced setup.

You can get the the relevant output field using this command:

```shell
openstack stack output show <stackName> lburl -c output_value -f value
```

The Anyapp is reachable via `https://<loadbalancerIP>` and shows the IP of the currently-used backend server.
