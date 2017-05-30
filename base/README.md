# Dockerfile

## Contents:

- `base`: The base img.
    - `:latest` & `:edge` -  Based on `alpine:latest` and `alpine:edge`, includes [su-exec](https://github.com/ncopa/su-exec), a handy tool to exec cmds with different privileges in containers.
    - `:centos` - Based on `centos:latest` with [EPEL](https://fedoraproject.org/wiki/EPEL) & [gosu](https://github.com/tianon/gosu) pre-installed.

## Usage

Build an image...
Based on Alpine `latest`:

``` bash
docker build -q=false --rm=true -t quchao/base .
```

Based on Alpine `edge`:

``` bash
docker build -q=false --rm=true -t quchao/base:edge -f ./edge/Dockerfile .
```

Based on CentOS:

``` bash
docker build -q=false --rm=true -t quchao/base:centos -f ./centos/Dockerfile .
```
