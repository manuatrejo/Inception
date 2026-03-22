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

## Demo Commands

### All services status

```bash
docker compose -f srcs/docker-compose.yml ps
```

### Mandatory services

#### NGINX (HTTPS entrypoint)

Test HTTPS connection:

```bash
curl -sI -k https://localhost
curl -sI https://maanguit.42.fr
```

Verify TLS version:

```bash
openssl s_client -connect localhost:443 -brief
```

#### WordPress

Test WordPress response:

```bash
curl -sI https://maanguit.42.fr
curl -s https://maanguit.42.fr | grep -o "<title>.*</title>"
```

Verify PHP-FPM is running inside container:

```bash
docker exec wordpress ps aux | grep php
```

#### MariaDB

Show databases:

```bash
docker compose -f srcs/docker-compose.yml exec mariadb sh -lc 'MYSQL_PWD="$(cat /run/secrets/db_root_password)" mysql -u root -e "SHOW DATABASES;"'
```

Show WordPress tables:

```bash
docker compose -f srcs/docker-compose.yml exec mariadb sh -lc 'MYSQL_PWD="$(cat /run/secrets/db_root_password)" mysql -u root -e "USE wordpress; SHOW TABLES;"'
```

Show WordPress users:

```bash
docker compose -f srcs/docker-compose.yml exec mariadb sh -lc 'MYSQL_PWD="$(cat /run/secrets/db_root_password)" mysql -u root -e "USE wordpress; SELECT ID,user_login,user_email FROM wp_users;"'
```

### Bonus services

#### Redis (WordPress cache)

Verify Redis configuration in WordPress:

```bash
docker exec wordpress cat /var/www/html/wp-config.php | grep -i redis
```

Test Redis connection from WordPress container:

```bash
docker exec wordpress sh -lc 'redis-cli -h redis ping'
```

Check Redis is running:

```bash
docker exec redis redis-cli ping
```

#### FTP (WordPress files access)

Test FTP connection:

```bash
curl -v ftp://localhost --user ftpuser:$(cat secrets/ftp_password.txt)
```

List WordPress files via FTP:

```bash
curl ftp://localhost --user ftpuser:$(cat secrets/ftp_password.txt) -X LIST
```

Download a file via FTP:

```bash
curl ftp://localhost --user ftpuser:$(cat secrets/ftp_password.txt) -o wp-config.php -T /dev/null
```

Connect with FTP client:

```bash
ftp localhost 21
# User: ftpuser
# Password: (content of secrets/ftp_password.txt)
```

#### Static website

Test static site response:

```bash
curl -sI http://localhost:8081
curl -s http://localhost:8081 | head -20
```

#### Adminer (Database management)

Test Adminer response:

```bash
curl -sI http://localhost:8080
```

Access Adminer in browser:
- URL: `http://localhost:8080`
- Server: `mariadb`
- Username: `root` (or content of `secrets/db_root_password.txt`)
- Password: (content of `secrets/db_root_password.txt`)
- Database: `wordpress`

#### Database backup service

Check backup directory:

```bash
ls -la /home/maanguit/data/backups/
```

Check backup logs:

```bash
docker logs backup
```

Verify backup files exist:

```bash
find /home/maanguit/data/backups/ -name "*.sql" -type f
```

### Persistency verification

Show Docker volumes:

```bash
docker volume ls | grep srcs
```

Show data directories on host:

```bash
ls -la /home/maanguit/data/
ls -la /home/maanguit/data/database/
ls -la /home/maanguit/data/website/
ls -la /home/maanguit/data/backups/
```

Test data persistence (after `make down` and `make up`):

```bash
make down && make up
# Data should still be present
docker exec mariadb sh -lc 'MYSQL_PWD="$(cat /run/secrets/db_root_password)" mysql -u root -e "USE wordpress; SELECT COUNT(*) FROM wp_posts;"'
```
