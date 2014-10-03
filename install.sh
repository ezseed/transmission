#!/bin/bash

if [ -f /etc/init.d/transmission-daemon ]
then
    echo "Transmission is already installed"
    exit 0
else
	apt-get install transmission-daemon -y
	echo "Stopping transmission-daemon"
	/etc/init.d/transmission-daemon stop
fi

exit 0
