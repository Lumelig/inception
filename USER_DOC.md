# User Guide — Inception

## What does this project run?

The Inception project starts three services:

| Service | What it does | Where to find it |
|---------|-------------|---------------|
| **WordPress** | Your website | `https://pflegha.42.fr` |
| **WordPress Admin** | Admin dashboard | `https://jpflegha.42.fr/wp-admin` |
| **MariaDB** | Database (internal only) | — |

Only port 443 (HTTPS) is open. All traffic goes through NGINX.

---

## How to start and stop the project

### Start
```bash
make
```
Builds and starts all containers in the background.

### Stop (keep your data)
```bash
make stop
```
Stops and removes containers. Your data stays safe.

### Full reset (deletes everything)
```bash
make fclean
```
Removes all containers, images, volumes, and **all data** in `/home/$(USER)/data/`. The next `make up` starts from scratch.

### Rebuild
```bash
make re
```
Runs `fclean` and then `all`.

---

## How to open the website

### Before you start

Check that `$(USER).42.fr` points to localhost in your `/etc/hosts` file:
```bash
grep $(USER) /etc/hosts
# you should see: 127.0.0.1 $(USER).42.fr
```

If it's not there:
```bash
sudo nano /etc/hosts
# Add this line:
127.0.0.1 $(USER).42.fr
# Save with Ctrl+X → Y → Enter
```

### Open the website
Go to:
```
https://$(USER).42.fr
```
Your browser will warn you about the certificate. This is normal, for a self-signed certificate.
 click **Advanced** → **Accept Risk and Continue**

### How to open the admin panel

```bash
https://$(USER).42.fr/wp-admin
```

---

## Credentials

All credentials are stored in the `secrets/` folder at the root of the repository. This folder is **gitignored** and must be created manually on each machine.

| File | Used for |
|------|----------|
| `secrets/db_password.txt` | WordPress database user password |
| `secrets/db_root_password.txt` | MariaDB root password |
| `secrets/credentials.txt` | WordPress admin password |

### WordPress accounts

| Role | Username | Password source |
|------|----------|-----------------|
| Administrator | `$(USER)` | `secrets/credentials.txt` |
| Author | `wp_editor` | `secrets/credentials.txt` |

---

## Checking that services 

### Status check
```bash
docker ps
```
If all three containers (`mariadb`, `wordpress`, `nginx`) Show `Up`. Everything is fine.

### logs
```bash
make logs
```
---
### Individual docker logs
```bash
docker logs src-mariadb-1
docker logs src-wordpress-1
docker logs src-nginx-1
```

### Check volumes exist and contain data
```bash
docker volume ls
docker volume inspect src_wordpress
```
The `Mountpoint` field should show a path under `/home/$(USER)/data/`.

### Make sure MariaDB is reachable
```bash
 docker exec -it src-mariadb-1 mariadb -u wp_user -p wordpress
# Enter the password from secrets/db_password.txt 
SHOW TABLES;
```