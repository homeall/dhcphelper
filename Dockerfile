FROM alpine:latest

RUN apk --no-cache add dhcp-helper

ENV IP=""

EXPOSE 67 67/udp

HEALTHCHECK --interval=5s --timeout=3s --start-period=5s CMD nc -uzvw3 localhost 67 || exit 1

ENTRYPOINT dhcp-helper -n -s ${IP:-NODATA}
