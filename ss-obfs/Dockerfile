FROM nutshells/base
LABEL maintainer='Chao QU <mail@quchao.com>'

ARG SS_VERSION='3.3.3'
ARG SS_SHA256='677356a5ed6b5ae9e32a898061db2587158ff27e245db03f4bde9b006ef12dc9'
ARG OBFS_COMMIT='486bebd'
ARG OBFS_SHA256='d717dc3389955633a2155b53a280c3982e30f7f890df9b4a32961040282fbf26'
ARG LIBCORK_COMMIT='f029845'
ARG LIBCORK_SHA256='0f1ede7bd23672718d1d10adbe9e4028515d029585b93092d7199e51a40b3fe4'
ENV WITH_OBFS='true'

WORKDIR /usr/local/src/

RUN set -ex; \
    # build deps
    apk add --no-cache --virtual .build-deps \
        build-base \
        linux-headers \
        autoconf \
        automake \
        libtool \
        pcre-dev \
        mbedtls-dev \
        libsodium-dev \
        c-ares-dev \
        libev-dev \
    ; \
    # ss-libev
    curl -sSLO "https://github.com/shadowsocks/shadowsocks-libev/releases/download/v${SS_VERSION}/shadowsocks-libev-${SS_VERSION}.tar.gz"; \
    echo "${SS_SHA256}  shadowsocks-libev-${SS_VERSION}.tar.gz" | sha256sum -c -; \
    tar xzf "shadowsocks-libev-${SS_VERSION}.tar.gz"; \
    cd "shadowsocks-libev-${SS_VERSION}"; \
    ./configure --disable-documentation; \
    make; \
    #make check; \
    #make install; \
    cp src/ss-server src/ss-local /usr/local/bin/; \
    #make installcheck; \
    cd ..; \
    rm -f "shadowsocks-libev-${SS_VERSION}.tar.gz"; \
    rm -rf "shadowsocks-libev-${SS_VERSION}"; \
    if [ "${WITH_OBFS}" = 'true' ]; then \
        # simple-obfs
        curl -sSLO "https://github.com/shadowsocks/simple-obfs/archive/${OBFS_COMMIT}.tar.gz"; \
        echo "${OBFS_SHA256}  ${OBFS_COMMIT}.tar.gz" | sha256sum -c -; \
        tar xzf "${OBFS_COMMIT}.tar.gz"; \
        mv simple-obfs-* simple-obfs; \
        cd simple-obfs; \
        # libcork
        rm -rf libcork; \
        curl -sSLO "https://github.com/shadowsocks/libcork/archive/${LIBCORK_COMMIT}.tar.gz"; \
        echo "${LIBCORK_SHA256}  ${LIBCORK_COMMIT}.tar.gz" | sha256sum -c -; \
        tar xzf "${LIBCORK_COMMIT}.tar.gz"; \
        mv libcork-* libcork; \
        ./autogen.sh; \
        ./configure --disable-documentation; \
        make; \
        #make check; \
        #make install; \
        cp src/obfs-server src/obfs-local /usr/local/bin/; \
        #make installcheck; \
        cd ..; \
        rm -f "simple-obfs-${OBFS_COMMIT}.tar.gz"; \
        rm -rf "simple-obfs-${OBFS_COMMIT}"; \
    fi; \
    # runtime deps
    apk add --no-cache --virtual .runtime-deps $( \
       scanelf --needed --nobanner --recursive /usr/local \
           | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
           | sort -u \
           | xargs -r apk info --installed \
           | sort -u \
    ); \
    # cleanup
    apk del --purge .build-deps; \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /usr/local/src/*;

COPY docker-entrypoint.sh /usr/local/bin/

RUN set -ex; \
    chmod +x /usr/local/bin/docker-entrypoint.sh; \
    chown "${RUN_AS_USER}":"${RUN_AS_USER}" /usr/local/bin/ss-*; \
    chown "${RUN_AS_USER}":"${RUN_AS_USER}" /usr/local/bin/obfs-*;

ENV LISTEN_PORT='12345' \
    SERVER_ADDRESS='' \
    SERVER_PORT='' \
    PASSWORD='' \
    KEY_IN_BASE64='' \
    ENCRYPT_METHOD='xchacha20-ietf-poly1305' \
    DNS_RESOLVERS='8.8.8.8,8.8.4.4' \
    TIMEOUT='300' \
    TCP_RELAY='true' \
    UDP_RELAY='true' \
    REUSE_PORT='true' \
    TCP_FAST_OPEN='true' \
    OBFS_PLUGIN='http' \
    OBFS_HOST='bing.com'

#HEALTHCHECK --interval=1m --timeout=3s \
#    CMD [[ "$(curl -f http://localhost:"${LISTEN_PORT}" 2>&1 | grep 'curl: (52)' | wc -l)" -eq 1 ]] || exit 1

EXPOSE ${LISTEN_PORT}/tcp ${LISTEN_PORT}/udp

WORKDIR /usr/local/var/ss-obfs
ENTRYPOINT [ "docker-entrypoint.sh" ]
