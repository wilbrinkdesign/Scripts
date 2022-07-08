# Check alle licenties welke de tenant heeft
Get-MsolAccountSku | Select AccountSkuId | Sort AccountSkuId

# Voeg licenties toe
Get-MsolUser -all | Where-Object {($_.licenses).accountskuid -like "*tenantnaam:ENTERPRISEPACK*"} | Set-MsolUserLicense -AddLicenses "tenantnaam:ENTERPRISEPACK"

# Disable plan
Get-MsolAccountSku | Where-Object {$_.SkuPartNumber -eq "ENTERPRISEPACK"} | ForEach-Object {$_.ServiceStatus}
$x = New-MsolLicenseOptions -AccountSkuId "wodv:ENTERPRISEPACK" -DisabledPlans "YAMMER_ENTERPRISE"
Get-MsolUser -UserPrincipalName <email> | Set-MsolUserLicense -LicenseOptions $x

# Vraag licentie op van specifieke user
Get-MsolUser -all | Where-Object {$_.userprincipalname -like "*achternaam*" -and ($_.licenses).accountskuid -like "*ENTERPRISE*"}
