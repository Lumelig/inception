#!/bin/bash

mkdir -p /etc/nginx/ssl

if [ ! -f "/etc/nginx/ssl/nginx.crt" ]; then
openssl req -x509 -nodes \
-out /etc/nginx/ssl/nginx.crt \
-keyout /etc/nginx/ssl/nginx.key \
-subj "/CN=${DOMAIN_NAME}" \
-days 365                         
exec nginx -g "daemon off;"

#Without daemon off:
#Start → background → container exits

#With daemon off:
#Start → foreground → container keeps running