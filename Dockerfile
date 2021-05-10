FROM alpine:3

WORKDIR /usr/src/kinbal

RUN apk update && \
    apk add jq gzip nano tar git unzip wget sudo bash openssl groff less

# Install AWS CLI (alpine does not have packages for AWSCLI v2)
RUN apk --no-cache add \
    binutils \
    curl \
    && GLIBC_VER=$(curl -s https://api.github.com/repos/sgerrand/alpine-pkg-glibc/releases/latest | grep tag_name | cut -d : -f 2,3 | tr -d \",' ') \
    && curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk \
    && apk add --no-cache \
    glibc-${GLIBC_VER}.apk \
    glibc-bin-${GLIBC_VER}.apk \
    && curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && unzip awscliv2.zip \
    && aws/install \
    && rm -rf \
    awscliv2.zip \
    aws \
    /usr/local/aws-cli/v2/*/dist/aws_completer \
    /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
    /usr/local/aws-cli/v2/*/dist/awscli/examples \
    && apk --no-cache del \
    binutils \
    && rm glibc-${GLIBC_VER}.apk \
    && rm glibc-bin-${GLIBC_VER}.apk \
    && rm -rf /var/cache/apk/*

RUN apk add terraform --repository=http://dl-cdn.alpinelinux.org/alpine/v3.13/community
RUN apk add kubectl --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing

RUN curl -fsSL https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | DESIRED_VERSION=v2.17.0 sh

COPY . .

ENTRYPOINT /bin/sh
