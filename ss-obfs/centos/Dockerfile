FROM quchao/base:centos
LABEL maintainer "Chao QU <mail@quchao.com>"

WORKDIR /etc/shadowsocks-libev/

ARG SS_VERSION="3.0.6"
ARG SS_SHA256="7d9b43b0235a57c115bfe160efd54abef96bffcbfff61c5496e7c2800f0734ca"
ARG OBFS_VERSION="0.0.3"
ARG OBFS_SHA256="350c22e138202868d5726cb55e3d71e9962aad3306988a9f746b80d0e8998a75"
ARG LIBSODIUM_VERSION="1.0.12"
ARG LIBSODIUM_SHA256="b8648f1bb3a54b0251cf4ffa4f0d76ded13977d4fa7517d988f4c902dd8e2f95"
ARG LIBMBEDTLS_VERSION="2.4.2"
ARG LIBMBEDTLS_SHA256="b7afab6a0f86e29c6055848b70d183c4e2531cb0ec955b66c0e4e1b7e4954bf4"
ARG LIBUDNS_VERSION="0.4"
ARG LIBUDNS_SHA256="115108dc791a2f9e99e150012bcb459d9095da2dd7d80699b584ac0ac3768710"
ARG LIBCORK_COMMIT="3bcb832"
ARG LIBCORK_SHA256="c229dbfe754ec376f906043a35b1fb10725226c6c7136911cf817c92fc170959"

# Dev Tools & Deps
RUN set -ex; \
    cd /usr/local/src/; \
    # build & runtime deps
    yum install -y \
        gcc \
        autoconf \
        automake \
        libtool \
        make \
        pcre-devel \
        libev-devel; \
    # libsodium (v1.0.8+) \
    curl -LO https://github.com/jedisct1/libsodium/releases/download/${LIBSODIUM_VERSION}/libsodium-${LIBSODIUM_VERSION}.tar.gz; \
    echo "${LIBSODIUM_SHA256}  libsodium-${LIBSODIUM_VERSION}.tar.gz" | sha256sum -c; \
    tar xvf libsodium-${LIBSODIUM_VERSION}.tar.gz; \
    pushd libsodium-${LIBSODIUM_VERSION}; \
    ./configure --prefix=/usr; \
    make; \
    #make check; \
    make install; \
    #make installcheck; \
    popd; \
    ldconfig; \
    rm -f libsodium-${LIBSODIUM_VERSION}.tar.gz; \
    rm -rf libsodium-${LIBSODIUM_VERSION}; \
    # libmbedtls
    curl -LO https://github.com/ARMmbed/mbedtls/archive/mbedtls-${LIBMBEDTLS_VERSION}.tar.gz; \
    echo "${LIBMBEDTLS_SHA256}  mbedtls-${LIBMBEDTLS_VERSION}.tar.gz" | sha256sum -c; \
    tar xvf mbedtls-${LIBMBEDTLS_VERSION}.tar.gz; \
    pushd mbedtls-mbedtls-${LIBMBEDTLS_VERSION}; \
    make SHARED=1 CFLAGS=-fPIC; \
    make DESTDIR=/usr install; \
    popd; \
    ldconfig; \
    rm -f mbedtls-${LIBMBEDTLS_VERSION}.tar.gz; \
    rm -rf mbedtls-mbedtls-${LIBMBEDTLS_VERSION}; \
    # libudns
    curl -LO http://www.corpit.ru/mjt/udns/udns-${LIBUDNS_VERSION}.tar.gz; \
    echo "${LIBUDNS_SHA256}  udns-${LIBUDNS_VERSION}.tar.gz" | sha256sum -c; \
    tar xvf udns-${LIBUDNS_VERSION}.tar.gz; \
    pushd udns-${LIBUDNS_VERSION}; \
    ./configure; \
    make shared; \
    cp udns.h /usr/include/; \
    cp libudns.so.0 /usr/lib/; \
    cd /usr/lib/; \
    ln -s libudns.so.0 libudns.so; \
    popd; \
    ldconfig; \
    rm -f udns-${LIBUDNS_VERSION}.tar.gz; \
    rm -rf udns-${LIBUDNS_VERSION}; \
    # shadowsocks-libev
    curl -LO https://github.com/shadowsocks/shadowsocks-libev/releases/download/v${SS_VERSION}/shadowsocks-libev-${SS_VERSION}.tar.gz; \
    echo "${SS_SHA256}  shadowsocks-libev-${SS_VERSION}.tar.gz" | sha256sum -c; \
    tar xvf shadowsocks-libev-${SS_VERSION}.tar.gz; \
    pushd shadowsocks-libev-${SS_VERSION}; \
    #autoreconf --install --force; \
    ./configure --disable-documentation; \
    make; \
    #make check; \
    make install; \
    #make installcheck; \
    popd; \
    rm -f shadowsocks-libev-${SS_VERSION}.tar.gz; \
    rm -rf shadowsocks-libev-${SS_VERSION}; \
    # simple-obfs
    curl -LO https://github.com/shadowsocks/simple-obfs/archive/v${OBFS_VERSION}.tar.gz; \
    echo "${OBFS_SHA256}  v${OBFS_VERSION}.tar.gz" | sha256sum -c; \
    tar xvf v${OBFS_VERSION}.tar.gz; \
    pushd simple-obfs-${OBFS_VERSION}; \
    # libcork
    curl -LO https://github.com/shadowsocks/libcork/archive/${LIBCORK_COMMIT}.tar.gz; \
    echo "${LIBCORK_SHA256}  ${LIBCORK_COMMIT}.tar.gz" | sha256sum -c; \
    tar xvf ${LIBCORK_COMMIT}.tar.gz; \
    rm -rf libcork; \
    mv libcork-* libcork; \
    ./autogen.sh; \
    ./configure --disable-documentation; \
    make; \
    #make check; \
    make install; \
    #make installcheck; \
    popd; \
    rm -f v${OBFS_VERSION}.tar.gz; \
    rm -rf simple-obfs-${OBFS_VERSION}; \
    # Cleaning
    yum remove -y \
        gcc \
        autoconf \
        automake \
        libtool \
        make; \
	yum clean all; \
    rm -rf /tmp/* /var/tmp/* /usr/local/src/*;

# Set password in server.json
# Set password, server ip and port in client.json
COPY server.json client.json /etc/shadowsocks-libev/
COPY docker-entrypoint.sh /usr/local/bin/

RUN set -ex; \
    # Use GoSU instead
    sed -i 's/su-exec/gosu/' /usr/local/bin/docker-entrypoint.sh; \
    chmod +x /usr/local/bin/docker-entrypoint.sh; \
    # User/Group
    groupadd -r shadowsocks; \
    useradd -M -d /var/empty -s /sbin/nologin -g shadowsocks -r shadowsocks;

ENV APP_PORT="12345"

HEALTHCHECK --interval=1m --timeout=3s \
    CMD [ 1 == $(curl -f http://localhost:${APP_PORT} 2>&1 | grep 'curl: (52)' | wc -l) ] || exit 1

ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD [ "ss-server" ]

EXPOSE ${APP_PORT}/tcp ${APP_PORT}/udp
