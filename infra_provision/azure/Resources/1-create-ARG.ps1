param(
    $EnvConfig
)

$MyCommandName = $MyInvocation.MyCommand.Name
Write-Output "--------------------------------------------------------------- ${MyCommandName} $(Get-Date -format 'u')"
#Create Resource Group

if($EnvConfig.group.createresourcegroup) {
    $BO=$EnvConfig.group.tags.'Business Owner'
    $DO=$EnvConfig.group.tags.'DevOps Owner'
    $groupname = $EnvConfig.group.name
    $grouplocation = $EnvConfig.group.location
    Write-Output "################ Creating Resource Group $groupname on location $grouplocation ################"
    az group create  --name  $groupname `
                 --location $grouplocation `
                 --tags "Business Owner=$BO" "DevOps Owner=$DO" --only-show-errors
} else {
    Write-Output "Skipping Resource Group creation"
}
Write-Output "--------------------------------------------------------------- $(Get-Date -format 'u')"

 