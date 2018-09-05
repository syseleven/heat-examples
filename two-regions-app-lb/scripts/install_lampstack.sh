#!/bin/bash
# 2016 j.peschke@syseleven.de

# some generic stuff that is the same on any cluster member

# wait for a valid network configuration
until ping -c 1 syseleven.de; do sleep 5; done

# install necessary services
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
composer pwgen haveged unzip wget jq git apache2 libapache2-mod-php \
php php-curl php-intl php-mbstring php-xml php-gd php-zip


cat <<EOF> /var/www/html/index.html

Backend: $(hostname)

EOF

echo "finished generic webserver setup"

