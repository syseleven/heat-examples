#!/bin/bash
# 2015 j.peschke@syseleven.de

# wait for a valid network configuration
until ping -c 1 syseleven.de; do sleep 1; done

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" nginx memcached

# generate a upstream-template used by consul-template
cat <<EOF> /opt/consul-http-upstreams.ctpl
upstream syseleven-appserver  {
  least_conn;
  {{range service "appserver"}}server {{.Address}}:{{.Port}} max_fails=3 fail_timeout=60 weight=1;
  {{else}}server 127.0.0.1:65535; # force a 502{{end}}
}
upstream syseleven-consul-ui  {
  least_conn;
  {{range service "consul-ui"}}server {{.Address}}:8500 max_fails=3 fail_timeout=60 weight=1;
  {{else}}server 127.0.0.1:65535; # force a 502{{end}}
}
EOF

# configure and run consul-template for nginx:

cat <<EOF> /etc/systemd/system/consultemplate-upstreams.service
[Unit]
Description=consul-template for nginx upstreams
Requires=network-online.target
After=network-online.target

[Service]
User=root
EnvironmentFile=-/etc/default/consul-template
Environment=GOMAXPROCS=2
Restart=on-failure
ExecStart=/usr/local/sbin/consul-template -template "/opt/consul-http-upstreams.ctpl:/etc/nginx/upstream.conf:service nginx restart"
ExecReload=/bin/kill -HUP \$MAINPID
KillSignal=SIGINT

[Install]
WantedBy=multi-user.target
EOF

systemctl enable consultemplate-upstreams
systemctl restart consultemplate-upstreams


#until pgrep -f 'consul-template -template /opt/consul-http-upstreams.ctpl:/etc/nginx/upstream.conf:service nginx restart'; do 
#	consul-template -template "/opt/consul-http-upstreams.ctpl:/etc/nginx/upstream.conf:service nginx restart" >> /var/log/consul-template.log & sleep 2; 
#done


# create a default nginx vhost
cat <<EOF> /etc/nginx/sites-enabled/default
    server {
        listen          80 default_server;
        server_name     _;
        access_log	/var/log/nginx/defaultsite.log proxy;

        error_page 502 /errorpage.html;
        location = /errorpage.html {
            root  /var/www/;
        }

        location        / {
            proxy_pass      http://syseleven-appserver;
        }
    }
    server {
        listen          8080 default_server;
        server_name     _;
        access_log	/var/log/nginx/consului.log proxy;

        error_page 502 /errorpage.html;
        location = /errorpage.html {
            root  /var/www/;
        }

        location        / {
            proxy_pass      http://syseleven-consul-ui;
        }
    }
EOF

# configure core nginx 
cat <<EOF> /etc/nginx/nginx.conf
user www-data;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';

    log_format proxy '[\$time_local] Cache: \$upstream_cache_status '
                     '\$upstream_addr \$upstream_response_time \$status '
                     '\$bytes_sent \$proxy_add_x_forwarded_for \$request_uri';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    include /etc/nginx/upstream.conf;
    include /etc/nginx/sites-enabled/*;
}
EOF

# set memcache to listen global and act as a session store
sed -i s'/127.0.0.1/0.0.0.0/'g /etc/memcached.conf

systemctl restart memcached
systemctl restart nginx


