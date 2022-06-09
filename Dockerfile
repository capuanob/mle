# Build Stage
FROM fuzzers/aflplusplus:3.12c as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git clang build-essential libtool automake uthash-dev liblua5.3-dev libpcre3-dev

## Add source code to the build stage.
WORKDIR /
ADD https://api.github.com/repos/capuanob/mle/git/refs/heads/mayhem version.json
RUN git clone -b mayhem https://github.com/capuanob/mle.git
WORKDIR /mle

## Build
RUN CC=clang make -j$(nproc)

## Prepare all library dependencies for copy
RUN mkdir /deps
RUN cp `ldd ./mle | grep so | sed -e '/^[^\t]/ d' | sed -e 's/\t//' | sed -e 's/.*=..//' | sed -e 's/ (0.*)//' | sort | uniq` /deps 2>/dev/null || :

## Package Stage
FROM --platform=linux/amd64 ubuntu:20.04
COPY --from=builder /mle/mle /
COPY --from=builder /deps /usr/lib

CMD ["/mle"]
