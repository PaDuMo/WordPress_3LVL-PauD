#!/bin/bash
set -e

EXPORT_DIR="/var/www/html"
CIDR="10.0.0.0/24"

apt update -y
apt install -y nfs-kernel-server


mkdir -p ${EXPORT_DIR}
chown -R www-data:www-data ${EXPORT_DIR}


echo "${EXPORT_DIR} ${CIDR}(rw,sync,no_subtree_check)" >> /etc/exports
exportfs -ra

systemctl enable nfs-server
systemctl restart nfs-server



