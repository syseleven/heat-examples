## Heat Templates

Heat is a service to orchestrate multiple composite cloud applications using templates

This repository provides:

    Example templates from a single machine setup up to bigger 
    distributed deployment scenarios.
    Examples include usage of

    - Resource Groups
	With resource groups you can start defined resources multiple times. 
	For example to start <n> application server you would build them as
	a resource group.

    - Floating IPs
	Floating IPs are public IPs you attach to a server or gateway to make 
	your resource reachable outside of your private network space.

    - Router and router interfaces
	You need a router, if you don't want to waste public/ floating IPs for 
	instances that do not need public interfaces. 

    - working with volumes
	Volumes are a way to get data persistence even if you terminate your 
	instance. Volumes are recommended if you work with databases or any
	content you want to use longer than your VMs life cycle.

The "example-project" combines theses examples in one setup. Here you can see that 
resource dependencies play an important role.

To work through these examples you need to install OpenStack command line clients as described here:

http://docs.openstack.org/user-guide/content/install_clients.html

Or you can build your own environment using the "gettingStarted" template. This template is prepared to 
be used as a copy&paste file that you can use within the openstack dashboard. The only needed Parameter
is "key_name", where you insert the name of your public SSH key.
