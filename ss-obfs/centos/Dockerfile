FROM quchao/base:centos
MAINTAINER Chao QU <mail@quchao.com>

WORKDIR /usr/local/src/

ENV SS_VERSION='3.0.6' \
    SS_SHA256='7d9b43b0235a57c115bfe160efd54abef96bffcbfff61c5496e7c2800f0734ca' \
    OBFS_VERSION='0.0.3' \
    OBFS_SHA256='350c22e138202868d5726cb55e3d71e9962aad3306988a9f746b80d0e8998a75' \
    LIBSODIUM_VERSION='1.0.12' \
    LIBSODIUM_SHA256='b8648f1bb3a54b0251cf4ffa4f0d76ded13977d4fa7517d988f4c902dd8e2f95' \
    LIBCORK_COMMIT='3bcb832' \
    LIBCORK_SHA256='c229dbfe754ec376f906043a35b1fb10725226c6c7136911cf817c92fc170959'

# Dev Tools & Deps
RUN set -ex; \
    yum install -y \
        gcc \
        autoconf \
        automake \
        libtool \
        make \
        pcre-devel \
        libev-devel \
        mbedtls-devel \
        udns-devel; \
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
    yum clean all;

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
    useradd -g shadowsocks -r shadowsocks;

# Entrypoint
ENTRYPOINT [ "docker-entrypoint.sh" ]
EXPOSE 12345/tcp 12345/udp
CMD [ "ss-server" ]
