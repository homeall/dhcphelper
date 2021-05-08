FROM alpine:latest

RUN apk add --no-cache dhcp-helper tzdata; \
    rm -rf /var/cache/apk/*;

ENV IP=""

EXPOSE 67/udp

HEALTHCHECK CMD nc -uzvw3 127.0.0.1 67 || exit 1

ENTRYPOINT dhcp-helper -n -s ${IP:-NODATA}
