Function New-CreateVariables {
Write-Host '*** Creating Variables Script ****' -ForegroundColor Magenta -BackgroundColor Black 
New-Item $global:currentdir\$global:server\Variables-$global:server.ps1 -Force
Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value " # #  WEBHOOK HERE - - \/  \/  \/"
Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:WEBHOOK = `"$global:WEBHOOK`""
Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:process = `"$global:process`""
Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:HOSTNAME = `"$global:HOSTNAME`""
Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`${global:QUERYPORT} = `"${global:QUERYPORT}`""
Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`${global:PORT} = `"${global:PORT}`""
Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:game = `"$global:game`""
Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:saves = `"$global:saves`""
Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`${global:IP} = `"${global:IP}`""
Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:AppID = `"$global:AppID`""
Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:RCONPORT = `"$global:RCONPORT`""
Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:RCONPASSWORD = `"$global:RCONPASSWORD`""
Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:MAP = `"$global:MAP`""
Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:CLIENTPORT = `"$global:CLIENTPORT`""
Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:EXEDIR = `"$global:EXEDIR`""
# CSGO
Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:TICKRATE = `"$global:TICKRATE`""
Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:GAMETYPE = `"$global:GAMETYPE`""
Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:GAMEMODE = `"$global:GAMEMODE`""
Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:MAPGROUP = `"$global:MAPGROUP`""
}
