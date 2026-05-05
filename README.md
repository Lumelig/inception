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

Docker Compose is used to define, link, and run all containers together from a single `docker-compose.yml` file.

### Key Design Comparisons
### 🖥️ Virtual Machine vs Docker
|     | Virtual Machine  | Docker Container   |
|:---------|:--------:|:----------:|
|**Isolation** | Full OS per VM  | Shares host OS kernel  |
|**Size** | GBs  | MBs |
|**Startup** | Minutes  | Seconds |
|**Use case** | Full system emulation | Isolated app/service|

In this project, Docker containers are used for each service, while the entire project itself runs inside a VM — combining both worlds.

### 🔐 Secrets vs Environment Variables
|    |Secrets  | Environment Variables |
|:--------|:-------|:---------|
|**Storage** | Stored in files, injected securely at runtime | Stored in `.env` files or shell |
|**Security** | Not exposed in `docker inspect` or logs | Can be leaked via inspection or logs |
|**Use case** | Passwords, credentials | Non-sensitive config (ports, usernames) |

This project uses **Docker secrets** for sensitive data (e.g., database passwords) to avoid exposing credentials in plain text. Less sensitive values use environment variables passed via `.env`.

### 🌐 Docker Network vs Host Network
|    | Docker Network | Host Network |
|:-----|:-------|:---------|
|**Security** | Services only talk to each other via defined rules | All host ports exposed directly |
|**Isolation** | Containers get their own virtual network | Container shares the host network stack |
|**Use case** | Multi-container apps | Low-latency single-container tools |

Inception uses a **custom Docker bridge network** so that containers can communicate with each other by name (e.g., `wordpress` can reach `mariadb`), while staying isolated from the outside world. **NGINX** is the only service exposed to the host.

---

## Instructions
### Requirements
Make sure you have installed:
- **Docker**
- **Docker Compose**

If you use a distro without a GUI, you may also want to install:
- **w3m** — renders HTML in the terminal, making it readable.

### Installation
Clone the repository and go into the folder:

```bash
git clone https://github.com/Lumelig/inception.git
cd inception
```

### Setup
Before running the project, you need to:
- **Configure a `.env` file with the environment variables** (there is an `example.env` with the empty variables)
- **Make sure the required ports are available**
- **Check the path for volumes**

### Execution
Build and start the containers:
```bash
make
```
### All other commands:
Stop containers:
```bash
make down
```
Stop containers and remove the images:
```bash
make clean
```
Stop and remove volumes and network settings:
```bash
make fclean
```
Stop, remove and start again:
```bash
make re
```

# Show the logs:
```bash
make logs <docker_name>
```

### Notes
- **Data is stored using Docker volumes to keep it persistent**
- **Containers are automatically connected through a custom network**

---

## Resources

- [Virtual Machines vs Docker](https://www.docker.com/resources/what-container/)
- [Secrets vs Environment Variables](https://docs.docker.com/engine/swarm/secrets/)
- [Docker Network vs Host Network](https://docs.docker.com/network/)
- [Docker Volumes vs Bind Mounts](https://docs.docker.com/storage/volumes/)

> **Tip:** To test via terminal without a GUI:
> ```bash
> w3m -o ssl_verify_server=0 https://localhost:443
> ```