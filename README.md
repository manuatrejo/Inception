_This project has been created as part of the 42 curriculum by maanguit._

# Inception

## Description

Inception is a system administration project based on Docker and Docker Compose.
The goal is to build a small, secure infrastructure from custom Docker images (no prebuilt service images), with persistent data and service isolation.

The mandatory stack includes:
- NGINX as the only public entrypoint (HTTPS, TLS 1.2/1.3)
- WordPress with PHP-FPM
- MariaDB

This repository also includes bonus services:
- Redis (WordPress cache)
- FTP (access to WordPress files volume)
- Static website (non-PHP)
- Adminer
- Database backup service

## Instructions

### 1) Prerequisites

- Linux VM with Docker and Docker Compose installed
- Your domain mapped in `/etc/hosts`

Example:

```bash
127.0.0.1 maanguit.42.fr
```

### 2) Secrets

Create these files in `secrets/`:

- `db_root_password.txt`
- `db_password.txt`
- `ftp_password.txt` (needed for FTP bonus)

Example generation:

```bash
openssl rand -base64 24 > secrets/db_root_password.txt
openssl rand -base64 24 > secrets/db_password.txt
openssl rand -base64 24 > secrets/ftp_password.txt
```

### 3) Build and run

```bash
make build
make up
```

Main endpoints:
- WordPress: `https://maanguit.42.fr`
- Static site (bonus): `http://localhost:8081`
- Adminer (bonus): `http://localhost:8080`

### 4) Stop and clean

```bash
make down
make clean
```

## Project description

### Docker usage and repository sources

All service images are built from Dockerfiles located in `srcs/requirements/`.
The orchestration is defined in `srcs/docker-compose.yml`, and common runtime values are stored in `srcs/.env`.

Core folders:
- `srcs/requirements/mariadb/`
- `srcs/requirements/wordpress/`
- `srcs/requirements/nginx/`
- `srcs/requirements/bonus/` (bonus services)

### Virtual Machines vs Docker

- A VM virtualizes full hardware and runs a complete OS per instance.
- Docker virtualizes at the OS level and isolates processes in containers.
- Docker starts faster, uses fewer resources, and is easier to reproduce for this project.

### Secrets vs Environment Variables

- Environment variables are used for non-sensitive configuration (domain, usernames, ports).
- Docker secrets are used for sensitive values (database and FTP passwords).
- This reduces credential exposure in compose files and images.

### Docker Network vs Host Network

- A custom bridge network (`inception`) isolates inter-service traffic.
- Services communicate by container name (`mariadb`, `wordpress`, `redis`, etc.).
- Host network mode is avoided because it breaks isolation and is forbidden in the project rules.

### Docker Volumes vs Bind Mounts

- The project uses Docker named volumes for persistence in Compose.
- Data is stored under `/home/maanguit/data/` on the host.
- This keeps service data persistent across container rebuilds/restarts and follows subject requirements.

## Resources

- Docker official docs: https://docs.docker.com/
- Docker Compose docs: https://docs.docker.com/compose/
- NGINX docs: https://nginx.org/en/docs/
- MariaDB docs: https://mariadb.com/kb/en/documentation/
- WordPress docs: https://wordpress.org/documentation/

### AI usage in this project

AI was used to:
- Draft implementation plans and checklists
- Review Docker/Compose configuration consistency
- Generate initial documentation drafts

All generated content was manually reviewed, adapted, and validated in the project environment.
