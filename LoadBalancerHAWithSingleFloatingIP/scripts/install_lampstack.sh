#!/bin/bash
# 2016 j.peschke@syseleven.de

# some generic stuff that is the same on any cluster member

# wait for a valid network configuration
until ping -c 1 syseleven.de; do sleep 5; done

# install necessary services
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" composer pwgen haveged unzip wget jq git apache2 libapache2-mod-php mysql-server php7.0 php7.0-mysql php7.0-curl php7.0-intl php7.0-mbstring php7.0-xml php7.0-gd php7.0-zip
# Required to convert random files to random png pictures
apt-get install -y imagemagick 
apt-get install -y graphicsmagick-imagemagick-compat

phpenmod  mbstring xml intl curl mysqli mysqlnd 

# disable unneeded apache modules
a2dismod autoindex deflate status localized-error-pages serve-cgi-bin  
a2enmod rewrite
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


echo "Writing default webserver page."
hostname="$(hostname)"

cat <<EOF> /var/www/html/index.html
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>This is node $hostname.</title>
  <meta name="description" content="Node $hostname">
  <meta name="author" content="Syseleven Stack">

<div align="center">
<h1>This is node $hostname.</h1>
<h3>Showing some random generated pictures.</h3>
<img src="random1.png" alt="Random 1" style="width:1280px;720height:px;">
<img src="random2.png" alt="Random 1" style="width:1280px;720height:px;">
<img src="random3.png" alt="Random 1" style="width:1280px;720height:px;">
</div>

</head>
<body>
</body>
</html>
EOF

echo "Generate random png files for testing"
mx=1920;my=1080;head -c "$((3*mx*my))" /dev/urandom | convert -depth 8 -size "${mx}x${my}" RGB:- /var/www/html/random1.png
mx=1920;my=1080;head -c "$((3*mx*my))" /dev/urandom | convert -depth 8 -size "${mx}x${my}" RGB:- /var/www/html/random2.png
mx=1920;my=1080;head -c "$((3*mx*my))" /dev/urandom | convert -depth 8 -size "${mx}x${my}" RGB:- /var/www/html/random3.png

echo "finished generic lamp setup"

