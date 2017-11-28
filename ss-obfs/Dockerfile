FROM nutshells/base
LABEL maintainer='Chao QU <mail@quchao.com>'

ARG SS_VERSION='3.1.0'
ARG SS_SHA256='3b6493ebdcfff1eb31faf34d164d57049f7253ff5bffafa6ce2263c9ac123f31'
ARG OBFS_VERSION='0.0.5'
ARG OBFS_SHA256='0de9b551b67ec82d0af9d09bcb74c9e8d047f0082ae07db8e4f5f3defeb2ce4c'
ARG LIBCORK_COMMIT='29d7cba'
ARG LIBCORK_SHA256='52be7bddaf4cbcf8635c616b69c1b89e776ad2b19458a3e8c80fc1c30b13f79d'
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
        mbedtls-dev \
        libev-dev \
        libsodium-dev \
        c-ares-dev \
        pcre-dev \
    ; \
    # runtime deps
    apk add --no-cache --virtual .runtime-deps \
        mbedtls \
        libev \
        libsodium \
        c-ares \
        pcre \
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
        curl -sSLO "https://github.com/shadowsocks/simple-obfs/archive/v${OBFS_VERSION}.tar.gz"; \
        echo "${OBFS_SHA256}  v${OBFS_VERSION}.tar.gz" | sha256sum -c -; \
        tar xzf "v${OBFS_VERSION}.tar.gz"; \
        cd "simple-obfs-${OBFS_VERSION}"; \
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
        rm -f "simple-obfs-${OBFS_VERSION}.tar.gz"; \
        rm -rf "simple-obfs-${OBFS_VERSION}"; \
    fi; \
    # do some cleanup
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
