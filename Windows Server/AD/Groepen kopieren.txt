# Groep y krijgt de members van groep x
Add-ADGroupMember -Identity 'NIEUWE_GROEP' -Members (Get-ADGroupMember -Identity 'OUDE_GROEP' -Recursive) 

# Gebruiker x kopieert zijn member of groepen naar gebruiker y
Get-ADUser 'OUDE_USER' -Properties MemberOf | Select-Object -ExpandProperty MemberOf | Add-ADGroupMember -Members 'NIEUWE_USER' 

# Groep x kopieert zijn member of naar groep y
Add-ADPrincipalGroupMembership -Identity 'NIEUWE_GROEP' -MemberOf (Get-ADPrincipalGroupMembership 'OUDE_GROEP') 
