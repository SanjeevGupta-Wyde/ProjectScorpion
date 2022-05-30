var process = require('process')

const myArgs = process.argv.slice(2)
let object = myArgs[0]
let key = myArgs [1]

function GetKeyValue(obj, key) {
    return key
      .split('/') // split key by `/`
      .reduce(function(obj, key) {
        return obj && obj[key]; 
      }, obj) 
  }


console.log(
    "object: ", object, 
    "\n key: ", key,
    "\n result: ", GetKeyValue(object, key)
  ) 