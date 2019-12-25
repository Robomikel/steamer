Function Select-launchServer {
    Write-Host '*** Starting Server *****' -ForegroundColor Yellow -BackgroundColor Black  
    & "$global:currentdir\$global:server\Launch-*.ps1"
    Set-Location $global:currentdir
    #Select-Steamer
}