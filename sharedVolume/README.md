# Shared volume example
We will build two stacks: 
* a persistent volume
* a stack using the created volume as a shared storage via NFS

This way we can keep our data during several livetimes of an application stack. If you delete the first stack, the persistent volume will be destroyed. Be careful!

## Start volume stack first

```
openstack stack create -t persistent_volume.yaml volume_storage
```

## Get cinder volume ID

```
openstack volume list
```

## Paste Cinder volume ID to env.yaml i.e.

```
parameters:
  volume_id: e9639480-5dff-41ed-84a7-c734c46e8942
```

## Create NFS client/server stack
Don't forget to insert your SSH key

```
users:
    - name: syseleven
      gecos:  Workshop user
      lock-passwd: false
      sudo: ALL=(ALL) NOPASSWD:ALL
      shell: /bin/bash
      ssh-authorized-keys:
        - 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABA...
```

Create the stack with the following command

```
openstack stack create -t stack.yaml -e env.yaml demo_stack
```

