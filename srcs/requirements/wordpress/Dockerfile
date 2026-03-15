FROM alpine:3.22

RUN apk add --no-cache \
	php-fpm php-mysql php-curl php-gd php-mbstring \
	php-xml php-json php-zlib php-openssl wordpress

RUN mkdir -p /var/www/html /run/php && \ 
	chown -R nginx:nginx /var/www/html /run/php

COPY conf/www.conf /etc/php82/php-fpm.d/www.conf
COPY tools/docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["php-fpm", "--nodaemonize"]