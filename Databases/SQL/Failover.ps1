If (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
	Write-Host "Run PowerShell eerst als Administrator!" -ForegroundColor YELLOW
	Exit
}
Else
{
	$sql01 = "SQLSRV01"
	$sql02 = "SQLSRV02"
	$sql_server = "SQLSRV01"
	$sql_changelog_db = "databaseit"
	$sql_changelog_table_servers = "ittable"
	$sql_changelog_table_servers_log = "ittable_log"
	$sql_actief = ((Get-ClusterGroup "SQL Server (SQLSERVER)").OwnerNode).Name
	$sql_passief = If ($sql_actief -eq $sql01) { $sql02 } Else { $sql01 }
	$gebruiker = [Environment]::UserName

	Write-Host "De failover wordt gestart. $sql_passief wordt actief en $sql_actief wordt passief." -ForegroundColor YELLOW
	$vraag = Read-Host "Wil je doorgaan?"
	Clear-Host

	If ($vraag -like "*J*" -Or $vraag -like "*Y*")
	{
		Write-Host "Cluster groepen worden nu overgezet. Een ogenblik geduld a.u.b." -ForegroundColor YELLOW
		Get-ClusterNode $sql_actief | Get-ClusterGroup | Move-ClusterGroup -Node $sql_passief
		Get-ClusterNode $sql_actief | Get-ClusterSharedVolume | Move-ClusterSharedVolume -Node $sql_passief
		
		Write-Host "De Changelog wordt bijgewerkt. Een ogenblik geduld a.u.b." -ForegroundColor YELLOW
		Invoke-Sqlcmd -Query "USE $sql_changelog_db; INSERT INTO $sql_changelog_table_servers_log (id, oms, date, manager) VALUES ((SELECT id FROM $sql_changelog_table_servers WHERE naam = '$sql01'), 'Failover van $sql_actief naar $sql_passief', GETDATE(), '$gebruiker');" -ServerInstance "$sql_server"
		Invoke-Sqlcmd -Query "USE $sql_changelog_db; INSERT INTO $sql_changelog_table_servers_log (id, oms, date, manager) VALUES ((SELECT id FROM $sql_changelog_table_servers WHERE naam = '$sql02'), 'Failover van $sql_actief naar $sql_passief', GETDATE(), '$gebruiker');" -ServerInstance "$sql_server"

		If ($? -eq $True)
		{
			Clear-Host
			Write-Host "De failover is geslaagd. $sql_passief is nu de actieve server." -ForegroundColor GREEN
			
			Write-Host ""
			Write-Host "Get-ClusterGroup:" -ForegroundColor YELLOW
			Get-ClusterGroup
			Write-Host "Get-ClusterSharedVolume:" -ForegroundColor YELLOW
			Get-ClusterSharedVolume
		}
		Else
		{
			Write-Host "Er is een fout opgetreden." -ForegroundColor RED
			Write-Host "Get-ClusterGroup:" -ForegroundColor YELLOW
			Get-ClusterGroup
			Write-Host "Get-ClusterSharedVolume:" -ForegroundColor YELLOW
			Get-ClusterSharedVolume
		}
	}
	Else { Write-Host "Er is gekozen om niet door te gaan. Het script is afgesloten." -ForegroundColor RED; Exit }
}
