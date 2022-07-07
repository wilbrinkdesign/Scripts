# Vraag expiration date op (uitdienstdatum)
Get-ADUser -Properties sn, AccountExpirationDate -Filter * -SearchBase "OU=Container1,DC=domein,DC=test,DC=lan" | fl sn,samaccountname,@{Name='AccountExpiration'; Expression={if($null -eq $_.AccountExpirationDate){'Never Expires'}else{$_.AccountExpirationDate}}}

# Datum gerelateerde zaken
Get-ADUser -Properties * -Filter * | Select @{Name="LastLogonTimestamp";Expression={[datetime]::FromFileTime($_.'LastLogonTimestamp')}}, @{Name="LastLogon";Expression={[datetime]::FromFileTime($_.'LastLogon')}}, @{Name="AccountExpirationDate";Expression={[datetime]::FromFileTime($_.'AccountExpirationDate')}}, @{Name="PwdLastSet";Expression={[datetime]::FromFileTime($_.'PwdLastSet')}}, samaccountname, mail 

Search-ADAccount -AccountExpiring -TimeSpan "14" 

# Vraag gebruikers op die aangemaakt zijn na...
Get-ADUser -Filter * -SearchBase "OU=Container1,DC=domein,DC=test,DC=lan" -Properties * | where { $_.createTimeStamp -gt "2021-08-31" -and $_.enabled -eq $True } | select-object mail 
