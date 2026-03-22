#!/bin/sh
set -e

FTP_USER=${FTP_USER:-ftpuser}
FTP_PASSWORD_FILE=/run/secrets/ftp_password

if [ ! -f "$FTP_PASSWORD_FILE" ]; then
    echo "Error: FTP password not found at $FTP_PASSWORD_FILE"
    exit 1
fi

FTP_PASSWORD=$(cat "$FTP_PASSWORD_FILE")

if id "$FTP_USER" >/dev/null 2>&1; then
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
fi

chown ftpuser:ftpuser /var/www/html 2>/dev/null || true

exec "$@"
