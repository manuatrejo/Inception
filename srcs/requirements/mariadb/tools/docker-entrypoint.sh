#!/bin/sh
set -e

echo "Initializing MariaDB..."

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Creating database structure..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password 2>/dev/null || echo "")
MYSQL_PASSWORD=$(cat /run/secrets/db_password 2>/dev/null || echo "")
MYSQL_DATABASE=${MYSQL_DATABASE:-wordpress}
MYSQL_USER=${MYSQL_USER:-wpuser}

echo "Starting MariaDB temporarily..."
mysqld --user=mysql --skip-networking &
MYSQL_PID=$!

echo "Waiting for MariaDB to be ready..."
for i in $(seq 1 30); do
    if mysqladmin ping -h localhost --silent 2>/dev/null; then
        break
    fi
    sleep 1
done

echo "Creating database and users..."
if [ -n "$MYSQL_PASSWORD" ]; then
    mysql -u root <<-EOSQL
        CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        ALTER USER IF EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
        CREATE USER IF NOT EXISTS 'maanguit'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        ALTER USER IF EXISTS 'maanguit'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO 'maanguit'@'%';
        FLUSH PRIVILEGES;
EOSQL
fi

echo "Stopping temporary MariaDB..."
mysqladmin -u root shutdown

echo "Starting MariaDB permanently..."
exec mysqld --user=mysql
