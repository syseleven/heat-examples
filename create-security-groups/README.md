# Maintain Security Groups with Heat

These templates show some use cases where security groups are maintained with heat. These use cases cover the following scenarios:

* A development environment, only accessible from your office IP (range).

Template: singleMachineDevEnv.yaml

* A production environment. Public access to port 80 and port 443, access to port 22 (SSH) only from specified IP address/ range.

Template: singleMachineProdEnv.yaml

These templates are simplified examples; it should be a good idea to build them as parameters in your stack-templates.  
All these examples have in common that they create security groups and assign them to specified ports.

If you are only interested in how to create a security group you can assign later (for example starting VMs using the web interface) you can have a look at
the securityGroup.yaml example which only creates a security group.

