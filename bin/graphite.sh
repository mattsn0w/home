#!/bin/bash
### BEGIN INIT INFO
# Provides:          graphite
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the Graphite carbon daemon and Gunicorn server
# Description:       starts graphite services using start-stop-daemon
### END INIT INFO


PYTHON=/usr/bin/python
GUNICORN=/usr/local/bin/gunicorn
GUNICORN_LOG=/opt/graphite/storage/log/webapp/gunicorn.log
GUNICORN_PID=/var/run/gunicorn.pid

GRAPHITE_DIR=/opt/graphite/webapp/graphite


function start_graphite() {
    cd ${GRAPHITE_DIR}
    ${PYTHON} ${GUNICORN} -b 127.0.0.1:8080 -w2 -u graphite -g graphite --log-file=${GUNICORN_LOG} graphite_wsgi:application &
    echo $! > $GUNICORN_PID
    sleep 1
    ${GRAPHITE_DIR}/../../bin/carbon-cache.py start
}

function stop_graphite() {
    pid=$(cat $GUNICORN_PID)
    kill ${pid}
    if [ $? -eq 0 ]; then
        rm $GUNICORN_PID
    fi
    ${GRAPHITE_DIR}/../../bin/carbon-cache.py stop
}

case "$1" in
    start)
        start_graphite
    ;;
    stop)
        stop_graphite
    ;;
    restart)
        start_graphite
        stop_graphite
    ;;
    *)
        echo "$0 [start|stop|restart]"
    ;;
esac


