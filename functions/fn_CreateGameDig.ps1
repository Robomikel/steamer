Function New-GameDigScript {
    $global:nodeversion="12.13.1"
    ${global:EXTIP}=(Invoke-WebRequest -uri "http://ifconfig.me/ip").Content
    #${global:IP}=((ipconfig | findstr [0-9].\.)[0]).Split()[-1]
    New-Item $global:currentdir\$global:server\GameDig-$global:server.ps1 -Force
    Add-Content -Path $global:currentdir\$global:server\GameDig-$global:server.ps1 -Value "Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64"
    Add-Content -Path $global:currentdir\$global:server\GameDig-$global:server.ps1 -Value ".\gamedig --type $global:game ${global:EXTIP}:${global:PORT} --pretty | Select-String -Pattern 'name','map','password','maxplayers','IP','port','ping' -SimpleMatch -CaseSensitive"
    Add-Content -Path $global:currentdir\$global:server\GameDig-$global:server.ps1 -Value "Set-Location $global:currentdir"
    Add-Content -Path $global:currentdir\$global:server\GameDig-$global:server.ps1 -Value "Select-Steamer"
}