$ipRange = 60..254 | ForEach-Object { "10.100.5.$_" }

foreach ($ip in $ipRange) {
    # Ping the IP to ensure it's in the ARP cache
    $ping = Test-Connection -ComputerName $ip -Count 1 -Quiet

    if ($ping) {
        # Get ARP entry for the IP
        arp -a $ip
    }
}
