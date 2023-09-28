#Installiere die AzureAD module
#Install-Module AzureAD

#Melde dich bei AzureAD an
Connect-AzureAD

#Lade alle DeviceInfos
$DeviceInfo = Get-AzureADDevice -All $true

#Erstelle ein Array mit den notwendigen Informationen
$DeviceInfoArray = @()

#Iteriere durch die DeviceInfos
foreach ($Device in $DeviceInfo)
{
    $DeviceInfoObject = New-Object PSObject
    $DeviceInfoObject | Add-Member -MemberType NoteProperty -Name "Name" -Value $Device.DisplayName
    $DeviceInfoObject | Add-Member -MemberType NoteProperty -Name "OSType" -Value $Device.DeviceOsType
    $DeviceInfoObject | Add-Member -MemberType NoteProperty -Name "JoinType" -Value $Device.DeviceTrustType
    #"ServerAD" = join; "Workplace" = registered
    $DeviceInfoObject | Add-Member -MemberType NoteProperty -Name "Enabled" -Value $Device.AccountEnabled
    $DeviceInfoObject | Add-Member -MemberType NoteProperty -Name "LastSync" -Value $Device.LastDirSyncTime

    #F&uuml;ge das Objekt dem Array hinzu
    $DeviceInfoArray += $DeviceInfoObject
}

#Exportiere das Array als CSV
$DeviceInfoArray | Export-Csv -Path "DeviceInfo.csv" -NoTypeInformation
