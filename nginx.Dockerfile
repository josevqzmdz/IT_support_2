FROM nginxinc/nginx-unprivileged:latest

RUN mkdir -p /var/log/nginx

RUN chown -R nginx:nginx /var/log/nginx && \
    chmod -R 755 /var/log/nginx

USER nginx
RUN touch /var/log/nginx/access.log /var/log/nginx/error.log

USER root

COPY --chown=nginx:nginx ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY --chown=nginx:nginx ./nginx/default.conf /etc/nginx/conf.d/default.conf

COPY --chown=nginx:nginx ./nginx/nginx-entrypoint.sh /docker-entrypoint.d/
COPY --chown=nginx:nginx ./docs/other_files/chemiloco /usr/local/bin/

RUN chmod +x /docker-entrypoint.d/nginx-entrypoint.sh && \
    chmod +x /usr/local/bin/chemiloco && \
    nginx -t

USER nginx

HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost/ || exit 1

ENTRYPOINT ["/docker-entrypoint.d/nginx-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]