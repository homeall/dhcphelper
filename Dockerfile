FROM arm64v8/alpine:latest

RUN apk --no-cache add dhcp-helper

EXPOSE 67 67/udp

ENTRYPOINT ["dhcp-helper", "-n"]
