var os = require('os')

if(/32/.test(os.arch())) {
  console.log('http://stedolan.github.io/jq/download/linux32/jq')
} else {
  console.log( 'http://stedolan.github.io/jq/download/linux64/jq')
}
