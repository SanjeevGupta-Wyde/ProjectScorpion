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

## Challenge #1 - Setup a 3-tier environment

Prerequisite:
1. You should have an Azure Account
2. You should have module az version 2.32 and above installed on your local machine. You can check it by command "az --version"
3. You should have pwsh installed. You can run "npm install pwsh" to install it.
4. Run command npm install

Procedure: 
1. Create a config file `#EnvName#.json` under folder ../config
2. Run npm command ```npm run create:infra #EnvName#" ```
example: ```npm run create:infra kpmgtestenv```

## Challenge #2 - Get an instance metadata
Prerequisite:
Same Prerequisites of Challenge #1
Procedure:
1. Run npm command ```npm run retrieve:metadata #EnvName# #vmrole#```

#vmrole# : can be 'front' or 'back'

example: ```npm run retrieve:metadata kpmgtestenv front```

## Challenge #3 - Retrieve Value using key from a nested object

Procedure: 
1. run npm command ```npm run challenge:3```

-------------------------------------------------------------------------------------------------------------------------------------

To do:
1. update .gitignore
2. Add steps to pass retrieved metadata (retrieved in Challenge #2) and key to script retrieveValueUsingKey.js
3. Add better tests for Challenge #3
4. Create a template config file which can be used to create env config file

