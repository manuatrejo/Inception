#!/bin/sh
set -e

MYSQL_DATABASE=${MYSQL_DATABASE:-wordpress}
MYSQL_USER=${MYSQL_USER:-wpuser}
MYSQL_PASSWORD=$(cat /run/secrets/db_password 2>/dev/null || echo "")
MYSQL_HOST=${MYSQL_HOST:-mariadb}

echo "Setting up WordPress..."

if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "Downloading WordPress..."
    mkdir -p /var/www/html
    cd /var/www/html
    curl -sL https://wordpress.org/latest.tar.gz | tar xz --strip-components=1
    chown -R nginx:nginx /var/www/html
fi

if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "Configuring WordPress..."
    
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    
    sed -i "s/database_name_here/$MYSQL_DATABASE/g" /var/www/html/wp-config.php
    sed -i "s/username_here/$MYSQL_USER/g" /var/www/html/wp-config.php
    sed -i "s/password_here/$MYSQL_PASSWORD/g" /var/www/html/wp-config.php
    sed -i "s/localhost/$MYSQL_HOST/g" /var/www/html/wp-config.php
    
    chown nginx:nginx /var/www/html/wp-config.php
fi

echo "Starting PHP-FPM..."
exec php-fpm
