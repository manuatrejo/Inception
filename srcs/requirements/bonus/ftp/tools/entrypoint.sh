#!/bin/sh
set -e

FTP_USER=${FTP_USER:-ftpuser}
FTP_PASV_ADDRESS=${FTP_PASV_ADDRESS:-127.0.0.1}
FTP_PASV_MIN_PORT=${FTP_PASV_MIN_PORT:-21000}
FTP_PASV_MAX_PORT=${FTP_PASV_MAX_PORT:-21010}

if [ ! -f /run/secrets/ftp_password ]; then
    echo "Missing /run/secrets/ftp_password"
    exit 1
fi

FTP_PASSWORD=$(cat /run/secrets/ftp_password)

if ! id "$FTP_USER" >/dev/null 2>&1; then
    adduser -D "$FTP_USER"
fi

echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
mkdir -p /var/www/html
chown -R "$FTP_USER":"$FTP_USER" /var/www/html

sed -i "s|^pasv_address=.*|pasv_address=$FTP_PASV_ADDRESS|" /etc/vsftpd/vsftpd.conf
sed -i "s|^pasv_min_port=.*|pasv_min_port=$FTP_PASV_MIN_PORT|" /etc/vsftpd/vsftpd.conf
sed -i "s|^pasv_max_port=.*|pasv_max_port=$FTP_PASV_MAX_PORT|" /etc/vsftpd/vsftpd.conf

exec "$@"
