FROM alpine:3.22

RUN apk add --no-cache \
    php-fpm php-mysqli php-curl php-gd php-mbstring \
    php-xml php-json php-zlib php-openssl curl && \
    adduser -D -G www-data -g 'WordPress' -s /bin/sh www-data

RUN mkdir -p /var/www/html /run/php

COPY tools/docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/php-fpm83", "--nodaemonize"]