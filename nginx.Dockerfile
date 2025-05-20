FROM nginxinc/nginx-unprivileged:latest

USER root
RUN mkdir -p /tmp/nginx-logs/ && \
    touch /tmp/nginx-logs/access.log /tmp/nginx-logs/error.log && \
    chown -R nginx:nginx /var/log/nginx && \
    chmod -R 755 /tmp/nginx-logs/

USER root
COPY --chown=101:101 ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY --chown=101:101 ./nginx/default.conf /etc/nginx/conf.d/default.conf

COPY --chown=101:101 ./nginx/nginx-entrypoint.sh /nginx-entrypoint.sh
COPY --chown=101:101 ./docs/other_files/chemiloco /usr/local/bin/chemiloco

RUN chmod +x /nginx-entrypoint.sh && \
    chmod +x /usr/local/bin/chemiloco && \
    nginx -t

USER nginx

ENTRYPOINT ["/nginx-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]