# LAMP Scalable Setup

## Overview

Using this simple template you launch an scalable LAMP setup on the SysEleven Stack where you can deploy and run you PHP-Application.
It launches APP servers with a webserver, PHP, caching and a separate database server.

## Usage

### Launch stack


### SSH Login

* Retrieve the floating IP of any app server:  
`$ openstack server list`

* Open a terminal of your choice and log in to any app instance via ssh with the username `syseleven`:  
`$ ssh syseleven@<floating IP> -A -i ~/.ssh/< private ssh key >`
* You should now be logged in your instance via SSH  

#### SSH Login to the database server
You can only login to the app server via SSH, the database server does not require a public IP. Once connected the appserver you can jump to the database server:  
`$ ssh syseleven@<database server IP>`

### Final tests

**APP Server**
In the background, the web server and a up-to-date PHP version is being installed.  
You can check the progress with the following command: `tail -f /var/log/cloud-init-output.log`

This template deploys a simple PHP application. Once the initial installation
is done you can test the webserver by opening its floating IP in you browser.

You can now place any PHP application to `/var/www/html` and test it.

**DB Server**
In the background the database server is being installed.  
We can check the progress with the following command: `tail -f /var/log/cloud-init-output.log`




