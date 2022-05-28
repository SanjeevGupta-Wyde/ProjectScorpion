param(
    $EnvConfig
)

$MyCommandName = $MyInvocation.MyCommand.Name
Write-Output "--------------------------------------------------------------- ${MyCommandName} $(Get-Date -format 'u')"

if($EnvConfig.vm.createvm) {
    
    $BO=$EnvConfig.vm.tags.'Business Owner'
    $DO=$EnvConfig.vm.tags.'DevOps Owner'
    $RG=$EnvConfig.group.name
    $vnetname="$($EnvConfig.vm.vnet.name)"

    Write-Output "################ Creating Azure Vnet ${vnetname} ################" 

    $vnets=Get-AzVirtualNetwork | select-object name -ExpandProperty name
    if(!("$vnets" -like "*$vnetname*")) {
    az network vnet create --resource-group $RG `
                --name $vnetname `
                --address-prefixes $EnvConfig.vm.vnet.address `
                --tags "Business Owner=$BO" "DevOps Owner=$DO" --only-show-errors
    
    } else {
        Write-Output "##### $vnetname alrady exists #####" 
    }    
    foreach ($subnet in $EnvConfig.vm.vnet.subnets) {
        Write-Output "################ Creating subnet $($subnet.name) ################" 
        az network vnet subnet create -g $RG `
        --vnet-name $vnetname `
        --name $subnet.name `
        --address-prefixes $subnet.address --only-show-errors
        
    }
    foreach ($vm in $EnvConfig.vm.vms) {
        Write-Output "################ Creating Azure VM `"$($vm.name)`" in subnet `"$($vm.subnet)`" ################" 
        az vm create -g $RG `
            --name $vm.name `
            --admin-username $vm.adminname `
            --admin-password $vm.password `
            --public-ip-address-dns-name $vm.DNSname `
            --public-ip-sku Standard `
            --vnet-name $vnetname `
            --subnet $vm.subnet `
            --image $EnvConfig.vm.image `
            --tags "Business Owner=$BO" "DevOps Owner=$DO" `
            --size $vm.vmsize --only-show-errors
        
    }

    $nsgs = Get-AzNetworkSecurityGroup -ResourceGroupName $RG | select-object name -ExpandProperty name
    foreach ($nsg in $nsgs){
        if ($nsg -like "*front*"){
            Write-Output "################ Creating NSG Rules for $nsg to allow traffic on port 80 ################" 
            Get-AzNetworkSecurityGroup -Name $nsg -ResourceGroupName $RG | Add-AzNetworkSecurityRuleConfig -Name "http-Rule" -Description "Allow http traffic" -Access "Allow" -Protocol "*" -Direction "Inbound" -Priority 100 -SourceAddressPrefix "Internet" -SourcePortRange "*" -DestinationAddressPrefix "*" -DestinationPortRange "80" | Set-AzNetworkSecurityGroup

            Write-Output "################ Creating NSG Rules for $nsg to allow traffic on port 443 ################"
            Get-AzNetworkSecurityGroup -Name $nsg -ResourceGroupName $RG | Add-AzNetworkSecurityRuleConfig -Name "https-Rule" -Description "Allow https traffic" -Access "Allow" -Protocol "*" -Direction "Inbound" -Priority 200 -SourceAddressPrefix "Internet" -SourcePortRange "*" -DestinationAddressPrefix "*" -DestinationPortRange "443" | Set-AzNetworkSecurityGroup
        }
        Write-Output "################ Removing NSG Rules for $nsg to deny rdp connection ################"
        Get-AzNetworkSecurityGroup -Name $nsg -ResourceGroupName $RG | Remove-AzNetworkSecurityRuleConfig -Name "rdp" | Set-AzNetworkSecurityGroup
    }
}
else {
    Write-Output "Skipping VM Creation" 
}
Write-Output "--------------------------------------------------------------- $(Get-Date -format 'u')" 
