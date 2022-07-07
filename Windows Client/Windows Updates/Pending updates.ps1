$wu_pending =  [activator]::CreateInstance([type]::GetTypeFromProgID("Microsoft.Update.Session"))
$tu_pending = $wu_pending = $wu_pending.CreateUpdateSearcher()
$windows_updates_pending = $tu_pending.Search("IsInstalled=0")
$windows_updates_pending_loop = $windows_updates_pending.Updates

$windowsupdates = @()

Foreach ($update In $windows_updates_pending_loop)
{
	$windowsupdates += $update.Title
}

$windowsupdates | clip