Rename-computer -newname SQL  
New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress "192.168.1.3" -AddressFamily IPv4 -PrefixLength 24 -DefaultGateWay 192.168.1.1
Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses "192.2.1.1"
Restart-Computer -f
