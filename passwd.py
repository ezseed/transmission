#!/usr/bin/python
# -*- coding: utf-8 -*-
import json
import sys

"""
Args:
    - username
    - password
"""

settingsFile = open('/etc/transmission-daemon-'+sys.argv[1]+'/settings.json', 'r+')

d = json.load(settingsFile)
d['rpc-password'] = sys.argv[2]

settingsFile.seek(0)
settingsFile.truncate()

json.dump(d, settingsFile, indent=4)

settingsFile.close()
