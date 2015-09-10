#!/bin/bash

set -x
env
HOME="/root"
USER="root"

# wait for a valid network configuration
until ping -c 1 syseleven.de; do sleep 5; done

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" postgresql avahi-daemon git wget bc unzip screen curl pwgen haveged

mypass=$(pwgen 16 1)

#sed -i "s/SECRET/$mypass/"g /root/.my.cnf

# change listen address
echo "listen_addresses = '0.0.0.0'" >> /etc/postgresql/9.3/main/postgresql.conf
sed -i "s#127.0.0.1/32#192.168.2.0/24#"g /etc/postgresql/9.3/main/pg_hba.conf
service postgresql restart
service avahi-daemon restart

su -c "psql -d template1 -c \"CREATE USER syseleven WITH PASSWORD 'syseleven_pass'\"" postgres
su -c "psql -d template1 -c \"CREATE DATABASE syseleven\"" postgres
su -c "psql -d template1 -c \"GRANT ALL PRIVILEGES ON DATABASE syseleven to syseleven\"" postgres


