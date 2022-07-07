# Specifieke registry module inladen en data opvragen
New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR 
$sophos_connect = (Get-ItemProperty -Path 'HKCR:\Installer\Products\*' | where { $_.ProductName -like "*Sophos Connect*" }).ProductIcon 
$regex = [regex]::new("(?<={)(.*)(?=})") 
$msi = ($regex.Match($sophos_connect)).Value 
