# ── SMTP Relay Test ──────────────────────────────────────────────
$SMTPServer   = "localhost"
$SMTPPort     = 25
#$Username     = "xxxxxxx"
#$Password     = "xxxxxxx"
$From         = "xxxx@domain"
$To           = "username@gmail.com"
$Subject      = "SMTP Relay Test 5 - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
$Body         = "This is a test 5 email sent via PowerShell SMTP relay test."
# ─────────────────────────────────────────────────────────────────

$SecurePass = ConvertTo-SecureString $Password -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($Username, $SecurePass)

$MailParams = @{
    SmtpServer                 = $SMTPServer
    Port                       = $SMTPPort
    #Credential                 = $Credential
    From                       = $From
    To                         = $To
    Subject                    = $Subject
    Body                       = $Body
}

try {
    Send-MailMessage @MailParams
    Write-Host "SUCCESS: Email sent via $SMTPServer : $SMTPPort" -ForegroundColor Green
} catch {
    Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red
}
