# Project Nutshells 🌰

[![Project Nutshells](https://img.shields.io/badge/Project-_Nutshells_🌰-orange.svg)](https://github.com/quchao/nutshells/) [![Docker Repo](https://img.shields.io/badge/Docker-Repos-22B8EB.svg)](https://hub.docker.com/r/nutshells/) [![Alpine Based](https://img.shields.io/badge/Alpine-Based-0D597F.svg)](http://alpinelinux.org/) [![CentOS Based](https://img.shields.io/badge/CentOS-Based-932279.svg)](https://www.centos.org/) [![License](https://img.shields.io/github/license/quchao/nutshells.svg?label=License)](https://github.com/quchao/nutshells/blob/master/LICENSE)

Project [**Nutshells**](https://github.com/quchao/nutshells/) contains a bunch of docker images all based on the lightweight [Alpine](http://alpinelinux.org/), a few of them offer a variant based on [CentOS](https://www.centos.org/) alternatively.

## Contents

- [**Base**](https://github.com/quchao/nutshells/blob/master/base/): The base image.
    - `:latest` & `:edge`: Based on `alpine:latest` and `alpine:edge`, includes a handy tool named [su-exec](https://github.com/ncopa/su-exec/) to exec commands with different privileges in containers.
    - `:centos`: Based on `centos:latest` with [EPEL](https://fedoraproject.org/wiki/EPEL) & [gosu](https://github.com/tianon/gosu/) pre-installed.
- [**DNSCrypt-Wrapper**](https://github.com/quchao/nutshells/blob/master/dnscrypt-wrapper/): The server-end of DNSCrypt proxy, which is a protocol to improve DNS security, now with xchacha20 cipher support.
- [**DNSMasq-fast-lookup**](https://github.com/quchao/nutshells/blob/master/dnsmasq-fast-lookup/): A fork of the well-known lightweight DNS forwarder and DHCP server, featuring fast ipset/server/address lookups.
- [**SS-Obfs**](https://github.com/quchao/nutshells/blob/master/ss-obfs/) - [ss-libev](https://github.com/shadowsocks/shadowsocks-libev/) & [simple-obfs](https://github.com/shadowsocks/simple-obfs/). A `:centos` variant is available.

## Usages

All images are built on [docker hub](https://hub.docker.com/r/nutshells/) automatically.
For more detail, refer to their respective README please.

## Contributing

> Follow GitHub's [*How-to*](https://opensource.guide/how-to-contribute/) guide for the basis.

Contributions are always welcome in many ways:

- Give a star to show your fondness;
- File an [issue](https://github.com/quchao/nutshells/issues) if you have a question or an idea;
- Fork this repo and submit a [PR](https://github.com/quchao/nutshells/pulls);
- Improve the documentation.

## Licenses

Unless specified, all codes of **Project Nutshells** are released under the [MIT License](https://github.com/quchao/nutshells/blob/master/LICENSE).
