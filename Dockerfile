FROM rust:1.79-alpine@sha256:a454f49f2e15e233f829a0fd9a7cbdac64b6f38ec08aeac227595d4fc6eb6d4d as server_builder

RUN apk add musl-dev pkgconfig wget

RUN wget -O sccache.tar.gz https://github.com/mozilla/sccache/releases/download/v0.8.1/sccache-v0.8.1-$(uname -m)-unknown-linux-musl.tar.gz \
    && tar xzf sccache.tar.gz \
    && mv sccache-v0.8.1-$(uname -m)-unknown-linux-musl/sccache /usr/local/bin/sccache \
    && chmod +x /usr/local/bin/sccache;

ENV SCCACHE_DIR=/sccache-cache
ENV RUSTC_WRAPPER="/usr/local/bin/sccache"

RUN mkdir /app
COPY / app/
WORKDIR /app

RUN --mount=type=cache,target=/sccache-cache cargo build --release && sccache --show-stats

# final image
FROM alpine:3.20@sha256:b89d9c93e9ed3597455c90a0b88a8bbb5cb7188438f70953fede212a0c4394e0

RUN apk add vips-tools

RUN mkdir /app

COPY --from=server_builder /app/target/release/rust-cache-test /app/rust-cache-test

CMD ["/app/rust-cache-test"]
