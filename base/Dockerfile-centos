FROM centos
LABEL maintainer "Chao QU <mail@quchao.com>"

WORKDIR /usr/bin/

ARG GOSU_VERSION="1.10"

# GoSU
RUN set -ex; \
    # EPEL
    #yum -y install epel-release; \
    # Keep up-to-date
    yum update -y --exclude=kernel*; \
    ARCH="amd64"; \
    GOSU_URL_BASE="https://github.com/tianon/gosu/releases/download/"; \
	curl -L -o gosu "${GOSU_URL_BASE}${GOSU_VERSION}/gosu-${ARCH}"; \
	curl -L -o gosu.asc "${GOSU_URL_BASE}${GOSU_VERSION}/gosu-${ARCH}.asc"; \
    # Verify the signature
	GPG_HOME="$(mktemp -d)"; \
    GPG_KEY_SRV="ha.pool.sks-keyservers.net"; \
    GOSU_GPG_KEY="B42F6819007F00F88E364FD4036A9C25BF357DD4"; \
	gpg --keyserver "${GPG_KEY_SRV}" --recv-keys "${GOSU_GPG_KEY}"; \
	gpg --batch --verify gosu.asc gosu; \
	rm -r "${GPG_HOME}" gosu.asc; \
    # Test flight
	chmod +x gosu; \
	gosu nobody true; \
	# Cleaning
	yum clean all; \
    rm -rf /tmp/* /var/tmp/*;
