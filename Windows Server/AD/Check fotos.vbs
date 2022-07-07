strUser = CreateObject("WScript.Network").UserName 
Set objFSO = CreateObject("Scripting.FileSystemObject") 
Set objSysInfo = Createobject("ADSystemInfo") 
 
Dim DN 
DN = objSysInfo.UserName 
 
If InStr(1, DN, "Standaard") > 0 Then 
If objFSO.FolderExists("\\srv01\fotos$") Then 
If Not objFSO.FileExists("\\srv01\fotos$\"&strUser&".jpg") Then 
      strMessage = "Dit is tekst." 
Msgbox strMessage, 0, "Geen foto" 
End If 
End If 
End If 
