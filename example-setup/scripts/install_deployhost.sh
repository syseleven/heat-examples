#!/bin/bash
# 2016 j.peschke@syseleven.de
# 2017 d.schwabe@syseleven.de

# this script relies on a working consul cluster service.
# information from this cluster service is used to create/update
# our inventory file and trigger install events.

PATH=$PATH:/usr/local/bin/
MASTERTOKEN=$1

# wait for a valid network configuration
until ping -c 1 syseleven.de; do sleep 5; done

# ssh key for lsyncd - to be implemented
#ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''

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
  "disable_remote_exec": true,
  "start_join": ["192.168.2.11", "192.168.2.12", "192.168.2.13"],
  "addresses" : {
    "http": "${internalIP} 127.0.0.1" 
  }
}
EOF

cat <<EOF> /etc/consul.d/aclmaster.json
{
  "acl_datacenter": "cbk1",
  "acl_default_policy": "deny",
  "acl_down_policy": "extend-cache",
  "acl_master_token": "$MASTERTOKEN"
}
EOF


# Fix Script field
# 2017/12/14 12:16:59 [WARN] agent: check "service:consul-ui" has the 'script' field, which has been deprecated and replaced with the 'args' field. See https://www.consul.io/docs/agent/checks.html

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
