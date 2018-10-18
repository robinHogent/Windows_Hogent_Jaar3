$passwordAD= ConvertTo-SecureString "Test123" -AsPlainText -force
$credential = New-Object System.Management.Automation.PSCredential ("thovan\administrator", $passwordAD)
