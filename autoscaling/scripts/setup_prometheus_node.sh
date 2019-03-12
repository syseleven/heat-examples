#!/bin/bash
set -e

grep prometheus /etc/passwd > /dev/null || useradd -d /opt/prometheus -m prometheus

cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v0.17.0/node_exporter-0.17.0.linux-amd64.tar.gz

tar xzf node_exporter-0.17.0.linux-amd64.tar.gz

mv node_exporter-0.17.0.linux-amd64/node_exporter /opt/prometheus/

cat <<EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target


[Service]
User=prometheus
Type=simple
ExecStart=/opt/prometheus/node_exporter

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

systemctl enable node_exporter
systemctl start node_exporter

