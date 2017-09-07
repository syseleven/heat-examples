#!/bin/bash
# 2017 d.schwabe@syseleven.de

# Define variables below
# OpenStack Config variables
OS_USERNAME_V="<OS_USERNAME>"
OS_PROJECT_ID_V="<OS_PROJECT_ID>"
OS_PASSWORD_V="<OS_PASSWORD>"

# OpenStack Floating IP ID
FLOATING_IP_ID_V="<floating_ip_id>"


#localip="$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)"
keepalivedpassword="afni189afnasl1912e4kilodtj"
# hostnames are lowercase!
LB1="lb-server-a"
LB2="lb-server-b"
LB1IP="10.0.10.251"
LB2IP="10.0.10.252"
APP1IP="10.0.10.241"
APP2IP="10.0.10.242"

# some generic stuff that is the same on any cluster member
# wait for a valid network configuration
until ping -c 1 syseleven.de; do sleep 5; done

# write hostname to variable
HOSTNAME="$(hostname)"
# install necessary services
#export DEBIAN_FRONTEND=noninteractive

# Move IP association script to keepalived folder
#mv /home/syseleven/AssociateIP.yaml /etc/keepalived/

#################################

echo "Writing Config for keepalived..."
if [[ "$HOSTNAME" == "$LB1" ]]
then
cat <<EOF> /etc/keepalived/keepalived.conf
 vrrp_script httpcheckscript {
   script       "/etc/keepalived/httpcheckscript.sh"
   interval 5   # check every 5 seconds
   fall 2       # require 2 failures for KO
   #rise 2       # require 2 successes for OK
   weight 2
 }

vrrp_instance VI_1 {
    interface eth0
    state MASTER
    priority 200

    virtual_router_id 33
    unicast_src_ip $LB1IP
    unicast_peer {
        $LB2IP
    }

    authentication {
        auth_type PASS
        auth_pass $keepalivedpassword
    }

    track_script {
        httpcheckscript
    }

    notify_master /etc/keepalived/master.sh
}
EOF
cat <<EOF> /etc/keepalived/httpcheckscript.sh
# set the url to probe
url='http://$LB2IP:80'
# use curl to request headers (return sensitive default on timeout: "timeout 500"). Parse the result into an array (avoid settings IFS, instead use read)
read -ra result <<< \$(curl -Is --connect-timeout 3 "\${url}" || echo "timeout 500")
# status code is second element of array "result"
status=\${result[1]}
# if status code is greater than or equal to 400, then output a bounce message (replace this with any bounce script you like)
[ \$status -ge 400 ] && echo "bounce at \$url with \$status " && exit 1
[ \$status -lt 400 ] && echo "bounce at \$url with \$status " && exit 0
EOF
fi

if [[ "$HOSTNAME" == "$LB2" ]]
then
cat <<EOF> /etc/keepalived/keepalived.conf
 vrrp_script httpcheckscript {
   script       "/etc/keepalived/httpcheckscript.sh"
   interval 5   # check every 5 seconds
   fall 2       # require 2 failures for KO
   #rise 2       # require 2 successes for OK
   weight 2
 }

vrrp_instance VI_1 {
    interface eth0
    state BACKUP
    priority 100

    virtual_router_id 33
    unicast_src_ip $LB2IP
    unicast_peer {
        $LB1IP
    }

    authentication {
        auth_type PASS
        auth_pass $keepalivedpassword
    }

    track_script {
        httpcheckscript
    }

    notify_master /etc/keepalived/master.sh
}
EOF
cat <<EOF> /etc/keepalived/httpcheckscript.sh
# set the url to probe
url='http://$LB1IP:80'
# use curl to request headers (return sensitive default on timeout: "timeout 500"). Parse the result into an array (avoid settings IFS, instead use read)
read -ra result <<< \$(curl -Is --connect-timeout 3 "\${url}" || echo "timeout 500")
# status code is second element of array "result"
status=\${result[1]}
# if status code is greater than or equal to 400, then output a bounce message (replace this with any bounce script you like)
[ \$status -ge 400 ] && echo "bounce at \$url with \$status " && exit 1
[ \$status -lt 400 ] && echo "bounce at \$url with \$status " && exit 0
EOF
fi

# Escape character used here to write output correct.
# Script needs to contain a command that writes to a variable
cat <<EOF> /etc/keepalived/master.sh
#!/bin/bash
# This script will associate the specified floating IP to the local instance if it cannot reach the other instance after a specified amount of time.
# Paste local instance (server) id below.

server_id="<Enter local instance id here>"

# Paste the floating IP id below. This can be added before creating the stack or afterwards.
floating_ip_id=$FLOATING_IP_ID_V

# This following code will check if this instance got a floating ip assigned and stop sending the command once it was assigned.
HAS_FLOATING_IP="\$(curl -s curl http://169.254.169.254/latest/meta-data/public-ipv4/)"

if [ -z "\${HAS_FLOATING_IP}" ]; then
    n=0
    while [ \$n -lt 3 ]
    do
        source /etc/skel/openrc
        openstack stack update -t /etc/keepalived/AssociateIP.yaml --parameter "server_id=\$server_id" --parameter "floating_ip=\$floating_ip_id" ExampleStack_3_IP_Association & break
        n=$((n+1))
        sleep 3
    done
fi
EOF

chown syseleven:syseleven /etc/keepalived/httpcheckscript.sh
chmod +x /etc/keepalived/httpcheckscript.sh
chown syseleven:syseleven /etc/keepalived/master.sh
chmod +x /etc/keepalived/master.sh

systemctl restart keepalived
echo "Installing keepalived done."


echo "Writing config for haproxy..."
cat <<EOF>> /etc/haproxy/haproxy.cfg
frontend http
  bind *:80

  default_backend web-servers

  backend web-servers

    balance  roundrobin
    option   httpchk GET /
    option   httplog

    server app1 $APP1IP:80
    server app2 $APP2IP:80
EOF

sudo systemctl restart haproxy
echo "Installing haproxy done."


echo "Writing config for openstack client..."
cat <<EOF> /etc/skel/openrc
    # replace "demo_user", "demo_project_id" and "demo_password" by your corresponding credentials

    export OS_USERNAME=$OS_USERNAME_V
    export OS_PROJECT_ID=$OS_PROJECT_ID_V
    export OS_PASSWORD=$OS_PASSWORD_V

    # the following lines don't need to be changed
    export OS_AUTH_URL=https://api.cbk.cloud.syseleven.net:5000/v3
    export OS_IDENTITY_API_VERSION=3
    export OS_USER_DOMAIN_NAME="Default"
    export OS_INTERFACE=public
    export OS_ENDPOINT_TYPE=public
    export OS_REGION_NAME="cbk"

    # Don't leave a blank variable, unset it if it was empty
    if [ -z "\$OS_REGION_NAME" ]; then unset OS_REGION_NAME; fi
    if [ -z "\$OS_USER_DOMAIN_NAME" ]; then unset OS_USER_DOMAIN_NAME; fi
    unset OS_TENANT_ID
    unset OS_TENANT_NAME
EOF
chown root:root /etc/skel/openrc
chmod 0600 /etc/skel/openrc

echo "Writing config for openstack client done."

echo "Writing associateIP.yaml..."
cat <<EOF> /etc/keepalived/AssociateIP.yaml
heat_template_version: 2014-10-16

description: Associate a FIP to a server with Nova.

parameters:
  floating_ip:
    type: string
    default: $FLOATING_IP_ID_V
  server_id:
    type: string

resources:
  loadbalancer_floating_ip_1_association:
    type: OS::Nova::FloatingIPAssociation
    properties:
      floating_ip: { get_param: floating_ip }
      server_id: { get_param: server_id }
EOF
chown syseleven:syseleven /etc/keepalived/AssociateIP.yaml
chmod 0755 /etc/keepalived/AssociateIP.yaml

echo "Writing associateIP.yaml done."
