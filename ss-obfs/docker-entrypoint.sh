#!/bin/sh
set -e

# user setting
ENTRYPOINT_USER='shadowsocks'

# params
ENTRYPOINT_CMD=$1
shift
ENTRYPOINT_PARAMS=$@

# conf file
if [ "${ENTRYPOINT_CMD}" = 'ss-server' ]; then
    SS_MODE='server'
else
    SS_MODE='client'
fi

# exec ENTRYPOINT_COMMAND as specified user
exec su-exec \
  $ENTRYPOINT_USER \
  $ENTRYPOINT_CMD -c "/etc/shadowsocks-libev/${SS_MODE}.json" \
  $ENTRYPOINT_PARAMS
