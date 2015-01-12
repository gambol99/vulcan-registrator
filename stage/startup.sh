#!/bin/bash
#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2015-01-09 16:10:42 +0000 (Fri, 09 Jan 2015)
#
#  vim:ts=2:sw=2:et
#

ETCD=${ETCD:-127.0.0.1}
ETCD_PORT=${ETCD_PORT:-4001}
IPADDRESS=${IPADDRESS:-""}
SOCKET=${SOCKET:-/var/run/docker.sock}

failed() {
  echo "[failed] $@"
  exit 1
}

# step: check we have an ip address
[ -z "$IPADDRESS" ] && failed "You need to supply a ip address for the docker host"
# step: check we have a docker socket
[ -S "$SOCKET" ] || failed "You have not specified or mapped in the docker socket: ${SOCKET}"

echo "Starting the Vulcand Registrator service"
ruby /opt/vulcan_registrator/vulcan_registrator -H ${ETCD} -i ${IPADDRESS} -p ${ETCD_PORT} -s ${SOCKET} $@
