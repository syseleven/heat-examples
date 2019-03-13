#!/bin/bash

grep prometheus /etc/passwd || useradd  -d /opt/prometheus prometheus

cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v2.7.1/prometheus-2.7.1.linux-amd64.tar.gz

tar xzf prometheus-2.7.1.linux-amd64.tar.gz
rm -rf /opt/prometheus
mv prometheus-2.7.1.linux-amd64 /opt/prometheus

chown -R prometheus /opt/prometheus

cat <<EOF > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target


[Service]
User=prometheus
Type=simple
ExecStart=/opt/prometheus/prometheus --storage.tsdb.path=/opt/prometheus/data --web.console.templates=/opt/prometheus/consoles --web.console.libraries=/opt/prometheus/console_libraries --config.file=/opt/prometheus/prometheus.yml

[Install]
WantedBy=multi-user.target

EOF

cat <<EOF > /opt/prometheus/prometheus.yml
global:
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
  - static_configs:
    - targets:
       - 127.0.0.1:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  - rules.yml

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  - job_name: 'prometheus'

    static_configs:
    - targets: ['localhost:9090']

  - job_name: 'node_exporter-cbk'
    openstack_sd_configs:
      - identity_endpoint: https://api.cbk.cloud.syseleven.net:5000/v3
        username: $1
        project_id: $3
        domain_name: Default
        password: $2
        role: instance
        region: cbk
        port: 9100

    relabel_configs:
    - source_labels: [__meta_openstack_instance_name]
      target_label: node_name
    - source_labels: [__meta_openstack_instance_status]
      target_label: status
    - source_labels: [__meta_openstack_instance_id]
      target_label: openstack_id
    - source_labels: [__meta_openstack_tag_stackid]
      regex: $4
      action: keep

  - job_name: 'node_exporter-dbl'
    openstack_sd_configs:
      - identity_endpoint: https://api.cbk.cloud.syseleven.net:5000/v3
        username: $1
        project_id: $3
        domain_name: Default
        password: $2
        role: instance
        region: dbl
        port: 9100

    relabel_configs:
    - source_labels: [__meta_openstack_instance_name]
      target_label: node_name
    - source_labels: [__meta_openstack_instance_status]
      target_label: status
    - source_labels: [__meta_openstack_instance_id]
      target_label: openstack_id
    - source_labels: [__meta_openstack_tag_stackid]
      regex: $4
      action: keep

EOF

cat <<EOF > /opt/prometheus/rules.yml
groups:
  - name: load appserver
    rules:
    - alert: load
      expr: avg(node_load1{node_name="app"}) > 0.3
      for: 30s
      labels:
        severity: upscale
      annotations:
        summary: Example alert to trigger a heat upscaling

  - name: instance error
    rules:
    - alert: instance_error
      expr: node_load1{node_name="app", status="ERROR"}
      labels:
        severity: instance_error
      annotations:
        summary: Replace a server that is in error state
EOF

touch /opt/prometheus/rules.yml

systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus


##### Alertmanager

version=0.16.1

cd /tmp
wget https://github.com/prometheus/alertmanager/releases/download/v$version/alertmanager-$version.linux-amd64.tar.gz

tar -xzf alertmanager-$version.linux-amd64.tar.gz

mv alertmanager-$version.linux-amd64/alertmanager /opt/prometheus/
mv alertmanager-$version.linux-amd64/amtool /opt/prometheus/

cat <<EOF > /etc/systemd/system/prometheus_alertmanager.service
[Unit]
Description=Alertmanager
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Type=simple
ExecStart=/opt/prometheus/alertmanager --storage.path=/opt/prometheus/data  --config.file=/opt/prometheus/alertmanager.yml

[Install]
WantedBy=multi-user.target

EOF


cat <<EOF > /opt/prometheus/alertmanager.yml
global:
  resolve_timeout: 5m

route:
  group_by: ['alertname']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 15m
  receiver: 'web.hook'

receivers:
  - name: 'web.hook'
    webhook_configs:
    - url: 'http://127.0.0.1:5001/'
      send_resolved: true
EOF

chown prometheus /opt/prometheus/alertmanager
chown prometheus /opt/prometheus/alertmanager.yml
chown prometheus /opt/prometheus/amtool


cat <<EOF > /opt/prometheus/scale.sh
#!/bin/bash

set -e

scale_up_url="${5/sys11cloud.net/cloud.syseleven.net}"
scale_down_url="${6/sys11cloud.net/cloud.syseleven.net}"

export OS_AUTH_URL=https://keystone.cloud.syseleven.net:5000
export OS_PASSWORD=$2
export OS_USERNAME=$1
export OS_PROJECT_ID=$3

token=\$(openstack token issue -c id -f value)


if [[ "\$AMX_ALERT_1_LABEL_severity" == "upscale" ]]; then
    if [[ "\$AMX_ALERT_1_STATUS" == "firing" ]]; then
        echo "Start a new appserver"
        curl -s -H "X-Auth-Token: \$token" -X POST "\$scale_up_url"
    else
        echo "Delete an appserver"
        curl -s -H "X-Auth-Token: \$token" -X POST "\$scale_down_url"
    fi
fi


if [[ "\$AMX_ALERT_1_LABEL_severity" == "instance_error" ]] &&  [[ "\$AMX_ALERT_1_STATUS" == "firing" ]]; then

    echo "Start a new appserver"
	curl -s -H "X-Auth-Token: \$token" -X POST "\$scale_up_url"

	echo "Delete server in error state: \$AMX_ALERT_1_LABEL_openstack_id"
	openstack server delete \$AMX_ALERT_1_LABEL_openstack_id
fi


EOF

chown prometheus /opt/prometheus/scale.sh
chmod 500 /opt/prometheus/scale.sh

cat <<EOF > /etc/systemd/system/prometheus-am-executor.service 

[Unit]
Description=Webhook receiver
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Type=simple
ExecStart=/opt/prometheus/prometheus-am-executor -l 127.0.0.1:5001 -v /opt/prometheus/scale.sh

[Install]
WantedBy=multi-user.target

EOF


cd /opt/prometheus
wget https://github.com/thiagoalmeidasa/prometheus-am-executor/releases/download/v0.0.2/prometheus-am-executor
chmod +x prometheus-am-executor
chown prometheus:prometheus prometheus-am-executor

systemctl daemon-reload
systemctl enable prometheus_alertmanager.service
systemctl start prometheus_alertmanager.service
systemctl enable prometheus-am-executor.service
systemctl start prometheus-am-executor.service


