param(
    [Parameter(Mandatory=$true)] 
    $metadata
)

$ImdsServer = "http://169.254.169.254"
$InstanceEndpoint = $ImdsServer + "/metadata/instance"


function Query-InstanceEndpoint
{
    $uri = $InstanceEndpoint + "?api-version=2021-02-01"
    curl -s -H Metadata:true --noproxy "*" $uri | jq
}

# Make Instance call and print the response
$result = Query-InstanceEndpoint
Set-Variable -Name $metadata -Value $result -Scope 1