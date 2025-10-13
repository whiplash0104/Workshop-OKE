#!/bin/sh

sed -i -e s/HOSTNAME/${HOSTNAME}/g /usr/share/nginx/html/index.html

exec /usr/sbin/nginx -g "daemon off;"
