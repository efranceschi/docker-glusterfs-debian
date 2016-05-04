FROM debian:wheezy
MAINTAINER Eduardo Franceschi <eduardo.franceschi@wiseinformatica.com>
EXPOSE 24007
EXPOSE 24008

# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

# Gluster repository key
ADD http://download.gluster.org/pub/gluster/glusterfs/3.5/3.5.2/Debian/wheezy/pubkey.gpg /tmp
RUN apt-key add /tmp/pubkey.gpg && rm -f /tmp/pubkey.gpg

# Add gluster debian repo
RUN echo deb http://download.gluster.org/pub/gluster/glusterfs/3.5/3.5.2/Debian/wheezy/apt wheezy main > /etc/apt/sources.list.d/gluster.list

# Update package cache
RUN apt-get update

# Install Gluster
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install glusterfs-server

# Copy init script
COPY init.sh /etc/init.sh
RUN chmod a+x /etc/init.sh

# Clean
RUN apt-get clean

ENTRYPOINT /etc/init.sh

