# Base Image of Project Nutshells 🌰

[![Project Nutshells](https://img.shields.io/badge/Project-_Nutshells_🌰-orange.svg)](https://github.com/quchao/nutshells/) [![Docker Repo](https://img.shields.io/badge/Docker-Repo-22B8EB.svg)](https://hub.docker.com/r/nutshells/base/) [![Alpine Based](https://img.shields.io/badge/Alpine-3.6-0D597F.svg)](http://alpinelinux.org/) [![CentOS Based](https://img.shields.io/badge/CentOS-7.3-932279.svg)](https://www.centos.org/) [![MIT License](https://img.shields.io/github/license/quchao/nutshells.svg?label=License)](https://github.com/quchao/nutshells/blob/master/LICENSE)


## Variants:

| Tag | Description | 🐳 |
|:-- |:-- |:--:|
| `:latest` | Based on `alpine:latest`, includes a handy tool named [su-exec](https://github.com/ncopa/su-exec/) to exec cmds with different privileges in containers. | [Dockerfile](https://github.com/QuChao/nutshells/blob/master/base/Dockerfile) |
| `:edge` | Based on `alpine:edge`. | [Dockerfile-edge](https://github.com/QuChao/nutshells/blob/master/base/Dockerfile-edge) |
| `:centos` | Based on `centos:latest` with [EPEL](https://fedoraproject.org/wiki/EPEL) & [gosu](https://github.com/tianon/gosu/) pre-installed. | [Dockerfile-centos](https://github.com/QuChao/nutshells/blob/master/base/Dockerfile-centos) |


## Usage

### Customizing the image

#### By modifying the dockerfile

You may want to make some modifications to the image.
Pull the source code from GitHub, customize it, then build one by yourself:

> Get `<:img_tag>` & `<dockerfile_name>` from [this sheet](#variants).

``` bash
git clone --depth 1 https://github.com/quchao/nutshells.git
docker build -q=false --rm=true --no-cache=true \
             -t nutshells/base<:img_tag> \
             -f ./base/<dockerfile_name> \
             ./base
```

#### By committing the changes on a container

Otherwise just pull the image from the official registry, start a container and get a shell to it, [commit the changes](https://docs.docker.com/engine/reference/commandline/commit/) afterwards.

``` bash
docker pull nutshells/base
docker run -it --name=base nutshells/base /bin/ash
docker commit --change "Commit msg" base nutshells/base
```


## Contributing

> Follow GitHub's [*How-to*](https://opensource.guide/how-to-contribute/) guide for the basis.

Contributions are always welcome in many ways:

- Give a star to show your fondness;
- File an [issue](https://github.com/quchao/nutshells/issues) if you have a question or an idea;
- Fork this repo and submit a [PR](https://github.com/quchao/nutshells/pulls);
- Improve the documentation.


## Acknowledgments & Licenses

Unless specified, all codes of **Project Nutshells** are released under the [MIT License](https://github.com/quchao/nutshells/blob/master/LICENSE).

Other relevant softwares:

| Ware/Lib | License |
|:-- |:--:|
| [Docker](https://www.docker.com/) | [Apache 2.0](https://github.com/moby/moby/blob/master/LICENSE) |
| [Official Alpine Docker image](https://github.com/gliderlabs/docker-alpine) | [BSD 2-clause "Simplified"](https://github.com/gliderlabs/docker-alpine/blob/master/LICENSE) |
| [Official CentOS Docker image](https://github.com/CentOS/sig-cloud-instance-images) | GNU GPL v2.0 |
| [su-exec](https://github.com/ncopa/su-exec/) | [MIT](https://github.com/ncopa/su-exec/blob/master/LICENSE) |
| [EPEL](https://fedoraproject.org/wiki/EPEL) | [Various](https://fedoraproject.org/wiki/Licensing:Main?rd=Licensing) |
| [gosu](https://github.com/tianon/gosu/) | [GNU GPL v3.0](https://github.com/tianon/gosu/blob/master/LICENSE) |
