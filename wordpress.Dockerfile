FROM wordpress:php8.2-fpm-alpine

RUN { \
    echo '[www]'; \
    echo 'listen = 9000'; \
    echo 'listen.allowed_clients = any'; \
    echo 'pm = dynamic'; \
    echo 'pm.max_children = 20'; \
    echo 'pm.start_servers = 5'; \
    echo 'pm.min_spare_servers = 2'; \
    echo 'pm.max_spare_servers = 8'; \
    echo 'clear_env = no'; \
} > /usr/local/etc/php-fpm.d/zz-custom.conf

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && touch /var/log/php-fpm.log \
    && chown www-data:www-data /var/log/php-fpm.log

COPY ./docs/other_files/wp1-entrypoint.sh /usr/local/bin/wp-entrypoint
RUN chmod +x /usr/local/bin/wp-entrypoint

HEALTHCHECK --interval=30s --timeout=3s \
    CMD php-fpm -t || exit 1

ENTRYPOINT ["wp-entrypoint"]
CMD ["php-fpm"]