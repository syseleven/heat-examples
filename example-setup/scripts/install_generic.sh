#!/bin/bash
# 2016 j.peschke@syseleven.de
# 2017 d.schwabe@syseleven.de

# some generic stuff that is the same on any cluster member
MASTERTOKEN=$1

# wait for a valid network configuration
until ping -c 1 syseleven.de; do sleep 5; done

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" curl haveged unzip wget jq git dnsmasq dnsutils uuid-runtime

# add a user for consul
adduser --quiet --shell /bin/sh --no-create-home --disabled-password --disabled-login --home /var/lib/misc --gecos "Consul system user" consul 

# install consul
consulversion=1.0.2
consultemplateversion=0.19.4

wget https://releases.hashicorp.com/consul/${consulversion}/consul_${consulversion}_linux_amd64.zip
unzip consul_${consulversion}_linux_amd64.zip
mv consul /usr/local/sbin/
rm consul_${consulversion}_linux_amd64.zip
mkdir -p /etc/consul.d

# install consul template
wget https://releases.hashicorp.com/consul-template/${consultemplateversion}/consul-template_${consultemplateversion}_linux_amd64.zip
unzip consul-template_${consultemplateversion}_linux_amd64.zip
mv consul-template /usr/local/sbin/
rm consul-template_${consultemplateversion}_linux_amd64.zip

# select three defined nodes as server, any other host will be in consul agent mode
if [ "$(hostname -s)" == "db0" ] || [ "$(hostname -s)" == "lb0" ] || [ "$(hostname -s)" == "servicehost0" ]; then 
cat <<EOF> /etc/consul.d/consul.json
{
  "datacenter": "cbk1",
  "data_dir": "/tmp/consul",
  "bootstrap_expect": 3,
  "server": true,
  "enable_script_checks": true,
  "disable_remote_exec": true,
  "start_join": ["192.168.2.11", "192.168.2.12", "192.168.2.13"]
}
EOF

cat <<EOF> /etc/consul.d/aclmaster.json
{
  "acl_datacenter": "cbk1",
  "acl_default_policy": "allow",
  "acl_down_policy": "allow",
  "acl_master_token": "$MASTERTOKEN"
}
EOF

else 
cat <<EOF> /etc/consul.d/consul.json
{
  "datacenter": "cbk1",
  "data_dir": "/tmp/consul",
  "server": false,
  "enable_script_checks": true,
  "disable_remote_exec": true,
  "start_join": ["192.168.2.11", "192.168.2.12", "192.168.2.13"]
}
EOF

cat <<EOF> /etc/consul.d/aclmaster.json
{
  "acl_datacenter": "cbk1",
  "acl_default_policy": "allow",
  "acl_down_policy": "allow"
}
EOF

fi


# ACL Example that can be set via API/Webinterface if required
# key "" {
#   policy = "read"
# }
# key "lock/" {
#   policy = "write"
# }
# key "cronsul/" {
#   policy = "write"
# }
# service "" {
#   policy = "write"
# }


cat <<EOF> /etc/systemd/system/consul.service
[Unit]
Description=consul agent
Requires=network-online.target
After=network-online.target

[Service]
User=consul
EnvironmentFile=-/etc/default/consul
Environment=GOMAXPROCS=2
Restart=on-failure
ExecStart=/usr/local/sbin/consul agent \$OPTIONS -config-dir=/etc/consul.d
ExecReload=/bin/kill -HUP \$MAINPID
KillSignal=SIGINT

[Install]
WantedBy=multi-user.target
EOF

systemctl enable consul
systemctl restart consul

# join configured in consul.json
until consul join 192.168.2.11 192.168.2.12 192.168.2.13; do sleep 2; done

# setup dnsmasq to communicate via consul
echo "server=/consul./127.0.0.1#8600" > /etc/dnsmasq.d/10-consul
systemctl restart dnsmasq

echo "finished generic core setup"


