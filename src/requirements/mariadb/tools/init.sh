#!/bin/bash
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
#This ensures the folder /run/mysqld exists, which MariaDB needs to store its socket file.
#Create the directory for the socket file and give ownership to the mysql user. Without this MariaDB can't start.

if [ ! -d "/var/lib/mysql/mysql" ]; then