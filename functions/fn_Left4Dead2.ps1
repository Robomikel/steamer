Function New-LaunchScriptLFD2serverPS {
    #----------   left4dead2 Server CFG    -------------------
    $global:MODDIR="left4dead2"
    $global:EXEDIR=""
    $global:GAME = "left4dead2"
    $global:PROCESS = "l4d2"
    $global:SERVERCFGDIR = "left4dead2\cfg"
    
    Get-StopServerInstall
    $global:gamedirname="Left4Dead2"
    $global:config1="server.cfg"
    Get-Servercfg
    # - - - - - - - - - - - - -

    Write-Host "***  Renaming srcds.exe to l4d2.exe to avoid conflict with local source Engine (srcds.exe) server  ***" -ForegroundColor Magenta -BackgroundColor Black
    Rename-Item -Path "$global:currentdir\$global:server\srcds.exe" -NewName "$global:currentdir\$global:server\l4d2.exe" >$null 2>&1
    Rename-Item -Path "$global:currentdir\$global:server\srcds_x64.exe" -NewName "$global:currentdir\$global:server\l4d2_x64.exe" >$null 2>&1
    
    Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "Input Server local IP: " -ForegroundColor Cyan -NoNewline
    ${global:IP} = Read-Host
    if(($global:PORT = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [27015]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:PORT="27015"}else{$global:PORT}
    if(($global:CLIENTPORT = Read-Host -Prompt (Write-Host "Input Server Client Port, Press enter to accept default value [27005]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:CLIENTPORT="27005"}else{$global:CLIENTPORT}
    if(($global:MAP = Read-Host -Prompt (Write-Host "Input Server Map and Mode,Press enter to accept default value [c1m1_hotel]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:MAP="c1m1_hotel"}else{$global:MAP}
    Write-Host 'Input maxplayers[1-8]: ' -ForegroundColor Cyan -NoNewline
    $global:MAXPLAYERS = Read-host 
    Write-Host 'Input hostname: ' -ForegroundColor Cyan -NoNewline 
    $global:HOSTNAME = Read-host
    if(($global:RCONPASSWORD = Read-Host -Prompt (Write-Host "Input Server Rcon Password,Press enter to accept default value [$global:RANDOMPASSWORD]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:RCONPASSWORD="$global:RANDOMPASSWORD"}else{$global:RCONPASSWORD}
    $global:RCONPORT="$global:PORT"
    #if(($global:workshop = Read-Host -Prompt (Write-Host "Input 1 to enable workshop, Press enter to accept default value [0]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:workshop="0"}else{$global:workshop}
    #if(($global:sv_pure = Read-Host -Prompt (Write-Host "Input addtional launch params ie. +sv_pure 0, Press enter to accept default value []: "-ForegroundColor Cyan -NoNewline)) -eq ''){}else{$global:sv_pure}
    Write-Host "***  Editing Default server.cfg  ***" -ForegroundColor Magenta -BackgroundColor Black
    ((Get-Content -path $global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg -Raw) -replace "\bSERVERNAME\b","$global:HOSTNAME") | Set-Content -Path $global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg
    ((Get-Content -path $global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg -Raw) -replace "\bADMINPASSWORD\b","$global:RCONPASSWORD") | Set-Content -Path $global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg
    Write-Host "***  Creating Launch script ***" -ForegroundColor Magenta -BackgroundColor Black
    New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\l4d2.exe -console -game left4dead2 -strictportbind -ip `${global:IP} +port `$global:PORT +clientport `$global:CLIENTPORT +hostip ${global:EXTIP} +maxplayers `$global:MAXPLAYERS +map `"`$global:MAP`" -condebug "# +sv_workshop_enabled $global:workshop $global:sv_pure
    #A:\L4D2\srcds.exe -console -game left4dead2 -ip 10.0.0.2 +port 27020 +hostip YOURDEDIIP +maxplayers 8 +exec server.cfg +map c2m1_highway
    # -game left4dead2 -strictportbind -ip ${ip} -port ${port} +clientport ${clientport} +map ${defaultmap} +servercfgfile ${servercfg} -maxplayers ${maxplayers}
    Get-SourceMetMod
}
  