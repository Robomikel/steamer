Function Select-ValidateServer {
    Write-Host '*** Validating Server *****' -ForegroundColor Yellow -BackgroundColor Black  
    & "$global:currentdir\$global:server\Validate-*.ps1"
    Set-Location $global:currentdir
    #Select-Steamer
}