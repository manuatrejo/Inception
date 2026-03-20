FROM alpine:3.22

RUN apk add --no-cache vsftpd

COPY conf/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY tools/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh && mkdir -p /var/www/html

EXPOSE 21 21000-21010

ENTRYPOINT ["/entrypoint.sh"]
CMD ["vsftpd", "/etc/vsftpd/vsftpd.conf"]
