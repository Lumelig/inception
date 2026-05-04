This project has been created as part of the 42 curriculum by jpflegha

# 📦 Inception 📦

## Description
Inception is a system administration project from 42 School that introduces containerization using Docker and Docker Compose. The goal is to set up a small, multi-service infrastructure entirely inside a virtual machine, where each service runs in its own dedicated container.
The project involves building and connecting three core services:

- **NGINX** — acts as the only entry point (reverse proxy) with TLS/SSL
- **WordPress** — the web application (with php-fpm)
- **MariaDB** — the database backend

All containers are built from custom Dockerfiles (based on Alpine or Debian) — no pre-built images from Docker Hub are allowed (except the base OS).

### 🐳 Why Docker?

Docker allows us to package each service with all its dependencies into an isolated container. This makes the project reproducible, easy to configure, and cleanly separated — each service only does one thing.

Docker Compose is used to define, link, and run all containers together from a single docker-compose.yml file.

### Key Desingn Comparisons
### 🖥️ Virtual Machine vs Docker
|     | Virtual Machine  | Docker Container   |
|:---------|:--------:|:----------:|
|**Isolation** | Full OS per VM  | Shares host OS kernel  |
|**Size** | GBs  | MBs |
|**Startup** | Minutes  | Seconds |
|**Use case** | Full system emulation | Isolated app/service|

In this project, Docker containers are used for each service, while the entire project itself runs inside a VM — combining both worlds.

### 🔐 Secrets vs Environment Variables
|    |Secrets  | Environment Varables |
|:--------|:-------|:---------|
|**Storage** | Stored in files, injected securely at runtime | stored in .env files or shell |
|**Security** | Not exposed in `docker inspect` or logs | Can be leaked via inspection or logs |
|**Use case** | Passwords, credenttials | Non-sensitive config(ports, usernames) |

This project uses **Docker secrets** for sensitive data (e.g., database passwords) to avoid exposing credentials in plain text. Less sensitive values use environment variables passed via `.env`.
```
secrets/
├── db_password.txt
├── db_root_password.txt
└── credentials.txt
```

### 🌐 Docker Network vs Host Network
|    | Docker Network | Host Network |
|:-----|:-------|:---------|
|**Security** | Services only talk to each other via dfined rules | All host ports exposed directly |
|**Isolation** | Containers get their own virtual network | Container shares the host networ stack |
|**Use case** | Multi-container apps | Low-latency single-container tool|

Inception uses a **custom Docker bridge network** so that containers can communicate with each other by name (e.g., `wordpress` can reach `mariadb`), while staying isolated from the outside world. **NGINX** is the only service exposed to the host.

### 💾 Docker Volumes vs Bind Mounts

|  | Docker Volumes | Bind Mounts |
|:----|:----|:----|
|**Managed by**| Docker | Host |
|**Portability** | High - works on any machine | Low - depens on host path |
|**Location** | `var/lib/docker/volumes/` | Any path on the host machine|
|**Use case**| Presistent data (DB,file) | Develoment/live code editing |

This project uses Docker volumes to persist data for MariaDB and WordPress files.
This ensures data survives container restarts and keeps the setup clean and portable.

---

## Instructions:
### Requirements
Make sure you have installed:
- **Docker**
- **Docker Compose**

if you use a distor without GUI, you maybe also install:
- **w3m**
makes a html in the terminal, readable.

### Installation
Clone  the repository and go into the folder:

```bash
git clone https://github.com/Lumelig/inception.git
cd inception
```

### Setup
Befor running the project, you need to:
- **Configure a .env file withe the enviroment variables (there is a example.env with the empty variables)**
- **Creat the `db_password.txt`, `db_root_passowrd.txt` and `crededentials.txt` files and set the ppasswords**
- **Make sure the required ports are available**
- **Check path for volumes**

### 📝 File Contents
- `secrets/db_password.txt` - Password for the WordPress database user
- `secrets/db_root_password.txt` - Root password for MariaDB
- `secrets/credentials.txt` - WordPress admin credentials


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

If you want to use w3m, for the website:
```
w3m -o ssl_verify_server=0 https://localhost:443
```
You can change the `localhost` with your `DOMAIN_NAME` from your .env file.


### Notes
- **Data is stored using Docker volumes to keep it persistent**
- **Containers are automatically connected through a custem network**


### Resources 
- **[Docker Docuentation](https://docs.docker.com/)**
- **[Docker Compose Documentation](https://docs.docker.com/compose/)**
- **[NGINX Documentation](https://nginx.org/en/docs/)**
- **[WordPPress CLI Docuemtation](https://wp-cli.org/)**
- **[MAriaDB Documentation](https://mariadb.com/kb/en/)**




