# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential libtool automake clang uthash-dev liblua5.3-dev libpcre3-dev

## Add source code to the build stage.
ADD . /mle
WORKDIR /mle

## Build
RUN CC=clang make

# Package Stage
FROM --platform=linux/amd64 ubuntu:20.04
COPY --from=builder /mle/mle /
COPY --from=builder /lib /lib
COPY --from=builder /mle/corpus /corpus
COPY --from=builder /mle/vendor /vendor
