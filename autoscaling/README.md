# Autoscaling using heat and prometheus

This example contains heat code that will demonstrate autoscaling and autohealing with heat.

This template starts one appservers and a prometheus server. The prometheus server has two alerts configured:

- Average load on the app server > 0.3
- An appserver is in error state

Both alerts start a new appserver to solve the problem. The cluster is scaled down if the average load is below 0.3 again. A instance in error state will be deleted.

The prometheus server requires openstack credentials to auto generate server inventory.

You can create a stack with the following command:

openstack stack create -t clustersetup.yaml -e clustersetup-env.yaml  mystack --wait --parameter os_username=$OS_USERNAME --parameter os_password=$OS_PASSWORD --parameter os_tenant_id=$OS_PROJECT_ID
