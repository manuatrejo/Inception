FROM alpine:3.22

RUN apk add --no-cache vsftpd openrc

RUN mkdir -p /var/www/html && \
    mkdir -p /run/vsftpd/empty && \
    adduser -D -s /sbin/nologin ftpuser && \
    echo "ftpuser:ftpuser" | chpasswd && \
    chown -R ftpuser:ftpuser /var/www/html

COPY conf/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY conf/pam_vsftpd.conf /etc/pam.d/vsftpd
COPY tools/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 21 21000-21010

ENTRYPOINT ["/entrypoint.sh"]
CMD ["vsftpd", "/etc/vsftpd/vsftpd.conf"]
