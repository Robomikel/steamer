Function New-GameDigFullScript {
    ${global:EXTIP}=(Invoke-WebRequest -uri "http://ifconfig.me/ip").Content
    #${global:IP}=((ipconfig | findstr [0-9].\.)[0]).Split()[-1]
    New-Item $global:currentdir\$global:server\GameDigFull-$global:server.ps1 -Force
    Add-Content -Path $global:currentdir\$global:server\GameDigFull-$global:server.ps1 -Value "Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64"
    Add-Content -Path $global:currentdir\$global:server\GameDigFull-$global:server.ps1 -Value ".\gamedig --type $global:game ${global:EXTIP}:${global:PORT} --pretty"
    Add-Content -Path $global:currentdir\$global:server\GameDigFull-$global:server.ps1 -Value "Set-Location $global:currentdir"
    #Add-Content -Path $global:currentdir\$global:server\GameDigFull-$global:server.ps1 -Value "Select-Steamer"
}