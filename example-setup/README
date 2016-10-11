## Distributed Setup with loadbalancer, database server and a dynamic number of application servers.

 with this example we demonstrate a cluster setup with the following features:

- a loadbalancer
- a server group with dynamic numbers of servers
- a database server
- a bastion host

These servers are provisioned only with cloud-init/ shell scripts. For service discovery we use consul.

The bootstrap process goes:

Any node installs consul via cloud-init/ a simple shell script.
Any node joins a cluster with the first three nodes  
 in the internal network range as (as defined in OS::Neutron::Subnet)
 
Any node has service checks, that announce it's services to the whole cluster.
The loadbalancer for example distributes requests across all application servers, if their checks are green.

