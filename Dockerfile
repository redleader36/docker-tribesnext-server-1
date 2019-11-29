# Multi-Stage Build (TacoServer)
# This stage compiles the various resources that make up TacoServer
FROM alpine:3.10 as tacobuilder

RUN apk --update add git sed less wget nano openssh && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*

WORKDIR /tmp

RUN git clone --depth 1 "https://github.com/ChocoTaco1/TacoServer/" && cd ./TacoServer \
    && git checkout "a03ff8f66ef7b3e12b3a8514aed8eecf76a50c6c"
WORKDIR /tmp

RUN git clone --depth 1 "https://github.com/ChocoTaco1/TacoMaps/"  && cd ./TacoMaps \ 
    && git checkout "908d952c04caf01091af70c3791b4606bc94395a"
WORKDIR /tmp





# Main Game Server Image
FROM multiarch/debian-debootstrap:i386-jessie
LABEL maintainer="sairuk, amineo, chocotaco"

# ENVIRONMENT
ARG SRVUSER=gameserv
ARG SRVUID=1000
ARG SRVDIR=/tmp/tribes2/
ENV INSTDIR=/home/${SRVUSER}/.wine/drive_c/Dynamix/Tribes2/

# UPDATE IMAGE
RUN apt-get -y update && apt-get -y upgrade


# DEPENDENCIES
RUN apt-get -y install \
# -- access
sudo unzip \
# -- logging
rsyslog \
# -- utilities
sed less nano vim file \
# --- wine
wine \
# -- display
xvfb


# CLEAN IMAGE
RUN apt-get -y clean && apt-get -y autoremove


# ENV
# -- shutup installers
ENV DEBIAN_FRONTEND noninteractive


# USER
# -- add the user, expose datastore
RUN useradd -m -s /bin/bash -u ${SRVUID} ${SRVUSER}
# -- temporarily steal ownership
RUN chown -R root: /home/${SRVUSER}


# SCRIPT - installer
COPY _scripts/tribesnext-server-installer ${SRVDIR}
RUN chmod +x ${SRVDIR}/tribesnext-server-installer
RUN ${SRVDIR}/tribesnext-server-installer


# SCRIPT - server (default)
COPY _scripts/start-server ${INSTDIR}/start-server
RUN chmod +x ${INSTDIR}/start-server


# CLEAN UP TMP
COPY _scripts/clean-up ${SRVDIR}
RUN chmod +x ${SRVDIR}/clean-up
RUN ${SRVDIR}/clean-up


# TacoServer - Pull in resources from builder
COPY --from=tacobuilder /tmp/TacoServer/Classic/. ${INSTDIR}GameData/Classic/.
COPY --from=tacobuilder /tmp/TacoMaps/. ${INSTDIR}GameData/Classic/Maps/


# SCRIPT - custom (custom content / overrides)
COPY _custom/. ${INSTDIR}


# SCRIPT - expand admin prefs
COPY _scripts/cfg-admin-prefs ${SRVDIR}
RUN chmod +x ${SRVDIR}/cfg-admin-prefs


# PERMISSIONS
RUN chown -R ${SRVUSER}: /home/${SRVUSER}


# PORTS
EXPOSE \
# -- tribes
666/tcp \
28000/udp 

USER ${SRVUSER}
WORKDIR ${INSTDIR}

CMD ["./start-server"]

