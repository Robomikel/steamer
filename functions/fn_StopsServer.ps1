Function Select-StopsServer {
    Write-Host '*** Stopping Server Process *****' -ForegroundColor Yellow -BackgroundColor Black  
    & "$global:currentdir\$global:server\Stops-*.ps1"
    Set-Location $global:currentdir
    #Select-Steamer
}