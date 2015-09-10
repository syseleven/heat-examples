#!/bin/bash
# 2015 j.peschke@syseleven.de

# wait for a valid network configuration
until ping -c 1 syseleven.de; do sleep 5; done

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" nginx avahi-daemon avahi-utils git wget bc unzip screen curl haveged memcached

mv /etc/nginx/nginx_template.conf /etc/nginx/nginx.conf
rm /etc/nginx/sites-enabled/default

sed -i s'/127.0.0.1/0.0.0.0/'g /etc/memcached.conf

service memcached restart
service nginx restart
service avahi-daemon restart

/usr/local/sbin/update_lb

echo "* * * * * root /usr/local/sbin/update_lb >> /var/log/lb.log" > /etc/cron.d/lbupdate

