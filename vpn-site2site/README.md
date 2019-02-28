# Site2Site VPN

This repository contains heat code examples that will build a multi region setup with including a site2site vpn.

You can start it as usual with a single sommand line:

```
 openstack stack create -t network-topology.yaml <stackName> --wait
```

The result will be a VPN-Service running in region CBK, a VPN-Service running in region DBL and one connecion connecting both services.

These services are built high available running as distributed objects in our software defined network.

Part of this example is also a simpel testserver per region you can login to (if you give your puzblic SSH-key as a parameter obviously). 
These VMs are only meant as a placeholder for your own infrastructure.


