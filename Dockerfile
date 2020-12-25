FROM alpine:latest

RUN apk --no-cache add dhcp-helper

ENV IP=""

EXPOSE 67 67/udp

ENTRYPOINT dhcp-helper -s ${IP}
