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
apt-get install -y php5-fpm php5-cli php5-memcached

ln -s /etc/nginx/sites-available/syseleven.conf /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

mkdir -p /var/www/nginx/html
echo  '<?php phpinfo(); ?>' > /var/www/nginx/html/info.php

sessionstore=$(avahi-browse _session._tcp --resolve -p -t  |awk -F';'  '/^=;eth0;IPv4/{print $8}' | sort -n)

sed -i 's/session.save_handler = files/session.save_handler = memcached/g' /etc/php5/fpm/php.ini
sed -i "s#;session.save_path = \"/var/lib/php5\"#session.save_path = 'tcp://$sessionstore:11211'#g" /etc/php5/fpm/php.ini


# nginx + fpm version:
service php5-fpm restart
service nginx restart
service avahi-daemon restart

logger "finished appserver installation"
