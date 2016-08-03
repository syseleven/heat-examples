#!/bin/bash

# wait for a valid network configuration
until ping -c 1 syseleven.de; do sleep 5; done

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y avahi-daemon avahi-utils haveged git curl screen bc wget

# nginx version:
# install nginx
apt-get install -y nginx-extras
## install php-fpm
apt-get install -y php7.0-fpm php7.0-cli php-memcached php7.0-pgsql

ln -s /etc/nginx/sites-available/syseleven.conf /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

mkdir -p /var/www/nginx/html
echo  '<?php phpinfo(); ?>' > /var/www/nginx/html/info.php


# nginx + fpm version:
systemctl restart php7.0-fpm
systemctl restart nginx
systemctl restart avahi-daemon

echo "* * * * * root /usr/local/sbin/update_sessionconfig >> /var/log/sessionconfig.log" > /etc/cron.d/update_sessionstore

logger "finished appserver installation"
