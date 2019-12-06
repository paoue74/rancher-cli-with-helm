FROM alpine:3.8
LABEL maintainer="Fabien OUEDRAOGO <opaf.info@gmail.com>"

# Install Utils
RUN apk add --update --no-cache -t deps openssl ca-certificates git bash curl wget tar gzip

# Install Kubectl
ENV KUBERNETES_VERSION=v1.15.6

RUN apk --update --no-cache add curl \
    && curl -LO https://storage.googleapis.com/kubernetes-release/release/$KUBERNETES_VERSION/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

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

RUN adduser -S rancher
USER rancher

WORKDIR /home/rancher

RUN mkdir -p .kube/


# ENTRYPOINT [ "/usr/local/bin/helm" ]