FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -fr /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/nginx.conf

COPY tools/init.sh /init.sh
RUN comod +x /init.sh

EXPOSE 433

ENTRYPOINT ["/init.sh"]

