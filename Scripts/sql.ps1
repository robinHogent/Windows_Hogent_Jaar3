$ip = "192.168.1.3"
$dns = "192.168.1.1"
$name = "srvmailsql"
New-NetIPAddress -InterfaceAlias Ethernet -IPAddress $ip -AddressFamily IPv4 -PrefixLength 24 -DefaultGateway 192.168.1.1
Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses $dns
Rename-Computer -NewName $Name
Restart-Computer


$domain = "ROBDEC.gent"
$password = "PASSWD" | ConvertTo-SecureString -asPlainText -Force
$username = "$domain\administrator" 
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
Add-Computer -DomainName $domain -Credential $credential
Restart-Computer


$sqlAdminUser = "ROBDEC\Administrator"
$execdir = (get-location).Drive.Name+":\sql-exchange\"
$installationdir="c:\install\"
If(!(test-path $installationdir))
{
      New-Item -ItemType Directory -Force -Path $installationdir
}
Copy-Item $execdir"sql.iso" -Destination $installationdir"sql.iso"
$mountResult = Mount-DiskImage $installationdir"sql.iso" -PassThru
$driveLetter = ($mountResult | Get-Volume).DriveLetter
cd $driveLetter":\"
.\setup.exe /QS /ACTION=install /IAcceptSQLServerLicenseTerms /ACTION=Install /FEATURES=SQLEngine /INSTANCENAME=MSSQLSERVER /TCPENABLED=1 /SQLSYSADMINACCOUNTS=$sqlAdminUser

Install-WindowsFeature NET-Framework-45-Features, RPC-over-HTTP-proxy, RSAT-Clustering, RSAT-Clustering-CmdInterface, RSAT-Clustering-Mgmt, RSAT-Clustering-PowerShell, Web-Mgmt-Console, WAS-Process-Model, Web-Asp-Net45, Web-Basic-Auth, Web-Client-Auth, Web-Digest-Auth, Web-Dir-Browsing, Web-Dyn-Compression, Web-Http-Errors, Web-Http-Logging, Web-Http-Redirect, Web-Http-Tracing, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Lgcy-Mgmt-Console, Web-Metabase, Web-Mgmt-Console, Web-Mgmt-Service, Web-Net-Ext45, Web-Request-Monitor, Web-Server, Web-Stat-Compression, Web-Static-Content, Web-Windows-Auth, Web-WMI, Windows-Identity-Foundation






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


Install-WindowsFeature NET-Framework-45-Features, RPC-over-HTTP-proxy, RSAT-Clustering, RSAT-Clustering-CmdInterface, RSAT-Clustering-Mgmt, RSAT-Clustering-PowerShell, Web-Mgmt-Console, WAS-Process-Model, Web-Asp-Net45, Web-Basic-Auth, Web-Client-Auth, Web-Digest-Auth, Web-Dir-Browsing, Web-Dyn-Compression, Web-Http-Errors, Web-Http-Logging, Web-Http-Redirect, Web-Http-Tracing, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Lgcy-Mgmt-Console, Web-Metabase, Web-Mgmt-Console, Web-Mgmt-Service, Web-Net-Ext45, Web-Request-Monitor, Web-Server, Web-Stat-Compression, Web-Static-Content, Web-Windows-Auth, Web-WMI, Windows-Identity-Foundation
Install-WindowsFeature RSAT-ADDS


Mount-DiskImage "H:/sql.iso" -PassThru

.\setup.exe /QS /ACTION=install /IAcceptSQLServerLicenseTerms /ACTION=Install /FEATURES=SQLEngine /INSTANCENAME=MSSQLSERVER /TCPENABLED=1 /SQLSYSADMINACCOUNTS=ROBDEC.gent

.\setup /PrepareSchema /IAcceptExchangeServerLicenseTerms
.\setup /Preparead /IAcceptExchangeServerLicenseTerms /OrganizationName="ROBDEC"
