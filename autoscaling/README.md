
This repository contains heat code examples that will demonstrate autoscaling with heat. 

This template starts a consul cluster, some appservers and a prometheus server. The prometheus servers has one alert that triggers the autoscaling of the appserver group. 

The consul cluster requires openstack credentials

You can create a stack with the following command:

openstack stack create -t topology.yaml  -e env.yaml -e env_secrets.yaml  mystack --wait --parameter os_username=$OS_USERNAME --parameter os_password=$OS_PASSWORD --parameter os_tenant_id=$OS_PROJECT_ID
