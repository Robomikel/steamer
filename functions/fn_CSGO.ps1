Function New-LaunchScriptcsgoserverPS {
        #----------   CSGO Server CFG    -------------------
        $GSLT=""


        $global:game="csgo"
        ${gamedirname}="CounterStrikeGlobalOffensive"
        ${config1}="server.cfg"
        Write-Host "***  Copying Default server.cfg  ***" -ForegroundColor Magenta -BackgroundColor Black
        #(New-Object Net.WebClient).DownloadFile("$githuburl/${gamedirname}/${config1}", "$global:currentdir\$global:server\insurgency\cfg\server.cfg")
        $csgoWebResponse=Invoke-WebRequest "$githuburl/${gamedirname}/${config1}"
        $csgoWebResponse=$csgoWebResponse.content
        New-Item $global:currentdir\$global:server\csgo\cfg\server.cfg -Force
        Add-Content $global:currentdir\$global:server\csgo\cfg\server.cfg $insWebResponse

        Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
        $global:process = "csgo"
        Write-Host "***  Renaming srcds.exe to doi.exe to avoid conflict with local Insurgency (srcds.exe) server  ***" -ForegroundColor Magenta -BackgroundColor Black
        Rename-Item -Path "$global:currentdir\$global:server\srcds.exe" -NewName "$global:currentdir\$global:server\csgo.exe" >$null 2>&1
        #Rename-Item -Path "$global:currentdir\$global:server\srcds_x64.exe" -NewName "$global:currentdir\$global:server\csgo_x64.exe" >$null 2>&1
    
        Write-Host 'Input hostname: ' -ForegroundColor Cyan -NoNewline 
        $global:HOSTNAME = Read-host
        Write-Host 'Input rcon_password: ' -ForegroundColor Cyan -NoNewline
        $global:RCONPASSWORD = Read-host
        $global:RCONPORT="$global:PORT"

        Write-Host "Input Server local IP: " -ForegroundColor Cyan -NoNewline
        ${global:IP} = Read-Host
        if(($global:PORT = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [27015]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:PORT="27015"}else{$global:PORT}
        if(($global:CLIENTPORT = Read-Host -Prompt (Write-Host "Input Server Client Port, Press enter to accept default value [27005]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:CLIENTPORT="27005"}else{$global:CLIENTPORT}
        if(($global:TICKRATE = Read-Host -Prompt (Write-Host "Input Server TICKRATE, Press enter to accept default value [64]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:TICKRATE="64"}else{$global:TICKRATE}
        if(($global:MAP = Read-Host -Prompt (Write-Host "Input Server Map, Press enter to accept default value [de_mirage]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:MAP="de_mirage"}else{$global:MAP}
        #Write-Host 'Input maxplayers (lobby size [16-?]): ' -ForegroundColor Cyan -NoNewline
        #$global:MAXPLAYERS = Read-host
        if(($global:MAXPLAYERS= Read-Host -Prompt (Write-Host "Input maxplayers, Press enter to accept default value [16]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:MAXPLAYERS="16"}else{$global:MAXPLAYERS} 
        if(($global:GAMETYPE= Read-Host -Prompt (Write-Host "Input gametype, Press enter to accept default value [0]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:GAMETYPE="0"}else{$global:GAMETYPE}
        if(($global:GAMEMODE = Read-Host -Prompt (Write-Host "Input gamemode, Press enter to accept default value [0]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:GAMEMODE="0"}else{$global:GAMEMODE}
        if(($global:MAPGROUP = Read-Host -Prompt (Write-Host "Input mapgroup, Press enter to accept default value [mg_active]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:MAPGROUP="mg_active"}else{$global:MAPGROUP}

        Write-Host "***  Editing Default server.cfg  ***" -ForegroundColor Magenta -BackgroundColor Black
        ((Get-Content -path $global:currentdir\$global:server\csgo\cfg\server.cfg -Raw) -replace "\bSERVERNAME\b","$global:HOSTNAME") | Set-Content -Path $global:currentdir\$global:server\csgo\cfg\server.cfg
        ((Get-Content -path $global:currentdir\$global:server\csgo\cfg\server.cfg -Raw) -replace "\bADMINPASSWORD\b","$global:RCONPASSWORD") | Set-Content -Path $global:currentdir\$global:server\csgo\cfg\server.cfg


        New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "if(`$Null -eq (get-process `"$global:process`" -ea SilentlyContinue)){"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-UpdateServer"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\csgo\srcds.exe -game csgo -usercon -strictportbind -ip ${global:IP} -port $global:PORT +clientport $global:CLIENTPORT +sv_setsteamaccount $GSLT -tickrate $global:TICKRATE +map $global:MAP -maxplayers_override $global:MAXPLAYERS +mapgroup $global:MAPGROUP +game_type $global:GAMETYPE +game_mode $global:GAMEMODE -nobreakpad +net_public_adr ${global:EXTIP}"
        #+net_public_adr xxx.xxx.xxx.xxx
        #                                                                                                                               parms="-game csgo -usercon -strictportbind -ip ${ip} -port ${port} +clientport ${clientport} +tv_port ${sourcetvport} +sv_setsteamaccount ${gslt} -tickrate ${tickrate} +map ${defaultmap} +servercfgfile ${servercfg} -maxplayers_override ${maxplayers} +mapgroup ${mapgroup} +game_type ${gametype} +game_mode ${gamemode} +host_workshop_collection ${wscollectionid} +workshop_start_map ${wsstartmap} -authkey ${wsapikey} -nobreakpad"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "}else{"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"Server Running`""
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-Process `"$global:process`"}"

}

# gametype="0"
# gamemode="0"
# mapgroup="mg_active"


# fn_parms(){
#    parms="-game csgo -usercon -strictportbind -ip ${ip} -port ${port} +clientport ${clientport} +tv_port ${sourcetvport} +sv_setsteamaccount ${gslt} -tickrate ${tickrate} +map ${defaultmap} +servercfgfile ${servercfg} -maxplayers_override ${maxplayers} +mapgroup ${mapgroup} +game_type ${gametype} +game_mode ${gamemode} +host_workshop_collection ${wscollectionid} +workshop_start_map ${wsstartmap} -authkey ${wsapikey} -nobreakpad"
#    }
# Edit the batch file and type in one of the following lines

# Classic Casual:

# srcds -game csgo -console -usercon +game_type 0 +game_mode 0 +mapgroup mg_active +map de_dust2

# Classic Competitive:

# srcds -game csgo -console -usercon +game_type 0 +game_mode 1 +mapgroup mg_active +map de_dust2

# Arms Race:

# srcds -game csgo -console -usercon +game_type 1 +game_mode 0 +mapgroup mg_armsrace +map ar_shoots

# Demolition:

# srcds -game csgo -console -usercon +game_type 1 +game_mode 1 +mapgroup mg_demolition +map de_lake

# Deathmatch:

# srcds -game csgo -console -usercon +game_type 1 +game_mode 2 +mapgroup mg_allclassic +map de_dust

# The batch file is the "launch options" of the server, if you want your server to be public (not lan)
# add "+net_public_adr xxx.xxx.xxx.xxx" to the end of the "launch options"