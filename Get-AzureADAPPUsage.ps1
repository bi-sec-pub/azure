# cw, 2023

<#
.SYNOPSIS
    Lists all enterprise applications and their usage using the SignIn-Logs.

.PARAMETER Days
    The number of days the for checking the past. Default = 30

.EXAMPLE
    PS C:\> .\Get-AzureADAPPUsage.ps1 | Export-Csv -Path "usage.csv" -NoTypeInformation
    Generates a CSV report of usage.

.EXAMPLE
    PS C:\> .\Get-AzureADAPPUsage.ps1 -Days 15
    Checks usage for the last 15 days.
#>

[CmdletBinding()]
param(
    [int] $Days = 30
)

try {
    if(Get-Command "Get-AzureADAuditSignInLogs" -errorAction SilentlyContinue ){
            #Write-Host “Get-AzureADAuditSignInLogs exists”
        }else {
            Write-Host "You must install AzureADPreview before running this script. Use: Install-Module -Name AzureADPreview -Scope CurrentUser -Force -AllowClobber"
            return;
        }
} catch {}

# Get tenant details to test that Connect-AzureAD has been called
try {
    Connect-AzureAD | Out-Null
    $tenant_details = Get-AzureADTenantDetail
} catch {
    throw "You must call Connect-AzureAD before running this script."
}


$EnterpriseApps = Get-AzureADServicePrincipal -All $true | select AppID, AppDisplayName, PublisherName


if($Days -gt 0){
    $Days = $Days * -1;
}

$Date = (Get-Date).AddDays($Days).ToString("yyyy-MM-dd")
$Filter = "createdDateTime gt $date"
$SigninLogs = Get-AzureADAuditSignInLogs -Filter $Filter -All $true

$Counter = New-Object System.Collections.Generic.Dictionary"[String,Int]"
foreach ($Entry in $SigninLogs){
    if($Counter.ContainsKey($Entry.AppId)){
        $Counter[$Entry.AppId] = $Counter[$Entry.AppId] + 1;
    }else{
        $Counter.Add($Entry.AppId, 1);
    }
}

$Result = New-Object System.Collections.ArrayList

foreach ($Entry in $EnterpriseApps){
    $numOfUsage = $Counter[$Entry.AppId];
    if($numOfUsage -eq $null){
        $ResultObject = [PSCustomObject]@{
            AppName     = $Entry.AppDisplayName
            AppID = $Entry.AppId
            Counter = 0
            PublisherName = $Entry.PublisherName
            }
        $Result.Add($ResultObject) | Out-Null;
    }else{
        $ResultObject = [PSCustomObject]@{
            AppName     = $Entry.AppDisplayName
            AppID = $Entry.AppId
            Counter = $numOfUsage
            PublisherName = $Entry.PublisherName
            }
        $Result.Add($ResultObject) | Out-Null;
    }
}

$Result
