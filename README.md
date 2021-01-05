[![dhcphelper](https://github.com/homeall/dhcphelper/workflows/CI/badge.svg)](https://github.com/homeall/dhcphelper/actions) [![pull](https://img.shields.io/docker/pulls/homeall/dhcphelper)](https://img.shields.io/docker/pulls/homeall/dhcphelper) [![pull](https://img.shields.io/docker/image-size/homeall/dhcphelper)](https://img.shields.io/docker/image-size/homeall/dhcphelper) [![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://ionut.vip)


# DHCP Relay in docker

<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
      </ul>
    </li>
    <li>
      <a href="#usage">Usage</a>
      <ul>
        <li><a href="#potentials-issues">Potentials issues</a></li>
      </ul>
       <ul>
        <li><a href="#testing">Testing</a></li>
      </ul>
       <ul>
        <li><a href="#pihole-and-dhcp-relay">PiHole and DHCP Relay</a></li>
      </ul>
    </li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project  

This is a small docker image with a [DHCP Helper](http://www.thekelleys.org.uk/dhcp-helper/) useful in case when you have a DHCP server in the docker environment and you need a relay for broadcast.

The DHCP server in the container does get only *unicast the DHCPOFFER messages* when it will have to get **broadcast DHCPOFFER messages** on the [network](https://stackoverflow.com/questions/38816077/run-dnsmasq-as-dhcp-server-from-inside-a-docker-container).

It will **not** work the DHCP server in docker even in **networking host mode** unless you are using any DHCP relay.

:man_student: If you need to know more about how it works **DHCP protocol**, I highly recommend this [link](https://superuser.com/questions/811501/understanding-dhcp-discovery-specific-subnet). 

<!-- GETTING STARTED -->
## Getting Started

:beginner: It will work on any Linux box amd64 or [Raspberry Pi](https://www.raspberrypi.org) with arm64 or arm32. 

### Prerequisites

[![Made with Docker !](https://img.shields.io/badge/Made%20with-Docker-blue)](https://github.com/homeall/dhcphelper/blob/main/Dockerfile)

You will need to have:

* :whale: [Docker](https://docs.docker.com/engine/install/)
* :whale2: [docker-compose](https://docs.docker.com/compose/) 
 >This step is optional


<!-- USAGE -->
## Usage

You only need to pass as variable the IP address of DHCP server: `"-e IP=X.X.X.X"`

You can run as:

`docker run --privileged -d --name dhcp --net host -e "IP=172.31.0.100" homeall/dhcphelper:latest`

![](dhcphelper.gif)

### Potentials issues

:warning: Please make sure your host has port **67 on UDP** *open* on **iptables/firewall** of your OS and it is running on network host mode **ONLY**.

:bangbang: Run command to check:

```
$ nc -uzvw3 127.0.0.1 67
Connection to 127.0.0.1 port 67 [udp/bootps] succeeded!
```

:hearts: On the status column of the docker, you will notice the `healthy` word. This is telling you that docker is running [healtcheck](https://scoutapm.com/blog/how-to-use-docker-healthcheck) itself in order to make sure it is working properly. Please test yourself using the following command:

```
$ docker inspect --format "{{json .State.Health }}" dhcp | jq
{
  "Status": "healthy",
  "FailingStreak": 0,
  "Log": [
    {
      "Start": "2021-01-04T10:28:11.8070681Z",
      "End": "2021-01-04T10:28:14.8695872Z",
      "ExitCode": 0,
      "Output": "127.0.0.1 (127.0.0.1:67) open\n"
    }
  ]
}
```
:arrow_up: [Go on TOP](#about-the-project) :point_up:

### Testing

:arrow_right: You can run a command from Linux/Mac:

`$ sudo nmap --script broadcast-dhcp-discover -e $Your_Interface`

:arrow_down: Output result:

```
Starting Nmap 7.91 ( https://nmap.org ) at 2021-01-01 19:40 GMT
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

### [PiHole](https://github.com/pi-hole/pi-hole) and DHCP Relay

:moneybag: It will work amazing both together **dhcphelper** and :copyright: [PiHole](https://github.com/pi-hole/pi-hole) :yin_yang:

:sparkle: A simple [docker-compose.yml](https://docs.docker.com/compose/):

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
:arrow_up: [Go on TOP](#about-the-project) :point_up:

<!-- LICENSE -->
## License

:newspaper_roll: Distributed under the MIT license. See [LICENSE](https://raw.githubusercontent.com/homeall/dhcphelper/main/LICENSE) for more information.

<!-- CONTACT -->
## Contact

:red_circle: Please free to open a ticket on Github.

<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements

 * :tada: [@DerFetzer](https://discourse.pi-hole.net/t/dhcp-with-docker-compose-and-bridge-networking/17038) :trophy:
 * :tada: [@Simon Kelley](http://www.thekelleys.org.uk/dhcp-helper/) who is the **author** of *dnsmasq* and *dhcp-helper*. :1st_place_medal:

:arrow_up: [Go on TOP](#about-the-project) :point_up:
