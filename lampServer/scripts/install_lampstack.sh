#!/bin/bash
# 2016 j.peschke@syseleven.de

# some generic stuff that is the same on any cluster member

# wait for a valid network configuration
until ping -c 1 syseleven.de; do sleep 5; done

# install necessary services
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" haveged unzip wget jq git apache2 libapache2-mod-php mysql-server php7.0  

# basic deployment of any app
rm /var/www/html/*
git clone https://gitlab.syseleven.de/j.peschke/anyapp.git /var/www/html/
curl "https://raw.githubusercontent.com/syseleven/heattemplates-examples/master/lampServer/exampleApp/index.php > /var/www/html/index.php

echo "finished generic lamp setup"

