FROM debian:wheezy

# Our port
EXPOSE 21/tcp

# Install steps!
RUN echo "deb http://http.debian.net/debian wheezy main\n\
deb-src http://http.debian.net/debian wheezy main\n\
deb http://http.debian.net/debian wheezy-updates main\n\
deb-src http://http.debian.net/debian wheezy-updates main\n\
deb http://security.debian.org wheezy/updates main\n\
deb-src http://security.debian.org wheezy/updates main\n\
" > /etc/apt/sources.list
RUN DEBIAN_FRONTEND=noninteractive apt-get -y update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install dpkg-dev debhelper build-dep pure-ftpd
RUN mkdir /tmp/pure-ftpd/
RUN cd /tmp/pure-ftpd/
RUN apt-get source pure-ftpd
RUN cd pure-ftpd-*
RUN sed -i '/^optflags=/ s/$/ --without-capabilities/g' ./debian/rules
RUN dpkg-buildpackage -b -uc
RUN dpkg -i /tmp/pure-ftpd/pure-ftpd-common*.deb
RUN apt-get -y install openbsd-inetd
RUN dpkg -i /tmp/pure-ftpd/pure-ftpd_*.deb
RUN apt-mark hold pure-ftpd pure-ftpd-common
RUN groupadd ftpgroup
RUN useradd -g ftpgroup -d /dev/null -s /etc ftpuser

# startup
CMD /usr/sbin/pure-ftpd -c 30 -C 1 -l puredb:/etc/pure-ftpd/pureftpd.pdb -x -E -j -R
