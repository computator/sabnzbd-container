#!/bin/sh
set -eu

if [ -n "${1:-}" ] && [ "${1}" = "${1##-*}" ] && [ "$1" != "sabnzbd" ]; then
	exec "$@"
fi

[ "${1:-}" == "sabnzbd" ] && shift

exec sabnzbd \
	--config-file /config/sabnzbd.ini \
	--server :8080 \
	--browser 0 \
	--disable-file-log \
	--logging 1 \
	"$@"
