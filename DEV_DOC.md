# DEV_DOC

## Purpose

This document explains how a developer can set up, build, run, and maintain this Inception project from scratch.

## 1) Environment setup from scratch

### Prerequisites

- Linux VM
- Docker Engine
- Docker Compose plugin
- Access to `/home/maanguit/data`

### Required project files

- `Makefile`
- `srcs/docker-compose.yml`
- `srcs/.env`
- `secrets/` files

### Secrets

Create these files in `secrets/` before first run:

```bash
openssl rand -base64 24 > secrets/db_root_password.txt
openssl rand -base64 24 > secrets/db_password.txt
openssl rand -base64 24 > secrets/ftp_password.txt
```

## 2) Build and launch using Makefile and Docker Compose

Build images:

```bash
make build
```

Start services:

```bash
make up
```

Stop services:

```bash
make down
```

Remove containers, local images and volumes declared in compose:

```bash
make clean
```

## 3) Useful management commands

Container status:

```bash
make ps
```

Follow logs:

```bash
make logs
```

Inspect compose state:

```bash
docker compose -f srcs/docker-compose.yml config
docker compose -f srcs/docker-compose.yml ps
```

Inspect Docker objects:

```bash
docker volume ls
docker network ls
docker ps -a
```

Database quick check:

```bash
docker compose -f srcs/docker-compose.yml exec mariadb sh -lc 'MYSQL_PWD="$(cat /run/secrets/db_root_password)" mysql -u root -e "USE wordpress; SHOW TABLES; SELECT ID,user_login,user_email FROM wp_users;"'
```

## 4) Data storage and persistence

Project persistent data is mounted to host paths under `/home/maanguit/data`:

- MariaDB data: `/home/maanguit/data/database`
- WordPress files: `/home/maanguit/data/website`
- Bonus backups: `/home/maanguit/data/backups`

Defined as Docker named volumes in `srcs/docker-compose.yml`:
- `db_data`
- `wordpress_data`
- `db_backups`

Persistence behavior:
- Recreating containers does not remove persistent data.
- Data remains available after `make down` and `make up`.
- `make clean` removes compose volumes and local images.
