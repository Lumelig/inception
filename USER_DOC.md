# User Documentation — Inception

## What services does this stack provide?

The Inception stack runs three services:

| Service | Description | Accessible at |
|---------|-------------|---------------|
| **WordPress** | Full WordPress website with php-fpm | `https://chuhlig.42.fr` |
| **WordPress Admin** | Administration dashboard | `https://chuhlig.42.fr/wp-admin` |
| **MariaDB** | Database (internal only, not exposed to host) | — |

NGINX is the only entry point. Port 443 (HTTPS) is the only open port.

---

## Starting and stopping the project

### Start
```bash
make up
```
Builds images if needed and starts all containers in the background.

### Stop (keep data)
```bash
make down
```
Stops and removes containers and networks. Volumes and images are kept.

### Full reset (wipes everything)
```bash
make fclean
```
Removes all containers, images, volumes, networks, **and all data** from `/home/chuhlig/data/`. The next `make up` will start completely fresh.

### Rebuild
```bash
make re
```
Runs `fclean` followed by `up`.

---

## Accessing the website

### Prerequisites

Make sure `chuhlig.42.fr` resolves to localhost in `/etc/hosts`:
```bash
grep chuhlig /etc/hosts
# expected: 127.0.0.1 chuhlig.42.fr
```

If the entry is missing:
```bash
sudo nano /etc/hosts
add or update to 127.0.0.1 chuhlig.42.fr
Ctrl+X → Y → Enter safe update
or

```

### Website
Open your browser and go to:
```
https://chuhlig.42.fr
```
A browser warning about the self-signed certificate will appear. Click **Advanced** → **Accept Risk and Continue** (Firefox) or **Proceed** (Chrome).

### Administration Panel
```
https://chuhlig.42.fr/wp-admin
```

---

## Credentials

All credentials are stored in the `secrets/` folder at the root of the repository. This folder is **gitignored** and must be created manually on each machine.

| File | Used for |
|------|----------|
| `secrets/db_password.txt` | WordPress database user password |
| `secrets/db_root_password.txt` | MariaDB root password |
| `secrets/credentials.txt` | WordPress admin password |
| `secrets/wp_user_password.txt` | WordPress editor user password |

### WordPress accounts

| Role | Username | Password source |
|------|----------|-----------------|
| Administrator | `chuhlig` | `secrets/credentials.txt` |
| Author | `wp_editor` | `secrets/wp_user_password.txt` |

---

## Checking that services are running

### Quick status check
```bash
docker compose -f srcs/docker-compose.yml ps
```
All three containers (`mariadb`, `wordpress`, `nginx`) should show status `Up`.

### Live logs
```bash
make logs
```

### Individual container logs
```bash
docker logs mariadb
docker logs wordpress
docker logs nginx
```

### Check volumes exist and contain data
```bash
docker volume ls
docker volume inspect srcs_wordpress_db_volume
docker volume inspect srcs_wordpress_site_volume
```
The `Mountpoint` field should show a path under `/home/chuhlig/data/`.

### Check MariaDB is reachable
```bash
docker exec -it mariadb mariadb -u wp_user -p wordpress
# Enter the password from secrets/db_password.txt
SHOW TABLES;
```