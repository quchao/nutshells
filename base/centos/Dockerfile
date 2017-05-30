FROM centos
MAINTAINER Chao QU <mail@quchao.com>

WORKDIR /usr/local/src/

ENV GOSU_VERSION='1.10'

# Install EPEL
RUN set -ex; \
    yum -y install epel-release; \
    yum update -y --exclude=kernel*; \
    yum clean all;

# Install GoSU
RUN set -ex; \
    yum -y install dpkg; \
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	curl -L -o /usr/bin/gosu "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-${dpkgArch}"; \
	curl -L -o /tmp/gosu.asc "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-${dpkgArch}.asc"; \
    # Verify the signature
	export GNU_PG_HOME="$(mktemp -d)"; \
	gpg --keyserver 'ha.pool.sks-keyservers.net' --recv-keys 'B42F6819007F00F88E364FD4036A9C25BF357DD4'; \
	gpg --batch --verify /tmp/gosu.asc /usr/bin/gosu; \
	rm -r "${GNU_PG_HOME}" /tmp/gosu.asc; \
    # Test flight
	chmod +x /usr/bin/gosu; \
	gosu nobody true; \
	# Cleaning
	yum -y remove dpkg; \
	yum clean all;
