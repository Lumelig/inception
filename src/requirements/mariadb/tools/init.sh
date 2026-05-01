#!/bin/bash
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

# Start mysqld temporarily for bootstrap
mysqld --user=mysql --skip-networking --bootstrap <<EOF
FLUSH PRIVILEGES;

# Check if the database exists
SET @db_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='${MYSQL_DATABASE}');
EOF

# Using mysql command to check for database existence
DB_EXISTS=$(mysql -u root -p"${DB_ROOT_PASSWORD}" -e "SHOW DATABASES LIKE '${MYSQL_DATABASE}';" | grep "${MYSQL_DATABASE}" || true)

if [ -z "$DB_EXISTS" ]; then
    echo ">>> First time init — creating database and user..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

    mysqld --user=mysql --bootstrap <<EOF
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF
    echo ">>> Init done!"
else
    echo ">>> Database already exists, skipping init"
fi

exec mysqld --user=mysql