#!/bin/bash
# 2016 j.peschke@syseleven.de

# some generic stuff that is the same on any cluster member

# wait for a valid network configuration
until ping -c 1 syseleven.de; do sleep 5; done

# install necessary services
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" pwgen haveged unzip wget jq git apache2 libapache2-mod-php mysql-server php7.0  

# creating a database
rootpass=$(pwgen 16 1)
customerpass=$(pwgen 16 1)
/usr/bin/mysqladmin -u root password "$mypass"

cat <<EOF> /root/.my.cnf
[client]
user = root
password = ${mypass} 
host = localhost
EOF

cat <<EOF> /root/createDB.sql
CREATE DATABASE syseleven;
CREATE USER 'syseleven'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON syseleven.* TO 'syseleven'@'localhost';
FLUSH PRIVILEGES;
EOF

sed -i "s/password/${customerpass}/g" /root/createDB.sql

cat <<EOF> /etc/motd

DB-Name: syseleven
DB-User: syseleven
DB-Server: localhost
DB-Password: ${customerpass}

EOF


mysql < /root/createDB.sql

# basic deployment of any app
rm /var/www/html/*
git clone https://gitlab.syseleven.de/j.peschke/anyapp.git /var/www/html/
curl "https://raw.githubusercontent.com/syseleven/heattemplates-examples/master/lampServer/exampleApp/index.php" > /var/www/html/index.php

echo "finished generic lamp setup"

