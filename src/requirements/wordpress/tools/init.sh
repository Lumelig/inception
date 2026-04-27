#!/bin/bash

DB_PASSWORD=$(cat /run/secrets/db_password)

echo "Waiting for MariaDB..."
while ! mysqladmin ping -h mariadb -u ${MYSQL_USER} -p${DB_PASSWORD} --silent 2>/dev/null; do
    sleep 1
done
echo "MariaDB is ready"

mkdir -p /var/www/html
chown -R www-data:www-data /var/www/html

if [ ! -f "/var/www/html/wp-config.php" ]; then

    wp core download \
        --path=/var/www/html \
        --allow-root

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
        --admin_password=$(cat /run/secrets/credentials) \
        --admin_email=${WP_ADMIN_EMAIL} \
        --path=/var/www/html \
        --allow-root

    wp user create \
        ${WP_USER} ${WP_USER_EMAIL} \
        --role=author \
        --user_pass=${DB_PASSWORD} \
        --path=/var/www/html \
        --allow-root

    chown -R www-data:www-data /var/www/html

fi

exec php-fpm8.2 -F
#TODO