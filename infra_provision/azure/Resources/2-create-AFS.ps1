param(
    $EnvConfig,
    $CredentialFolder
)

$MyCommandName = $MyInvocation.MyCommand.Name
Write-Output "--------------------------------------------------------------- ${MyCommandName} $(Get-Date -format 'u')"
#Create file storage
foreach ($fs in $EnvConfig.filestorages) {
    #Create Storage Account
    $AfsName = $EnvConfig.group.name + $fs.name
    $generatedfilename = $EnvConfig.group.name + "_" + $fs.generatedfilename
    $BO=$fs.tags.'Business Owner'
    $DO=$fs.tags.'DevOps Owner'
    Write-Output "################ Creating Azure Storage Account $AfsName ################"
    az storage account create --name $AfsName `
                            --resource-group $EnvConfig.group.name `
                            --sku $fs.sku `
                            --location  $EnvConfig.group.location `
                            --tags "Business Owner=$BO" "DevOps Owner=$DO" --only-show-errors
    


    $fsConnectionString = $(az storage account show-connection-string `
                            -g $EnvConfig.group.name  `
                            -n $AfsName -o tsv)

    # [System.Environment]::SetEnvironmentVariable("AZURE_STORAGE_CONNECTION_STRING", $fsConnectionString)
    $filesharename = $fs.fileshare
    Write-Output "Creating Azure File Share $filesharename on Account $AfsName"
    az storage share create `
            --name $filesharename `
            --connection-string $fsConnectionString `
            --quota $fs.size --only-show-errors
    Write-Output "End of Creating Azure File Share $filesharename on Account $AfsName"
    
            

    # Get storage account key
    $fsstorageKey=$(az storage account keys list `
                            --resource-group $EnvConfig.group.name  `
                            --account-name $AfsName  `
                            --query "[0].value" -o tsv)

    
    $EndpointSuffix="core.windows.net"

    #Save storage account credentials in file

    Write-Output "Saving Azure File Share credentials in $CredentialFolder"
    $FileName = "$CredentialFolder/$generatedfilename"

    if(Test-Path -Path $FileName) {
        Remove-Item -Path $FileName -Force
    }
    @{name="$filesharename";login="$AfsName";password="$fsstorageKey"; connectionstring = "$fsConnectionString"; EndpointSuffix ="$EndpointSuffix" } | ConvertTo-Json | Out-File -FilePath $FileName
     
}

Write-Output "--------------------------------------------------------------- $(Get-Date -format 'u')" 
