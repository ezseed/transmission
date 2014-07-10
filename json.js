#!/usr/bin/env node

var minimist = require('minimist'),
    argv = require('minimist')(process.argv.slice(2)),
    fs = require('fs')

var file = argv._[0], key = argv._[1], value = argv._[2]

var f = require(file)

f[key] = value

fs.writeFileSync(file, JSON.stringify(f, null, '  '))
