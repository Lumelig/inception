#!/bin/bash

mkdir -p /etc/nginx/ssl

if [ ! -f "/etc/nginx/ssl/nginx.crt" ]; then
openssl req -x509 -nodes \        # Create a self-signed certificate without password protection
-out /etc/nginx/ssl/nginx.crt \   # Output certificate file
-keyout /etc/nginx/ssl/nginx.key \  # Output private key file
-subj "/CN=${DOMAIN_NAME}" \  # Certificate identity info
-days 365                         # Valid for 365 days
fi
exec nginx -g "daemon off;"

#Without daemon off:
#Start → background → container exits

#With daemon off:
#Start → foreground → container keeps running