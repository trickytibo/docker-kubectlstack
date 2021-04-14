# alpine based
FROM bitnami/kubectl:1.18-debian-10

LABEL maintainer="Thibaut ALLAIN <thibaut.allain29@gmail.com>"
LABEL description="Package with kubectl, helm, kustomize and fluxctl embedded."
LABEL version="1.18-debian-10"

ENV FLUX_VERSION=1.19.0
ENV HELM_VERSION=v3.5.3

USER root

WORKDIR /opt/bitnami

# Install fluxtl tool
RUN install_packages curl jq  \
 && curl -L https://github.com/fluxcd/flux/releases/download/${FLUX_VERSION}/fluxctl_linux_amd64 -o /usr/local/bin/fluxctl \
 && chmod +x /usr/local/bin/fluxctl \
 && chmod 755 /usr/local/bin/fluxctl 

# Install Helm tool 
RUN curl -L https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar xz \ 
 && mv linux-amd64/helm /usr/local/bin/helm \ 
 && chmod 755 /usr/local/bin/helm \
 && rm -rf linux-amd64 

# Install Kustomize 
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash \
 && mv kustomize /usr/local/bin/kustomize \
 && chmod 755 /usr/local/bin/kustomize 
 
USER 1001

ENTRYPOINT [ "/bin/sh", "-c" ]
CMD [ "kubectl --help" ]
