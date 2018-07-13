# LAMP Scalable Setup

## Overview

Using this simple template you launch an scalable LAMP setup on the SysEleven Stack where you can deploy and run you PHP-Application.
It launches APP servers with a webserver, PHP, caching and a separate database server.

## Usage

### Launch stack

* Clone the git repository containing this heat example
`git clone https://github.com/syseleven/heat-examples.git`

* Write your SSH key into the parameter section
`vim heat-examples/lamp-scalable-setup/example.yaml`
```yaml
parameters:
  public_network:
    type: string
    default: ext-net 
  ssh_keys:
    type: comma_delimited_list
    description: This parameter contains a comma separated list of ssh keys to be injected into all instances.
    default: 
      - 'ssh-rsa <SSH KEY CONTENT> user@host'
      - 'ssh-rsa <SSH KEY CONTENT> user@host'
```

* Launch the stack via CLI  
`openstack stack create -t heat-examples/lamp-scalable-setup/example.yaml <stackName>`
* Assign security group to LoadBalancer port. Please have a look at the OUTPUT section of the stack for instructions. 
The OUTPUT section of the stack also reveals the IP address of the database server for further usage.  
**You can get the the relevant output field including resource IDs using this command:**  
`openstack stack show <stackName> -f value -c outputs`

### SSH Login

**Information**  
If you need to login via SSH to any host please create and associate a floating IP via CLI/GUI to any of the APP servers.
The default security group rules allow ssh connection to the APP server from the outsite.  

* Retrieve the port IDs of the app server:  
```shell
$ openstack port list -f value -c Name -c ID | grep -i 'app server port'

app server port 0355e415-d313-4cc4-b906-9ee5598798ac
app server port 38c75742-e431-4a6f-a6c7-1ec18a80f000
```
* Create and associate a floating IP to one of the app servers:   
`$ openstack floating ip create --port <PORT ID> <EXTERNAL NETWORK>"`
```shell
$ openstack floating ip create --port 0355e415-d313-4cc4-b906-9ee5598798ac ext-net

+---------------------+--------------------------------------+
| Field               | Value                                |
+---------------------+--------------------------------------+
| created_at          | 2018-07-13T14:37:28Z                 |
| description         |                                      |
| dns_domain          | None                                 |
| dns_name            | None                                 |
| fixed_ip_address    | 10.0.0.10                            |
| floating_ip_address | 195.192.128.251                      |
| floating_network_id | 8bb661f5-76b9-45f1-9ef9-eeffcd025fe4 |
| id                  | 0be91549-4bbe-4d4d-a65c-16488e8303ba |
| name                | 195.192.128.251                      |
| port_id             | 0355e415-d313-4cc4-b906-9ee5598798ac |
| project_id          | de03fc96931c4b2ba4bf946115a60b6e     |
| qos_policy_id       | None                                 |
| revision_number     | 1                                    |
| router_id           | 7fa952ee-0b1d-4be1-b23f-b204f3d93e0a |
| status              | ACTIVE                               |
| subnet_id           | None                                 |
| tags                | []                                   |
| updated_at          | 2018-07-13T14:37:28Z                 |
+---------------------+--------------------------------------+
```

* Open a terminal of your choice and log in to any app instance via ssh with the username `syseleven`:  
`$ ssh syseleven@<floating IP> -A -i ~/.ssh/< private ssh key >`
* You should now be logged in your instance via SSH  

#### SSH Login to other app server and the database server
* You can only login to the app server with the floating IP via SSH, the other app server and 
database server do not require a public IP.

* Once connected the appserver you can jump to the database server:  
`$ ssh syseleven@<database server IP>`

### Final tests

**APP Server**
In the background, the web server and database server is being installed.  

We can check the progress with the following command:  
```shell
watch 'openstack console log show' "<SERVER NAME>" '| tail -n 40'
watch 'openstack console log show' "app0" '| tail -n 40'
```

This template deploys a simple PHP application. Once the initial installation
is done you can test the webserver by opening its floating IP in you browser.

You could place any PHP application to `/var/www/html` and test it.

## Final note
This example only covers the deployment of the infrastructure. 
The application can be automated in various ways.





