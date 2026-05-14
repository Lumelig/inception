#!/bin/bash

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

echo "MariaDB init.sh"
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

echo "Starting MariaDB..."
exec mysqld --user=mysql

# #!/bin/bash
# set -e

# # Verzeichnisse vorbereiten
# mkdir -p /run/mysqld
# chown -R mysql:mysql /run/mysqld
# chown -R mysql:mysql /var/lib/mysql

# # System-Tabellen installieren (macht nichts, wenn sie schon da sind)
# mysql_install_db --user=mysql --datadir=/var/lib/mysql --rpm

# # MariaDB im Hintergrund starten (ohne Netzwerk für die Config)
# mysqld --user=mysql --skip-networking &
# pid="$!"

# # Warten, bis MariaDB antwortet
# until mysqladmin ping --silent; do
#     sleep 1
# done

# # Die Logik: Wir versuchen uns mit dem neuen Root-Passwort einzuloggen.
# # Wenn das fehlschlägt (beim ersten Mal), nutzen wir den passwortlosen Zugang.
# DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
# DB_PASSWORD=$(cat /run/secrets/db_password)

# if mysql -u root -p"${DB_ROOT_PASSWORD}" -e "status" >/dev/null 2>&1; then
#     # Wenn wir hier landen, ist das Passwort schon gesetzt. 
#     # Wir nutzen das Passwort für die SQL-Befehle.
#     MYSQL_CONN="mysql -u root -p${DB_ROOT_PASSWORD}"
# else
#     # Wenn nicht, ist es der erste Start (kein Passwort).
#     MYSQL_CONN="mysql -u root"
# fi

# # Jetzt führen wir alles mit "IF NOT EXISTS" aus
# $MYSQL_CONN <<EOF
# CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
# CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
# GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
# ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
# FLUSH PRIVILEGES;
# EOF

# # Hintergrund-Prozess beenden
# kill "$pid"
# wait "$pid"

# # Finaler Start im Vordergrund
# echo "MariaDB starting..."
# exec mysqld --user=mysql