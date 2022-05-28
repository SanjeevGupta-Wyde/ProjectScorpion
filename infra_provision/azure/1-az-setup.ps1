Param(

    [Parameter(Mandatory=$true)]
    [string]$envconfigfile
 
 ) #end param

 <#
.DESCRIPTION
The script 1-az-setup.ps1 sets up Azure infra

.PARAMETER envconfigfile
Specifies env config file name
 #>


$CurrentFolder = "$PSScriptRoot"
$AzureFolder = "$CurrentFolder\.." 
Write-Output $CurrentFolder
$RootFolder = resolve-path "$CurrentFolder\..\.." 
$envconfigpath="$RootFolder\config"
$envconfig = Get-Content -Path "$envconfigpath\$envconfigfile.json" | ConvertFrom-Json
$starttimestamp = Get-Date -Format "yyyyMMddHHmmss"

Write-Output "Starting Azure infra creation.."

if ([string]::IsNullOrEmpty($(Get-AzContext).Account)) {Connect-AzAccount -UseDeviceAuthentication}

. "$CurrentFolder\resources\1-create-ARG.ps1" -EnvConfig $envconfig
. "$CurrentFolder\resources\2-create-AFS.ps1" -EnvConfig $envconfig
. "$CurrentFolder\resources\3-create-AVM.ps1" -EnvConfig $envconfig
. "$CurrentFolder\resources\4-create-APG.ps1" -EnvConfig $envconfig

Write-Output "End of Azure infra creation.."