FROM alpine:edge
MAINTAINER Chao QU <mail@quchao.com>

# Keep up-to-date
RUN set -ex; \
    # enable edge repos
    echo '@edge http://dl-cdn.alpinelinux.org/alpine/edge/main' >> /etc/apk/repositories; \
    echo '@community http://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories; \
    # change mirrors
    sed -i 's/http:\/\/dl-cdn.alpinelinux.org/https:\/\/mirrors.aliyun.com/g' /etc/apk/repositories; \
    apk update; \
    apk upgrade; \
    # runtime deps
    apk add --no-cache --virtual .common-deps \
        ca-certificates \
        su-exec \
    ; \
    # update ca
    update-ca-certificates --fresh; \
    # cleaning
    rm -rf /tmp/* /var/tmp/*;
