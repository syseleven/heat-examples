#!/bin/bash

# 2016 j.peschke@syseleven.de

# wait for a valid network configuration
until ping -c 1 syseleven.de; do sleep 1; done

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y mysql-server

# implement consul health check
cat <<EOF> /etc/consul.d/dbserver_health.json
{
  "service": {
    "name": "dbserver",
    "port": 80,
    "tags": ["mysql", "database"],
    "check": {
      "script": "ps aux |grep mysql > /dev/null",
      "interval": "10s"
    }
  }
}
EOF

systemctl restart consul 

logger "finished dbserver installation"

