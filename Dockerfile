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
# Set labels for Open Container Initiative (OCI) image
LABEL org.opencontainers.image.source=https://github.com/patschi/hfs-docker
LABEL org.opencontainers.image.description="Includes HFS application from https://github.com/rejetto/hfs"
LABEL org.opencontainers.image.licenses=MIT
# Set workdir
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

EXPOSE 80/tcp
EXPOSE 443/tcp

# Change work directory to save config to /app/config
ENTRYPOINT [ "/app/hfs", "--cwd", "/app/config" ]
