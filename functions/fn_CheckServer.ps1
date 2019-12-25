Function Select-CheckServer {
    Write-Host '*** Checking Process for server *****' -ForegroundColor Yellow -BackgroundColor Black  
    & "$global:currentdir\$global:server\Check-*.ps1" 
    Set-Location $global:currentdir
    #Select-Steamer
}