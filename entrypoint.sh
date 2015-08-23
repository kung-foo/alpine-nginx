#!/usr/bin/env sh
set -e

[ ! -z "$DEBUG" ] && set -ex

# TODO: this only works with docker-compose

export PROXY_TARGET=`echo $BLOG_PORT | sed 's/tcp:\/\///g'`

target_conf=/etc/nginx/conf.d/my-site.conf

if [ ! -f /etc/nginx/conf.d/my-site.conf ]; then
    target_conf=/etc/nginx/my-site.conf.default
fi

cat $target_conf | envsubst '$SITE_HOST_NAME $PROXY_TARGET' > /etc/nginx/conf.d/generated.conf

mkdir -p /etc/nginx/ssl/

if [ ! -f /etc/nginx/ssl/$SITE_HOST_NAME.key ]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/$SITE_HOST_NAME.key \
        -out /etc/nginx/ssl/$SITE_HOST_NAME.crt \
        -subj "/CN=$SITE_HOST_NAME"
fi

exec nginx
