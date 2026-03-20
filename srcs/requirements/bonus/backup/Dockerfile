FROM alpine:3.22

RUN apk add --no-cache mariadb-client tzdata

COPY tools/backup.sh /usr/local/bin/backup.sh
COPY conf/crontab /etc/crontabs/root

RUN chmod +x /usr/local/bin/backup.sh && mkdir -p /backups

CMD ["crond", "-f", "-l", "8"]
