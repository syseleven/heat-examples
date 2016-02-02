#!/bin/sh
# wait for a valid network configuration
until ping -c 1 syseleven.de; do sleep 5; done

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install avahi-daemon avahi-utils haveged git curl screen bc wget nfs-common -y
mkdir -p /mnt/nfs
echo "nfs-server0.local:/mnt/nfs    /mnt/nfs    nfs    users,noauto,rw  0  0" >> /etc/fstab
until rpcinfo -u nfs-server0.local nfs 3; do
        sleep 10
done
mount /mnt/nfs 
