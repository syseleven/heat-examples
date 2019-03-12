#!/bin/bash


set -x
cd /tmp

CONSUL_VERSION="1.4.3"
CONSUL_TEMPLATE_VERSION="0.20.0"
curl --silent --remote-name https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip
curl --silent --remote-name https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_SHA256SUMS
curl --silent --remote-name https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_SHA256SUMS.sig

curl --silent --remote-name https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip
curl --silent --remote-name https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_SHA256SUMS
curl --silent --remote-name https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_SHA256SUMS.sig

unzip consul_${CONSUL_VERSION}_linux_amd64.zip
chown root:root consul
mv consul /usr/local/bin/
consul --version

unzip consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip
chown root:root consul-template
mv consul-template /usr/local/sbin/

consul -autocomplete-install
complete -C /usr/local/bin/consul consul

useradd --system --home /etc/consul.d --shell /bin/false consul
mkdir --parents /opt/consul
chown --recursive consul:consul /opt/consul

chown consul:consul /etc/sysconfig/consul

cat <<EOF >/etc/systemd/system/consul.service
[Unit]
Description="HashiCorp Consul - A service mesh solution"
Documentation=https://www.consul.io/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/consul.d/consul.hcl

[Service]
EnvironmentFile=/etc/sysconfig/consul
User=consul
Group=consul
ExecStart=/usr/local/bin/consul agent -config-dir=/etc/consul.d/
ExecReload=/usr/local/bin/consul reload
KillMode=process
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target

EOF


mkdir --parents /etc/consul.d

consulname="$(hostname)-$(cat /var/lib/cloud/data/instance-id)"

touch /etc/consul.d/server.json
cat > /etc/consul.d/consul.hcl <<EOF
datacenter = "dc1"
data_dir = "/opt/consul"
encrypt = "$1"
ui = true
enable_local_script_checks = true
node_name = "$consulname"
EOF


if [[ "$2" == "server" ]]; then
    echo server=true > /etc/consul.d/server.hcl
    echo "bootstrap_expect=$3" > /etc/consul.d/bootstrap.hcl
fi

chown --recursive consul:consul /etc/consul.d
chmod 640 /etc/consul.d/*


systemctl daemon-reload

systemctl enable consul
systemctl start consul

cat > /etc/systemd/resolved.conf <<EOF
[Resolve]
DNS=127.0.0.1
Domains=~consul

EOF

systemctl restart systemd-resolved

iptables -t nat -A OUTPUT -d localhost -p udp -m udp --dport 53 -j REDIRECT --to-ports 8600
iptables -t nat -A OUTPUT -d localhost -p tcp -m tcp --dport 53 -j REDIRECT --to-ports 8600
