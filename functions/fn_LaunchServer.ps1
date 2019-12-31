Function Select-launchServer {
    Write-Host '*** Starting Launch script *****' -ForegroundColor Yellow -BackgroundColor Black  
    & "$global:currentdir\$global:server\Launch-*.ps1"
    Set-Location $global:currentdir
    #Select-Steamer
}