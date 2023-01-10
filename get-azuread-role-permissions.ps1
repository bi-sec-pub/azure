# cw, 2023 
# Script to retrieve the permissions for each AzureAD role 

# AzureADPreview is required


Import-Module AzureADPreview -Force
Connect-AzureAD

$RoleDefinitions = Get-AzureADMSRoleDefinition
$Result = New-Object System.Collections.ArrayList     
foreach($RoleDef in $RoleDefinitions){
    #Write-Host $RoleDef.RolePermissions.AllowedResourceActions
    foreach($AllowedAction in $RoleDef.RolePermissions.AllowedResourceActions){
        #Write-Host $RoleDef.DisplayName":"$AllowedAction
        $myObject = [PSCustomObject]@{
            DisplayName     = $RoleDef.DisplayName
            AllowedAction = $AllowedAction
            IsBuiltIn = $RoleDef.IsBuiltIn
            IsEnabled = $RoleDef.IsEnabled
        }
        $Result.Add($myObject) | Out-Null;
    }
}

$Result
