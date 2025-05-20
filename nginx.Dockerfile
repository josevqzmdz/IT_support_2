FROM nginxinc/nginx-unprivileged:latest

USER root
RUN mkdir -p /tmp/nginx-logs && \
    touch /tmp/nginx-logs/access.log /tmp/nginx-logs/error.log && \
    mkdir -p /tmp/nginx && \
    touch /tmp/nginx-logs/nginx.pid && \
    chown -R nginx:nginx /tmp/nginx-logs /tmp/nginx-logs && \
    chmod -R 777 /tmp/nginx-logs /tmp/nginx-logs && \
    chown -R nginx:nginx /tmp/nginx-logs/ /tmp/nginx-logs/ && \
    ls -la /tmp/nginx-logs/

USER root
COPY --chown=nginx:nginx ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY --chown=nginx:nginx ./nginx/default.conf /etc/nginx/conf.d/default.conf

RUN sed -i 's|/var/log/nginx|/tmp/nginx-logs|g' /etc/nginx/nginx.conf && \
    sed -i 's|/var/log/nginx|/tmp/nginx-logs|g' /etc/nginx/conf.d/default.conf

COPY --chown=nginx:nginx ./nginx/nginx-entrypoint.sh /nginx-entrypoint.sh
COPY --chown=nginx:nginx ./docs/other_files/chemiloco /usr/local/bin/chemiloco

USER root
RUN chmod +x /nginx-entrypoint.sh && \
    chmod +x /usr/local/bin/chemiloco && \
    nginx -t

USER nginx


HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost/ || exit 1

ENTRYPOINT ["/nginx-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]