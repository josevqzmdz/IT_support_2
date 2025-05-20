#!/bin/sh
exec nginx -g "daemon off;"

nginx -t || exit 1

#starts nginx 
exec "$@"