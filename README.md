# Dockerfiles

All images are based on [Alpine](http://alpinelinux.org/), a few of them offer a variant based on [CentOS](https://www.centos.org/) alternatively, use at your own risk please.

## Contents

- `base` - The base img.
    - `:latest` & `:edge` -  Based on `alpine:latest` and `alpine:edge`, includes [su-exec](https://github.com/ncopa/su-exec), a handy tool to exec cmds with different privileges in containers.
    - `:centos` - Based on `centos:latest` with [EPEL](https://fedoraproject.org/wiki/EPEL) & [gosu](https://github.com/tianon/gosu) pre-installed.
- `ss-obfs` - [ss-libev](https://github.com/shadowsocks/shadowsocks-libev) & [simple-obfs](https://github.com/shadowsocks/simple-obfs). `:centos` version available.

## Usage

See corresponding READMEs along with the dockerfiles.

## Documentation
- [`docker build --help`](https://docs.docker.com/engine/reference/commandline/build/)
- [`docker run --help`](https://docs.docker.com/engine/reference/commandline/run/) 
