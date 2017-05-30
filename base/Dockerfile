FROM alpine
MAINTAINER Chao QU <mail@quchao.com>

# Keep up-to-date
RUN set -ex; \
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
