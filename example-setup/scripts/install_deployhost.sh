#!/bin/bash
# 2016 j.peschke@syseleven.de
# 2017 d.schwabe@syseleven.de

# this script relies on a working consul cluster service.
# information from this cluster service is used to create/update
# our inventory file and trigger install events.

PATH=$PATH:/usr/local/bin/
<<<<<<< HEAD
MASTERTOKEN=$1
AGENTTOKEN=$2
=======
>>>>>>> master

# wait for a valid network configuration
echo "# Waiting for valid network configuration"
until ping -c 1 syseleven.de; do sleep 5; done

# ssh key for lsyncd - to be implemented
#ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''

export DEBIAN_FRONTEND=noninteractive

# get internal ipv4 ip
internalIP=$(curl -s 169.254.169.254/latest/meta-data/local-ipv4)

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

<<<<<<< HEAD
# test availability of consul service API
echo "# Waiting for consul leader election"
until leader=$(curl -s http://127.0.0.1:8500/v1/status/leader) && [ -n "$leader" ] && [ "$leader" != \"\" ]; do sleep 3; done

# allow anonymous consul node read
echo "# Allow anonymous consul node read"
curl \
    -s \
    --request PUT \
    --header "X-Consul-Token: $MASTERTOKEN" \
    --data \
'{
  "ID": "anonymous",
  "Type": "client",
  "Rules": "node \"\" { policy = \"read\" }"
}' http://127.0.0.1:8500/v1/acl/update

# create agent token
echo "# Create agent token"
curl \
    -s \
    --request PUT \
    --header "X-Consul-Token: $MASTERTOKEN" \
    --data \
'{
  "ID": "'${AGENTTOKEN}'",
  "Name": "Agent Token",
  "Type": "client",
  "Rules": "node \"\" { policy = \"write\" } service \"\" { policy = \"write\" }"
}' http://127.0.0.1:8500/v1/acl/create


#########################################################
#### other ACL examples #################################
######################################################### 
# # create ACLs for keys value store
# echo "# Create ACLs for keys value store"
# curl \
#     -s \
#     --request PUT \
#     --header "X-Consul-Token: $MASTERTOKEN" \
#     --data \
# '{
#   "Name": "my-keyvs-token",
#   "Type": "client",
#   "Rules": "key \"\" { policy = \"read\" } key \"foo/\" { policy = \"write\" } key \"foo/private/\" { policy = \"deny\" } operator = \"read\""
# }' http://127.0.0.1:8500/v1/acl/create

# # create ACLs for keys value store
# echo "# Create ACLs for service registration"
# curl \
#     -s \
#     --request PUT \
#     --header "X-Consul-Token: $MASTERTOKEN" \
#     --data \
# '{
#   "Name": "services-token",
#   "Type": "client",
#   "Rules": "service \"\" { policy = \"read\" } service \"consul-ui\" { policy = \"write\" } service \"dbserver\" { policy = \"write\" } service \"appserver\" { policy = \"write\" } operator = \"read\""
# }' http://127.0.0.1:8500/v1/acl/create

logger "# Finished deployment host setup"
echo "# Finished deployment host setup"


=======
# join configured in consul.json
until consul join 192.168.2.11 192.168.2.12 192.168.2.13; do sleep 2; done

echo "finished deployment host setup"
>>>>>>> master
