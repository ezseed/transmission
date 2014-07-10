#!/bin/bash
#You need to restart daemon to take changes
USERNAME=$1
PASSWORD=$2
RPC_PORT=$3

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_DIR="/usr/local/opt/ezseed" #not used
USER_HOME=$(su - $USERNAME -c 'cd ~/ && echo $HOME')

#Adding user to group
adduser $USERNAME debian-transmission
#could root it, see chroot
chown -R $USERNAME /home/$USERNAME/
su $USERNAME -c "mkdir -p ~/downloads ~/uploads ~/incomplete"

#Set new transmission-daemon-$USERNAME
cp /usr/bin/transmission-daemon /usr/bin/transmission-daemon-$USERNAME
cp /etc/init.d/transmission-daemon /etc/init.d/transmission-daemon-$USERNAME
cp -a /var/lib/transmission-daemon /var/lib/transmission-daemon-$USERNAME
cp -a /etc/transmission-daemon /etc/transmission-daemon-$USERNAME
cp /etc/default/transmission-daemon /etc/default/transmission-daemon-$USERNAME


sed 's/NAME=transmission-daemon/NAME=transmission-daemon-'$USERNAME'/' < /etc/init.d/transmission-daemon-$USERNAME >/etc/init.d/transmission-daemon-$USERNAME.new

mv /etc/init.d/transmission-daemon-$USERNAME.new /etc/init.d/transmission-daemon-$USERNAME

sed 's/USER=debian-transmission/USER='$USERNAME'/' < /etc/init.d/transmission-daemon-$USERNAME > /etc/init.d/transmission-daemon-$USERNAME.new

mv /etc/init.d/transmission-daemon-$USERNAME.new /etc/init.d/transmission-daemon-$USERNAME

sed 's/CONFIG_DIR="\/var\/lib\/transmission-daemon\/info"/CONFIG_DIR="\/var\/lib\/transmission-daemon-'$USERNAME'\/info"/' </etc/default/transmission-daemon-$USERNAME >/etc/default/transmission-daemon-$USERNAME.new

mv /etc/default/transmission-daemon-$USERNAME.new /etc/default/transmission-daemon-$USERNAME

#Repair rights
chmod 755 /usr/bin/transmission-daemon-$USERNAME
chmod 755 /etc/init.d/transmission-daemon-$USERNAME
chmod -R 755 /var/lib/transmission-daemon-$USERNAME
chmod -R 755 /etc/transmission-daemon-$USERNAME
chmod 755 /etc/default/transmission-daemon

$CONFIG_FILE = $USER_HOME/.settings.$USERNAME.json

ln -sf /etc/transmission-daemon-$USERNAME/settings.json $CONFIG_FILE
ln -sf /etc/transmission-daemon-$USERNAME/settings.json /var/lib/transmission-daemon-$USERNAME/info/settings.json

#Editing settings
node $DIR/json.js $CONFIG_FILE incomplete-dir-enabled true
node $DIR/json.js $CONFIG_FILE incomplete-dir "$USER_HOME/incomplete"
node $DIR/json.js $CONFIG_FILE download-dir "$USER_HOME/downloads"
node $DIR/json.js $CONFIG_FILE peer-port-random-on-start true
node $DIR/json.js $CONFIG_FILE lpd-enabled true
node $DIR/json.js $CONFIG_FILE peer-socket-tos 'lowcost'
node $DIR/json.js $CONFIG_FILE rpc-password $PASSWORD
node $DIR/json.js $CONFIG_FILE rpc-enabled true
node $DIR/json.js $CONFIG_FILE rpc-whitelist-enabled false
node $DIR/json.js $CONFIG_FILE rpc-authentication-required true
node $DIR/json.js $CONFIG_FILE rpc-username $USERNAME

chown -R $USERNAME:$USERNAME /var/lib/transmission-daemon-$USERNAME
chown -R $USERNAME:$USERNAME /etc/transmission-daemon-$USERNAME

chmod 775 $USER_HOME/.settings.$USERNAME.json
chmod -R 755 /etc/transmission-daemon-$USERNAME

exit 0
