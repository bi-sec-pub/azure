# cw 2023
# Replace: *address* with username@domain.tld
## Use existing and non-existing *address* to identify valid accounts / tenants
# Replace: *tenant* with domain.tld
# Requires AAD-Internals https://github.com/Gerenios/AADInternals
# "Username.txt" must contain *address*-List 

Invoke-RestMethod -Uri "https://login.microsoftonline.com/common/GetCredentialtype" -ContentType "application/json" -Method POST -Body (@{"username"="*address*"} | convertto-json)

Invoke-RestMethod -Uri ("https://login.microsoftonline.com/common/userrealm/*address*?api-version=2.0")

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

import-module aadinternals

Invoke-AADIntReconAsOutsider -DomainName *tenant* | Format-Table

Get-Content .\Username.txt | Invoke-AADIntUserEnumerationAsOutsider -Method Autologon

