Echo Deployment Agent.xml kopieren
mkdir "C:\Program Files (x86)\Liquit Workspace\Agent"
copy /Y Agent1.xml "C:\Program Files (x86)\Liquit Workspace\Agent\Agent.xml"

Echo Liquit installeren (en oude Liquit eventueel verwijderen zodat je dit script met de hand ook kunt starten mocht het fout gaan)
msiexec.exe /x Agent.msi /qn
msiexec.exe /i Agent.msi /qn DEPLOYMENT=1
"%ProgramFiles(x86)%\Liquit Workspace\Agent\shellapi.exe" deployment run

Echo Normale Agent.xml kopieren
copy /Y Agent2.xml "C:\Program Files (x86)\Liquit Workspace\Agent\Agent.xml"
