Function New-LaunchScriptcsgoserverPS {
        #----------   CSGO Server CFG    -------------------

        $global:githuburl="https://raw.githubusercontent.com/GameServerManagers/Game-Server-Configs/master"

        $global:game="csgo"
        ${gamedirname}="CounterStrikeGlobalOffensive"
        ${config1}="server.cfg"
        Write-Host "***  Copying Default server.cfg  ***" -ForegroundColor Magenta -BackgroundColor Black
        #(New-Object Net.WebClient).DownloadFile("$githuburl/${gamedirname}/${config1}", "$global:currentdir\$global:server\csgo\cfg\server.cfg")
        $csgoWebResponse=Invoke-WebRequest "$githuburl/${gamedirname}/${config1}"
        #$csgoWebResponse=$csgoWebResponse.content
        New-Item $global:currentdir\$global:server\csgo\cfg\server.cfg -Force
        Add-Content $global:currentdir\$global:server\csgo\cfg\server.cfg $csgoWebResponse

        Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
        $global:process = "csgo"
        Write-Host "Get Auth Token from this website and can add later in Launch-$global:server.ps1
                        https://steamcommunity.com/dev/managegameservers
                        Note use App ID 730: " -ForegroundColor Yellow
                Write-Host "Input Game Server Token (required for public servers): " -ForegroundColor Cyan -NoNewline
                $GSLT = Read-Host
        #if(($GSLT = Read-Host -Prompt (Write-Host "Input Game Server Token (required for public servers) Enter for Default:[]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$GSLT="YOUR AUTH TOKEN"}else{$GSLT}
        
        Write-Host "***  Renaming srcds.exe to csgo.exe to avoid conflict with local source (srcds.exe) server  ***" -ForegroundColor Magenta -BackgroundColor Black
        Rename-Item -Path "$global:currentdir\$global:server\srcds.exe" -NewName "$global:currentdir\$global:server\csgo.exe" >$null 2>&1
        #Rename-Item -Path "$global:currentdir\$global:server\srcds_x64.exe" -NewName "$global:currentdir\$global:server\csgo_x64.exe" >$null 2>&1
    
        Write-Host 'Input hostname: ' -ForegroundColor Cyan -NoNewline 
        $global:HOSTNAME = Read-host
        Write-Host "Input Server local IP: " -ForegroundColor Cyan -NoNewline
        ${global:IP} = Read-Host
        if(($global:PORT = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [27015]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:PORT="27015"}else{$global:PORT}
        Write-Host 'Input rcon_password: ' -ForegroundColor Cyan -NoNewline
        $global:RCONPASSWORD = Read-host
        $global:RCONPORT="$global:PORT"
        if(($global:CLIENTPORT = Read-Host -Prompt (Write-Host "Input Server Client Port, Press enter to accept default value [27005]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:CLIENTPORT="27005"}else{$global:CLIENTPORT}
        if(($global:TICKRATE = Read-Host -Prompt (Write-Host "Input Server TICKRATE, Press enter to accept default value [64]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:TICKRATE="64"}else{$global:TICKRATE}
        if(($global:MAP = Read-Host -Prompt (Write-Host "Input Server Map, Press enter to accept default value [de_mirage]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:MAP="de_mirage"}else{$global:MAP}
        #Write-Host 'Input maxplayers (lobby size [16-?]): ' -ForegroundColor Cyan -NoNewline
        #$global:MAXPLAYERS = Read-host
        if(($global:MAXPLAYERS= Read-Host -Prompt (Write-Host "Input maxplayers, Press enter to accept default value [16]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:MAXPLAYERS="16"}else{$global:MAXPLAYERS} 
        Write-Host "
        * Deathmatch: +game_type 1 +game_mode 2
        * Demolition: +game_type 1 +game_mode 1
        * Arms Race: +game_type 1 +game_mode 0
        * Classic Competitive: +game_type 0 +game_mode 1
        * Classic Casual: +game_type 0 +game_mode 0" -ForegroundColor Yellow
        if(($global:GAMETYPE= Read-Host -Prompt (Write-Host "Input gametype, Press enter to accept default value [0]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:GAMETYPE="0"}else{$global:GAMETYPE}
        if(($global:GAMEMODE = Read-Host -Prompt (Write-Host "Input gamemode, Press enter to accept default value [0]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:GAMEMODE="0"}else{$global:GAMEMODE}
        write-host "
        * mg_skirmish_demolition                * mg_deathmatch         * mg_skirmish_triggerdiscipline         * mg_active
        * mg_skirmish_flyingscoutsman           * mg_op_breakout        * mg_skirmish_headshots                 * mg_casualdelta
        * mg_skirmish_stabstabzap               * mg_op_op05            * mg_skirmish_huntergatherers           * mg_casualsigma
        * mg_lowgravity                         * mg_op_op06            * mg_skirmish_heavyassaultsuit          * mg_reserves
        * mg_demolition                         * mg_op_op07            * mg_skirmish_armsrace                  * mg_hostage
        * mg_armsrace                           * mg_op_op08                                                                    "
        if(($global:MAPGROUP = Read-Host -Prompt (Write-Host "Input mapgroup, Press enter to accept default value [mg_active]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:MAPGROUP="mg_active"}else{$global:MAPGROUP}

        Write-Host "***  Editing Default server.cfg  ***" -ForegroundColor Magenta -BackgroundColor Black
        ((Get-Content -path $global:currentdir\$global:server\csgo\cfg\server.cfg -Raw) -replace "\bSERVERNAME\b","$global:HOSTNAME") | Set-Content -Path $global:currentdir\$global:server\csgo\cfg\server.cfg
        ((Get-Content -path $global:currentdir\$global:server\csgo\cfg\server.cfg -Raw) -replace "\bADMINPASSWORD\b","$global:RCONPASSWORD") | Set-Content -Path $global:currentdir\$global:server\csgo\cfg\server.cfg


        New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "if(`$Null -eq (get-process `"$global:process`" -ea SilentlyContinue)){"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-UpdateServer"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\csgo.exe -game csgo -console -usercon -strictportbind -ip ${global:IP} -port $global:PORT +clientport $global:CLIENTPORT +sv_setsteamaccount '$GSLT' -tickrate $global:TICKRATE +map $global:MAP -maxplayers_override $global:MAXPLAYERS +mapgroup $global:MAPGROUP +game_type $global:GAMETYPE +game_mode $global:GAMEMODE -nobreakpad +net_public_adr ${global:EXTIP}"
        #+net_public_adr xxx.xxx.xxx.xxx
        #                                                                                                                               parms="-game csgo -usercon -strictportbind -ip ${ip} -port ${port} +clientport ${clientport} +tv_port ${sourcetvport} +sv_setsteamaccount ${gslt} -tickrate ${tickrate} +map ${defaultmap} +servercfgfile ${servercfg} -maxplayers_override ${maxplayers} +mapgroup ${mapgroup} +game_type ${gametype} +game_mode ${gamemode} +host_workshop_collection ${wscollectionid} +workshop_start_map ${wsstartmap} -authkey ${wsapikey} -nobreakpad"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "}else{"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"Server Running`""
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-Process `"$global:process`"}"

        $title    = 'Download MetaMod and SourceMod'
        $question = 'Download MetaMod, SourceMod and install?'
    
        $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
        $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
        $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    
        $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
        if ($decision -eq 0) {
        Get-SourceMetaModcs
        Write-Host 'Entered Y'
        #Get-Gamemode
    } else {
        Write-Host 'Entered N'
        #Get-Gamemode
    }
    
}

Function Get-SourceMetaModcs {
        $start_time = Get-Date
        Write-Host '*** Downloading Meta Mod *****' -ForegroundColor Magenta -BackgroundColor Black 
        #(New-Object Net.WebClient).DownloadFile("$global:metamodurl", "$global:currentdir\metamod.zip")
        #[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
        Invoke-WebRequest -Uri $global:metamodurl -OutFile $global:currentdir\metamod.zip
        Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
        Write-Host '*** Extracting Meta Mod *****' -ForegroundColor Magenta -BackgroundColor Black
        Expand-Archive "$global:currentdir\metamod.zip" "$global:currentdir\metamod\" -Force
        Write-Host '*** Copying/installing Meta Mod *****' -ForegroundColor Magenta -BackgroundColor Black 
        Copy-Item -Path $global:currentdir\metamod\* -Destination $global:currentdir\$global:server\csgo -Force -Recurse
        
        $start_time = Get-Date
        Write-Host '*** Downloading SourceMod *****' -ForegroundColor Magenta -BackgroundColor Black
        #(New-Object Net.WebClient).DownloadFile("$global:sourcemodurl", "$global:currentdir\sourcemod.zip")
        #[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
        Invoke-WebRequest -Uri $global:sourcemodurl -OutFile $global:currentdir\sourcemod.zip
        Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
        Write-Host '*** Extracting SourceMod *****' -ForegroundColor Magenta -BackgroundColor Black 
        Expand-Archive "$global:currentdir\sourcemod.zip" "$global:currentdir\sourcemod\" -Force
        Write-Host '*** Copying/installing SourceMod *****' -ForegroundColor Magenta -BackgroundColor Black
        Copy-Item -Path $global:currentdir\sourcemod\* -Destination $global:currentdir\$global:server\csgo -Force -Recurse
        
        }
# gametype="0"
# gamemode="0"
# mapgroup="mg_active"


# fn_parms(){
#    parms="-game csgo -usercon -strictportbind -ip ${ip} -port ${port} +clientport ${clientport} +tv_port ${sourcetvport} +sv_setsteamaccount ${gslt} -tickrate ${tickrate} +map ${defaultmap} +servercfgfile ${servercfg} -maxplayers_override ${maxplayers} +mapgroup ${mapgroup} +game_type ${gametype} +game_mode ${gamemode} +host_workshop_collection ${wscollectionid} +workshop_start_map ${wsstartmap} -authkey ${wsapikey} -nobreakpad"
#    }
# Edit the batch file and type in one of the following lines

# Classic Casual: +game_type 0 +game_mode 0

# srcds -game csgo -console -usercon +game_type 0 +game_mode 0 +mapgroup mg_active +map de_dust2

# Classic Competitive: +game_type 0 +game_mode 1

# srcds -game csgo -console -usercon +game_type 0 +game_mode 1 +mapgroup mg_active +map de_dust2

# Arms Race: +game_type 1 +game_mode 0

# srcds -game csgo -console -usercon +game_type 1 +game_mode 0 +mapgroup mg_armsrace +map ar_shoots

# Demolition: +game_type 1 +game_mode 1

# srcds -game csgo -console -usercon +game_type 1 +game_mode 1 +mapgroup mg_demolition +map de_lake

# Deathmatch: +game_type 1 +game_mode 2

# srcds -game csgo -console -usercon +game_type 1 +game_mode 2 +mapgroup mg_allclassic +map de_dust

# The batch file is the "launch options" of the server, if you want your server to be public (not lan)
# add "+net_public_adr xxx.xxx.xxx.xxx" to the end of the "launch options"

# Deathmatch: +game_type 1 +game_mode 2
# Demolition: +game_type 1 +game_mode 1
# Arms Race: +game_type 1 +game_mode 0
# Classic Competitive: +game_type 0 +game_mode 1
# Classic Casual: +game_type 0 +game_mode 0
