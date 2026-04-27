FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y mariadb-server \
    && rm -fr /var/lib/apt/lists/*
# rm -fr /var/lib/apt/lists/* Deletes cached package lists after installation. Keeps the image smaller and cleaner.

COPY conf/my.cnf /etc/mysql/conf.d/my.cnf
COPY tools/init.sh /init.sh
RUN chmod +x /init.sh
EXPOSE 3306
# mariadb defaul port This doesn't actually open the port — Docker Compose handles that.
ENTRYPOINT ["init.sh"]
#Run init script as PID 1 when the container starts. Use the exec form (square brackets) — this makes the script PID 1 directly, which is required.
