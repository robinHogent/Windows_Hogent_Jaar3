# --AD-- 
## Uitleg powerscript

Veel van de code vind je terugt in de documentatie van DC1
```
Rename-computer -newname DC2   
New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress "192.168.1.2" -AddressFamily IPv4 -PrefixLength 24 -DefaultGateway "192.168.1.1"
Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses "192.168.1.1"
Restart-Computer -f
```
om deze opdracht goed uitvoeren moeten we ook de AD-roles instaleren
```
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```
laatste stap het deze pc toevoegen aan het domein
```
$W8 = ConvertTo-SecureString "Robin1#TeKortw8woord" -AsPlainText -force
$W8A= ConvertTo-SecureString "Robin1" -AsPlainText -force
$credential = New-Object System.Management.Automation.PSCredential ("robdec\administrator", $W8A)
Install-ADDSDomainController -DomainName "robdec.gent" -SafeModeAdministratorPassword $W8 -Force -Credential $credential
Restart-Computer -f
```



# Bronnnen
