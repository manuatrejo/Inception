# USER_DOC

## Services provided by this stack

Mandatory services:
- NGINX (HTTPS entrypoint)
- WordPress (PHP-FPM)
- MariaDB

Bonus services:
- Redis cache for WordPress
- FTP server for WordPress files volume
- Static website
- Adminer
- Database backup service

## Start and stop the project

Start:

```bash
make up
```

Stop:

```bash
make down
```

Rebuild if needed:

```bash
make build
```

## Access website and administration panel

Before access, set host mapping in `/etc/hosts`:

```bash
127.0.0.1 maanguit.42.fr
```

Main website:
- `https://maanguit.42.fr`

WordPress admin panel:
- `https://maanguit.42.fr/wp-admin`

Bonus web interfaces:
- Static site: `http://localhost:8081`
- Adminer: `http://localhost:8080`

## Credentials location and management

Sensitive credentials are stored in local files under `secrets/`:

- `secrets/db_root_password.txt`
- `secrets/db_password.txt`
- `secrets/ftp_password.txt`

These files are mounted as Docker secrets at runtime.
Do not commit credential files to the repository.

## Check services are running correctly

Basic status check:

```bash
make ps
```

Detailed container and ports:

```bash
docker compose -f srcs/docker-compose.yml ps
```

Logs:

```bash
make logs
```

Functional checks:
- Open `https://maanguit.42.fr`
- Log in to `wp-admin`
- Open `http://localhost:8080` (Adminer)
- Open `http://localhost:8081` (Static site)

Database check example:

```bash
docker compose -f srcs/docker-compose.yml exec mariadb sh -lc 'MYSQL_PWD="$(cat /run/secrets/db_root_password)" mysql -u root -e "SHOW DATABASES;"'
```
