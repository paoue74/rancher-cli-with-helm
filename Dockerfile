FROM alpine:3.8
LABEL maintainer="Fabien OUEDRAOGO <opaf.info@gmail.com>"


RUN apk add --update --no-cache openssl ca-certificates git bash

WORKDIR /

# Install Utils
RUN apk add --update -t deps curl wget tar gzip

# Install HELM
RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh

# Install Rancher CLI
ENV RANCHER_CLI_VERSION=v2.3.2
ENV FILENAME=rancher-linux-amd64-${RANCHER_CLI_VERSION}.tar.gz

RUN wget https://github.com/rancher/cli/releases/download/${RANCHER_CLI_VERSION}/${FILENAME} && \
    tar -xf ${FILENAME} && \
    mv rancher-${RANCHER_CLI_VERSION}/rancher /usr/bin/rancher && \
    chmod a+x /usr/bin/rancher

# Clean
RUN rm -rf rancher-${RANCHER_CLI_VERSION}

# ENTRYPOINT [ "/usr/local/bin/helm" ]