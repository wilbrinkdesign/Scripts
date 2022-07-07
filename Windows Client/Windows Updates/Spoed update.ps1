Param($dir)

# Start logging
Start-Transcript -Path "$dir\wu.log"

# Windows versie opvragen
$windows_versie = (Get-WmiObject -class Win32_OperatingSystem).BuildNumber
$windows_naam = (Get-WmiObject -class Win32_OperatingSystem).Caption

# Installed Windows Updates opvragen
$wu_search = New-Object -ComObject "Microsoft.Update.Searcher"
$wu_history = $wu_search.GetTotalHistoryCount()
$wu = $wu_search.QueryHistory(0,$wu_history)
$wu1 = foreach ($w in $wu) { $w.Title}
$wu2 = (Get-HotFix).HotFixID
$wu_all = $wu1+$wu2

# Geraakte Windows builds (versies) (https://docs.microsoft.com/en-us/windows/release-health/release-information) met de bijbehorende KB nummers en download links
$updates = @{
   "17763" = [PSCustomObject]@{KB="KB5008218";URL="http://download.windowsupdate.com/d/msdownload/update/software/secu/2021/12/windows10.0-kb5008218-x64_66e07f2fc23728ca0b8f395df15da52546e45e45.msu"} # 1809 Windows 10
   "18363" = [PSCustomObject]@{KB="KB5008206";URL="http://download.windowsupdate.com/d/msdownload/update/software/secu/2021/12/windows10.0-kb5008206-x64_21e0a9eade0fa1885d5c96cd1cf9b12fbc8ef8d9.msu"} # 1909 Windows 10
   "19041" = [PSCustomObject]@{KB="KB5008212";URL="http://download.windowsupdate.com/d/msdownload/update/software/secu/2021/12/windows10.0-kb5008212-x64_aef75b014bf6a8b9f858533d9dafb07c6f6fb741.msu"} # 2004 Windows 10
   "19042" = [PSCustomObject]@{KB="KB5008212";URL="http://download.windowsupdate.com/d/msdownload/update/software/secu/2021/12/windows10.0-kb5008212-x64_aef75b014bf6a8b9f858533d9dafb07c6f6fb741.msu"} # 20H1 Windows 10
   "19043" = [PSCustomObject]@{KB="KB5008212";URL="http://download.windowsupdate.com/d/msdownload/update/software/secu/2021/12/windows10.0-kb5008212-x64_aef75b014bf6a8b9f858533d9dafb07c6f6fb741.msu"} # 21H1 Windows 10
   "22000" = [PSCustomObject]@{KB="KB5008215";URL="http://download.windowsupdate.com/d/msdownload/update/software/secu/2021/12/windows10.0-kb5008215-x64_8b19785f2a319bd716c6cee9fbf345cf19f6941b.msu"} # 21H2 Windows 11
}

# De Windows OS naam, KB nummer en de download link mocht het device in aanmerking komen, anders zijn de variabelen leeg
$kb_nummer = $updates[$windows_versie].KB
$download_link = $updates[$windows_versie].URL

# Als het device in aanmerking komt voor een spoed update, installeer deze dan
If ($kb_nummer) # KB nummer gevuld? Oftewel, komt het device in aanmerking voor deze spoed update?
{
    If (!($wu_all | Where-Object {$_ -like "*$kb_nummer*"})) # Windows Update nog niet eerder geinstalleerd?
    {
        Write-Host "$kb_nummer wordt nu gedownload en geinstalleerd voor $windows_naam, build nummer $windows_versie. Een ogenblik geduld a.u.b." -ForegroundColor YELLOW
        (New-Object System.Net.WebClient).DownloadFile($download_link, "$dir\$kb_nummer.msu")
        wusa.exe "$dir\$kb_nummer.msu" /quiet /norestart
    }
    Else
    {
        Write-Host "$kb_nummer is al geinstalleerd voor $windows_naam, build nummer $windows_versie." -ForegroundColor GREEN
    }
}
Else
{
    Write-Host "Dit device ($windows_naam, build nummer $windows_versie) komt niet in aanmerking voor deze spoed update." -ForegroundColor GREEN
}

# Stop logging
Stop-Transcript