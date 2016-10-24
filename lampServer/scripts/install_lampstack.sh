#!/bin/bash
# 2016 j.peschke@syseleven.de

# some generic stuff that is the same on any cluster member

# wait for a valid network configuration
until ping -c 1 syseleven.de; do sleep 5; done

# install necessary services
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" composer pwgen haveged unzip wget jq git apache2 libapache2-mod-php mysql-server php7.0 php7.0-mysql php7.0-curl php7.0-intl php7.0-mbstring php7.0-xml 

phpenmod  mbstring xml intl curl mysqli mysqlnd 
systemctl restart apache2

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
mysql < /root/createDB.sql

cat <<EOF> /etc/motd

  Welcome to SysEleven Stack

	    /\
	  /\\//\
        /\\//\\//\
        \//\\//\\/
        /\\//\\/
        \//\\/
          \/

     engage.build.run
            
For documentation please visit
https://doc.syselevenstack.com/

DB-Name: syseleven
DB-User: syseleven
DB-Server: localhost
DB-Password: ${customerpass}

EOF

cat <<EOF> /home/syseleven/dbcredentials

DB-Name: syseleven
DB-User: syseleven
DB-Server: localhost
DB-Password: ${customerpass}

EOF

chmod 400 /home/syseleven/dbcredentials
chown syseleven: /home/syseleven/dbcredentials

echo "finished generic lamp setup"

