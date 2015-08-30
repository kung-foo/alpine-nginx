FROM gliderlabs/alpine:3.2
MAINTAINER docker@jonathan.camp

RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
RUN apk update
RUN apk add curl
RUN curl -o /usr/local/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.4/gosu-amd64" && \
    chmod +x /usr/local/bin/gosu

RUN apk add nginx gettext

EXPOSE 8080 8443

VOLUME ["/var/log/nginx", "/etc/nginx/ssl", "/etc/nginx/conf.d"]

# defaults
ENV SITE_HOST_NAME localhost

ADD *.conf /etc/nginx/
ADD my-site.conf /etc/nginx/my-site.conf.default

ADD entrypoint.sh /opt/
CMD ["/opt/entrypoint.sh"]
