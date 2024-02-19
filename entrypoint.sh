#!/bin/sh
set -eu

if [ -n "${1+x}" ] && [ "${1}" = "${1##-*}" ]; then
	exec "$@"
fi

exec sabnzbd \
	--config-file /config/sabnzbd.ini \
	--server :8080 \
	--browser 0 \
	--disable-file-log \
	--logging 1 \
	"$@"
