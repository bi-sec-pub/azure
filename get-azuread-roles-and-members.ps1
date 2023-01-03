# cb, 2023
# Script  uses PowerShell AzureAd (install-module AzureAD -scope CurrentUser) 
# Output is a list of AzureAD Roles with the assigned users

#Connect-AzureAD

$adroles = Get-AzureADDirectoryRole
        Write-Host "ADRole.DisplayName - UserPrincipalName (DisplayName) - AccountEnabled"
foreach ($adrole in $adroles) {

    $roleMembers = Get-AzureADDirectoryRoleMember -ObjectId $adrole.ObjectId

    foreach ($roleMember in $roleMembers) {
        Write-Host $adrole.DisplayName " - " $roleMember.UserPrincipalName "(" $roleMember.DisplayName ") - " $roleMember.AccountEnabled

    }
} 
