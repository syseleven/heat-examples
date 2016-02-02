#!/bin/sh
# wait for a valid network configuration
until ping -c 1 syseleven.de; do sleep 5; done

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install avahi-daemon avahi-utils haveged git curl screen bc wget xfsprogs nfs-kernel-server -y

mkdir -p /mnt/nfs
while [ ! -e /dev/vdb ]
do
  echo "Waiting for volume to attach"
  sleep 10
done
if mountpoint -q "/mnt/nfs"
then
  echo "nfs is mounted"
else
  mount -t xfs /dev/vdb /mnt/nfs
fi
if [ $? -eq 0 ]
then
  echo "Already Formatted Volume. Mounted"
else
  /sbin/mkfs.xfs /dev/vdb
  mount -t xfs /dev/vdb /mnt/nfs/
  echo "RAW Volume. Formatted and mounted"
fi
if grep -q "/mnt/nfs 10.10.10.0/24(rw,no_root_squash)" "/etc/exports"
then
  echo "File path is part of exports"
else
  echo "/mnt/nfs 10.10.10.0/24(rw,no_root_squash)" >> /etc/exports
  echo "restart server"
  service nfs-kernel-server restart
fi
echo "Volume mounted and shared"
