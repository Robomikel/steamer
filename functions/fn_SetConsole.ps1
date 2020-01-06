Function Set-Console
    {
        clear-host
        $host.ui.RawUi.WindowTitle = "-------- STEAMER ------------"
        [console]::ForegroundColor="Green"
        [console]::BackgroundColor="Black"
        $host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size(160,5000)
        Get-logo
    }