#!/bin/bash
OPT=$1
USERNAME=$2
daemon="transmission-daemon-$2"

d_start() {
  running=$(ps -ef | grep "$daemon" | grep -v grep)
  if [ ! -z "$running" ];
  then
		echo "$daemon is already running" >&2
		return
	else
		/etc/init.d/transmission-daemon-$USERNAME $OPT
	fi

}

d_stop() {
  	/etc/init.d/transmission-daemon-$USERNAME $OPT
}

d_restart() {
	/etc/init.d/transmission-daemon-$USERNAME $OPT
}

case "$1" in
  start)
    d_start
    ;;
  stop)
    d_stop
    ;;
  restart|force-reload)
    d_restart
    ;;
  *)
    echo "Usage: $SCRIPTNAME {start|stop|restart|force-reload} user" >&2
    exit 1
    ;;
esac

exit 0
