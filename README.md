# Ezseed rtorrent shell bindings

## API:
  - `install.sh` - installs transmission
  - `useradd.sh username password` - creates a transmission user, system user should exists and `settings.json` need to be copied to `CONFIG_DIR/settings.username.json`
  - `userdel.sh username` - deletes transmission user, don't delete user system
  - `daemon.sh start|stop|restart username` - daemonize user transmission

For a more powerful usage see [ezseed](https://github.com/ezseed/ezseed)

## Nodejs

`passwd.sh` and `useradd.sh` are node-dependent because we need to update a `json` file. `sed`'s are awful and I have no python knowledges (but yes it could be a nice alternative !) 

This module is there to be used without [ezseed](https://github.com/ezseed/ezseed) whole package. If you need to require this in a module:

```javascript
var i = require('ezseed-transmission')('install')

console.log(i)

//will output
// /path/to/the/node_modules/ezseed-rtorrent/install.sh
```
