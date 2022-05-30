Param(

    [Parameter(Mandatory=$true)]
    [string]$envconfigfile,
    [Parameter(Mandatory=$true)]
    [string]$vmrole
    [Parameter(Mandatory=$false)]
    [string]$vmproperty
 ) #end param

$CurrentFolder = "$PSScriptRoot"
$AzureFolder = "$CurrentFolder\.." 
Write-Output $CurrentFolder
$RootFolder = resolve-path "$CurrentFolder\..\.." 
$envconfigpath="$RootFolder\config"
$envconfig = Get-Content -Path "$envconfigpath\$envconfigfile.json" | ConvertFrom-Json
$envshortname = $EnvConfig.group.name
$VMOperationsPath = "$CurrentFolder\Operations"
$starttimestamp = Get-Date -Format "yyyyMMddHHmmss"

foreach ($vm in $envconfig.vm.vms) {
    if ($vm.role -eq $vmrole) {
        $vmname = $vm.name
        $vmostype = $vm.ostype
    }
}

Write-Output "-- Retrieving Azure Instance Metadata for vm $vmname --"

if ([string]::IsNullOrEmpty($(Get-AzContext).Account)) {Connect-AzAccount -UseDeviceAuthentication}
if ($vmostype -eq "windows"){
    Invoke-AzVMRunCommand -ResourceGroupName $envconfig.group.name -VMName $vmname -CommandId 'RunPowerShellScript' -ScriptPath "$VMOperationsPath\GetInstanceMatadataForWindowsVM.ps1" -Parameter @{param1 = "metadata"}
}
if ($vmostype -eq "linux"){
    Invoke-AzVMRunCommand -ResourceGroupName $envconfig.group.name -VMName $vmname -CommandId 'RunPowerShellScript' -ScriptPath "$VMOperationsPath\GetInstanceMatadataForLinuxVM.ps1" -Parameter @{param1 = "metadata"}
}
if ($vmproperty){
    $metadataobject = $metadata | ConvertTo-JSON -Depth 99 | ConvertFrom-Json
    npm run retrievedata:key $metadataobject $vmproperty | Write-Output
}
else{
    $metadata | ConvertTo-JSON -Depth 99 | Write-Output
}
Write-Output "-- Retrival of Azure Instance Metadata Completed --"