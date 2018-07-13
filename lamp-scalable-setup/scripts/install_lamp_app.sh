#!/bin/bash
# 2018 d.schwabe@syseleven.de

# some generic stuff that is the same on any cluster member

# wait for a valid network configuration
until ping -c 1 syseleven.de; do sleep 5; done

# install necessary services
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" composer pwgen haveged unzip wget jq git apache2 libapache2-mod-php php7.0 php7.0-mysql php7.0-curl php7.0-intl php7.0-mbstring php7.0-xml php7.0-gd php7.0-zip 

phpenmod mbstring xml intl curl mysqli mysqlnd

# disable unneeded apache modules
a2dismod autoindex deflate status localized-error-pages serve-cgi-bin  
a2enmod rewrite
systemctl restart apache2

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
echo 'Webroot: /var/www/html/'
echo 'Web-User: www-data'
echo ''
echo ''
}

create_motd > /etc/motd

echo "Finished LAMP APP server setup"