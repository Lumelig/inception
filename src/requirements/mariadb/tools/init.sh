#!/bin/bash
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)


# Using mysql command to check for database existence
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    echo ">>> First time init — creating database and user..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null
    mysqld --user=mysql --skip-networking &
    until mysqladmin ping --silent 2>/dev/null; do
        sleep 1
    done
    mysqld --user=mysql --bootstrap <<EOF
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF
    mysqladmin -u root -p${DB_ROOT_PASSWORD} shutdown
    echo ">>> Init done!"
else
    echo ">>> Database already exists, skipping init"
fi

exec mysqld --user=mysql