FROM alpine:latest

RUN apk --no-cache add dhcp-helper tzdata; \
    rm -rf /var/cache/apk/*;

ENV IP=""

EXPOSE 67/udp

HEALTHCHECK CMD nc -uzvw3 127.0.0.1 67 || exit 1

ENTRYPOINT dhcp-helper -n -s ${IP:-NODATA}
