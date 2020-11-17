FROM python:3.9.0-buster

# set version for s6 overlay
ARG OVERLAY_VERSION="v1.22.0.0"
ARG OVERLAY_ARCH="amd64"

ENV UMASK_SET="022"
ENV CALIBRE_OPTS="--auth-mode basic --userdb /config/users.sqlite --enable-auth"
ENV CALIBRE_LIBRARY_LOCATION="/calibre"

RUN apt-get update -y && \
    apt-get install -y wget libfontconfig libgl1-mesa-glx && \
    apt-get clean && \
    rm -rf /var/cache/apt/* /var/lib/apt/lists/* && \
    cd /tmp && \
    wget -O /tmp/linux-installer.sh https://download.calibre-ebook.com/linux-installer.sh && \
    chmod 755 /tmp/linux-installer.sh && \
    /tmp/linux-installer.sh && \
    curl -o \
     /tmp/s6-overlay.tar.gz -L \
	"https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-${OVERLAY_ARCH}.tar.gz" && \
     tar xfz \
	/tmp/s6-overlay.tar.gz -C / && \
    useradd -u 911 -U -d /config -s /bin/false abc && \
    usermod -G users abc


EXPOSE 8080

COPY root/ /

ENTRYPOINT ["/init"]
