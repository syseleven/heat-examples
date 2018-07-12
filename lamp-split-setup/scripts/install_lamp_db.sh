#!/bin/bash
# 2018 d.schwabe@syseleven.de

# some generic stuff that is the same on any cluster member

# wait for a valid network configuration
until ping -c 1 syseleven.de; do sleep 5; done

# install necessary services
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" pwgen haveged wget mysql-server 

# creating a database
rootpass=$(pwgen 16 1)
customerpass=$(pwgen 16 1)
/usr/bin/mysqladmin -u root password "$customerpass"

cat <<EOF> /root/.my.cnf
[client]
user = root
password = ${customerpass} 
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

create_motd(){
echo ''
echo ''
echo '  Welcome to SysEleven Stack'
echo ''
echo '            /\'
echo '          /\\//\'
echo '        /\\//\\//\'
echo '        \//\\//\\/'
echo '        /\\//\\/'
echo '        \//\\/'
echo '          \/'
echo '     engage.build.run'
echo ''
echo ''
echo 'For documentation please visit'
echo 'https://doc.syselevenstack.com/'
echo ''
echo 'DB-Name: syseleven'
echo 'DB-User: syseleven'
echo 'DB-Server: localhost'
echo "DB-Password: ${customerpass}"
echo ''
echo ''
}

create_motd > /etc/motd

cat <<EOF> /home/syseleven/dbcredentials

DB-Name: syseleven
DB-User: syseleven
DB-Server: localhost
DB-Password: ${customerpass}

EOF

chmod 400 /home/syseleven/dbcredentials
chown syseleven: /home/syseleven/dbcredentials

echo "Finished LAMP DB server setup"