#!/bin/bash
USERNAME=$1
PASSWORD=$2

USER_HOME=$("su - $USER -c 'echo $HOME'")
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

node $DIR/json.js $CONFIG_FILE rpc-password $PASSWORD

exit 0
