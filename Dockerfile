FROM alpine:latest

RUN apk --no-cache add dhcp-helper

ENV IP=""

EXPOSE 67/udp

HEALTHCHECK CMD nc -uzvw3 localhost 67 || exit 1

ENTRYPOINT dhcp-helper -n -s ${IP:-NODATA}
