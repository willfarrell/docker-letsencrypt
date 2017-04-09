#!/bin/bash
set -e
#set -x

if [ "${LE_ENV}" == 'production' ]; then
	sed -i 's@CA=.*@CA="https://acme-v01.api.letsencrypt.org/directory"@g' /etc/dehydrated/config
fi

echo "${@}"
exec "${@}"
