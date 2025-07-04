FROM wordpress:php8.2-fpm-alpine

USER root
#RUN { \
#    echo '[www]'; \
#    echo 'listen = 9000'; \
#    echo 'listen.allowed_clients = 0.0.0.0'; \
#    echo 'pm = dynamic'; \
#    echo 'pm.max_children = 20'; \
#    echo 'pm.start_servers = 5'; \
#    echo 'pm.min_spare_servers = 2'; \
#    echo 'pm.max_spare_servers = 8'; \
#    echo 'clear_env = no'; \
#    echo 'pm.status_path = /status'; \
#} > /usr/local/etc/php-fpm.d/zz-custom.conf

WORKDIR /usr/src/wordpress
RUN set -eux; \
	find /etc/apache2 -name '*.conf' -type f -exec sed -ri -e "s!/var/www/html!$PWD!g" -e "s!Directory /var/www/!Directory $PWD!g" '{}' +; \
	cp -s wp-config-docker.php wp-config.php

#RUN mkdir -p /var/www/html/wp-content/uploads && \
#    chmod -R 775 /var/www/html/wp-content/uploads

#COPY --chown=www-data:www-data ./docs/other_files/wp1-entrypoint.sh /usr/local/bin/wp-entrypoint.sh
#RUN chmod +x /usr/local/bin/wp-entrypoint.sh

# script that checks if memor > 70
COPY --chown=www-data:www-data ./docs/other_files/chemiloco /usr/local/bin/chemiloco
RUN chmod +x /usr/local/bin/chemiloco

#RUN echo 'pm.status_path = /status' >> /usr/local/etc/php-fpm.d/zz-custom.conf

USER www-data

#HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=3 \
#    CMD curl -f http://localhost/ || exit 1

ENTRYPOINT ["wp-entrypoint.sh"]
CMD ["php-fpm"]
