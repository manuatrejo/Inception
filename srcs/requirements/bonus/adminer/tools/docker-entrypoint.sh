#!/bin/sh
set -e

if [ ! -f "/var/www/adminer/index.php" ]; then
    echo "Downloading Adminer..."
    wget -q -O /var/www/adminer/index.php https://github.com/vrana/adminer/releases/download/v5.4.0/adminer-5.4.0.php
fi

echo "Starting Adminer (PHP-FPM)..."
exec "$@"
