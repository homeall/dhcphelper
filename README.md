[![dhcphelper](https://github.com/homeall/dhcphelper/workflows/CI/badge.svg)](https://github.com/homeall/dhcphelper/actions)

# DHCP Relay
This is a small docker image with a [DHCP Helper](http://www.thekelleys.org.uk/dhcp-helper/) useful in case when you have a DHCP server in the docker environment and you need a relay for broadcast.

The DHCP server in the container does get only *unicast the DHCPOFFER messages* when it will have to get **broadcast DHCPOFFER messages** on the [network](https://stackoverflow.com/questions/38816077/run-dnsmasq-as-dhcp-server-from-inside-a-docker-container).

It will **not** work DHCP server in docker even in **networking host mode**.

You can  run as:

```docker run --privileged -d --name dhcp --net host -e "IP=172.31.0.100" homeall/dhcphelper:latest```

## PiHole + DHCP Relay

It will work amazing both together **dhcphelper** and [PiHole](https://hub.docker.com/r/pihole/pihole) 

Simple [docker-compose.yml](https://docs.docker.com/compose/):
```
version: "3.3"

services:
  pihole:
    container_name: pihole
    image: pihole/pihole:latest
    hostname: pihole
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "80:80/tcp"
    environment:
      TZ: 'Europe/London'
      WEBPASSWORD: 'admin'
      DNS1: '127.0.0.53'
      DNS2: 'no'
    volumes:
      - './etc-pihole/:/etc/pihole/'
    depends_on:
      - dhcphelper
    cap_add:
      - NET_ADMIN
    restart: unless-stopped
    networks:
      backend:
        ipv4_address: '172.31.0.100'
      proxy-tier: {}

  dhcphelper:
    restart: unless-stopped
    container_name: dhcphelper
    network_mode: "host"
    image: homeall/dhcphelper:latest
    environment:
      IP: '172.31.0.100'
    cap_add:
      - NET_ADMIN
```
### Testing

You can run a command from Linux/Mac:

```sudo nmap --script broadcast-dhcp-discover -e $Your_Interface```

Output result:

```Starting Nmap 7.91 ( https://nmap.org ) at 2021-01-01 19:40 GMT
Pre-scan script results:
| broadcast-dhcp-discover:
|   Response 1 of 1:
|     Interface: en0
|     IP Offered: 192.168.1.30
|     DHCP Message Type: DHCPOFFER
|     Server Identifier: 172.31.0.100
|     IP Address Lease Time: 2m00s
|     Renewal Time Value: 1m00s
|     Rebinding Time Value: 1m45s
|     Subnet Mask: 255.255.255.0
|     Broadcast Address: 192.168.1.255
|     Domain Name Server: 172.31.0.100
|     Domain Name: lan
|     Router: 192.168.1.1
Nmap done: 0 IP addresses (0 hosts up) scanned in 10.26 seconds
```
