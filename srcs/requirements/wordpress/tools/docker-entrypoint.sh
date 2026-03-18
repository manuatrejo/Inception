#!/bin/sh
set -e

MYSQL_DATABASE=${MYSQL_DATABASE:-wordpress}
MYSQL_USER=${MYSQL_USER:-wpuser}
MYSQL_PASSWORD=$(cat /run/secrets/db_password 2>/dev/null || echo "")
MYSQL_HOST=${MYSQL_HOST:-mariadb}

echo "Setting up WordPress..."

mkdir -p /var/www/html
cd /var/www/html

if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "Downloading WordPress..."
    curl -sL https://wordpress.org/latest.tar.gz | tar xz --strip-components=1
fi

RECONFIGURE=0
if [ -f "/var/www/html/wp-config.php" ]; then
    CURR_DB=$(grep "define.*'DB_NAME'" /var/www/html/wp-config.php | grep -o "'wordpress'" | head -1)
    if [ -n "$CURR_DB" ]; then
        RECONFIGURE=1
    fi
fi

if [ ! -f "/var/www/html/wp-config.php" ] || [ "$RECONFIGURE" = "1" ]; then
    echo "Configuring WordPress wp-config.php..."
    if [ -f "/var/www/html/wp-config-sample.php" ]; then
        cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    else
        curl -sL https://wordpress.org/latest.tar.gz | tar xz --strip-components=1
    fi

    sed -i "s|define.*'DB_NAME'.*;|define( 'DB_NAME', '${MYSQL_DATABASE}' );|g" /var/www/html/wp-config.php
    sed -i "s|define.*'DB_USER'.*;|define( 'DB_USER', '${MYSQL_USER}' );|g" /var/www/html/wp-config.php
    sed -i "s|define.*'DB_PASSWORD'.*;|define( 'DB_PASSWORD', '${MYSQL_PASSWORD}' );|g" /var/www/html/wp-config.php
    sed -i "s|define.*'DB_HOST'.*;|define( 'DB_HOST', '${MYSQL_HOST}' );|g" /var/www/html/wp-config.php

    chown www-data:www-data /var/www/html/wp-config.php
fi

chown -R www-data:www-data /var/www/html

echo "Starting PHP-FPM..."
exec "$@"
