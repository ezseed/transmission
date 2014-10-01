#!/bin/bash
USERNAME=$1
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_DIR="/usr/local/opt/ezseed"
USER_HOME=$(su - $USERNAME -c 'cd ~/ && echo $HOME')

/etc/init.d/transmission-daemon-$USERNAME stop

killall -9 -u $USERNAME

rm /usr/bin/transmission-daemon-$USERNAME
rm /etc/init.d/transmission-daemon-$USERNAME
rm -r /var/lib/transmission-daemon-$USERNAME
rm -r /etc/transmission-daemon-$USERNAME
rm /etc/default/transmission-daemon-$USERNAME

rm $USER_HOME/.settings.$USERNAME.json

exit 0
