#!/bin/bash
# 2019 j.peschke@syseleven.de

# wait for a valid network configuration
echo "# Waiting for valid network configuration"
until ping -c 1 syseleven.de; do sleep 1; done

echo "# Install dependencies"
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" memcached

# consul service check to promote and check session-service
cat <<EOF> /etc/consul.d/sessionstore.json
{
  "service": {
    "name": "sessionstore",
    "port": 11211,
    "tags": ["sessionstore", "memcache"],
    "check": {
      "script": "echo stats | nc localhost 11211 > /dev/null",
      "interval": "2s"
    }
  }
}
EOF


# set memcache to listen globally
sed -i s'/127.0.0.1/0.0.0.0/'g /etc/memcached.conf

systemctl restart memcached
systemctl restart consul 


