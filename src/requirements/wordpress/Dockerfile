FROM debian:bookworm-slim

# Install php-fpm to run PHP, php-mysql to connect to MariaDB, curl to download wp-cli
RUN apt-get update && apt-get install -y \
    php-fpm \
    php-mysql \
    net-tools \
    curl \
    default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

# Download wp-cli, make it executable, and move it to a system-wide location
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Copy php-fpm pool config — adjust version if needed
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# Copy and enable the entrypoint script
COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

# Create the web root directory where WordPress files will live
RUN mkdir -p /var/www/html
WORKDIR /var/www/html

# php-fpm listens on port 9000 — NGINX connects here for PHP processing
EXPOSE 9000

# Run init script as PID 1
ENTRYPOINT ["/init.sh"]