# Multi server setup example

This heat file starts a stack with multiple servers. You can use it to
build a distributed application setup with a SQL-database master/slave repliation, 
a loadbalancer in front of <n> application servers and for example two 
elasticsearch nodes.

You can override some aspects of your stack in 

multiserver-env.yaml,

for example, you could increase the number of appservers to 10 if needed.

This template is configured to run an "init_script" if a node gets 
deployed. You could override this script as a parameter if it doesn't 
fit to your needs. Or you can just replace the default kickstart-repo 
with your own. This way you are able to use any deployment mechanism you 
want. 

If you decide to run this stack, you have to prepare some things:

1. You need a SSH public key already known to OpenStack. Just upload it if you
	did not yet.
2. You should provide a private deploy key if you want to access any
	repository via git.

Then you can start this stack-template using this command:

  'heat stack-create -f multiserver-stack.yaml -e multiserver-env.yaml -P key_name=<yourRealKeyName> -P deploy_key="$(cat ~/.ssh/cloud_deploykey)" <myFancyStackName>'


