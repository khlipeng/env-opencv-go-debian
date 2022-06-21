ARG OPENCV_VERSION
ARG GOLANG_VERSION
ARG TARGETARCH

FROM ghcr.io/khlipeng/opencv-debian:$OPENCV_VERSION-$TARGETARCH

LABEL maintainer="khlipeng"
LABEL DATE="2022-06-20"

ARG TARGETARCH
ARG GOLANG_VERSION


RUN apt-get update && apt-get install -y --no-install-recommends \
            git software-properties-common && \
            rm -rf /var/lib/apt/lists/*

RUN set -eux; curl -o go.tgz -fsSL https://dl.google.com/go/go${GOLANG_VERSION}.linux-${TARGETARCH}.tar.gz && \
            tar -C /usr/local -xf go.tgz && \
            rm go.tgz
            

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

WORKDIR $GOPATH
