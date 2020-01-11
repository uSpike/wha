#!/bin/sh -x

if [ -z "${TARGET_HOST:-}" ] || [ -z "${TARGET_PORT:-}" ]; then
    echo "Host / port not set"
    exit 1
fi
if [ -z "${LIBRESPOT_USER:-}" ] || [ -z "${LIBRESPOT_PASSWORD:-}" ]; then
    echo "Host / port not set"
    exit 1
fi

[ ! -e /tmp/snapfifo ] && mkfifo /tmp/snapfifo
sender() {
    while ! nc ${TARGET_HOST} ${TARGET_PORT} </tmp/snapfifo; do
        sleep 1
    done
}
sender &
librespot -v -n ${LIBRESPOT_NAME:-snapcast} -b ${LIBRESPOT_BITRATE:-320} -u ${LIBRESPOT_USER} -p ${LIBRESPOT_PASSWORD} --initial-volume 100 --backend pipe --device /tmp/snapfifo
