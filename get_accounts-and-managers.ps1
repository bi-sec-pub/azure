# Variablen definieren
$csvPath = "UserAccounts-and-Managers.csv"

# Importieren des Azure AD Moduls
#Import-Module AzureAD

# Verbindung zu Azure AD herstellen
Connect-AzureAD

# Benutzerkonten abrufen
#$userAccounts = Get-AzureADUser

# Benutzerkonten in ein Array speichern
$userAccountArray = @()

# Für jedes Benutzerkonto die Manager abrufen
foreach($userAccount in $userAccounts){
    $userAccountObject = New-Object PSObject
    $userAccountObject | Add-Member -MemberType NoteProperty -Name "AccountName" -Value $userAccount.DisplayName
    $userAccountObject | Add-Member -MemberType NoteProperty -Name "Status" -Value $userAccount.AccountEnabled
    $userAccountObject | Add-Member -MemberType NoteProperty -Name "UserType" -Value $userAccount.UserType
    $userAccountObject | Add-Member -MemberType NoteProperty -Name "Manager" -Value (Get-AzureADUserManager -ObjectId $userAccount.ObjectId).DisplayName
    $userAccountArray += $userAccountObject
}

# Benutzerkonten als CSV-Datei exportieren
$userAccountArray | Export-Csv -Path $csvPath -NoTypeInformation
