var p = require('path')

module.exports = function(shell) {
  if(['install', 'useradd', 'userdel', 'daemon'].indexOf(shell) !== -1)
    return p.join(__dirname, shell) + '.sh'
  else
    throw new Error('Shell %s does not exists', shell)
}
