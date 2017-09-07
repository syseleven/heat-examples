# BETA Setup example with two loadbalancer in HA and two appserver.
This setup is still beeing worked on to improve it's stability and flexibility.  
Basic functionallity is given already.

## Overview

 With this example we demonstrate a loadbalancer cluster setup with the following features:

* One floating IP
* Two loadbalancer that run in HA
* Two application server (webserver)
* Three stacks to make updates possible with affecting others

*A setup overview will be added later.*
![Setup overview](img/setup_overview.png)

These servers are provisioned only with cloud-init / shell scripts. 

The LB node installs haproxy, keepalived and openstack clients via cloud-init / a simple shell script.
Any node joins in the internal network range.
The floating IP association will be initialized manually and afterwards be controlled by the keepalived daemons running on both LB nodes.

## How to start this setup

* Request one floating IP:
```
openstack stack create -t 1.1_reservedIP.yaml ExampleStack_1_IP_Reservation --wait
```

* Add your public SSH key to `server-env.yaml`
* Retrieve the floating IP ID
```
openstack floating ip list
```
* Add the floating IP ID to the shell script `scripts/init_lb_config.sh`
* Add your OpenStack credentials to the shell script `scripts/init_lb_config.sh`
* Change the keepalived password in the shell script `scripts/init_lb_config.sh`
* Start the setup of the main stack:
```
openstack stack create -t 2.1_lbhaandlampstack.yaml -e server-env.yaml ExampleStack_2_Server --wait
```
* Retrieve the LB instance IDs
```
openstack server list
```
* Assign the floating IP to one instance
```
openstack stack create -t 3.1_AssociateIP_Nova.yaml --parameter "server_id=<server_id>" --parameter "floating_ip=<floating_ip_id>" ExampleStack_3_IP_Association --wait
```
* Connect to the server `ssh -A syseleven@<FIP>` you assigned the FIP to and enter it's instance ID including the name of the stack that you chose for the floating IP assignment (in this example: "ExampleStack_3_IP_Association") into the shell script `/etc/keepalived/master.sh`

* Connect to the second instance from within the first instance (jumphost) and enter it's instance ID including the name of the stack that you chose for the floating IP assignment (in this example: "ExampleStack_3_IP_Association") into the shell script `/etc/keepalived/master.sh`

* The configuration is done. 

Keepalived should now automatically assign the FIP to a loadbalancer that is available.  
If one LB node fails, the other takes over.  
There is on master LB that will always retrieve the FIP if it is online (again).  
The priority of this may be changed in the keepalived configuration file. `keepalived.conf`

There is a script that calls out for a http response from the other LB.  
If it fails it will assign the floating IP to itself.

## Known bugs
* The master.sh that keepalived executes runs without error. For some reason the openstack command run with this script is beeing executed without result but also without error.  
When executing the script manuylly the stack is beeing updated without any error.
* Keepalived continuously executs the master.sh if the other node is not reachable. This does not cause any trouble, but isn't nice either.

## Usability
* The stack name for the IP association can be defined via a variable in the shell script. Yet to be implemented.
* Maybe it is possible to somehow retrieve a usable instance IDs while running the setup, so no configuration has to be done manually after the installation.
