# Dockerfile

## Contents:

- `ss-obfs` - [ss-libev](https://github.com/shadowsocks/shadowsocks-libev) & [simple-obfs](https://github.com/shadowsocks/simple-obfs). `:centos` version is available.

## Usage

### Build

> Edit server/client.json before building an img.

Build an image...
Based on Alpine:

``` bash
docker build -q=false --rm=true -t quchao/ss-obfs .
```

Based on CentOS:

``` bash
docker build -q=false --rm=true -t quchao/ss-obfs:centos -f ./centos/Dockerfile .
```

### Run

Run a server container:

``` bash
docker run -d --name=ss-obfs-server -p 12345:12345/tcp -p 12345:12345/udp --read-only --restart=always quchao/ss-obfs
```

Run a client container:

> The first argument will be taken as the program to be run (w/ restricted privilege),
> available values are `ss-local`, `ss-redir`, `ss-tunnel`...
> leave it blank for `ss-server`.
> Other tailing arguments will be passed to the program intactly.

``` bash
docker run -d --name=ss-obfs-client -p 127.0.0.1:12345:12345/tcp -p 127.0.0.1:12345:12345/udp --read-only --restart=always quchao/ss-obfs ss-local
```

### Advanced

Run a container with a custom config file:

> Replace the filename with `client.json` in client mode.

``` bash
docker run -d --name=ss-obfs-server -p 12345:12345/tcp -p 12345:12345/udp --read-only --restart=always -v /path/to/custom.json:/etc/shadowsocks-libev/server.json:ro quchao/ss-obfs
```

