# uitleg powerscript

Als we beginnen met het maken van een DC is het belangrijk om de computernaam aantepassen dit doe je via
```
Rename-computer -newname DC1
```
We moet daarbij ook een fixed ip toe wijzen, deze staat in de opdracht omschrijving
```
New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress "192.168.1.1" -AddressFamily IPv4 -PrefixLength 24
```
De rollen voor AD te installeren gaat als het volgend.
```
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName name.loc -SafeModeAdministratorPassword "wachtwoord"
```
**Note** merk op dat er hierbij ook een domain wordt aangemaak door  
*-DomainName*  
daarbij word er ook een SafeModeAdministratorPassword meegeven deze is voor het aanmelden van het domain , dit doe je via  
*-SafeModeAdministratorPassword*
