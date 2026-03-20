#!/bin/sh
set -e

MYSQL_HOST=${MYSQL_HOST:-mariadb}
MYSQL_DATABASE=${MYSQL_DATABASE:-wordpress}
MYSQL_USER=${MYSQL_USER:-wpuser}
BACKUP_RETENTION_DAYS=${BACKUP_RETENTION_DAYS:-7}

if [ ! -f /run/secrets/db_password ]; then
    echo "Missing /run/secrets/db_password"
    exit 1
fi

MYSQL_PASSWORD=$(cat /run/secrets/db_password)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="/backups/${MYSQL_DATABASE}_${TIMESTAMP}.sql"

echo "Creating backup ${BACKUP_FILE}"
MYSQL_PWD="$MYSQL_PASSWORD" mariadb-dump -h "$MYSQL_HOST" -u "$MYSQL_USER" "$MYSQL_DATABASE" > "$BACKUP_FILE"

find /backups -type f -name "${MYSQL_DATABASE}_*.sql" -mtime +"$BACKUP_RETENTION_DAYS" -delete
echo "Backup completed"
