# Single server from snapshot

This example shows how to launch a single server from an instance or volume snapshot that was created previously.

---

## Create a Snapshot

Create a reference snapshot.

### Instance Snapshots

the running instance that you want to use as reference:

```shell
$ openstack server image create --name <MyInstanceSnapshotName> <MyInstanceName>
+------------------+-----------------------------------------------------------------------------------------------------------+
| Field            | Value                                                                                                     |
+------------------+-----------------------------------------------------------------------------------------------------------+
| checksum         | None                                                                                                      |
| container_format | None                                                                                                      |
| created_at       | 2018-05-28T13:00:55Z                                                                                      |
| disk_format      | None                                                                                                      |
| file             | /v2/images/21484215-7679-4673-9093-5d3a4f77a2ab/file                                                      |
| id               | 21484215-7679-4673-9093-5d3a4f77a2ab                                                                      |
| min_disk         | 50                                                                                                        |
| min_ram          | 0                                                                                                         |
| name             | jumphostsnapshot                                                                                          |
| owner            | xxxxxxxx931c4gggggf946yyyyy                                                                               |
| properties       | base_image_ref='34faf858-f2e9-4656-93ac-fcc8371a9877', basename='Ubuntu Xenial 16.04 (2019-05-01) ...... '|
| protected        | False                                                                                                     |
| schema           | /v2/schemas/image                                                                                         |
| size             | None                                                                                                      |
| status           | queued                                                                                                    |
| tags             |                                                                                                           |
| updated_at       | 2018-05-28T13:00:55Z                                                                                      |
| virtual_size     | None                                                                                                      |
| visibility       | private                                                                                                   |
+------------------+-----------------------------------------------------------------------------------------------------------+
```

### Volume Snapshots

or a snapshot of the reference volume if you used a volume as root disk for an instance:
**To create proper volume snapshots the instance should be to be shut off.**

```shell
$ openstack volume snapshot create --volume <MyVolumeName> <MyVolumeSnapshotName>
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

```shell
$ openstack image list --private
+--------------------------------------+--------------------------+--------+
| ID                                   | Name                     | Status |
+--------------------------------------+--------------------------+--------+
| 21484215-7679-4673-9093-5d3a4f77a2ab | <MyInstanceSnapshotName> | active |
+--------------------------------------+--------------------------+--------+
```

### Volume Snapshots

```shell
$ openstack volume snapshot list
+--------------------------------------+------------------------+-------------+-----------+------+
| ID                                   | Name                   | Description | Status    | Size |
+--------------------------------------+------------------------+-------------+-----------+------+
| a06bb744-3b2e-4700-aee7-6e7973d2ec53 | <MyVolumeSnapshotName> | None        | available |  300 |
+--------------------------------------+------------------------+-------------+-----------+------+
```

## Launch instance from snapshot

This id can be inserted as a parameter to the main stack file.

### Configure heat template (optional)

To keep things comfortable, just put this ID into the environment file:

#### Image snapshot

```shell
~/heat-examples/singleServerFromSnapshot$ cat snapshot_image_example.yaml
parameters:
  image: 21484215-7679-4673-9093-5d3a4f77a2ab
```

#### Volume snapshot

```shell
~/heat-examples/singleServerFromSnapshot$ cat snapshot_volume_example.yaml
parameters:
  snapshot: a06bb744-3b2e-4700-aee7-6e7973d2ec53
```

### Create stack/instance

You don't need to provide the snapshot ID again if you configured the template file.

With that done, you can start your template as usual:

#### Launch an instance based on an image snapshot

```shell
openstack stack create -t snapshot_image_example.yaml --parameter key_name=<keyName> --parameter image=<Image ID> <stackName>
```

#### Launch an instance based on a volume snapshot

```shell
openstack stack create -t snapshot_volume_example.yaml --parameter key_name=<keyName> --parameter snapshot=<Snapshot ID> <stackName>
```

After successful stack creation you can login with (if you didn't configure any other username)

```shell
ssh -l ubuntu <externalIP>
```
