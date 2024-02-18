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
	wget -qO - ${RELEASE_SRC_URL} | tar -C ${SABNZBD_PATH} -xz --strip-components 1; \
	pip3 install --no-cache-dir --root-user-action=ignore -r ${SABNZBD_PATH}/requirements.txt; \
	find ${SABNZBD_PATH} -type f -name '*.py' | xargs sed -Ei '1 s%/usr/bin/python3%/usr/local/bin/python3%'; \
	${SABNZBD_PATH}/tools/make_mo.py

