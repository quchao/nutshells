FROM alpine
LABEL maintainer "Chao QU <mail@quchao.com>"

# Keep up-to-date
RUN set -ex; \
    # Change repo mirror
    sed -i 's/http:\/\/dl-cdn.alpinelinux.org/https:\/\/mirrors.aliyun.com/g' /etc/apk/repositories; \
    apk update; \
    apk upgrade; \
    # Runtime deps
    apk add --no-cache --virtual .common-deps \
        ca-certificates \
        su-exec \
        curl \
    ; \
    # Update CAs
    update-ca-certificates --fresh; \
    # Cleaning
    rm -rf /tmp/* /var/tmp/*;
