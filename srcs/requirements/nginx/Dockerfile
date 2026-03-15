FROM alpine:3.22

RUN apk add --no-cache nginx openssl

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/key.pem -out /etc/nginx/ssl/cert.pem \
    -subj "/C=ES/ST=Madrid/L=Madrid/O=42/OU=Inception/CN=maanguit.42.fr"

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf /etc/nginx/http.d/default.conf

RUN mkdir -p /var/www/html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]