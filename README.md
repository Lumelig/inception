This project has been created as part of the 42 curriculum by jpflegha

# Inception

## Description
Inception is a system administration project from 42 School that introduces containerization using Docker and Docker Compose. The goal is to set up a small, multi-service infrastructure entirely inside a virtual machine, where each service runs in its own dedicated container.
The project involves building and connecting three core services:

NGINX — acts as the only entry point (reverse proxy) with TLS/SSL
WordPress — the web application (with php-fpm)
MariaDB — the database backend

All containers are built from custom Dockerfiles (based on Alpine or Debian) — no pre-built images from Docker Hub are allowed (except the base OS).

### Why Docker?

Docker allows us to package each service with all its dependencies into an isolated container. This makes the project reproducible, easy to configure, and cleanly separated — each service only does one thing.

Docker Compose is used to define, link, and run all containers together from a single docker-compose.yml file.

### Key Desingn Comparisons
### Virtual Machine vs Docker
|     | Virtual Machine  | Docker Container   |
|:---------|:--------:|----------:|
| Isolation     | Full OS per VM  | Shares host OS kernel  |
|Size | GBs  | MBs |
|Startup | Minutes  | Seconds |
|Use case | Full system emulation | Isolated app/service|

---

## Instructions:
### Requirements
Make sure you have installed:
** Docker
** Docker Compose

if you use a distor without GUI, you maybe also install:
** w3m
makes a html in the terminal, readable.

### Installation
Clone  the repository and go into the folder:

```bash
git clone https://github.com/Lumelig/inception.git
cd inception
```

### Setup
Befor running the project, you need to:
** Configure a .env file withe the enviroment variables (there is a example.env with the empty variables)
** Make sure the required ports are available
** Check path for volumes

### Execution
Build and start the containers:
```bash
make
```
all other commands:
```bash
#Stop containers:
make down

#Stop containers and remove the images
make clean

#Stop and Remove volumes and network settings
make fclean

#Stops, Removes and Start again
make re

#Shows the logs
make lage <docker_name>
```

### Notes
** Data is stored using Docker volumes to keep it persistent
** Containers are automatically connected through a custem network


## Resources 

Resources

Virtual Machines vs Docker
◦ Secrets vs Environment Variables
◦ Docker Network vs Host Network
◦ Docker Volumes vs Bind Mounts

w3m -o ssl_verify_server=0 https://localhost:443