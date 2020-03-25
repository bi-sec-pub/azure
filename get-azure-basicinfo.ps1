# bi-sec 2020, cb 
## This script reads (Get-*-Commands) different information from Azure and Azure AD and stores them into text files
## No interpretation or recommendations here! Those are up to the organization. 
# Preconditions: Installed Azure PowerShell Module && Installed AzureAD Module
# https://docs.microsoft.com/de-de/powershell/azure/install-az-ps?view=azps-3.6.1
## Install-Module -Name Az -AllowClobber
## Install-Module -Name AzureAD -Scope CurrentUser

$storePath = "C:\Users\cb\pstest\"
$storeFile = ""
$fullPath = ""

# Import module into current Session
Import-Module -Name Az
Import-Module -Name AzureAD

# Use your Account Creds + MFA to login 
Connect-AzAccount
Connect-AzureAD

# Get and store basic information
## Get current Context
$storeFile = "Get-AzContext.txt"
$fullPath = join-path $storePath $storeFile
Get-AzContext | Out-File -FilePath $fullPath

## Get all Subscriptions
$storeFile = "Get-AzSubscription.txt"
$fullPath = join-path $storePath $storeFile
Get-AzSubscription | Out-File -FilePath $fullPath

## Get all Groups
$storeFile = "Get-AzADGroup.txt"
$fullPath = join-path $storePath $storeFile
Get-AzADGroup | Out-File -FilePath $fullPath

## Get all Users
$storeFile = "Get-AzADUser.txt"
$fullPath = join-path $storePath $storeFile
Get-AzADUser | Out-File -FilePath $fullPath

## Get Group-Memberships for all AzureADUsers 
$storeFile = "Get-AzureADUserMembership-foreach.txt"
$fullPath = join-path $storePath $storeFile
Get-AzureADUser | ForEach-Object {echo $_.DisplayName;Get-AzureADUserMembership -ObjectId $_.ObjectId} | Out-File -FilePath $fullPath

## Get all Group-Members for the groups 
$storeFile = "Get-AzADGroupMember-foreach.txt"
$fullPath = join-path $storePath $storeFile
Get-AzADGroup | ForEach-Object {echo $_.DisplayName;Get-AzADGroupMember -GroupObjectId $_.Id} | Out-File -FilePath $fullPath

## Get AzureAD Roles
$storeFile = "AzureADDirectoryRole.txt"
$fullPath = join-path $storePath $storeFile
Get-AzureADDirectoryRole | Out-File -FilePath $fullPath

## Get AzureAD Role Members 
$storeFile = "AzureADDirectoryRoleMember-foreach.txt"
$fullPath = join-path $storePath $storeFile
Get-AzureADDirectoryRole |  ForEach-Object {echo $_.DisplayName;Get-AzureADDirectoryRoleMember -ObjectId $_.ObjectId} | Out-File -FilePath $fullPath

## Get all resource Groups
$storeFile = "AzResourceGroup.txt"
$fullPath = join-path $storePath $storeFile
Get-AzResourceGroup | Out-File -FilePath $fullPath

## Get all public IP adresses
$storeFile = "AzPublicIpAddress.txt"
$fullPath = join-path $storePath $storeFile
Get-AzPublicIpAddress  | Out-File -FilePath $fullPath


## Get all Storage Containers with info about public access
### Not working with Read-Only Roles sometimes
$storeFile = "AzStorageContainer-all.txt"
$fullPath = join-path $storePath $storeFile
Get-AzStorageAccount | Get-AzStorageContainer | Out-File -FilePath $fullPath 
