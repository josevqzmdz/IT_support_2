FROM nginxinc/nginx-unprivileged:latest

RUN mkdir -p /tmp/nginx-logs && \
    touch /tmp/nginx-logs/{access,error}.log && \
    chmod -R 755 /tmp/nginx-logs

COPY --chown=101:101 ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY --chown=101:101 ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --chown=101:101 ./nginx/nginx-entrypoint.sh /nginx-entrypoint.sh
# script that checks if memory > 70%
#COPY --chown=101:101 ./docs/other_files/chemiloco /#chemiloco

RUN chmod +x /nginx-entrypoint.sh && \
    nginx -t

#RUN chmod +x /chemiloco && \
#    nginx -t

HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost/ || exit 1

ENTRYPOINT ["/nginx-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]