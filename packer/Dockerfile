FROM alpine:3.8

## Image metadata ##

LABEL maintainer="stuart@stuartellis.name" \
     version="0.2.0" \
    description="Packer builder"

ENV PACKER_VERSION 1.3.3
ENV PACKER_BINARY packer_${PACKER_VERSION}_linux_amd64.zip

RUN apk add --update wget ca-certificates && \
  rm /var/cache/apk/*

## Install Packer ##

RUN wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/${PACKER_BINARY} && \
  unzip ${PACKER_BINARY} && \
  rm -r ${PACKER_BINARY} && \
  mv packer /usr/local/bin

## Run ##

WORKDIR /var/local
