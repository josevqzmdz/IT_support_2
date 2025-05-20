FROM wordpress:php8.2-fpm-alpine

RUN { \
    echo '[www]'; \
    echo 'listen = 9000'; \
    echo 'listen.allowed_clients = 0.0.0.0'; \
    echo 'pm = dynamic'; \
    echo 'pm.max_children = 20'; \
    echo 'pm.start_servers = 5'; \
    echo 'pm.min_spare_servers = 2'; \
    echo 'pm.max_spare_servers = 8'; \
    echo 'clear_env = no'; \
} > /usr/local/etc/php-fpm.d/zz-custom.conf

USER www-data
RUN mkdir -p /var/www/html/wp-content/uploads && \
    chmod -R 775 /var/www/html/wp-content/uploads

COPY --chown=www-data:www-data ./docs/other_files/wp1-entrypoint.sh /usr/local/bin/wp-entrypoint.sh
RUN chmod +x /usr/local/bin/wp-entrypoint.sh

# script that checks if memor > 70
COPY --chown=www-data:www-data ./docs/other_files/chemiloco /usr/local/bin/chemiloco
RUN chmod +x /usr/local/bin/chemiloco

HEALTHCHECK --interval=30s --timeout=3s \
    CMD php-fpm -t || exit 1

ENTRYPOINT ["wp1-entrypoint.sh"]
CMD ["php-fpm"]
