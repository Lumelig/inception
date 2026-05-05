# Developer Documentation — Inception

## Environment setup from scratch

### Prerequisites

- A Linux VM running Debian (i used Alpine, without GUI)

### 1. Install Docker

```bash
sudo apt update && sudo apt install -y ca-certificates curl gnupg make

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker $USER
newgrp docker
```

### 2. Clone the repository

```bash
git clone git@github.com:cuhlig42/inception42.git inception
cd inception
```

### 3. Create secret files

These files are **gitignored** and must be created manually:

```bash
mkdir -p secrets
echo "your_db_password"        > secrets/db_password.txt
echo "your_db_root_password"   > secrets/db_root_password.txt
echo "your_wp_admin_password"  > secrets/credentials.txt
echo "your_wp_user_password"   > secrets/wp_user_password.txt
```

### 4. Create the `.env` file

```bash
cat > srcs/.env << EOF
DOMAIN_NAME=chuhlig.42.fr

MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
MYSQL_PASSWORD_FILE=/run/secrets/db_password
MYSQL_ROOT_PASSWORD_FILE=/run/secrets/db_root_password

WP_ADMIN_USER=chuhlig
WP_ADMIN_EMAIL=chuhlig@student.42.fr
WP_USER=wp_editor
WP_USER_EMAIL=wp_editor@student.42.fr
EOF
```

### 5. Configure hostname resolution

```bash
sudo nano /etc/hosts
add or update this line "127.0.0.1 chuhlig.42.fr"
Ctrl+X → Y → Enter safe update
```

---

## Building and launching with Make and Docker Compose

### Build and start all services
```bash
make up
```

This does the following:
1. Creates host data directories `~/data/db` and `~/data/wp` if they don't exist
2. Runs `docker compose -f srcs/docker-compose.yml up --build -d`
3. Docker Compose builds each image from its Dockerfile and starts the containers

### What happens on first boot

**MariaDB** (`srcs/requirements/mariadb/tools/init.sh`):
- Starts `mysqld` in background with `--skip-networking`
- Waits until the socket is ready
- Creates the database, application user, sets root password
- Kills the temporary instance, then `exec mysqld --user=mysql` as PID 1

**WordPress** (`srcs/requirements/wordpress/tools/setup.sh`):
- Downloads WordPress core files into the volume (if not already present)
- Waits for MariaDB to accept TCP connections on port 3306
- Runs `wp config create` to generate `wp-config.php`
- Runs `wp core install` — creates the admin user (`chuhlig`)
- Creates a second user (`wp_editor`, role: author)
- `exec php-fpm7.4 -F` as PID 1

**NGINX**:
- Starts directly as PID 1 with `nginx -g daemon off;`
- Serves HTTPS on port 443 with a self-signed TLS certificate
- Proxies PHP requests to `wordpress:9000` via FastCGI

---

## Container and volume management

### Useful commands

```bash
# Show running containers
docker compose -f srcs/docker-compose.yml ps

# Follow logs for all servidocker volume ls
docker volume inspect srcs_wordpress_db_volume
docker volume inspect srcs_wordpress_site_volumeces
make logs

# Open a shell in a container
make shell      # wordpress
make db-shell   # mariadb

# Stop containers (keep volumes and images)
make down

# Remove everything including data
make fclean
```

### Rebuilding a single service
```bash
docker compose -f srcs/docker-compose.yml build wordpress
docker compose -f srcs/docker-compose.yml up -d --no-deps wordpress
```

---

## Data storage and persistence

All persistent data is stored on the host under `$HOME/data/`:

| Path on host | Docker volume | Container path | Contents |
|---|---|---|---|
| `~/data/db` | `srcs_wordpress_db_volume` | `/var/lib/mysql` | MariaDB database files |
| `~/data/wp` | `srcs_wordpress_site_volume` | `/var/www/html` | WordPress files + uploads |

The volumes use `driver: local` with `driver_opts type: none, o: bind` — this is a named volume backed by a host directory (bind mount under the hood). This satisfies the project requirement of named volumes while keeping data at a predictable host location.


### Inspecting volumes

```bash
docker volume ls
docker volume inspect srcs_wordpress_db_volume
docker volume inspect srcs_wordpress_site_volume
```

The `Mountpoint` in the output points to the Docker internal storage path, but the actual data is at `~/data/db` and `~/data/wp` on the host.

---

## Project structure

```
.
├── Makefile
├── secrets/                  # gitignored — create manually
│   ├── credentials.txt
│   ├── db_password.txt
│   ├── db_root_password.txt
│   └── wp_user_password.txt
└── srcs/
    ├── .env                  # gitignored — create manually
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   |── conf/
        │   |   └── my.cnf   
        |   └── tools
        |       └── init.sh
        ├── nginx/
        │   ├── Dockerfile
        │   |── conf/
        │   |   └── nginx.conf  
        |   └── tools
        |       └── init.sh
        |   
        └── wordpress/
            │   ├── Dockerfile
            |── conf/
            |   └── www.conf 
            └── tools
                └── init.sh
```