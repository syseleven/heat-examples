# Autoscaling using heat and prometheus

This example contains heat code that will demonstrate autoscaling with heat. 

This template starts one appservers and a prometheus server. The prometheus server has one alert that triggers the upscaling of the appserver group. 

The prometheus server requires openstack credentials to auto generate server inventory. 

You can create a stack with the following command:

openstack stack create -t clustersetup.yaml -e clustersetup-env.yaml  mystack --wait --parameter os_username=$OS_USERNAME --parameter os_password=$OS_PASSWORD --parameter os_tenant_id=$OS_PROJECT_ID
