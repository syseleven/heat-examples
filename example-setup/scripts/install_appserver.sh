#!/bin/bash
# 2016 j.peschke@syseleven.de

# wait for a valid network configuration
until ping -c 1 syseleven.de; do sleep 1; done

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y language-pack-en-base libapache2-mod-php7.0 php7.0 php7.0-mysql mysql-client php7.0-gd php7.0-curl apache2 php-memcached php-memcache php7.0-xml php7.0-mbstring php-apcu php7.0-zip

# in ubuntu some php modules behave strange
phpenmod php7.0-mysql

# configure apache vhost
cat <<EOF> /etc/apache2/sites-enabled/000-default.conf
<VirtualHost *:80>
	ServerName shopware.syseleven.de
	ServerAdmin admin@syseleven.de
	DocumentRoot /var/www/html
	ErrorLog /var/log/apache2/error.log
	CustomLog /var/log/apache2/access.log combined
	<Directory /var/www/html>
		AllowOverride All
	</Directory>
</VirtualHost>
EOF

a2enmod rewrite
service apache2 restart

# implement consul health check
cat <<EOF> /etc/consul.d/appserver_health.json
{
  "service": {
    "name": "appserver",
    "port": 80,
    "tags": ["apache2", "appserver"],
    "check": {
      "script": "curl -s localhost > /dev/null",
      "interval": "10s"
    }
  }
}
EOF

systemctl restart consul 

logger "finished appserver installation"

