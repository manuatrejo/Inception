FROM alpine:3.22

RUN apk add --no-cache \
    mariadb mariadb-client

RUN mkdir -p /run/mysqld /var/lib/mysql && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql

COPY conf/mariadb.cnf /etc/my.cnf.d/mariadb.cnf
COPY tools/docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["mariadbd", "--user=mysql"]