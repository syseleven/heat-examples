## Getting started 

This template can be used to deploy a single server with any CLI-Clients you 
need to start working with SysEleven Stack.
It is meant as an alternative to installing OpenStack Clients by hand on 
your local machine, which remains an option nevertheless.

Prerequisites:
You need to import a valid SSH public key.
This can be done under
--> Compute 
  --> Access & Security
    --> Key Pairs 
and weather import or create a fresh public key. You just have to remeber the given
key name.

### Launch the heat template

Navigate to 
--> Orchestration
  --> Stacks
    --> Launch Stack
Here you can select "Direct Input" as source and press "Next"
Fill in any stack name you like and a password (which is necessary but unused this time).
Then fill in the name of your imported public key and press "Launch"

After a couple of seconds you should see a new machine spawning under
--> Compute
 --> Instances
Copy the IP address from "Floating IPs" and you should be ready to login via SSH.

```ssh syselevenstack@77.247.XX.XX```

The home directory has a prepared "openrc" file, which allows you to work with the 
openstack endpoints:
```syselevenstack@kickstart:~$ ls
openrc```

Within this openrc file you just need to adjust tenant name, user name and user password.
After you changed these credentials, you have to source this file:
```source openrc```
Now you are ready to deploy any template from this repository or any other heat template.
As a quick test we can list our currently running machines:
```syselevenstack@kickstart:~$ nova list
+--------------------------------------+----------------+--------+------------+-------------+----------------------------------------+
| ID                                   | Name           | Status | Task State | Power State | Networks                               |
+--------------------------------------+----------------+--------+------------+-------------+----------------------------------------+
| a35fb8ed-3c8f-4cf1-a6d5-7fa1c6c57fcc | kickstart      | ACTIVE | -          | Running     | kickstart-net=10.0.0.11, 77.247.84.214 |
+--------------------------------------+----------------+--------+------------+-------------+----------------------------------------+```

