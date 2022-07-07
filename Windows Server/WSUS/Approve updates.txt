# Approve WSUS updates
Get-WsusUpdate -Classification Critical -Approval Unapproved -Status Any | Approve-WsusUpdate -Action Install -TargetGroupName "All Computers"
Get-WsusUpdate -Classification Security -Approval Unapproved -Status Any | Approve-WsusUpdate -Action Install -TargetGroupName "All Computers"
Get-WsusUpdate -Classification WSUS -Approval Unapproved -Status Any | Approve-WsusUpdate -Action Install -TargetGroupName "All Computers"
Get-WsusUpdate -Classification All -Approval Unapproved -Status Any | Approve-WsusUpdate -Action Install -TargetGroupName "All Computers"

# Approve automatisch
$Updates = Get-WsusUpdate -Approval Approved -Status Any | Where { $_.update.title -notlike "*Onderdelenupdate*" }

$Groepen = @("FAT", "Laptops")

Foreach ($Groep In $Groepen)
{
	Write-Host "De updates worden nu goedgekeurd voor de groep $Groep..." -ForeGroundColor YELLOW
	$Updates | Approve-WsusUpdate -Action Install -TargetGroupName $Groep
}