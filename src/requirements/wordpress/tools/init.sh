#!/bin/bash

DB_PASSWORD=$(cat /run/secrets/db_password)
mkdir -p /var/www/html
chown -R www-data:www-data /var/www/html

if[ ! f "/var/html/wp-config.php" ]; then
    wp config create \
    --dbname=${MYSQL_DATABASE} \
    --dbuser=${MYSQL_USER} \
    --dbpass=${DB_PASSWORD} \
    --dbhost=mariadb \
    --path=/var/www/html \
    --allow-root
#Notice --dbhost=mariadb — this is the service name from docker-compose.yml. 
#Docker's internal DNS resolves container names, so WordPress can reach MariaDB just by using its service name.
    wp user creat \
    ${WP_USER} ${WP_USER_EMAIL} \
    --role=author \
    --user_pass=${DB_PASSWORD} \
    --path=/var/www/html \
    --allow-root 
    chown -R www-data:www-data /var/www/html
#Fix ownership again after all files were created — wp-cli may have created files as root. 
fi

exec php-fpm8.2 -F
#TODO maybe change version
