FROM docker.io/library/python:3-alpine

LABEL org.opencontainers.image.source=https://github.com/computator/sabnzbd-container

ENV SABNZBD_PATH=/opt/sabnzbd
RUN set -eux; \
	RELEASE_SRC_URL=$(\
		wget -qO - https://api.github.com/repos/sabnzbd/sabnzbd/releases/latest \
			| grep -e 'browser_download_url.*src\.tar\.gz' \
			| cut -d '"' -f 4 \
		); \
	install -d ${SABNZBD_PATH}; \
	cd ${SABNZBD_PATH}; \
	wget -qO - ${RELEASE_SRC_URL} | tar -xz --strip-components 1; \
	pip3 install --no-cache-dir --root-user-action=ignore -r requirements.txt; \
	rm -r tests; \
	find -type f -name '*.py' | xargs sed -Ei '1 s%/usr/bin/python3%/usr/local/bin/python3%'; \
	tools/make_mo.py; \
	echo -e '#!/bin/sh\ncd $SABNZBD_PATH && exec ./SABnzbd.py "$@"' > /usr/local/bin/sabnzbd; \
	chmod 755 /usr/local/bin/sabnzbd


COPY entrypoint.sh /

RUN set -eux; \
	mkdir -p /config /data; \
	printf '%s\n' \
		'[misc]' \
		'dirscan_dir = /data/incoming' \
		'download_dir = /data/incomplete' \
		'complete_dir = /data/complete' \
		'url_base = /' \
		| tee /config/sabnzbd.ini

VOLUME /config
VOLUME /data

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
