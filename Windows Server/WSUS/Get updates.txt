# Get WSUS updates
Get-WsusUpdate -Approval Approved -Classification All -Status FailedOrNeeded | select @{Name="Title";Expression={$_.update.title}},@{Name="Description";Expression={$_.update.description}},@{Name="KB";Expression={$_.update.knowledgebasearticles}}
Get-WsusUpdate -Approval Approved -Classification All -Status FailedOrNeeded | Where { $_.update.knowledgebasearticles -like "*4052623*" }
Get-WsusUpdate -Classification All -Approval Approved -Status Any | Where { $_.update.IsSuperseded -eq $True }
Get-WsusUpdate -Classification All -Approval Approved -Status Any | Where { $_.update.knowledgebasearticles -eq "3020388" }

[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration")
$wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer();
$wsus.GetUpdates() | Where {$_.knowledgebasearticles -eq '2830477'}