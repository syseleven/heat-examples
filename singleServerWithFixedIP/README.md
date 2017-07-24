
To use a fixed IP where you can be sure, that a special machine 
uses this special IP, you need to follow these steps:

First, create a floating ip which is not assigned to a running machine. 

````
openstack stack create -t reservedIP.yaml reserved-ips
````
You have now created your stack containing the IP.

Then you search for the unique ID of this object:

````
openstack ip floating list
````

This id can be inserted as a parameter to the main stack file.
To keep things comfortable, just put this id into the environment file:

````
c3@toolbox:~/heattemplates-examples/singleServerWithFixedIP$ cat example-env.yaml 
parameters:
  fixed_ip: 09391788-1db2-4495-9c50-3ff0c363988b
````

With that done, you can start your template as usual:

````
openstack stack create -t example.yaml -e example-env.yaml --parameter key_name=<keyName> <stackName>
````

 after successful stack creation you can login with 
 ssh -l ubuntu <externalIP> 
