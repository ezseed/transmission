#!/bin/bash
#You need to restart daemon to take changes
USERNAME=$1
PASSWORD=$2
RPC_PORT=$3

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_DIR="/usr/local/opt/ezseed" #not used
USER_HOME=$(su - $USERNAME -c 'cd ~/ && echo $HOME')

if [ ! -e /etc/init.d/transmission-daemon ]
then
    echo "Transmission is not installed"
    exit 1
fi

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
cp /lib/systemd/system/transmission-daemon.service /lib/systemd/system/transmission-daemon-$USERNAME.service

sed 's/NAME=transmission-daemon/NAME=transmission-daemon-'$USERNAME'/' < /etc/init.d/transmission-daemon-$USERNAME >/etc/init.d/transmission-daemon-$USERNAME.new

mv /etc/init.d/transmission-daemon-$USERNAME.new /etc/init.d/transmission-daemon-$USERNAME

sed 's/USER=debian-transmission/USER='$USERNAME'/' < /etc/init.d/transmission-daemon-$USERNAME > /etc/init.d/transmission-daemon-$USERNAME.new

mv /etc/init.d/transmission-daemon-$USERNAME.new /etc/init.d/transmission-daemon-$USERNAME

sed 's/CONFIG_DIR="\/var\/lib\/transmission-daemon\/info"/CONFIG_DIR="\/var\/lib\/transmission-daemon-'$USERNAME'\/info"/' </etc/default/transmission-daemon-$USERNAME >/etc/default/transmission-daemon-$USERNAME.new

mv /etc/default/transmission-daemon-$USERNAME.new /etc/default/transmission-daemon-$USERNAME

sed 's/User=debian-transmission/User='$USERNAME'/' < /lib/systemd/system/transmission-daemon-$USERNAME.service > /lib/systemd/system/transmission-daemon-$USERNAME.service.new

mv /lib/systemd/system/transmission-daemon-$USERNAME.service.new /lib/systemd/system/transmission-daemon-$USERNAME.service

sed 's/ExecStart=\/usr\/bin\/transmission-daemon -f --log-error/ExecStart=\/usr\/bin\/transmission-daemon -f --log-error -g \/var\/lib\/transmission-daemon-'$USERNAME'\/info/' < /lib/systemd/system/transmission-daemon-$USERNAME.service > /lib/systemd/system/transmission-daemon-$USERNAME.service.new

mv /lib/systemd/system/transmission-daemon-$USERNAME.service.new /lib/systemd/system/transmission-daemon-$USERNAME.service

#Repair rights
chmod 755 /usr/bin/transmission-daemon-$USERNAME
chmod 755 /etc/init.d/transmission-daemon-$USERNAME
chmod -R 755 /var/lib/transmission-daemon-$USERNAME
chmod -R 755 /etc/transmission-daemon-$USERNAME
chmod 755 /etc/default/transmission-daemon
chmod 644 /lib/systemd/system/transmission-daemon-$USERNAME.service

CONFIG_FILE=/etc/transmission-daemon-$USERNAME/settings.json

ln -sf $CONFIG_FILE $USER_HOME/.settings.json
ln -sf $CONFIG_FILE /var/lib/transmission-daemon-$USERNAME/info/settings.json

#Editing settings
python $DIR/settings.py $USERNAME $PASSWORD $USER_HOME $RPC_PORT

chown -R $USERNAME:$USERNAME /var/lib/transmission-daemon-$USERNAME
chown -R $USERNAME:$USERNAME /etc/transmission-daemon-$USERNAME

chmod 775 $CONFIG_FILE
chmod 775 $USER_HOME/.settings.json
chmod -R 775 /etc/transmission-daemon-$USERNAME

exit 0
