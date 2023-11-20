# Short scriptlet to create emails fake emails in users mailboxes 
# Adds individual canary token to each mail
# bi-sec, 2023-11


# Enable for first usage:
##Import-Module Microsoft.Graph.Mail
##Import-Module AzureAD 

# Replace all *changeme* variables 
# Enable the New-MgUserMessage to write the emails 

# Connect
Connect-MgGraph -Scopes Mail.ReadWrite
Connect-AzureAD

# Set variables 
$users  = Get-AzureADUser # Filter users as required 
$userCanaryArray = @()
$serverURL = "https://pentest.bi-sec.cloud/*changeme*"
$toReceipient = "*changeme*@bi-sec.cloud"
# Check or change .. 
$mailSubject ="Vorschlag zur Gehaltsanpassung 2024"
$mailContent = Hallo Zusammen, <br /> 
                        anbei der Vorschlag <a href='"+$serverURL + "" + $canaryID + "' /> download </a>! <br />
                        Danke und Gruß <br />
                        John Doe"
$csvExportPath = "C:\tmp\canarytokens"

# Create E-Mail with Canary-Token-Link for each user
foreach ($user in $users) {
    #Write-Host $user.UserPrincipalName

    $canaryID = new-guid
    Write-Host $canaryID
    $userCanary = New-Object PSObject
    $userCanary | Add-Member -MemberType NoteProperty -Name "UserPrincipalName" -Value $user.UserPrincipalName
    $userCanary | Add-Member -MemberType NoteProperty -Name "CanaryGUID" -Value $canaryID
    $userCanaryArray += $userCanary

    $params = @{
	    subject = $mailSubject
	    importance = "Low"
	    body = @{
		    contentType = "HTML"
		    content = $mailContent
	    }
	    toRecipients = @(
		    @{
			    emailAddress = @{
				    address = $toReceipient
			    }
		    }
	    )
    }
	
 # Enable if you really want to create the email 
 # *changeme* 
## New-MgUserMessage -UserId $user.UserPrincipalName -BodyParameter $params
}
$userCanaryArray | Format-Table

# Export as CSV if needed 
# $userCanaryArray | Export-Csv -Path $csvPath -NoTypeInformation
