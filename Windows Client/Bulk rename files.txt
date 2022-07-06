# Bulk rename files
$i = 1
Get-ChildItem | %{Rename-Item $_ -NewName ('prefixnaam_{0:D0}.png' -f $i++)}