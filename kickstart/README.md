# Kickstart

## Getting started

This template can be used to deploy a single server with every CLI-Clients you need to start working with the SysEleven Stack. It is meant as an alternative to install OpenStack Clients by hand on
your local machine, which is documented [here](https://docs.syseleven.de/syseleven-stack/en/howtos/openstack-cli).

Prerequisites:

- You need a valid SSH public key that you can import as described [here](https://docs.syseleven.de/syseleven-stack/en/howtos/ssh-keys)


### Launch the heat template

- Navigate to Orchestration --> Stacks --> Launch Stack to start a template.
- Select "URL" in the Template Source select box.
- Paste the URL of the template into Template URL: `https://raw.githubusercontent.com/syseleven/heat-examples/master/kickstart/kickstart.yaml`
- Don't change the field "Environment Source" and click "Next".
- Write "kickstart" into the field "Stackname".
- Write the name of the public SSH-Key as parameter "key_name"  
- Now click "Launch".

After a couple of seconds you should see a new machine spawning under --> "Compute" --> "Instances".  
Copy the IP address from "Floating IPs" and you should be ready to login via SSH.

```shell
ssh syseleven@< Floating IP > -A
```

The home directory has a prepared ["openrc" file](https://docs.syseleven.de/syseleven-stack/en/tutorials/api-access#setting-up-the-environment-variables),
which allows you to work with openstack endpoints. The required values can be found under [Project --> Access and Security --> API Access](https://dashboard.cloud.syseleven.net/horizon/project/access_and_security/?tab=access_security_tabs__api_access_tab) --> View Credentials.

Open it with a text editor of your choice.

```shell
syseleven@kickstart:~$ vim openrc
```

You just need to adjust `OS_PROJECT_ID`, `OS_USERNAME` and `OS_PASSWORD` to the actual values.
To be able to use the command line tools just source the environment variables:

```shell
source openrc
```

Now you are ready to deploy any template from this repository or any other heat template.
As a quick test we can list our currently running machines:

```shell
syselevenstack@kickstart:~$ openstack server list
+--------------------------------------+-----------+--------+--------------------------------------------+
| ID                                   | Name      | Status | Networks                                   |
+--------------------------------------+-----------+--------+--------------------------------------------+
| a54d0883-988b-4730-a533-2c91fc66c518 | kickstart | ACTIVE | kickstart-net=10.0.0.10, < Floating IP >   |
+--------------------------------------+-----------+--------+--------------------------------------------+
```

