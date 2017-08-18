# DNSMasq Docker Image

[![Project Nutshells](https://img.shields.io/badge/Project-_Nutshells_🌰-orange.svg)](https://github.com/quchao/nutshells/) [![Docker Build Build Status](https://img.shields.io/docker/build/nutshells/dnsmasq-fast-lookup.svg?maxAge=3600&label=Build Status)](https://hub.docker.com/r/nutshells/dnsmasq-fast-lookup/) [![Alpine Based](https://img.shields.io/badge/Alpine-3.6-0D597F.svg)](https://alpinelinux.org/) [![MIT License](https://img.shields.io/github/license/quchao/nutshells.svg?label=License)](https://github.com/quchao/nutshells/blob/master/LICENSE) [![DNSMasq-fast-lookup](https://img.shields.io/badge/DNSMasq-fast--lookup-lightgrey.svg)](https://github.com/infinet/dnsmasq/)

[DNSMasq-fast-lookup](https://github.com/infinet/dnsmasq/) is a fork of the well-known lightweight DNS forwarder [DNSMasq](http://www.thekelleys.org.uk/dnsmasq/doc.html), it aims to improve --ipset/--server/--address lookup performance.


## Variants:

| Tag | Description | 🐳 |
|:-- |:-- |:--:|
| `:latest` | DNSMasq-fast-lookup `2.77test4` on `alpine:latest`. | [![Dockerfile](https://img.shields.io/badge/Dockerfile-latest-22B8EB.svg?style=flat-square&maxAge=2592000)](https://github.com/QuChao/nutshells/blob/master/dnsmasq-fast-lookup/Dockerfile/) |


## Usage

### Synopsis

```
docker run [OPTIONS] nutshells/dnsmasq-fast-lookup [COMMAND] [ARG...]
```

> Learn more about `docker run` [here](https://docs.docker.com/engine/reference/commandline/run/).

### Getting Started

Let's create a dnsmasq container on port `53` with default settings:

``` bash
docker run -d -p 53:12345/udp \
           --name=dnsmasq --restart=unless-stopped --read-only \
           nutshells/dnsmasq-fast-lookup
```

It will get its upstream servers from `/etc/resolv.conf` inside the container, in other words, it inherits the DNS settings from the host by default, `/etc/hosts` as well.

Run this command to see if it works:

``` bash
dig -p 53 google.com @127.0.0.1
```

If you want to customize a container's DNS settings, just refer to [this article](https://docs.docker.com/engine/userguide/networking/configure-dns/), or else you can specify the upstream resolver(s) directly in the [settings](#customizing-settings).

### Customizing settings

There're two ways for you to customize the settings of dnsmasq: setting options from command line or writing them into configuration files. Of course you could use them concurrently.

#### Using configuration files

Please choose a host directory to store the configuration files, let's suppose the path to it is `<conf_dir>`, then we mount it to `/usr/local/etc/dnsmasq` in the container:

``` bash
docker run -d -p 53:12345/udp \
           --name=dnsmasq --restart=unless-stopped --read-only \
           --mount=type=bind,src=<conf_dir>,dst=/usr/local/etc/dnsmasq,readonly \
           nutshells/dnsmasq-fast-lookup
```

All the files ending with `.conf` will be loaded. If you have none of them, please follow [this instruction](#getting-a-configuration-sample) to generate a sample one for yourself.

#### Using command line options

It's much simpler to use options from command line.
There's an example from the [`nutshells/dnscrypt-wrapper`](https://github.com/QuChao/nutshells/tree/master/dnscrypt-wrapper#better-Performance) image, which starts a dnsmasq server with a larger cache size and sets Google's public DNS as its upstream resolver:

> In the example below: all parameters following the `nutshells/dnsmasq-fast-lookup` line are original options of dnsmasq.

``` bash
docker run -d -p 53:12345/udp \
           --name=dnsmasq --restart=unless-stopped --read-only \
           nutshells/dnsmasq-fast-lookup \
           --domain-needed --bogus-priv \
           --server=8.8.8.8 --no-resolv --no-hosts \
           --cache-size=10240
```

### Utilities

Check version, compile-time options & license:

``` bash
docker run --rm --read-only nutshells/dnsmasq-fast-lookup --version
```

Print its original options :

> Please be informed that **some** of the listed options are managed by the container intentionally, you will encounter an exception while trying to set any of them, please follow the exception message to get rid of it.

``` bash
docker run --rm --read-only nutshells/dnsmasq-fast-lookup --help
```

Validate syntax of the configurtation (by adding the `--test` option anytime):

``` bash
docker run [OPTIONS] nutshells/dnsmasq-fast-lookup [COMMAND] [ARG...] --test
```

Show debug messages:

``` bash
docker run [OPTIONS] nutshells/dnsmasq-fast-lookup [COMMAND] [ARG...] -d --log-queries=extra
```


## Reference

### Build Arguments

| Argument | Description | Default |
|:-- |:-- |:--:|
| `WITH_DNSSEC` | Compile with DNSSEC support. Read [more](https://github.com/infinet/dnsmasq/blob/fastlookup-v2.77test4/dnsmasq.conf.example#L23) about related configurations. | `true` |
| `WITH_IDN` | Compile with IDN support. | `true` |

### Useful Paths

| Path in Container | Description | Mount as Readonly |
|:-- |:-- |:--:|
| `/usr/local/etc/dnsmasq` | Directory where configuration files are stored | Y |

### Commands

List available commands:

```
docker run --rm --read-only nutshells/dnsmasq-fast-lookup help
```


## Advanced Topics

### Using Docker-compose

See [the sample file](https://github.com/quchao/nutshells/blob/master/dnsmasq-fast-lookup/docker-compose.yml).

### Getting a configuration sample

Mount `<conf_dir>` as **writable**, then run the `sample` command:

``` bash
docker run --rm --read-only \
           --mount=type=bind,src=<conf_dir>,dst=/usr/local/etc/dnsmasq \
           nutshells/dnsmasq-fast-lookup \
           sample
```

Or get one from [github](https://github.com/infinet/dnsmasq/blob/fastlookup-v2.77test4/dnsmasq.conf.example).

### Enabling DNSSEC validation

No doubt the [DNSSEC](https://en.wikipedia.org/wiki/Domain_Name_System_Security_Extensions) can secure your DNS query results. DNSMasq is DNSSEC-ready, and so is the image.

Frist of all, you should choose some upstream DNS resolvers which perform DNSSEC validation, [Google's Public DNS](https://developers.google.com/speed/public-dns/) is one of them. However normally your local DNS resolver is not capable for DNSSEC, so we have to disable it and use Google's instead:

> [OpenDNS](www.opendns.com/) only supports its DNSCrypt protocol, check [`nutshells/dnscrypt-wrapper`](https://github.com/QuChao/nutshells/tree/master/dnscrypt-wrapper/) for more details.

``` bash
docker run -d -p 53:12345/udp \
           --name=dnsmasq --restart=unless-stopped --read-only \
           nutshells/dnsmasq-fast-lookup
           --no-resolv --server=8.8.8.8 \
           --dnssec --dnssec-check-unsigned \
           --trust-anchor=.,19036,8,2,49AAC11D7B6F6446702E54A1607371607A1A41855200FD2CE1CDDE32F24E8FB5
```

Have a test on a DNSSEC-ready domain, such a `paypal.com` or `quchao.com`:

``` bash
dig -p 53 +dnssec paypal.com @127.0.0.1
```

If you see a `RRSIG` (*Resource Record Signature*) record in the *ANSWER SECTION*, that means you get it correctly configured.

### Gaining a shell access

Get an interactive shell to the container by overwritting the default entrypoint:

``` bash
docker run -it --rm --entrypoint=/bin/ash nutshells/dnsmasq-fast-lookup
```

### Customizing the image

#### By modifying the dockerfile

You may want to make some modifications to the image.
Pull the source code from GitHub, customize it, then build one by yourself:

``` bash
git clone --depth 1 https://github.com/quchao/nutshells.git
docker build -q=false --rm=true --no-cache=true \
             -t nutshells/dnsmasq-fast-lookup \
             -f ./dnsmasq-fast-lookup/Dockerfile \
             ./dnsmasq-fast-lookup
```

#### by using the `--build-arg` options

You can customize the image more easily by using the `--build-arg` options.

> Check out all the **build-time** arguments in [this table](#build-arguments).

Let's disable *DNSSEC* and *IDN* for the image: 

``` bash
git clone --depth 1 https://github.com/quchao/nutshells.git
docker build -q=false --rm=true --no-cache=true \
             -t nutshells/dnsmasq-fast-lookup \
             -f ./dnsmasq-fast-lookup/Dockerfile \
             --build-arg WITH_DNSSEC=false \
             --build-arg WITH_IDN=false \
             ./dnsmasq-fast-lookup
```

#### By committing the changes on a container

Otherwise just pull the image from the official registry, start a container and [get a shell](#gaining-a-shell-access) to it, [commit the changes](https://docs.docker.com/engine/reference/commandline/commit/) afterwards.

``` bash
docker pull nutshells/dnsmasq-fast-lookup
docker run -it --name=dnsmasq-fast-lookup --entrypoint=/bin/ash nutshells/dnsmasq-fast-lookup
docker commit --change "Commit msg" dnsmasq-fast-lookup nutshells/dnsmasq-fast-lookup
```


## Contributing

[![Github Starts](https://img.shields.io/github/stars/quchao/nutshells.svg?style=social&label=Star&maxAge=3600)](https://github.com/quchao/nutshells/) [![Twitter Followers](https://img.shields.io/twitter/follow/chappell.svg?style=social&label=Follow&maxAge=3600)](https://twitter.com/chappell/)

> Follow GitHub's [*How-to*](https://opensource.guide/how-to-contribute/) guide for the basis.

Contributions are always welcome in many ways:

- Give a star to show your fondness;
- File an [issue](https://github.com/quchao/nutshells/issues) if you have a question or an idea;
- Fork this repo and submit a [PR](https://github.com/quchao/nutshells/pulls);
- Improve the documentation.


## Todo

- [x] Add an instruction about how to enable DNSSEC.
- [ ] Add an instruction about how to test IDN.
- [x] Add a `HealthCheck` instruction to indicate the expiration status of certs.
- [ ] Add build-time arguments for [patches](https://github.com/lede-project/source/tree/master/package/network/services/dnsmasq/patches) from the [lede project](https://github.com/lede-project/).


## Acknowledgments & Licenses

Unless specified, all codes of **Project Nutshells** are released under the [MIT License](https://github.com/quchao/nutshells/blob/master/LICENSE).

Other relevant softwares:

| Ware/Lib | License |
|:-- |:--:|
| [Docker](https://www.docker.com/) | [![License](https://img.shields.io/github/license/moby/moby.svg?maxAge=2592000&label=License)](https://github.com/moby/moby/blob/master/LICENSE/) |
| [DNSMasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) | [![License](https://img.shields.io/badge/License-GNU_General_Public_License_v2.0-blue.svg?maxAge=2592000)](http://thekelleys.org.uk/gitweb/?p=dnsmasq.git;a=blob_plain;f=COPYING;hb=HEAD) |
| [DNSMasq-fast-lookup](https://github.com/infinet/dnsmasq/) | [![License](https://img.shields.io/github/license/infinet/dnsmasq.svg?maxAge=2592000&label=License)](https://github.com/infinet/dnsmasq/blob/master/LICENSE/) |


