# ProjectScorpion
##  Solution for KPMG Technical Challenge 
This repo contains solution for KPMG Technical Challenge on Azure Cloud

Below is the relevent files for each challenges


## Challenge #1: 
- infra_provision\azure\1-az-setup.ps1
- infra_provision\azure\Resources\1-create-ARG.ps1
- infra_provision\azure\Resources\2-create-AFS.ps1
- infra_provision\azure\Resources\3-create-AVM.ps1
- infra_provision\azure\Resources\4-create-APG.ps1

## Challenge #2:
- infra_provision\azure\2-az-metadata.ps1
- infra_provision\azure\Operations\GetInstanceMatadataForWindowsVM.ps1
- infra_provision\azure\Operations\GetInstanceMatadataForLinuxVM.ps1 

## Challenge #3:
- scripts\js\retrieveValueUsingKey.js
- scripts\js\retrieveValueUsingKey_withKeyAndData.js

## Prerequisite:
1. You should have an Azure Account
2. You should have module az version 2.32 and above installed on your local machine. You can check it by command "az --version"
3. You should have nodejs v10.x or above installed.
4. You should have pwsh installed. You can run "npm install pwsh" to install it.
5. Run command `npm i`

## Challenge #1 - Setup a 3-tier environment

Procedure: 
1. Create a config file `#EnvName#.json` under folder ../config
2. Run npm command ```npm run create:infra #EnvName#" ```
example: ```npm run create:infra kpmgtestenv```

## Challenge #2 - Get an instance metadata

Procedure:
1. To retrieve metadata for an instance, run npm command ```npm run retrieve:metadata #EnvName# #VMRole# #VMProperty#```

#EnvName# : Name of the env
#VMRole# : can be 'front' or 'back'
#VMProperty# : to specify a data key. Use '/' for nested key. Leave blank for complete metadata

example: 1. ```npm run retrieve:metadata kpmgtestenv front``` 
         2. ```npm run retrieve:metadata kpmgtestenv back compute/name``` 


## Challenge #3 - Retrieve Value using key from a nested object

Procedure: 
1. run npm command ```npm run retrievedata:key #dataobject# #key#```
   #dataobject# : nested object
   #key# : data key to retrieve

For Test, run npm command ```npm run test:retrievedata:key```


-------------------------------------------------------------------------------------------------------------------------------------

To do:
1. update .gitignore
2. Add steps to pass retrieved metadata (retrieved in Challenge #2) and key to script retrieveValueUsingKey.js
3. Add better tests for Challenge #3
4. Create a template config file which can be used to create env config file

