Rename-computer -newname WDS  
New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress "192.168.1.4" -AddressFamily IPv4 -PrefixLength 24 -DefaultGateway "192.168.1.1"
Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses "192.168.1.1"
