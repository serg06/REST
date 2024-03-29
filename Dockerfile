FROM harbor.disembark.dev/libs/libwebp:latest as libwebp

FROM golang:1.17.3-alpine as builder

WORKDIR /tmp/rest

COPY . .

ARG BUILDER
ARG VERSION

ENV REST_BUILDER=${BUILDER}
ENV REST_VERSION=${VERSION}

RUN apk add --no-cache make git && \
    make linux

FROM harbor.disembark.dev/libs/ffmpeg:latest

COPY --from=libwebp /libwebp/webpmux /usr/bin

WORKDIR /app

COPY --from=builder /tmp/rest/bin/rest .

ENTRYPOINT ["./rest"]
