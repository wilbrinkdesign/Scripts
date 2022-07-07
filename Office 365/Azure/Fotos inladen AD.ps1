$folderpath = "E:\pad\naar\fotos\"  
New-Item -ItemType directory -Path $folderpath -Force | Out-Null 
Write-Host "" 
Write-Host $folderpath "ingesteld als foto pad." 
Write-Host "" 

$allUsers = Get-Mailbox -RecipientTypeDetails UserMailbox -ResultSize Unlimited | select UserPrincipalName,Alias,DisplayName 
 
Foreach ($user in $allUsers) 
{ 
    $gebruiker_email = $user.UserPrincipalName 
    $gebruiker_id = Get-ADUser -Filter { EmailAddress -like $gebruiker_email } | select SamAccountName 
 
    $path = $folderpath+$gebruiker_id.SamAccountName+".jpg" 
    $photo = Get-Userphoto -identity $user.UserPrincipalName -ErrorAction SilentlyContinue 
     
    If ($photo.PictureData -ne $null) 
    { 
        [io.file]::WriteAllBytes($path,$photo.PictureData) 
        Write-Host "Foto" $gebruiker_id.SamAccountName "gedownload -" $user.Alias 
 
        $ad_photo = [byte[]](Get-Content "$path" -Encoding byte) 
        Set-ADUser $gebruiker_id.SamAccountName -Replace @{thumbnailPhoto=$ad_photo} 
        Write-Host "Foto" $gebruiker_id.SamAccountName "in AD geplaatst - " $user.Alias 
    } 
    Else 
    { 
        Write-Host "Geen foto van" $user.Alias 
    } 
} 
