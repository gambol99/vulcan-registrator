#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2015-01-12 12:35:12 +0000 (Mon, 12 Jan 2015)
#
#  vim:ts=2:sw=2:et
#
FROM progrium/busybox
MAINTAINER <gambol99@gmail.com>

RUN opkg-install curl
RUN mkdir -p /opt/vulcand/bin; mkdir -p /opt/vulcand/release
RUN curl -kLs https://github.com/mailgun/vulcand/releases/download/v0.8.0-alpha.4/vulcand-v0.8.0-alpha.4-linux-amd64.tar.gz > /opt/vulcand/release/vulcand.tar.gz
RUN gzip -d /opt/vulcand/release/vulcand.tar.gz; tar -xvf /opt/vulcand/release/vulcand.tar -C /opt/vulcand/release
RUN cp /opt/vulcand/release/vulcand-*-linux-amd64/* /opt/vulcand/bin
RUN chmod +x /opt/vulcand/bin/v*

ENTRYPOINT [ "/opt/vulcand/bin/vulcand" ]
