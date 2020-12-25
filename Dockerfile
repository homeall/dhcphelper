FROM alpine:latest

RUN apk --no-cache add dhcp-helper

ENV IP=""

EXPOSE 67 67/udp

RUN echo "#!/bin/sh \n dhcp-helper -s ${IP} -n" > ./entrypoint.sh

RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
