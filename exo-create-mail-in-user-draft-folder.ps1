# bi-sec, 2023-10
# Scriptlet, um eine E-Mail in einem User-Postfach zu erzeugen
# Benötigt Microsoft.Graph PowerShell
# Benötigt Application Consent für Mail.ReadWrite 

# install-module Microsoft.Graph
# Import-Module Microsoft.Graph.Mail
Connect-MgGraph -Scopes Mail.ReadWrite
#Random ID 
$uniqueid = "42ce6bf8-c852-47a5-abea-2f89be19a657"
# Postfach des Users
$userId ="abc@7rtm4v.onmicrosoft.com"
$params = @{
	subject = "Vorschlag Gewerbe"
	importance = "Low"
	body = @{
		contentType = "HTML"
		content = "Hallo Zusammen, <br /> 
                    anbei der Vorschlag <a href='https://pentest.bi-sec.cloud/canary/"+ $uniqueid + "' /> download </a>! <br />
                    Danke und Gruß <br />
                    John"
	}
	toRecipients = @(
		@{
			emailAddress = @{
				address = "ptusercanarydemo@bi-sec.cloud"
			}
		}
	)
}

New-MgUserMessage -UserId $userId -BodyParameter $params
