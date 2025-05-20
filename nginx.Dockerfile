FROM nginxinc/nginx-unprivileged:latest

RUN mkdir -p /tmp/nginx-logs && \
    touch /tmp/nginx-logs/{access,error}.log && \
    chmod -R 755 /tmp/nginx-logs

COPY --chown=101:101 ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY --chown=101:101 ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --chown=101:101 ./nginx/nginx-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh && \
    nginx -t

HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost/ || exit 1

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]