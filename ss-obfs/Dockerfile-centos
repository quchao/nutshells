FROM nutshells/base:centos
LABEL maintainer="Chao QU <mail@quchao.com>"

ARG SS_VERSION='3.2.3'
ARG SS_SHA256='2befc27b1cc62af0450702343d17e347936f0d4e3d4b04ba9246c4f9b409b742'
ARG OBFS_VERSION='0.0.5'
ARG OBFS_SHA256='0de9b551b67ec82d0af9d09bcb74c9e8d047f0082ae07db8e4f5f3defeb2ce4c'
ARG LIBSODIUM_VERSION='1.0.16'
ARG LIBSODIUM_SHA256='eeadc7e1e1bcef09680fb4837d448fbdf57224978f865ac1c16745868fbd0533'
ARG LIBMBEDTLS_VERSION='2.15.1'
ARG LIBMBEDTLS_SHA256='59d69500a7e919ddb9b35d2ca2b2bbeb8d66cf7f5da61de01a053dfe2b5a0060'
ARG LIBCORK_COMMIT='29d7cba'
ARG LIBCORK_SHA256='52be7bddaf4cbcf8635c616b69c1b89e776ad2b19458a3e8c80fc1c30b13f79d'
ENV WITH_OBFS='true'

WORKDIR /usr/local/src/

# Dev Tools & Deps
RUN set -ex; \
    # build deps
    yum install -y \
        gcc \
        autoconf \
        automake \
        libtool \
        make \
        pcre-devel \
        c-ares-devel \
        libev-devel; \
    # libsodium (v1.0.8+) \
    curl -sSLO "https://github.com/jedisct1/libsodium/releases/download/${LIBSODIUM_VERSION}/libsodium-${LIBSODIUM_VERSION}.tar.gz"; \
    echo "${LIBSODIUM_SHA256}  libsodium-${LIBSODIUM_VERSION}.tar.gz" | sha256sum -c -; \
    tar xvf "libsodium-${LIBSODIUM_VERSION}.tar.gz"; \
    pushd "libsodium-${LIBSODIUM_VERSION}"; \
    env CFLAGS=-Ofast ./configure --disable-dependency-tracking --prefix=/usr; \
    #make; \
    #make check; \
    make install; \
    #make installcheck; \
    popd; \
    #ldconfig; \
    rm -f "libsodium-${LIBSODIUM_VERSION}.tar.gz"; \
    rm -rf "libsodium-${LIBSODIUM_VERSION}"; \
    # libmbedtls
    curl -sSLO "https://github.com/ARMmbed/mbedtls/archive/mbedtls-${LIBMBEDTLS_VERSION}.tar.gz"; \
    echo "${LIBMBEDTLS_SHA256}  mbedtls-${LIBMBEDTLS_VERSION}.tar.gz" | sha256sum -c -; \
    tar xvf "mbedtls-${LIBMBEDTLS_VERSION}.tar.gz"; \
    pushd "mbedtls-mbedtls-${LIBMBEDTLS_VERSION}"; \
    make SHARED=1 CFLAGS=-fPIC; \
    make DESTDIR=/usr install; \
    popd; \
    #ldconfig; \
    rm -f "mbedtls-${LIBMBEDTLS_VERSION}.tar.gz"; \
    rm -rf "mbedtls-mbedtls-${LIBMBEDTLS_VERSION}"; \
    # shadowsocks-libev
    curl -sSLO "https://github.com/shadowsocks/shadowsocks-libev/releases/download/v${SS_VERSION}/shadowsocks-libev-${SS_VERSION}.tar.gz"; \
    echo "${SS_SHA256}  shadowsocks-libev-${SS_VERSION}.tar.gz" | sha256sum -c -; \
    tar xvf "shadowsocks-libev-${SS_VERSION}.tar.gz"; \
    pushd "shadowsocks-libev-${SS_VERSION}"; \
    #autoreconf --install --force; \
    ./configure --disable-documentation; \
    make; \
    #make check; \
    #make install; \
    cp src/ss-server src/ss-local /usr/local/bin/; \
    #make installcheck; \
    popd; \
    rm -f "shadowsocks-libev-${SS_VERSION}.tar.gz"; \
    rm -rf "shadowsocks-libev-${SS_VERSION}"; \
    if [ "${WITH_OBFS}" = 'true' ]; then \
        # simple-obfs
        curl -sSLO "https://github.com/shadowsocks/simple-obfs/archive/v${OBFS_VERSION}.tar.gz"; \
        echo "${OBFS_SHA256}  v${OBFS_VERSION}.tar.gz" | sha256sum -c; \
        tar xvf "v${OBFS_VERSION}.tar.gz"; \
        pushd "simple-obfs-${OBFS_VERSION}"; \
        # libcork
        curl -sSLO "https://github.com/shadowsocks/libcork/archive/${LIBCORK_COMMIT}.tar.gz"; \
        echo "${LIBCORK_SHA256}  ${LIBCORK_COMMIT}.tar.gz" | sha256sum -c; \
        tar xvf "${LIBCORK_COMMIT}.tar.gz"; \
        rm -rf libcork; \
        mv libcork-* libcork; \
        ./autogen.sh; \
        ./configure --disable-documentation; \
        make; \
        #make check; \
        #make install; \
        cp src/obfs-server src/obfs-local /usr/local/bin/; \
        #make installcheck; \
        popd; \
        rm -f "v${OBFS_VERSION}.tar.gz"; \
        rm -rf "simple-obfs-${OBFS_VERSION}"; \
    fi; \
    # cleanup pt.1
    yum remove -y \
        gcc \
        autoconf \
        automake \
        libtool \
        make \
        pcre-devel \
        c-ares-devel \
        libev-devel; \
    # runtime deps
    yum install -y \
        pcre \
        c-ares \
        libev; \
    # cleanup pt.2
	yum clean all; \
    rm -rf /tmp/* /var/tmp/* /usr/local/src/*;

COPY docker-entrypoint.sh /usr/local/bin/

RUN set -ex; \
    # Use GoSU instead
    sed -i 's/su-exec/gosu/' /usr/local/bin/docker-entrypoint.sh; \
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
