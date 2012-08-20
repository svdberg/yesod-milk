#!/bin/sh
#
# Startup script for the milkmachine server
#
# chkconfig: 2345 99 01
# description: This script starts your milkmachine server
# processname: milkmachine-basic
# pidfile: /var/run/milkmachine-basic.pid

# Source function library.
. /etc/rc.d/init.d/functions

# Source networking configuration.
. /etc/sysconfig/network

# Check that networking is up.
[ ${NETWORKING} = "no" ] && exit 0

RETVAL=0

# See how we were called.
case "$1" in
  start)
    echo -n "Starting milkmachine: "
    daemon /home/ec2-user/yesod-milk/milkmachine-new.sh
    RETVAL=$?
    echo
    [ $RETVAL -eq 0 ] && touch /var/lock/subsys/milkmachine-new
    ;;
  stop)
    echo -n "Shutting down milkmachine: "
    killproc yesod-milk
    RETVAL=$?
    echo
    [ $RETVAL -eq 0 ] && rm -f /var/lock/subsys/milkmachine-new
    ;;
  status)
    status milkmachine
    RETVAL=$?
    ;;
  restart|reload)
    $0 stop
    $0 start
    RETVAL=$?
    ;;
  *)
    echo "Usage: milkmachine-new {start|stop|restart|reload|status}"
    exit 1
esac

exit $RETVAL
