# Prepare dynamically-linked HFS library
FROM alpine:3 AS build
ARG DOWNLOAD_URL
WORKDIR /app
RUN apk add --update --no-cache curl zip jq && \
    curl -sLo hfs.zip $DOWNLOAD_URL && \
    unzip hfs.zip && \
    chmod +x hfs && \
    rm -f hfs.zip && \
    rm -rf plugins

# Prepare container only to copy over required libraries
FROM gcr.io/distroless/nodejs22-debian12:nonroot AS deps

# Create minimal image with above dependencies copied
FROM gcr.io/distroless/static-debian12:nonroot
WORKDIR /app
# Copy libraries needed for HFS
COPY --from=deps \
    /lib/x86_64-linux-gnu/libdl.so* \
    /usr/lib/x86_64-linux-gnu/libstdc++.so* \
    /lib/x86_64-linux-gnu/libm.so* \
    /lib/x86_64-linux-gnu/libgcc_s.so* \
    /lib/x86_64-linux-gnu/libpthread.so* \
    /lib/x86_64-linux-gnu/libc.so* \
    /lib/x86_64-linux-gnu/ld-linux-x86-64.so* \
    /lib/x86_64-linux-gnu/
COPY --from=deps /lib64/ld-linux-x86-64.so* /lib64/
# Copy HFS binary with non-root privileges (allowing auto-update)
COPY --from=build --chown=65532:65532 /app/hfs /app
# Change work directory to save config to /app/config
ENTRYPOINT [ "/app/hfs", "--cwd", "/app/config" ]
