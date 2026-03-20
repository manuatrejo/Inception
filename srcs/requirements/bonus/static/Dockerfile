FROM alpine:3.22

RUN apk add --no-cache nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY website/index.html /var/www/static/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
