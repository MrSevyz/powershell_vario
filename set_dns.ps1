$interfaceAlias = "Wi-Fi"  # Specify the interface alias or name
$dnsServers = "8.8.8.8", "8.8.4.4"  # Specify the DNS server IP addresses

# Get the network adapter interface object
$adapter = Get-NetAdapter | Where-Object { $_.InterfaceAlias -eq $interfaceAlias }

# Set the DNS server addresses
Set-DnsClientServerAddress -InterfaceIndex $adapter.InterfaceIndex -ServerAddresses $dnsServers
