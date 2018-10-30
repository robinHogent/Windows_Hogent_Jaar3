Rename-computer -newname DC1  
New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress "192.168.1.1" -AddressFamily IPv4 -PrefixLength 24 -DefaultGateWay 192.168.1.1
Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses "192.168.1.1"
Restart-Computer -f
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName robdec.gent -DomainNetbiosName "ROBDEC" -InstallDns -SafeModeAdministratorPassword (ConvertTo-SecureString -String "Robin1" -AsPlainText -Force)
Restart-Computer -f﻿Install-WindowsFeature -Name 'DHCP'  
Add-DhcpServerV4Scope -Name "ROBDEC Scope" -StartRange 192.168.1.50 -EndRange 192.168.1.100 -SubnetMask 255.255.255.0  
Set-DhcpServerV4OptionValue -DnsServer 192.168.1.1 -Router 192.168.1.1  
#Set-DhcpServerv4Scope -ScopeId 192.168.1.1 -LeaseDuration 1.00:00:00  
Add-DhcpServerInDc
Restart-service dhcpserver  
Install-windowsFeature Routing -IncludeManagementTools
Restart-Computer -f
if (Get-NetAdapter -Name "Ethernet") {
Rename-NetAdapter -Name "Ethernet 2" -NewName "LAN"
}
Add-DnsServerForwarder -IPAddress 193.190.173.1 #school
Add-DnsServerForwarder -IPAddress 195.130.131.2 #telenet
Install-RemoteAccess -VpnType Vpn
cmd.exe /c "netsh routing ip nat install"
cmd.exe /c "netsh routing ip nat add interface Ethernet"
cmd.exe /c "netsh routing ip nat set interface Ethernet mode=full"
cmd.exe /c "netsh routing ip nat add interface LAN"
