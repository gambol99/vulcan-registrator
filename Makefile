#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2015-01-09 16:20:08 +0000 (Fri, 09 Jan 2015)
#
#  vim:ts=2:sw=2:et
#
NAME=vulcan-registrator
AUTHOR=gambol99
VERSION=0.0.1

build:
	docker build -t ${AUTHOR}/${NAME} .

vulcand:
	docker build -t ${AUTHOR}/vulcand vulcand/

.PHONY: build vulcand
