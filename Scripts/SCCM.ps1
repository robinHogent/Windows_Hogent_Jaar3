Rename-computer -newname WDS  
New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress "192.168.1.4" -AddressFamily IPv4 -PrefixLength 24 -DefaultGateway "192.168.1.1"
Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses "192.168.1.1"
wget http://download.microsoft.com/download/D/7/E/D7E22261-D0B3-4ED6-8151-5E002C7F823D/adkwinpeaddons/adkwinpesetup.exe -O adkwinpesetup.exe
.\adkwinpesetup.exe
