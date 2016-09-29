#!/bin/bash
# 2016 j.peschke@syseleven.de

# some generic stuff that is the same on any cluster member

# wait for a valid network configuration
until ping -c 1 syseleven.de; do sleep 5; done

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" haveged unzip wget jq git apache2 libapache2-mod-php mysql-server php7.0  

echo "finished generic lamp setup"

