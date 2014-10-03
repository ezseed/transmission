var p = require('path')

module.exports = function(shell) {
  if(shell == 'settings') {
    return p.join(__dirname, 'settings.json')
  } else if(['install', 'useradd', 'userdel', 'daemon'].indexOf(shell) !== -1) {
    return p.join(__dirname, shell) + '.sh'
  } else if(shell == 'passwd') {
    return p.join(__dirname, 'passwd.py')
  }
  else
    throw new Error('Shell %s does not exists', shell)
}
