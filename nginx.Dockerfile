FROM nginxinc/nginx-unprivileged:latest

USER root
RUN mkdir -p /tmp/nginx-logs/ && \
    touch /tmp/nginx-logs/access.log /tmp/nginx-logs/error.log && \
    chown -R nginx:nginx /var/log/nginx && \
    chmod -R 755 /tmp/nginx-logs/

COPY --chown=nginx:nginx ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY --chown=nginx:nginx ./nginx/default.conf /etc/nginx/conf.d/default.conf

COPY --chown=nginx:nginx ./nginx/nginx-entrypoint.sh /nginx-entrypoint.sh
COPY --chown=nginx:nginx ./docs/other_files/chemiloco /usr/local/bin/chemiloco

RUN chmod +x /nginx-entrypoint.sh && \
    chmod +x /usr/local/bin/chemiloco && \
    nginx -t

USER nginx

ENTRYPOINT ["/nginx-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]