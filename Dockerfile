# builder stage
FROM alpine:latest AS builder

RUN apk add --no-cache dhcp-helper tzdata netcat-openbsd

# create output dir
RUN mkdir -p /out/bin /out/usr/sbin /out/usr/bin /out/usr/share/zoneinfo /out/lib /out/usr/lib

# copy binaries and minimal files
RUN cp /usr/sbin/dhcp-helper /out/usr/sbin/ \
    && cp /usr/bin/nc /out/usr/bin/ \
    && cp /bin/sh /out/bin/ \
    && cp -r /usr/share/zoneinfo /out/usr/share/ \
    && cp -P /lib/ld-musl-*.so.1 /out/lib/ \
    && cp -P /lib/libc.musl-*.so.1 /out/lib/ \
    && cp -P /usr/lib/libbsd.so.0* /out/usr/lib/

COPY entrypoint.sh /out/entrypoint.sh
RUN chmod +x /out/entrypoint.sh

# final stage
FROM gcr.io/distroless/base-debian12:latest

COPY --from=builder /out/ /
EXPOSE 67/udp
HEALTHCHECK CMD ["/usr/bin/nc","-uzvw3","127.0.0.1","67"]

ENTRYPOINT ["/bin/sh","/entrypoint.sh"]
