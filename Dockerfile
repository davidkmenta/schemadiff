FROM alpine:3.22.1

ARG SCHEMADIFF_VERSION=default_invalid

RUN apk add --no-cache \
    mysql-client \
    mariadb-connector-c-dev \
    tar \
    tzdata \
    wget

RUN wget \
    --no-verbose \
    -O schemadiff.tar.gz \
    "https://github.com/planetscale/schemadiff/releases/download/$SCHEMADIFF_VERSION/schemadiff-linux.tar.gz" \
    && tar -xf schemadiff.tar.gz -C /usr/local/bin \
    && rm schemadiff.tar.gz \
    && chmod +x /usr/local/bin/schemadiff
