var process = require('process')
//const myArgs = require('minimist')(process.argv.slice(2))
//let object = myArgs['object'];
//let key = myArgs['key'];

//const myArgs = process.argv.slice(2)
//let object = myArgs[0]
//let key = myArgs [1]

function GetKeyValue(obj, key) {
    return key
      .split('/') // split key by `/`
      .reduce(function(obj, key) {
        return obj && obj[key]; 
      }, obj) 
  }

let object1 = {
    a: {
        b: {
            c : "d"
        }
    }
}
let key1 = "a" 

console.log(
    "object: ", object1, 
    "\n key: ", key1,
    "\n result: ", GetKeyValue(object1, key1)
  )

let object2 = {
    a: {
        b: {
            c : "d"
        }
    }
}
let key2 = "a/b"

  console.log(
    "object: ", object2, 
    "\n key: ", key2,
    "\n result: ", GetKeyValue(object2, key2)
  ) 

  let object3 = {
    a: {
        b: {
            c : "d"
        }
    }
}
let key3 = "a/b/c"

  console.log(
    "object: ", object3, 
    "\n key: ", key3,
    "\n result: ", GetKeyValue(object3, key3)
  ) 