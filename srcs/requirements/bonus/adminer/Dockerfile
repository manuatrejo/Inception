FROM alpine:3.22

RUN apk add --no-cache \
    php83 php83-mysqli php83-session php83-json php83-mbstring \
    php83-openssl php83-curl wget

RUN mkdir -p /var/www/adminer

COPY tools/docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["php83", "-S", "0.0.0.0:8080", "-t", "/var/www/adminer"]
