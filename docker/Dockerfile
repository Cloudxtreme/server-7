# Using Ubuntu base image modified for Docker-friendliness
# https://github.com/phusion/baseimage-docker
FROM phusion/baseimage:0.9.18
CMD ["/sbin/my_init"]
EXPOSE 25565

RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get -qqy update \
&& apt-get -qqy install software-properties-common python-software-properties screen \
&& add-apt-repository -y ppa:webupd8team/java \
&& apt-get -qqy update \
&& echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
&& echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections \
&& apt-get -qqy install oracle-java8-installer \
&& rm -rf /var/lib/{apt,cache,log}/

RUN adduser --disabled-password --gecos '' minecraft

COPY server /home/minecraft/server
COPY init /home/minecraft/init
COPY s3cmd-1.6.0 /usr/local/s3cmd

RUN mkdir -p /etc/service/minecraft \
&& mkdir -p /home/minecraft/mcbackup \
&& mkdir -p /home/minecraft/server/worlds \
&& mkdir -p /home/minecraft/server/dynmap \
&& mkdir -p /home/minecraft/server/mods \
&& mkdir -p /home/minecraft/server/logs \
&& mkdir -p /home/minecraft/server/plugins \
&& mkdir -p /home/minecraft/server/config \
&& mkdir -p /home/minecraft/server/config-server \
&& ln -s /home/minecraft/init/minecraft.runit /etc/service/minecraft/run \
&& chmod +x /home/minecraft/init/b2 \
&& chmod +x /usr/local/s3cmd/s3cmd \
&& chmod +x /home/minecraft/init/minecraft \
&& chmod +x /home/minecraft/init/minecraft.runit \
&& ln -s /home/minecraft/init/minecraft /usr/bin/minecraft \
&& ln -s /home/minecraft/init/b2 /usr/bin/b2 \
&& ln -s /usr/local/s3cmd/s3cmd /usr/bin/s3cmd

ENV "TERM=xterm"
ENV LANG ru_RU.UTF-8

RUN locale-gen ru_RU && locale-gen ru_RU.UTF-8 && dpkg-reconfigure locales

VOLUME ["/home/minecraft/mcbackup", "/home/minecraft/server/dynmap", "/home/minecraft/server/worlds", "/home/minecraft/server/plugins", "/home/minecraft/server/mods", "/home/minecraft/server/config", "/home/minecraft/server/logs", "/home/minecraft/server/config-server"]
