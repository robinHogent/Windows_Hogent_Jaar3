# --AD-- 
## Uitleg powerscript



New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress "192.168.1.1" -AddressFamily IPv4 -PrefixLength 24 -DefaultGateWay 192.168.1.1
Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses "192.168.1.1"

Restart-Computer -f

Als we beginnen met het maken van een DC is het belangrijk om de computernaam aantepassen dit doe je via
```
Rename-computer -newname DC1
```
We moet daarbij ook een fixed ip toe wijzen, deze staat in de opdracht omschrijving het is ook belangrijk dat je je default gateway er ook bij zet. ook voegen we de dns toe voor ons NAT adapter. de DNS van onze NAT adapter is uiteraard het ip adres van onze interenne adapter.
```
New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress "192.168.1.1" -AddressFamily IPv4 -PrefixLength 24 -DefaultGateWay 192.168.1.1
Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses "192.168.1.1"
```
**Note** het is aangeraden om u computer nu te herstarten. dit doe je met het kende commando
```
Restart-Computer -f
```
De rollen voor AD te installeren gaat als het volgend.
```
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```
Dan maken we een nieuw Forest
```
Install-ADDSForest -DomainName robdec.gent -DomainNetbiosName "ROBDEC" -InstallDns -SafeModeAdministratorPassword (ConvertTo-SecureString -String "Robin1" -AsPlainText -Force)
```
**Note** merk op dat er hierbij ook een domain wordt aangemaak door  
*-DomainName*  
daarbij word er ook een SafeModeAdministratorPassword meegeven deze is voor het aanmelden van het domain , dit doe je via  
*-SafeModeAdministratorPassword*

## Testen

om te testen of dit werken moeten we in de eerste plaats contoleren of de services van adws,kdc,netlogon,dns werken.  
Dit kunnen we zien door het commando.
```
Get-Service adws,kdc,netlogon,dns
```
Als alle deze services op running staan. is er geen probleem.  
Daarbij is een controle op de sysvol en de netlogon ook van belang, bekijk de output van de het commando
```
Get-smbshare
```
Moest je toch meer informatie wensen over wat er allemaal is gebreurd kan je steeds kijken naar de Review logs via
```
get-eventlog "Directory Service" | select entrytype, source, eventid, message
get-eventlog "Active Directory Web Services" | select entrytype, source, eventid, messag
```

# --DHCP-- 

de module DHCP instaleren gaat als volgend
```
Install-WindowsFeature -Name 'DHCP'  
```

Hierna wordt er een spool gemaakt met een bijbehoorde range en een lease time bij dze spool en de nadige configartie voor de dhcp , zoals het ip van de dns en de router.
```
Add-DhcpServerV4Scope -Name "ROBDEC Scope" -StartRange 192.168.1.50 -EndRange 192.168.1.100 -SubnetMask 255.255.255.0  
Set-DhcpServerV4OptionValue -DnsServer 192.168.1.1 -Router 192.168.1.1  
#Set-DhcpServerv4Scope -ScopeId 192.168.1.1 -LeaseDuration 1.00:00:00  
```
Deze dhcp authoritative maken is ook een vereiste anders zal de DHCP niet op een juist manier werken
```
Add-DhcpServerInD
```

De service moet wel herstarten worden via
```
Restart-service dhcpserver  
```
maar je kan ook gewoon je pc afzetten

# --NAT-- 

Nat zal er voor zorgen dat je internet hebt op je internne netwerk, om dit makkelijker te laten verlopen zullen we de naam van de adapter die het interenn netwerk aan elkaar verbind wijzige in lan
```
if (Get-NetAdapter -Name "Ethernet") {
Rename-NetAdapter -Name "Ethernet 2" -NewName "LAN"
}
```

we installeren Nat op de gewenste interfacesses
```
Install-RemoteAccess -VpnType Vpn
cmd.exe /c "netsh routing ip nat install"
cmd.exe /c "netsh routing ip nat add interface Ethernet"
cmd.exe /c "netsh routing ip nat set interface Ethernet mode=full"
cmd.exe /c "netsh routing ip nat add interface LAN"
```

en we forwwarden de dns (school en de dns an tellet)

```
Add-DnsServerForwarder -IPAddress 193.190.173.1
```

# Bronnnen

https://blogs.technet.microsoft.com/chadcox/2016/10/25/chads-quick-notes-installing-a-domain-controller-with-server-2016-core/  
https://docs.microsoft.com/nl-nl/windows-server/networking/technologies/dhcp/dhcp-deploy-wps  
https://www.reddit.com/r/PowerShell/comments/8fr0l8/how_do_i_convert_to_systemsecuritysecurestring/  
https://www.faqforge.com/windows/configure-dhcp-powershell/  

https://mikefrobbins.com/2013/03/14/use-powershell-to-add-an-additional-domain-controller-to-an-existing-windows-server-2012-active-directory-domain/
