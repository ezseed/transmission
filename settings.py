#!/usr/bin/python
# -*- coding: utf-8 -*-
import json
import sys

"""
Args:
    - username
    - password
    - user_home
    - port
Usage:
    ❯ python ./settings.py test 123 /home/test 8888
"""

# print 'Argument List:', str(sys.argv)

settingsFile = open('/etc/transmission-daemon-'+sys.argv[1]+'/settings.json', 'r+')

d = json.load(settingsFile)
d['incomplete-dir-enabled'] = True
d['incomplete-dir'] = sys.argv[3] + '/incomplete'
d['download-dir'] = sys.argv[3] + '/downloads'
d['peer-port-random-on-start'] = True
d['lpd-enabled'] = True
d['peer-socket-tos'] = 'lowcost'
d['rpc-password'] = sys.argv[2]
d['rpc-enabled'] = True
d['rpc-whitelist-enabled'] = False
d['rpc-authentication-required'] = True
d['rpc-username'] = sys.argv[1]
d['rpc-port'] = sys.argv[4]

settingsFile.seek(0, 0)

json.dump(d, settingsFile)

settingsFile.close()
