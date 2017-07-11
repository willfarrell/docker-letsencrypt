#!/bin/bash
set -e
#set -x

if [ "${LOG}" == "TRUE" ]; then
    LOG_DIR=/var/log/letsencrypt
	LOG_FILE=${LOG_DIR}/runtime.log
	mkdir -p ${LOG_DIR}
	touch ${LOG_FILE}

	UUID=$(cat /proc/sys/kernel/random/uuid)
	exec > >(read message; echo "${UUID} $(date -Iseconds) [info] $message" | tee -a ${LOG_FILE} )
	exec 2> >(read message; echo "${UUID} $(date -Iseconds) [error] $message" | tee -a ${LOG_FILE} >&2)
fi

if [ "${LE_ENV}" == 'production' ]; then
	echo "***** ${LE_ENV} *****"
	sed -i 's@CA=.*@CA="https://acme-v01.api.letsencrypt.org/directory"@g' /etc/dehydrated/config
else
	echo "***** staging *****"
fi

# comma = new line
if [ "${LE_DOMAIN}" ]; then
    echo "***** Creating domains.txt *****"
    echo ${LE_DOMAIN} | sed -e $'s/,/\\\n/g' > /etc/dehydrated/domains.txt
    cat /etc/dehydrated/domains.txt
fi

echo "${@}"
exec "${@}"
