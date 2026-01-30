#!/bin/bash
set -e

NFS_SERVER="10.0.1.10"
MOUNT_DIR="/var/www/html"
DB_NAME="wordpress"
DB_USER="wpuser"
DB_PASS="SuperPassword123"
DB_HOST="10.0.2.10"

apt update -y
apt install -y apache2 php php-mysql php-fpm php-xml php-gd php-curl php-mbstring php-zip nfs-common


systemctl stop apache2

mkdir -p ${MOUNT_DIR}
mount -t nfs ${NFS_SERVER}:${MOUNT_DIR} ${MOUNT_DIR}


echo "${NFS_SERVER}:${MOUNT_DIR} ${MOUNT_DIR} nfs defaults 0 0" >> /etc/fstab


cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz


rsync -av wordpress/ ${MOUNT_DIR}/
chown -R www-data:www-data ${MOUNT_DIR}


cp ${MOUNT_DIR}/wp-config-sample.php ${MOUNT_DIR}/wp-config.php

sed -i "s/database_name_here/${DB_NAME}/" ${MOUNT_DIR}/wp-config.php
sed -i "s/username_here/${DB_USER}/" ${MOUNT_DIR}/wp-config.php
sed -i "s/password_here/${DB_PASS}/" ${MOUNT_DIR}/wp-config.php
sed -i "s/localhost/${DB_HOST}/" ${MOUNT_DIR}/wp-config.php


systemctl start apache2
systemctl enable apache2

echo "[+] Frontend WordPress listo"
