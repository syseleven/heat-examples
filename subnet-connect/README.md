# Multiple subnet topology

This template demonstrates how you can connect multiple subnets with a router.
For demonstration and test purposes there are two VMs deployed, one in each subnet.

![network topology](img/topology.png)

You can start the stack with the following command 
``` openstack stack create -t subnetConnect.yaml --parameter key_name=<key_name> <stack name> ```
