Vooral eer we met de exchange mail server kunnen starten.
We Zullen de basis configuratie moeten doen, dit bestaat uit een vast Ip adress instellen, een nieuwe naam aan het systeem toewijzen, de dns wordt ook toegewezen. en het systeem wordt toegevoegd tot het systeem
```
Rename-Computer -NewName "DC3" -force
#Network adapters
if (Get-NetAdapter -Name "Ethernet") {
Rename-NetAdapter -Name "Ethernet" -NewName "LAN"
}


#IP instellen
New-NetIPAddress -InterfaceAlias "LAN" -IPAddress 192.168.1.3 -PrefixLength 24 -DefaultGateway 192.168.1.1


Set-DnsClientServerAddress -InterfaceAlias LAN -ServerAddresses "192.168.1.1"

$passwordAD= ConvertTo-SecureString "Robin1" -AsPlainText -force
$credential = New-Object System.Management.Automation.PSCredential("robdec\administrator", $passwordAD)
add-computer –domainname ROBDEC.gent -Credential $credential -restart –force

```
Exchange maakt gebruik maken van .NET software, instaleer deze dan ook op het systeem , net als volgende presoftware, we maken gebruik van een script die dat voor ons uitvoerd

```
Install-WindowsFeature NET-Framework-45-Features, RPC-over-HTTP-proxy, RSAT-Clustering, RSAT-Clustering-CmdInterface, RSAT-Clustering-Mgmt, RSAT-Clustering-PowerShell, Web-Mgmt-Console, WAS-Process-Model, Web-Asp-Net45, Web-Basic-Auth, Web-Client-Auth, Web-Digest-Auth, Web-Dir-Browsing, Web-Dyn-Compression, Web-Http-Errors, Web-Http-Logging, Web-Http-Redirect, Web-Http-Tracing, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Lgcy-Mgmt-Console, Web-Metabase, Web-Mgmt-Console, Web-Mgmt-Service, Web-Net-Ext45, Web-Request-Monitor, Web-Server, Web-Stat-Compression, Web-Static-Content, Web-Windows-Auth, Web-WMI, Windows-Identity-Foundation

Install-WindowsFeature RSAT-ADDS

```

Ook moet er gezorgt worden dat er een sql server is geinstaleerd we zorgen er eerst voor dat alles ge mount dit doe je door naar het gewenste path te gaan (meestal is dit een cijfer (vb H:/ en je voert volgend commando uit)
```
Mount-DiskImage "H:/sql.iso" -PassThru
```

daarna kunnen de instalatie van sql beginnen met het commando
```
.\setup.exe /QS /ACTION=install /IAcceptSQLServerLicenseTerms /ACTION=Install /FEATURES=SQLEngine /INSTANCENAME=MSSQLSERVER /TCPENABLED=1 /SQLSYSADMINACCOUNTS=ROBDEC.gent
```
net zoals in SQL moet alles gemount worden via 
```
.\setup /PrepareSchema /IAcceptExchangeServerLicenseTerms

.\setup /Preparead /IAcceptExchangeServerLicenseTerms /OrganizationName="ROBDEC"
```
Eenmaal als dit is gelukt kunt u de de iso van exchange de setup.exe aanklikken en de installatie volgen.

Eenmaal als je de installatie gedaan is, gaan we nog een beetje configuratie die we moeten invoeren. Deze vind je als je je naar start gaat en het mapje van Exchange open doet. foto 1.
Dit zal de browers openen en surfen naar de localhost en daar zal het controlepanel van exchange te zien zijn.
Nu zullen we ons verzendende connectors instellen, dit doen we door te navigeren naar volgend scherm foto 2.
Volgende scherm komt op het scherm foto 3 hier moet he de naam intypen,klink vervolgenrs op volgende 
Bij sit scherm zorg je er voor dat het MX-record aanstaat en je klikt terug op volgende
Het daarop volgend scherm klik je op de plus foto 6 om uiteindlijk een * te typen en op nieuw op volgende te drukken (dit stelt dit dan we de mail gaan verzenden met smpt)

Als je nu de mail zou verzenden zou hij moeten verzenden.

In sommige gevallen zou je het ipadress waarvan je stuurt moeten deblokeren. hiervan zal je een mail krijgen en het zal ongeveer een halfuurtje duren vooraleer dit ge deblokeerd is




https://www.youtube.com/watch?v=yZq5q9bNu9s  
https://practical365.com/exchange-server/powershell-email-message-body/  
https://stackoverflow.com/questions/1461154/figure-out-smtp-server-host  
