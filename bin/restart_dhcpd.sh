#!/usr/local/bin/bash

DHCPD=/usr/sbin/dhcpd
I=re1

function getPid() {
    PID=$(ps auxww | grep dhcpd | grep -v grep | grep -v restart |  awk '{print $2}')
    echo ${PID}
}

DHCPD_PID=$(getPid)
id=0

while [ $id -eq 0 ]; do
if [ -z "${DHCPD_PID}" ]; then
    ${DHCPD} ${I}
    if [ $? -eq 0 ]; then
        echo "DHCPD restarted successfully."
    else
        echo "Something went wrong."
    fi
elif [ -n "${DHCPD_PID}" ]; then
    echo "DHCPD is already running..."
    ps auxww | grep dhcpd | grep ${I} | grep -v grep
    echo "Restarting..."
    kill ${DHCPD_PID}
    ${DHCPD} ${I}
    echo "DHCPD Restarted with an exit of $?"
    id=1
fi
done
