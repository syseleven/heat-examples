# single Server from Snapshot

This exmaple shows how to launch a single server from an instance or volume snapshot that was created previously.

---
## Create a Snapshot
Create a reference snapshot. 

### Instance Snapshots
the running instance that you want to use as reference:

```
openstack server image create --name <MyInstanceSnapshotName> jumphost-kickstart
```

### Volume Snapshots
or a snapshot of the reference volume if you used a volume as root disk for an instance:
**To create proper volume snapshots the instance should be to be shut off.**

```
openstack volume snapshot create --name <MyVolumeSnapshotName> jumphost-kickstart
+-------------+--------------------------------------+
| Field       | Value                                |
+-------------+--------------------------------------+
| created_at  | 2018-05-02T13:12:24.596134           |
| description | None                                 |
| id          | a06bb744-3b2e-4700-aee7-6e7973d2ec53 |
| name        | <MyVolumeSnapshotName>               |
| properties  |                                      |
| size        | 300                                  |
| status      | creating                             |
| updated_at  | None                                 |
| volume_id   | 1fc8e1bf-69a6-468a-b64f-d296a9872ae0 |
+-------------+--------------------------------------+
```

## Get snapshot ID
Search for the unique ID of the snapshot.

### Instance Snapshots
````
openstack image list --private
+--------------------------------------+--------------------------+--------+
| ID                                   | Name                     | Status |
+--------------------------------------+--------------------------+--------+
| 21484215-7679-4673-9093-5d3a4f77a2ab | <MyInstanceSnapshotName> | active |
+--------------------------------------+--------------------------+--------+
````

### Volume Snapshots
````
openstack volume snapshot list
+--------------------------------------+------------------------+-------------+-----------+------+
| ID                                   | Name                   | Description | Status    | Size |
+--------------------------------------+------------------------+-------------+-----------+------+
| a06bb744-3b2e-4700-aee7-6e7973d2ec53 | <MyVolumeSnapshotName> | None        | available |  300 |
+--------------------------------------+------------------------+-------------+-----------+------+
````

This id can be inserted as a parameter to the main stack file.
To keep things comfortable, just put this id into the environment file:

````
~/heat-examples/singleServerWithFixedIP$ cat example-env.yaml
parameters:
  fixed_ip: 09391788-1db2-4495-9c50-3ff0c363988b
````

With that done, you can start your template as usual:

````
openstack stack create -t example.yaml -e example-env.yaml --parameter key_name=<keyName> <stackName>
````

After successful stack creation you can login with
```
ssh -l ubuntu <externalIP>
```
