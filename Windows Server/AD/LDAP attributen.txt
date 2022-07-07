# Attribuut legen
Get-ADUser -Properties info | Set-ADuser -Clear info 

# Attribuut vullen met bestaande attribuut
Get-ADUser -Filter {telephonenumber -like "088-7891*"} -Properties * | Foreach-object { 
  Set-ADuser -identity $_ -replace @{ipphone="$($_.telephonenumber.substring(8,3))"} 
} 

# Pas afdeling aan
Get-ADUser -Filter {department -like "Afdeling1"} | Foreach-object { Set-ADUser -Identity $_.SamAccountName -department "Afdeling2" }

# 06 van het ene veld naar het andere veld 
Get-ADUser -Properties * -Filter {mobile -notlike "*" -and postalcode -like "*"} -SearchBase "OU=Container1,DC=domein,DC=test,DC=lan" | Foreach-object { Set-ADUser -Identity $_.SamAccountName -Replace @{mobile = $_.postalcode} } 

# Manager aanpassen
Get-ADUser -Properties manager, mail -Filter * -SearchBase "OU=Container1,DC=domein,DC=test,DC=lan" | where {$_.manager -like "" -and $_.mail -like "*@domein.nl"} | Set-ADUser -Manager "HBakker" 
