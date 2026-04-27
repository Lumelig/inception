#!/bin/bash
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
#This ensures the folder /run/mysqld exists, which MariaDB needs to store its socket file.
#Create the directory for the socket file and give ownership to the mysql user. Without this MariaDB can't start.

#This check prevents re-initializing every time
if [ ! -d "/var/lib/mysql/mysql" ]; then
mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null
DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
mysqld --user=mysql --bootstrap <<EOF
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF
fi 

exec mysqld --user=mysql