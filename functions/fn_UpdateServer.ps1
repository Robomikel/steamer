Function Select-UpdateServer {
    Write-Host '*** Checking for Update *****' -ForegroundColor Yellow -BackgroundColor Black  
    & "$global:currentdir\$global:server\Update-*.ps1"
    Set-Location $global:currentdir
    Select-Steamer
}