#!/bin/bash
# 2016 j.peschke@syseleven.de

# this script relies on a working consul cluster service.
# information from this cluster service is used to create/update
# our inventory file and trigger install events.

PATH=$PATH:/usr/local/bin/

# wait for a valid network configuration
until ping -c 1 syseleven.de; do sleep 5; done

ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''

export DEBIAN_FRONTEND=noninteractive

# get internal ipv4 ip
internalIP=$(curl 169.254.169.254/latest/meta-data/local-ipv4)

# configure consul to serve a fancy ui on internal network
cat <<EOF> /etc/consul.d/consul.json
{
  "datacenter": "cbk1",
  "data_dir": "/tmp/consul",
  "server": true,
  "ui": true,
  "bootstrap_expect": 3,
  "enable_script_checks": true,
  "addresses" : {
    "http": "${internalIP}" 
  }
}
EOF

cat <<EOF> /etc/consul.d/consul-ui.json
{
  "service": {
    "name": "consul-ui",
    "port": 80,
    "tags": ["consul", "webui"],
    "check": {
      "script": "curl -s ${internalIP}:8500/ui/ > /dev/null",
      "interval": "10s"
    }
  }
}
EOF

# we changed consul http listen address; so a restart is needed
systemctl restart consul

echo "finished deployment host setup"
