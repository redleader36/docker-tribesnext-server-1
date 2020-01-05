# Containerized Tribes 2 Linux Dedicated Game Server

## Inspiration
TribesNext is an amazing project. If it weren’t for Tythe I'm not sure where this community would be. Thank you!  

- Running a TribesNext patched Tribes 2 Linux Game Server under Wine chugs on its calls to the Ruby library, mainly during its sha1 calcs. It's not that noticeable in windows, but in Linux this causes the infamous player join stutter that pauses the whole server for about a second. As you can imagine, in Tribes this is an eternity and extremely disruptive.
- Reproducable architecture
- Linux servers are cheaper and running a game server in docker swarm is hilarious ;)
- Science! 

---

## Read This!
First thing you should know:  
**This does not use TribesNext's auth system because TribesNext does not support Linux. It does however use the master server.**

What does this mean?  
**The server will show up normally in the joinable list but because it does not verify the player against TribesNext's auth, this could allow smurfs.**

---

## Prerequisites
 - Ubuntu *(Will likely work on other distros but this is what I've tested on)*
 - [Docker installed](HOW_TO_INSTALL_DOCKER.md)
 - [Docker Swarm](HOW_TO_INSTALL_DOCKER.md)
 - PORTS 28000/UDP, 666/TCP open on your firewall.

**[If you need to install Docker and Docker Swarm. Read this.](HOW_TO_INSTALL_DOCKER.md)**

---

## About the Dockerfile



## Setup

- Add swarm secrets
- Build and push the image
- Deploy stack



---

## Credits

*This is TribesNext RC2a with the wine patches included.*

The image will pull required files and install them at build time (providing the sources are live). 

Docker image is completely self contained when built; it is currently based off Debian Jessie 32bit. This brings in the server at around 1.6GB once built.

The server runs as the gameserv user


## Ports
Exposed ports are `666`, `28000`, the standard TribesNext ports, these can be mapped to whatever you need when you run the container, example below.


## Volumes
No volumes are used


## Usage
**Build the image**

`docker build . -t tribesnext-server`

**Run a container**

NB: the `--rm` arg will destroy the container when stopped; internal ports (666) can be mapped to available host ports (27999) per container
```
docker run -d --rm \
-p 27999:666/tcp \
-p 28000:28000/udp \
--name tribesnext-server \
tribesnext-server:latest
```

**Stop container**

`docker stop tribesnext-server`


## Server Customization
You can customize the server at build time by dropping the appropriate files at the appropriate locations in `_custom/`, these will be copied into the image into the install location within the container at build time.


You can override the following defaults at build time
```
ARG SRVUSER=gameserv
ARG SRVUID=1000
ARG SRVDIR=/tmp/tribes2/
```

You can also override the start-server script by added one to _custom this will overwrite the default at build time.



## Notes
You can modify the installer script to update the source locations of the required files.

`tribesnext-server-installer` may also be used in standalone mode to install TribesNext RC2a on the host system under wine but your mileage may vary.

Testing has been minimal but it is running the NET247 server so you can try it out at any point.

## 2do
* Thinner base OS
* Reduce duplicate data across scripts

