#!/bin/bash

# Load env_file manually
set -a
source /etc/environment || true  # optional, if env vars are in container env
set +a

# Secrets
DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/credentials)
WP_USER_PASSWORD=$(cat /run/secrets/credentials)


until bash -c "echo >/dev/tcp/mariadb/3306" 2>/dev/null; do
    echo "Waiting for MariaDB..."
    sleep 1
done
echo "MariaDB is ready"
mkdir -p /var/www/html
chown -R www-data:www-data /var/www/html

if [ ! -f "/var/www/html/wp-config.php" ]; then

    wp core download \
        --path=/var/www/html \
        --allow-root
    echo "DEBUG: MYSQL_USER=$MYSQL_USER, MYSQL_DATABASE=$MYSQL_DATABASE, DB_PASSWORD=$DB_PASSWORD"
    wp config create \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${DB_PASSWORD} \
        --dbhost=mariadb \
        --path=/var/www/html \
        --allow-root

    wp core install \
        --url=https://${DOMAIN_NAME} \
        --title="Inception" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --skip-email \
        --path=/var/www/html \
        --allow-root

    wp user create \
        ${WP_USER} ${WP_USER_EMAIL} \
        --role=author \
        --user_pass=${WP_USER_PASSWORD} \
        --path=/var/www/html \
        --allow-root

    chown -R www-data:www-data /var/www/html

fi

exec php-fpm8.2 -F
#TODO