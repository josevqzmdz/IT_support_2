#!/bin/sh
exec nginx -g "daemon off;"
#runs the memory > 70% script
exec ../docs/other_files/memory_protect.sh
#config test
nginx -t || exit 1

#starts nginx 
exec "$@"