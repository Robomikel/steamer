# Version 2.0
Function New-LaunchScriptdoiserverPS {
    #----------   doi Server CFG    -------------------
    # Steamer Vars Do Not Edit
    $global:MODDIR = "doi"
    $global:EXEDIR = ""
    $global:EXE = "doi"
    $global:GAME = "doi"
    $global:PROCESS = "doi"
    $global:SERVERCFGDIR = "doi\cfg"

    Get-StopServerInstall
    # Game-Server-Configs
    $global:gamedirname = "DayOfInfamy"
    $global:config1 = "server.cfg"

    Get-Servercfg
    Select-RenameSource
    If ( $global:Version -eq "2" ) {
        ${global:IP} = ""
        $global:PORT = ""
        $global:CLIENTPORT = ""
        $global:SOURCETVPORT = ""
        $global:TICKRATE = ""
        $global:MAP = ""
        $global:SV_LAN = ""
        $global:MAXPLAYERS = ""
        $global:COOPPLAYERS = ""
        $global:WORKSHOP = ""
        $global:SV_PURE = ""
        $global:HOSTNAME = ""
        $global:RCONPASSWORD = ""
        $global:RCONPORT = "$global:PORT" 
    }
    Else {

        Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
        Write-Host "Input Server local IP: " -ForegroundColor Cyan -NoNewline
        ${global:IP} = Read-Host
        if (($global:PORT = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [27015]: "-ForegroundColor Cyan -NoNewline)) -eq '') { $global:PORT = "27015" }else { $global:PORT }
        if (($global:CLIENTPORT = Read-Host -Prompt (Write-Host "Input Server Client Port, Press enter to accept default value [27005]: "-ForegroundColor Cyan -NoNewline)) -eq '') { $global:CLIENTPORT = "27005" }else { $global:CLIENTPORT }
        if (($global:SOURCETVPORT = Read-Host -Prompt (Write-Host "Input Server Source TV Port, Press enter to accept default value [27020]: "-ForegroundColor Cyan -NoNewline)) -eq '') { $global:SOURCETVPORT = "27020" }else { $global:SOURCETVPORT }
        if (($global:TICKRATE = Read-Host -Prompt (Write-Host "Input Server Tickrate,Press enter to accept default value [64]: " -ForegroundColor Cyan -NoNewline)) -eq '') { $global:TICKRATE = "64" }else { $global:TICKRATE }  
        #Write-Host "Input Game Server Token: " -ForegroundColor Cyan -NoNewline
        #$global:GSLT = Read-Host
        if (($global:MAP = Read-Host -Prompt (Write-Host "Input Server Map and Mode,Press enter to accept default value [bastogne stronghold]: "-ForegroundColor Cyan -NoNewline)) -eq '') { $global:MAP = "bastogne stronghold" }else { $global:MAP }
        if (($global:SV_LAN = Read-Host -Prompt (Write-Host "Input SV_LAN,Press enter to accept default value [0]: "-ForegroundColor Cyan -NoNewline)) -eq '') { $global:SV_LAN = "0" }else { $global:SV_LAN }
        if (($global:MAXPLAYERS = Read-Host -Prompt (Write-Host "Input maxplayers (lobby size 24-48) Press enter to accept default value [32]: "-ForegroundColor Cyan -NoNewline)) -eq '') { $global:MAXPLAYERS = "32" }else { $global:MAXPLAYERS }
        Write-Host 'Input players  (mp_coop_lobbysize [1-16]): ' -ForegroundColor Cyan -NoNewline  
        $global:COOPPLAYERS = Read-host
        if (($global:WORKSHOP = Read-Host -Prompt (Write-Host "Input 1 to enable workshop, Press enter to accept default value [0]: "-ForegroundColor Cyan -NoNewline)) -eq '') { $global:WORKSHOP = "0" }else { $global:WORKSHOP }
        if (($global:SV_PURE = Read-Host -Prompt (Write-Host "Input +sv_pure, Press enter to accept default value [1]: "-ForegroundColor Cyan -NoNewline)) -eq '1') { $global:SV_PURE = "1" }else { $global:SV_PURE } 
        Write-Host 'Input hostname: ' -ForegroundColor Cyan -NoNewline 
        $global:HOSTNAME = Read-host
        if (($global:RCONPASSWORD = Read-Host -Prompt (Write-Host "Input Server Rcon Password,Press enter to accept default value [$global:RANDOMPASSWORD]: " -ForegroundColor Cyan -NoNewline)) -eq '') { $global:RCONPASSWORD = "$global:RANDOMPASSWORD" }else { $global:RCONPASSWORD }
        $global:RCONPORT = "$global:PORT"
    }
    Select-EditSourceCFG

    #Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "start-process cmd `"/c doi.exe -game doi -strictportbind -usercon -ip `${global:IP} -port `${global:PORT} +clientport `${global:CLIENTPORT} +tv_port `${global:SOURCETVPORT} -tickrate `${global:TICKRATE} +map '`${global:MAP}' +maxplayers `${global:MAXPLAYERS} +sv_lan ${global:SV_LAN }+mp_coop_lobbysize `${global:COOPPLAYERS} +sv_workshop_enabled `${global:WORKSHOP} +sv_pure `${global:SV_PURE} -condebug`" -NoNewWindow"
    # VERSION 2 Requieres  Vars
    New-CreateVariables 
    Write-Host "**** Creating Start params ******" -ForegroundColor Magenta
    Add-Content $global:currentdir\$global:server\Variables-$global:server.ps1 "`$global:launchParams = @(`"`$global:EXE -game doi -strictportbind -usercon -ip `${global:IP} -port `${global:PORT} +clientport `${global:CLIENTPORT} +tv_port `${global:SOURCETVPORT} -tickrate `${global:TICKRATE} +map '`${global:MAP}' +maxplayers `${global:MAXPLAYERS} +sv_lan `${global:SV_LAN }+mp_coop_lobbysize `${global:COOPPLAYERS} +sv_workshop_enabled `${global:WORKSHOP} +sv_pure `${global:SV_PURE} -condebug`")"
    # -game doi -strictportbind           -ip ${ip} -port ${port} +clientport ${clientport} +tv_port ${sourcetvport} -tickrate ${tickrate} +map ${defaultmap} +servercfgfile ${servercfg} -maxplayers ${maxplayers} -workshop"
    #start srcds.exe -usercon +maxplayers 24 +sv_lan 0 +map "bastogne offensive"              
    Add-SubMotdtxts
    Get-Gamemodedoi
    Get-SourceMetMod
}


# not used in DOI 
#server.cfg		// this is your primary server config file containing global variables
#default_server_<mode>.cfg		// default file which contains settings for specific mode
#server_<mode>.cfg         // non-default config, overrides default, use this for custom servers
#server_<map>.cfg		// optional file for settings per-map
#server_<map>_<mode>.cfg		// optional file for settings per-map-gamemode
Function Get-Playlistdoi {
    Write-Host "Checking playlist" -ForegroundColor Yellow
    if ($global:playlist -eq "coop_commando") {
        Write-Host "edit nwi/$global:playlist in server.cfg" -ForegroundColor Magenta
        ((Get-Content -path $global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg -Raw) -replace "// Playlist", "mapcyclefile `"mapcycle_coop.txt`"") | Set-Content -Path $global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg
    }
    elseif ($global:playlist -eq "coop") {
        Write-Host "edit nwi/$global:playlist in server.cfg" -ForegroundColor Magenta
        ((Get-Content -path $global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg -Raw) -replace "// Playlist", "mapcyclefile `"mapcycle_coop.txt`"") | Set-Content -Path $global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg
    }
    elseif ($global:playlist -eq "mp_battles") {
        Write-Host "edit nwi/$global:playlist in server.cfg" -ForegroundColor Magenta
        ((Get-Content -path $global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg -Raw) -replace "// Playlist", "mapcyclefile `"Mapcycle_mp_battles.txt`"") | Set-Content -Path $global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg
    }
    elseif ($global:playlist -eq "mp_casual_with_bots") {
        Write-Host "edit nwi/$global:playlist in server.cfg" -ForegroundColor Magenta
        ((Get-Content -path $global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg -Raw) -replace "// Playlist", "mapcyclefile `"Mapcycle_mp_casual_with_bots.txt`"") | Set-Content -Path $global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg
        #}elseif($global:playlist -eq "mp_first_deployment"){
        #                    Write-Host "edit nwi/$global:playlist in server.cfg" -ForegroundColor Magenta
        #                    ((Get-Content -path $global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg -Raw) -replace "// Playlist","mapcyclefile `"mapcycle.txt`"") | Set-Content -Path $global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg
    }
    elseif ($global:playlist -eq "mp_special_assignments") {
        Write-Host "edit nwi/$global:playlist in server.cfg" -ForegroundColor Magenta
        ((Get-Content -path $global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg -Raw) -replace "// Playlist", "mapcyclefile `"Mapcycle_mp_special_assignments.txt`"") | Set-Content -Path $global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg
        #}elseif($global:playlist -eq "conquer"){
        #                            Write-Host "edit nwi/$global:playlist in server.cfg" -ForegroundColor Magenta
        #                            ((Get-Content -path $global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg -Raw) -replace "//mapcyclefile `"mapcycle.txt`"","mapcyclefile `"mapcycle_conquer.txt`"") | Set-Content -Path $global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg
        #}elseif($null -eq $global:playlist) {
        #                                Write-Host "entered blank or null" -ForegroundColor Red
    }
}
                

Function Set-Gamemodedoi {
    #nwi/coop_commando
    #nwi/coop
    #nwi/mp_battles *
    #nwi/mp_casual_with_bots *
    #nwi/mp_first_deployment
    #nwi/mp_special_assignments *
    # for coop gamemodes are the folllowing
    # raid, entrenchment, stronghold
    # with 2 ruleset playlist commando & infantry
    Write-Host "Enter one of the listed modes" -ForegroundColor Yellow
    Write-Host "coop_commando" -ForegroundColor Yellow
    Write-Host "coop" -ForegroundColor Yellow
    Write-Host "mp_battles" -ForegroundColor Yellow
    Write-Host "mp_casual_with_bots" -ForegroundColor Yellow
    #Write-Host "mp_first_deployment" -ForegroundColor Yellow
    Write-Host "mp_special_assignments" -ForegroundColor Yellow
    #Write-Host "conquer" -ForegroundColor Yellow
    Write-Host "Enter mode, Will add Mapcycle per mode: " -ForegroundColor Cyan -NoNewline
    $global:playlist = Read-Host 
    if (($global:playlist -eq "coop_commando") -or ($global:playlist -eq "coop") -or ($global:playlist -eq "mp_battles") -or ($global:playlist -eq "mp_casual_with_bots") -or ($global:playlist -eq "mp_special_assignments")) {
        Write-Host "Editing nwi/$global:playlist playlist in server.cfg" -ForegroundColor Magenta
        ((Get-Content -path $global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg -Raw) -replace "`"sv_playlist`" 		  `"nwi/coop`"", "sv_playlist `"nwi/$global:playlist`"") | Set-Content -Path $global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg
        Get-Playlistdoi
    }
    else {
        Write-Host " mode does not exist" -ForegroundColor Yellow
        Set-Gamemodedoi 
    }
}
Function Get-Gamemodedoi {
    $title = 'Set playlist and Mapcycles now?'
    $question = 'Set Gamemode (playlist will set Mapcycle) now?'
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
    if ($decision -eq 0) {
        Set-Gamemodedoi
        new-mapcycles
        Write-Host 'Entered Y'
    }
    else {
        Write-Host 'Entered N'
    }

}

Function Add-SubMotdtxts {
    Write-Host "***  Creating subscribed_file_ids.txt ***" -ForegroundColor Magenta -BackgroundColor Black
    New-Item $global:currentdir\$global:server\doi\subscribed_file_ids.txt -Force
    Write-Host "***  Creating motd.txt ***" -ForegroundColor Magenta -BackgroundColor Black
    New-Item $global:currentdir\$global:server\doi\motd.txt -Force
}
Function new-mapcycles {
    #mkdir $global:currentdir\$global:server\doi   >$null 2>&1
    $MapCyclePath = "$global:currentdir\$global:server\doi"
    Write-Host "***  Creating Mapcycle_coop.txt  ***" -ForegroundColor Magenta -BackgroundColor Black
    New-Item $MapCyclePath\Mapcycle_coop.txt -Force
    # - - - - - - MAPCYCLE.TXT - - - - - - - - - -# EDIT \/   \/   \/  \/  \/  \/ \/ \/ \/
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "bastogne		stronghold"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "comacchio		stronghold"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "crete			stronghold"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "dog_red		stronghold"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "foy			stronghold"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "ortona		stronghold"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "reichswald	stronghold"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "saint_lo		stronghold"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "salerno       stronghold"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "sicily		stronghold"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "rhineland     stronghold"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "vbreville		stronghold"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "dunkirk		stronghold"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "brittany		stronghold"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "flakturm		stronghold"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "bastogne		raid"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "comacchio		raid"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "crete			raid"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "dog_red		raid"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "foy			raid"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "ortona		raid"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "reichswald	raid"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "saint_lo		raid"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "salerno       raid"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "sicily		raid"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "rhineland		raid"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "bastogne      entrenchment"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "comacchio		entrenchment"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "crete			entrenchment"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "dog_red       entrenchment"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "foy			entrenchment"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "ortona		entrenchment"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "reichswald    entrenchment"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "saint_lo		entrenchment"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "salerno       entrenchment"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "sicily		entrenchment"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "rhineland		entrenchment"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "breville		entrenchment"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "dunkirk		entrenchment"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "brittany		entrenchment"
    Add-Content   $MapCyclePath\Mapcycle_coop.txt "flakturm		entrenchment"
    # PVP modes: mp_battles.playlist
    Write-Host "***  Creating Mapcycle_mp_battles.txt  ***" -ForegroundColor Magenta -BackgroundColor Black
    New-Item    $MapCyclePath\Mapcycle_mp_battles.txt -Force
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "bastogne	    offensive"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "comacchio    offensive"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "crete	    offensive"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "dog_red		offensive"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "foy	        offensive"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "ortona		offensive"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "reichswald	offensive"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "saint_lo     offensive"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "salerno		offensive"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "sicily		offensive"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "rhineland    offensive"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "breville		offensive"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "dunkirk		offensive"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "brittany		offensive"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "flakturm		offensive"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "bastogne		frontline"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "comacchio	frontline"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "crete		frontline"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "foy          frontline"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "ortona		frontline"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "reichswald	frontline"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "saint_lo     frontline"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "salerno		frontline"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "sicily		frontline"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "breville		frontline"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "rhineland    frontline"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "flakturm		frontline"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "bastogne		liberation"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "comacchio	liberation"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "crete		liberation"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "foy          liberation"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "ortona	    liberation"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "reichswald	liberation"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "saint_lo     liberation"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "salerno		liberation"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "sicily		liberation"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "rhineland    liberation"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "breville		liberation"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "dunkirk		liberation"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "brittany		liberation"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "bastogne     invasion"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "sicily       invasion"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "dog_red      invasion"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "foy          invasion"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "crete        invasion"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "ortona       invasion"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "breville		invasion"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "dunkirk		invasion"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "brittany	    invasion"
    Add-Content   $MapCyclePath\Mapcycle_mp_battles.txt "flakturm		invasion"
    # mp_special_assignments.playlist
    Write-Host "***  Creating Mapcycle_mp_special_assignments.txt  ***" -ForegroundColor Magenta -BackgroundColor Black
    New-Item   $MapCyclePath\Mapcycle_mp_special_assignments.txt -Force 
    Add-Content   $MapCyclePath\Mapcycle_mp_special_assignments.txt "bastogne    firefight"
    Add-Content   $MapCyclePath\Mapcycle_mp_special_assignments.txt "comacchio	firefight"
    Add-Content   $MapCyclePath\Mapcycle_mp_special_assignments.txt "crete		firefight"
    Add-Content   $MapCyclePath\Mapcycle_mp_special_assignments.txt "foy			firefight"
    Add-Content   $MapCyclePath\Mapcycle_mp_special_assignments.txt "ortona		firefight"
    Add-Content   $MapCyclePath\Mapcycle_mp_special_assignments.txt "reichswald   firefight"
    Add-Content   $MapCyclePath\Mapcycle_mp_special_assignments.txt "saint_lo     firefight"
    Add-Content   $MapCyclePath\Mapcycle_mp_special_assignments.txt "salerno		firefight"
    Add-Content   $MapCyclePath\Mapcycle_mp_special_assignments.txt "sicily		firefight"
    Add-Content   $MapCyclePath\Mapcycle_mp_special_assignments.txt "rhineland	firefight"
    Add-Content   $MapCyclePath\Mapcycle_mp_special_assignments.txt "breville	firefight"
    Add-Content   $MapCyclePath\Mapcycle_mp_special_assignments.txt "brittany	firefight"
    Add-Content   $MapCyclePath\Mapcycle_mp_special_assignments.txt "ortona		sabotage"
    Add-Content   $MapCyclePath\Mapcycle_mp_special_assignments.txt "comacchio	sabotage"
    Add-Content   $MapCyclePath\Mapcycle_mp_special_assignments.txt "reichswald  sabotage"
    Add-Content   $MapCyclePath\Mapcycle_mp_special_assignments.txt "saint_lo     sabotage"
    Add-Content   $MapCyclePath\Mapcycle_mp_special_assignments.txt "salerno       sabotage"	
    Add-Content   $MapCyclePath\Mapcycle_mp_special_assignments.txt "sicily         sabotage"
    Add-Content   $MapCyclePath\Mapcycle_mp_special_assignments.txt "foy           sabotage"
    Add-Content   $MapCyclePath\Mapcycle_mp_special_assignments.txt "rhineland     sabotage"
    Add-Content   $MapCyclePath\Mapcycle_mp_special_assignments.txt "breville		sabotage"
    Add-Content   $MapCyclePath\Mapcycle_mp_special_assignments.txt "ortona           intel"
    Add-Content   $MapCyclePath\Mapcycle_mp_special_assignments.txt "reichswald     intel"
    Add-Content   $MapCyclePath\Mapcycle_mp_special_assignments.txt "salerno         intel"
    Add-Content   $MapCyclePath\Mapcycle_mp_special_assignments.txt "saint_lo        intel"
    Add-Content   $MapCyclePath\Mapcycle_mp_special_assignments.txt "rhineland		intel"
    Add-Content   $MapCyclePath\Mapcycle_mp_special_assignments.txt "breville		intel"
    Add-Content   $MapCyclePath\Mapcycle_mp_special_assignments.txt "brittany		intel"
    # mp_casual_with_bots.playlist
    Write-Host "***  Mapcycle_mp_casual_with_bots.txt  ***" -ForegroundColor Magenta -BackgroundColor Black
    New-Item   $MapCyclePath\Mapcycle_mp_casual_with_bots.txt -Force 
    #Add-Content   $MapCyclePath\Mapcycle_mp_casual_with_bots.txt 
    Add-Content   $MapCyclePath\Mapcycle_mp_casual_with_bots.txt "bastogne			frontline"
    Add-Content   $MapCyclePath\Mapcycle_mp_casual_with_bots.txt "comacchio			frontline"
    Add-Content   $MapCyclePath\Mapcycle_mp_casual_with_bots.txt "crete				frontline"
    Add-Content   $MapCyclePath\Mapcycle_mp_casual_with_bots.txt "dog_red			invasion"
    Add-Content   $MapCyclePath\Mapcycle_mp_casual_with_bots.txt "foy                frontline"
    Add-Content   $MapCyclePath\Mapcycle_mp_casual_with_bots.txt "ortona				frontline"
    Add-Content   $MapCyclePath\Mapcycle_mp_casual_with_bots.txt "reichswald			frontline"
    Add-Content   $MapCyclePath\Mapcycle_mp_casual_with_bots.txt "saint_lo           frontline"
    Add-Content   $MapCyclePath\Mapcycle_mp_casual_with_bots.txt "salerno			frontline"
    Add-Content   $MapCyclePath\Mapcycle_mp_casual_with_bots.txt "sicily				frontline"
    Add-Content   $MapCyclePath\Mapcycle_mp_casual_with_bots.txt "breville			frontline"
    Add-Content   $MapCyclePath\Mapcycle_mp_casual_with_bots.txt "rhineland          frontline"
}