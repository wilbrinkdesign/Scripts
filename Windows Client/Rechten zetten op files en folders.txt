# Bepaalde ACLs zetten voor rechten op files en/of folders
$acl = Get-Acl $logfile 
$acl.SetAccessRuleProtection($true,$true) # Inherit uitzetten 
Set-Acl $log_locatie -AclObject $acl 
$acl.Access | where {$_.IdentityReference -eq "INGEBOUWD\Gebruikers" } | foreach { $acl.RemoveAccessRuleSpecific($_) } 
$acl.Access | where {$_.IdentityReference -eq "BUILTIN\Users" } | foreach { $acl.RemoveAccessRuleSpecific($_) } 
Set-Acl $log_locatie -AclObject $acl 
