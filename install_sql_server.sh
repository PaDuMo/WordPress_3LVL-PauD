#!/bin/bash
set -e

DB_NAME="wordpress"
DB_USER="wpuser"
DB_PASS="SuperPassword123"
DB_BIND="0.0.0.0"


apt update -y && apt upgrade -y


apt install -y mysql-server


sed -i "s/^bind-address.*/bind-address = ${DB_BIND}/" /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql


mysql -e "CREATE DATABASE ${DB_NAME} DEFAULT CHARACTER SET utf8mb4;"
mysql -e "CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';"
mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';"
mysql -e "FLUSH PRIVILEGES;"



