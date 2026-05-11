#!/bin/bash

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo ">>> First time init"

    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    mysqld --user=mysql &
    MYSQLD_PID=$!

    until mysqladmin ping --silent; do
        echo "hello"
        sleep 1
    done

    mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    kill $MYSQLD_PID
    wait $MYSQLD_PID
fi

exec mysqld --user=mysql