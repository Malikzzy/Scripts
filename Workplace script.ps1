# ==================== CONFIG ====================
$WorkspaceName = 'xxxxxx'      # Log Analytics workspace (exact name)
$SettingSuffix = '-Logs'             

$ResourceNames = @(
    'xxxxxxxxxxxxxxx'
    'xxxxxxxxxxxxxxxxx'
)
# ================================================

# Resolve the workspace once
$Law = @(Get-AzOperationalInsightsWorkspace | Where-Object Name -eq $WorkspaceName)
if ($Law.Count -ne 1) {
    throw "Expected exactly one workspace named '$WorkspaceName', found $($Law.Count)."
}
$Law = $Law[0]
Write-Host "Workspace: $($Law.Name)`n" -ForegroundColor Cyan

foreach ($name in $ResourceNames) {
    $name = $name.Trim(); if (-not $name) { continue }
    $settingName = "$name$SettingSuffix"

    # Resolve name -> single resource
    $res = @(Get-AzResource -Name $name)
    if ($res.Count -ne 1) {
        Write-Host "[$name] SKIP - found $($res.Count) resources with this exact name." -ForegroundColor Red
        continue
    }
    $resourceId = $res[0].ResourceId

    # Already enabled?
    if (Get-AzDiagnosticSetting -ResourceId $resourceId -ErrorAction SilentlyContinue |
        Where-Object Name -eq $settingName) {
        Write-Host "[$name] SKIP - '$settingName' already exists." -ForegroundColor Yellow
        continue
    }

    # Discover what this resource supports, then enable all of it
    $cats    = Get-AzDiagnosticSettingCategory -ResourceId $resourceId -ErrorAction SilentlyContinue
    $logCats = @($cats | Where-Object CategoryType -eq 'Logs')
    $metCats = @($cats | Where-Object CategoryType -eq 'Metrics')

    $logObjs = @()
    $groups  = $logCats.CategoryGroup | Where-Object { $_ } | Select-Object -Unique
    if ($groups) {
        foreach ($g in $groups) {
            $logObjs += New-AzDiagnosticSettingLogSettingsObject -Enabled $true -CategoryGroup $g
        }
    } else {
        foreach ($c in $logCats) {
            $logObjs += New-AzDiagnosticSettingLogSettingsObject -Enabled $true -Category $c.Name
        }
    }

    $metObjs = @()
    foreach ($m in $metCats) {
        $metObjs += New-AzDiagnosticSettingMetricSettingsObject -Enabled $true -Category $m.Name
    }

    if (-not $logObjs -and -not $metObjs) {
        Write-Host "[$name] SKIP - resource exposes no log or metric categories." -ForegroundColor Yellow
        continue
    }

    # Create it
    $params = @{ Name = $settingName; ResourceId = $resourceId; WorkspaceId = $Law.ResourceId }
    if ($logObjs) { $params.Log    = $logObjs }
    if ($metObjs) { $params.Metric = $metObjs }
    try {
        New-AzDiagnosticSetting @params -ErrorAction Stop | Out-Null
        Write-Host "[$name] CREATED '$settingName'  (logs: $($logObjs.Count), metrics: $($metObjs.Count))" -ForegroundColor Green
    } catch {
        Write-Host "[$name] ERROR - $($_.Exception.Message)" -ForegroundColor Red
    }
}
