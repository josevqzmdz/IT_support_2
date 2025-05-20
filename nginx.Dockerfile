FROM nginxinc/nginx-unprivileged:latest

# Création des fichiers de logs avec les bonnes permissions
RUN mkdir -p /var/log/nginx && \
    touch /var/log/nginx/{access,error}.log && \
    chown -R nginx:nginx /var/log/nginx && \
    chmod -R 755 /var/log/nginx

# Copie des fichiers de configuration
COPY --chown=nginx:nginx ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY --chown=nginx:nginx ./nginx/default.conf /etc/nginx/conf.d/default.conf

# Copie des scripts
COPY --chown=nginx:nginx ./nginx/nginx-entrypoint.sh /docker-entrypoint.d/nginx-entrypoint.sh
COPY --chown=nginx:nginx ./docs/other_files/chemiloco /usr/local/bin/chemiloco

# Vérification de la configuration et permissions
RUN chmod +x /docker-entrypoint.d/nginx-entrypoint.sh && \
    chmod +x /usr/local/bin/chemiloco && \
    nginx -t

USER nginx

HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost/ || exit 1

ENTRYPOINT ["/docker-entrypoint.d/nginx-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]