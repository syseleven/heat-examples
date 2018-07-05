#!/bin/bash

openstack image list --property name=private_coreos -f value | awk '{print $1}' | xargs openstack image delete

# download and unpack latest release
eval $(curl https://stable.release.core-os.net/amd64-usr/current/version.txt)
curl https://stable.release.core-os.net/amd64-usr/current/coreos_production_openstack_image.img.bz2 | bzcat > coreos_production_openstack_image.img

echo "Uploading image..."

# upload image
openstack image create private_coreos \
  --container-format bare \
  --disk-format qcow2 \
  --file coreos_production_openstack_image.img \
  --property "version=$COREOS_VERSION" \
  --private

# delete temporary files
rm coreos_production_openstack_image.img
