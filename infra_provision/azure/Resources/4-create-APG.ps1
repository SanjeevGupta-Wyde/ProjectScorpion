param(
    $EnvConfig
)

$MyCommandName = $MyInvocation.MyCommand.Name
Write-Output "--------------------------------------------------------------- ${MyCommandName} $(Get-Date -format 'u')"

if($EnvConfig.db.createdatabase -And $EnvConfig.db.databasetype -eq "postgre") {
    #Create Azure Postgres Db
    $BO=$EnvConfig.group.tags.'Business Owner'
    $DO=$EnvConfig.group.tags.'DevOps Owner'

Write-Output "################ Creating Azure Postgres DB Service ${$EnvConfig.db.name} ################"    
    $vnet=$EnvConfig.vm.vnet.name
    $subnet=$EnvConfig.vm.vnet.subnets[2].name
    #ToDo: subnet should be identified by name
    az postgres flexible-server create `
        --resource-group $EnvConfig.group.name `
        --location $EnvConfig.db.location `
        --name $EnvConfig.db.name `
        --admin-user $EnvConfig.db.admin.user `
        --admin-password $EnvConfig.db.admin.password `
        --database-name $EnvConfig.db.database `
        --backup-retention 7 `
        --sku-name $EnvConfig.db.sku `
        --high-availability Disabled `
        --vnet $vnet `
        --subnet $subnet `
        --version $EnvConfig.db.version `
        --tags "Business Owner=$BO" "DevOps Owner=$DO" `
        --yes

} else {
    Write-Output "Skipping DB creation"
}

Write-Output "--------------------------------------------------------------- $(Get-Date -format 'u')" 

