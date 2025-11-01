# ====================================================================================
# Script Name: ProofPoint Scriot
# Author: Malik Rubio
# Date: 5/31/2024
# Description: Script will Disable Junk folder, Created a Inbound and Outbound Connector, and a Transport Rule within 365
# ====================================================================================






Write-Host " ________  ________  ________  ________  ________         "
Write-Host "|\   __  \|\   __  \|\   __  \|\   __  \|\  _____\        "
Write-Host "\ \  \|\  \ \  \|\  \ \  \|\  \ \  \|\  \ \  \__/         "
Write-Host " \ \   ____\ \   _  _\ \  \\\  \ \  \\\  \ \   __\        "
Write-Host "  \ \  \___|\ \  \\  \\ \  \\\  \ \  \\\  \ \  \_|        "
Write-Host "   \ \__\    \ \__\\ _\\ \_______\ \_______\ \__\         "
Write-Host "    \|__|     \|__|\|__|\|_______|\|_______|\|__|         "
Write-Host "                                                         "
Write-Host "                                                         "
Write-Host "                                                         "
Write-Host " ________  ________  ___  ________   _________            "
Write-Host "|\   __  \|\   __  \|\  \|\   ___  \|\___   ___\          "
Write-Host "\ \  \|\  \ \  \|\  \ \  \ \  \\ \  \|___ \  \_|          "
Write-Host " \ \   ____\ \  \\\  \ \  \ \  \\ \  \   \ \  \           "
Write-Host "  \ \  \___|\ \  \\\  \ \  \ \  \\ \  \   \ \  \          "
Write-Host "   \ \__\    \ \_______\ \__\ \__\\ \__\   \ \__\         "
Write-Host "    \|__|     \|_______|\|__|\|__| \|__|    \|__|         "
Write-Host "                                                         "
Write-Host "                                                         "
Write-Host "                                                         "
Write-Host " ________  ________  ________  ___  ________  _________   "
Write-Host "|\   ____\|\   ____\|\   __  \|\  \|\   __  \|\___   ___\ "
Write-Host "\ \  \___|\ \  \___|\ \  \|\  \ \  \ \  \|\  \|___ \  \_| "
Write-Host " \ \_____  \ \  \    \ \   _  _\ \  \ \   ____\   \ \  \  "
Write-Host "  \|____|\  \ \  \____\ \  \\  \\ \  \ \  \___|    \ \  \ "
Write-Host "    ____\_\  \ \_______\ \__\\ _\\ \__\ \__\        \ \__\"
Write-Host "   |\_________\|_______|\|__|\|__|\|__|\|__|         \|__|"
Write-Host "   \|_________|                                           "



Start-Sleep 2



Connect-ExchangeOnline

### Disable Junk Folder 

Get-Mailbox -ResultSize Unlimited | ForEach-Object {
    try {
        Set-MailboxJunkEmailConfiguration -Identity $_.UserPrincipalName -Enabled $false
        Write-Host "Successfully updated junk email settings for: $($_.UserPrincipalName)"
    } catch {
        Write-Host "Failed to update junk email settings for: $($_.UserPrincipalName). Error: $($_.Exception.Message)"
    }
}

Start-Sleep 30

### Proofpoint Inbound Connector
Write-Host "Creating Proofpoint Inbound Connector...."
Start-Sleep 30
New-InboundConnector -Name "Proofpoint Inbound Connector" -SenderDomains * -SenderIPAddresses 148.163.128.0/24,148.163.129.0/24,148.163.130.0/24,148.163.131.0/24,148.163.132.0/24,148.163.133.0/24,148.163.134.0/24,148.163.135.0/24,148.163.136.0/24,148.163.137.0/24,148.163.138.0/24,148.163.139.0/24,148.163.140.0/24,148.163.141.0/24,148.163.142.0/24,148.163.143.0/24,148.163.144.0/24,148.163.146.0/24,148.163.147.0/24,148.163.148.0/24,148.163.149.0/24,148.163.150.0/24,148.163.151.0/24,148.163.152.0/24,148.163.153.0/24,148.163.154.0/24,148.163.155.0/24,148.163.156.0/24,148.163.157.0/24,148.163.158.0/24,148.163.159.0/24,67.231.148.0/24,67.231.152.0/24,67.231.153.0/24,67.231.154.0/24,67.231.155.0/24,67.231.156.0/24,67.231.144.0/24,67.231.146.0/24,67.231.147.0/24,50.19.242.23,46.51.173.223 -RequireTLS $true -ConnectorType Partner -Enabled $false 
Write-Host "Proofpoint Inbound Connector Completed"


### Proofpoint Outbound Connector
Write-Host "Creating Proofpoint Outbound Connector...."
New-OutboundConnector -Name "Office365 Outbound to Proofpoint" -RecipientDomains * -TlsSettings CertificateValidation -ConnectorType Partner -Enabled $false -SmartHosts outbound-us1.ppe-hosted.com -UseMXRecord $false 
Write-Host "Proofpoint Outbound Connector Completed"


### Proofpoint Inbound Transport Rule
Write-Host "Creating Proofpoint Inbound Transport Rule...."
New-TransportRule -Name "Proofpoint Essentials Inbound Allow" -Enabled $false -SenderIpRanges 148.163.128.0/24,148.163.129.0/24,148.163.130.0/24,148.163.131.0/24,148.163.132.0/24,148.163.133.0/24,148.163.134.0/24,148.163.135.0/24,148.163.136.0/24,148.163.137.0/24,148.163.138.0/24,148.163.139.0/24,148.163.140.0/24,148.163.141.0/24,148.163.142.0/24,148.163.143.0/24,148.163.144.0/24,148.163.146.0/24,148.163.147.0/24,148.163.148.0/24,148.163.149.0/24,148.163.150.0/24,148.163.151.0/24,148.163.152.0/24,148.163.153.0/24,148.163.154.0/24,148.163.155.0/24,148.163.156.0/24,148.163.157.0/24,148.163.158.0/24,148.163.159.0/24,67.231.148.0/24,67.231.152.0/24,67.231.153.0/24,67.231.154.0/24,67.231.155.0/24,67.231.156.0/24,67.231.144.0/24,67.231.146.0/24,67.231.147.0/24,50.19.242.23,46.51.173.223 -SetSCL "-1" -Mode "Enforce"
Write-Host "Proofpoint Inbound Transport Rule Completed"

