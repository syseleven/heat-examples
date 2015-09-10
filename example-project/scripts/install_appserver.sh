#!/bin/bash

# wait for a valid network configuration
until ping -c 1 syseleven.de; do sleep 5; done

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y avahi-daemon haveged git curl screen bc wget

# nginx version:
# install nginx
apt-get install -y nginx-extras
## install php-fpm
apt-get install -y php5-fpm php5-cli

ln -s /etc/nginx/sites-available/syseleven.conf /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

mkdir -p /var/www/nginx/html
echo  '<?php phpinfo(); ?>' > /var/www/nginx/html/info.php

# nginx + fpm version:
service php5-fpm restart
service nginx restart

logger "finished appserver installation"
