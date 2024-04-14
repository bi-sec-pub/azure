# Importiere AzureAD-Modul
Import-Module AzureAD

# Melde dich bei Azure an
Connect-AzureAD

# Hole alle Gruppen aus Azure
$Groups = Get-AzureADGroup -All $true

# Iteriere über alle Gruppen und speichere Gruppen- und Owner-Informationen
$GroupInfo = foreach($Group in $Groups)
{
    # Hole den Gruppen-Owner
    $GroupOwner = Get-AzureADGroupOwner -ObjectId $Group.ObjectId
    $GroupMember = Get-AzureADGroupMember -ObjectId $Group.ObjectId

    # Erstelle ein neues Objekt mit den Gruppen- und Owner-Informationen
    [PsCustomObject]@{
        GroupName = $Group.DisplayName
        GroupSecurity = $Group.SecurityEnabled
        GroupMail = $Group.MailEnabled
        GroupOwner = $GroupOwner.UserPrincipalName
        GroupMember = $GroupMember.UserPrincipalName
    }
}

# Exportiere die Gruppen- und Owner-Informationen als CSV
$GroupInfo | Export-Csv -Path "./Groups_and_Owners_and_members.csv" -NoTypeInformation
