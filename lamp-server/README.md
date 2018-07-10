# LampServer

## Overview

Using this simple template you launch an lamp server on the SysEleven Stack where you can deploy and run you PHP-Application.

## Usage

### Launch stack

* Log in to the [SysEleven Stack Dashboard](https://dashboard.cloud.syseleven.net) using the username and password (API credentials) that were provided by SysEleven. 
* In order to launch the example stack using the dashboard go to "Project" --> "Orchestration" --> "Stacks".  
* Click the button "Launch Stack"
* Select "URL" as "Template Source"
* Copy the URL of the example code file `https://raw.githubusercontent.com/syseleven/heat-examples/master/lamp-server/example.yaml`
* Paste the copied URL into the field "Template URL"
* Select "File" as "Environment Source"  
* Click "Next"
* Write "lampserver" into the field "Stack Name"
* Write the name of your SSH key that you uploaded to the Horizon Dashboard
* Click on "Launch"  
* Verify that the stack status is "Create In Progress" or "Create Complete"  

### SSH Login

* Go to "Compute" --> "Instances" in order to retrieve the floating IP that is required to access the instance via SSH  
* Copy the floating IP from the example server  
* Open a terminal of your choice and log in to the instance via ssh with the username `syseleven`  
`$ ssh syseleven@<floating IP> -i ~/.ssh/< private ssh key >`
* You should now be logged in your instance via SSH  

### Final tests

* You can follow the installation progress:

    In the background, the web server, database server and a up-to-date PHP version is being installed.  
    We can check the progress with the following command: `tail -f /var/log/cloud-init-output.log`
    
* Furthermore you may test the webserver:

    This template deploys a simple PHP application.    
    You can now place any PHP application to `/var/www/html` and test it.
