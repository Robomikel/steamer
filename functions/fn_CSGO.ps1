Function New-LaunchScriptcsgoserverPS {
       #----------   CSGO Server CFG    -------------------
        $global:MODDIR="csgo"
        $global:EXEDIR=""
        $global:GAME = "csgo"
        $global:PROCESS = "csgo"
        $global:SERVERCFGDIR = "csgo\cfg"
        
        Get-StopServerInstall
        $global:gamedirname="CounterStrikeGlobalOffensive"
        $global:config1="server.cfg"
        Get-Servercfg
        # - - - - - - - - - - - - -

        Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
        Write-Host "Input Server local IP: " -ForegroundColor Cyan -NoNewline
        ${global:IP} = Read-Host
        if(($global:PORT = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [27015]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:PORT="27015"}else{$global:PORT}
        if(($global:CLIENTPORT = Read-Host -Prompt (Write-Host "Input Server Client Port, Press enter to accept default value [27005]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:CLIENTPORT="27005"}else{$global:CLIENTPORT}
        if(($global:SOURCETVPORT = Read-Host -Prompt (Write-Host "Input Server Source TV Port, Press enter to accept default value [27020]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:SOURCETVPORT="27020"}else{$global:SOURCETVPORT}
        if(($global:TICKRATE = Read-Host -Prompt (Write-Host "Input Server TICKRATE, Press enter to accept default value [64]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:TICKRATE="64"}else{$global:TICKRATE}
        Write-Host "Get Auth Token from this website and can add later in Launch-$global:server.ps1
                        https://steamcommunity.com/dev/managegameservers
                        Note use App ID 730: " -ForegroundColor Yellow
        Write-Host "Input Game Server Token (required for public servers): " -ForegroundColor Cyan -NoNewline
        $global:GSLT = Read-Host
        if(($global:MAP = Read-Host -Prompt (Write-Host "Input Server Map, Press enter to accept default value [de_inferno]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:MAP="de_inferno"}else{$global:MAP}
        if(($global:MAXPLAYERS= Read-Host -Prompt (Write-Host "Input maxplayers, Press enter to accept default value [16]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:MAXPLAYERS="16"}else{$global:MAXPLAYERS} 

        Write-Host "***  Renaming srcds.exe to csgo.exe to avoid conflict with local source (srcds.exe) server  ***" -ForegroundColor Magenta -BackgroundColor Black
        Rename-Item -Path "$global:currentdir\$global:server\srcds.exe" -NewName "$global:currentdir\$global:server\csgo.exe" >$null 2>&1
        #Rename-Item -Path "$global:currentdir\$global:server\srcds_x64.exe" -NewName "$global:currentdir\$global:server\csgo_x64.exe" >$null 2>&1
        Write-Host 'Input hostname: ' -ForegroundColor Cyan -NoNewline 
        $global:HOSTNAME = Read-host
        if(($global:RCONPASSWORD = Read-Host -Prompt (Write-Host "Input Server Rcon Password,Press enter to accept default value [$global:RANDOMPASSWORD]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:RCONPASSWORD="$global:RANDOMPASSWORD"}else{$global:RCONPASSWORD}
        $global:RCONPORT="$global:PORT"
        Write-Host "
        * Competitive / Scrimmage: +game_type 0 +game_mode 1
        * Wingman:              +game_type 0 +game_mode 2
        * Custom:               +game_type 3 +game_mode any (?)
        * Guardian:             +game_type 4 +game_mode 0
        * Co-op Strike:         +game_type 4 +game_mode 1
        * Danger Zone:          +game_type 6 +game_mode 0
        * Deathmatch:           +game_type 1 +game_mode 2
        * Demolition:           +game_type 1 +game_mode 1
        * Arms Race:            +game_type 1 +game_mode 0
        * Classic Competitive:  +game_type 0 +game_mode 1
        * Classic Casual:       +game_type 0 +game_mode 0" -ForegroundColor Yellow
        if(($global:GAMETYPE= Read-Host -Prompt (Write-Host "Input gametype, Press enter to accept default value [0]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:GAMETYPE="0"}else{$global:GAMETYPE}
        if(($global:GAMEMODE = Read-Host -Prompt (Write-Host "Input gamemode, Press enter to accept default value [0]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:GAMEMODE="0"}else{$global:GAMEMODE}
        Write-Host "$global:CIRCLE View  \$global:SERVERCFGDIR\gamemodes.txt and  \$global:SERVERCFGDIR\gamemodes_server.txt.example for single Maps in Mapgroups $global:CIRCLE" -ForegroundColor Yellow
        write-host "
        * mg_skirmish_demolition                * mg_deathmatch         * mg_skirmish_triggerdiscipline         * mg_active
        * mg_skirmish_flyingscoutsman           * mg_op_breakout        * mg_skirmish_headshots                 * mg_casualdelta
        * mg_skirmish_stabstabzap               * mg_op_op05            * mg_skirmish_huntergatherers           * mg_casualsigma
        * mg_lowgravity                         * mg_op_op06            * mg_skirmish_heavyassaultsuit          * mg_reserves
        * mg_demolition                         * mg_op_op07            * mg_skirmish_armsrace                  * mg_hostage
        * mg_armsrace                           * mg_op_op08                                                                    " -ForegroundColor Yellow
        if(($global:MAPGROUP = Read-Host -Prompt (Write-Host "Input mapgroup, Press enter to accept default value [mg_active]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:MAPGROUP="mg_active"}else{$global:MAPGROUP}
        Write-Host "***  Editing Default server.cfg  ***" -ForegroundColor Magenta -BackgroundColor Black
        ((Get-Content -path $global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg -Raw) -replace "\bSERVERNAME\b","$global:HOSTNAME") | Set-Content -Path $global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg
        ((Get-Content -path $global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg -Raw) -replace "\bADMINPASSWORD\b","$global:RCONPASSWORD") | Set-Content -Path $global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg
        Write-Host "***  Creating Launch script  ***" -ForegroundColor Magenta -BackgroundColor Black
        New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "start-process cmd `"/c csgo.exe -game csgo -console -usercon -strictportbind -ip `${global:IP} -port `$global:PORT +clientport  `$global:CLIENTPORT +tv_port `$global:SOURCETVPORT +sv_setsteamaccount `"`$GSLT`" -tickrate `$global:TICKRATE +map `$global:MAP -maxplayers_override `$global:MAXPLAYERS +mapgroup `$global:MAPGROUP +game_type `$global:GAMETYPE +game_mode `$global:GAMEMODE +host_workshop_collection `${wscollectionid} +workshop_start_map `${WSSTARTMAP} -authkey `${WSAPIKEY} -nobreakpad +net_public_adr ${global:EXTIP} -condebug`""
        #+net_public_adr xxx.xxx.xxx.xxx
        # parms="                                                                                                                        -game csgo -console -usercon -strictportbind -ip ${ip} -port ${port} +clientport ${clientport} +tv_port ${sourcetvport} +sv_setsteamaccount ${gslt} -tickrate ${tickrate} +map ${defaultmap} +servercfgfile ${servercfg} -maxplayers_override ${maxplayers} +mapgroup ${mapgroup} +game_type ${gametype} +game_mode ${gamemode} +host_workshop_collection ${WSCOLLECTIONID} +workshop_start_map ${WSSTARTMAP} -authkey ${wsapikey} -nobreakpad"
        Get-SourceMetMod
}

# The batch file is the "launch options" of the server, if you want your server to be public (not lan)
# add "+net_public_adr xxx.xxx.xxx.xxx" to the end of the "launch options"
#Game Mode	game_type	game_mode
#Casual (default)	0	0
#Competitive / Scrimmage	0	1
#Wingman	        0	        2
#Arms Race	1	        0
#Demolition	1	        1
#Deathmatch	1	        2
#Custom	        3	        any (?)
#Guardian	4	        0
#Co-op Strike	4	        1
#Danger Zone	6	        0
# Removing the IP command line option is a must if you want to host your server on LAN.
# srcds -game csgo -console -usercon +game_type 0 +game_mode 0 +mapgroup mg_active +map de_dust 2 -maxplayers_override 32 +port 27016
