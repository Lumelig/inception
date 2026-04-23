FROM debian:bookworm-slim
RUN apt-get update && apt-get install -t \
    php-fpm \
    php-mysql \
    curl \ 
    && rm -fr /var/lib/apt/list/*
#curl is needed to download wp-cli.
RUN curl -o https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
&& chmod +x wp-cli.phar \
&& mv wp-cli.phar /usr/local/bin/wp

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
#TODO maybe chaning version later
COPY tools/init.sh /init.sh
RUN chmod +x /init.sh
RUN mkdir -p /var/www/html
WORKDIR /var/www/html
#Create the directory where WordPress files will live and set it as the working directory. 
#This is what your named volume will mount into, and what NGINX will serve files from.

EXPOSE 9000
#Document that php-fpm listens on port 9000. NGINX will connect here to process PHP files.

ENTRYPOINT ["/init.sh"]
#Run your init script as PID 1 using exec form.
