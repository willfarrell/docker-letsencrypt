#!/bin/bash
set -e
#set -x
echo "run"
if [ "${1}" = 'dehydrated' ]; then
    if [ "${LE_ENV}" == 'production' ]; then
        sed -i 's@CA=.*@CA="https://acme-v01.api.letsencrypt.org/directory"@g' /etc/dehydrated/config
    fi
fi

echo "${@}"
exec "${@}"
