# Vraag de IIS bezoekers op van bepaalde websites of alle sites
Get-Counter "\\windmz01\web service(website1.com)\current connections"
Get-Counter 'web service(_total)\current connections' -ComputerName $env:COMPUTERNAME