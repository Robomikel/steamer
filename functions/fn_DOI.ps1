Function New-LaunchScriptdoiserverPS
{
    #----------   doi Server CFG    -------------------
    ${gamedirname}="DayOfInfamy"
    ${config1}="server.cfg"
    Write-Host "***  Copying Default server.cfg  ***" -ForegroundColor Magenta -BackgroundColor Black
    #(New-Object Net.WebClient).DownloadFile("$githuburl/${gamedirname}/${config1}", "$global:currentdir\$global:server\doi\cfg\server.cfg")
    #"https://raw.githubusercontent.com/GameServerManagers/Game-Server-Configs/master/DayOfInfamy/server.cfg"
    $insWebResponse=Invoke-WebRequest "$githuburl/${gamedirname}/${config1}"
    $insWebResponse=$insWebResponse.content
    New-Item $global:currentdir\$global:server\doi\cfg\server.cfg -Force
    Add-Content $global:currentdir\$global:server\doi\cfg\server.cfg $insWebResponse
    Write-Host "***  Renaming srcds.exe to doi.exe to avoid conflict with local Insurgency (srcds.exe) server  ***" -ForegroundColor Magenta -BackgroundColor Black
    Rename-Item -Path "$global:currentdir\$global:server\srcds.exe" -NewName "$global:currentdir\$global:server\doi.exe" >$null 2>&1
    Rename-Item -Path "$global:currentdir\$global:server\srcds_x64.exe" -NewName "$global:currentdir\$global:server\doi_x64.exe" >$null 2>&1
    
    
    Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
    $global:process = "doi"
    Write-Host "Input Server local IP: " -ForegroundColor Cyan -NoNewline
    ${global:IP} = Read-Host
    if(($global:PORT = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [27015]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:PORT="27015"}else{$global:PORT}
    if(($global:MAP = Read-Host -Prompt (Write-Host "Input Server Map and Mode,Press enter to accept default value [bastogne stronghold]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:MAP="bastogne stronghold"}else{$global:MAP}
    if(($global:SV_LAN = Read-Host -Prompt (Write-Host "Input SV_LAN,Press enter to accept default value [0]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:SV_LAN="0"}else{$global:SV_LAN}
    if(($global:MAXPLAYERS = Read-Host -Prompt (Write-Host "Input maxplayers (lobby size 24-48) Press enter to accept default value [32]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:MAXPLAYERS="32"}else{$global:MAXPLAYERS}
#    Write-Host 'Input maxplayers (lobby size [24-48]): ' -ForegroundColor Cyan -NoNewline
 #   $global:MAXPLAYERS = Read-host 
    Write-Host 'Input players  (mp_coop_lobbysize [1-16]): ' -ForegroundColor Cyan -NoNewline  
    $global:PLAYERS = Read-host
    Write-Host 'Input hostname: ' -ForegroundColor Cyan -NoNewline 
    $global:HOSTNAME = Read-host
    Write-Host 'Input rcon_password: ' -ForegroundColor Cyan -NoNewline
    $global:RCONPASSORD = Read-host
    if(($global:workshop = Read-Host -Prompt (Write-Host "Input 1 to enable workshop, Press enter to accept default value [0]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:workshop="0"}else{$global:workshop}
    if(($global:sv_pure = Read-Host -Prompt (Write-Host "Input addtional launch params ie. +sv_pure 0, Press enter to accept default value []: "-ForegroundColor Cyan -NoNewline)) -eq ''){}else{$global:sv_pure}
    Write-Host "***  Editing Default server.cfg  ***" -ForegroundColor Magenta -BackgroundColor Black
    ((Get-Content -path $global:currentdir\$global:server\doi\cfg\server.cfg -Raw) -replace "\bSERVERNAME\b","$global:HOSTNAME") | Set-Content -Path $global:currentdir\$global:server\doi\cfg\server.cfg
    ((Get-Content -path $global:currentdir\$global:server\doi\cfg\server.cfg -Raw) -replace "\bADMINPASSWORD\b","$global:RCONPASSORD") | Set-Content -Path $global:currentdir\$global:server\doi\cfg\server.cfg
    Write-Host "***  Creating subscribed_file_ids.txt ***" -ForegroundColor Magenta -BackgroundColor Black
    New-Item $global:currentdir\$global:server\doi\subscribed_file_ids.txt -Force
    Write-Host "***  Creating motd.txt ***" -ForegroundColor Magenta -BackgroundColor Black
    New-Item $global:currentdir\$global:server\doi\motd.txt -Force
    Write-Host "***  Creating Launch script ***" -ForegroundColor Magenta -BackgroundColor Black
    New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "if(`$Null -eq (get-process `"$global:process`" -ea SilentlyContinue)){"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-UpdateServer"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\doi.exe -ip ${global:IP} -usercon -port $global:PORT +maxplayers $global:MAXPLAYERS +sv_lan $global:SV_LAN +mp_coop_lobbysize $global:PLAYERS +map '$global:MAP' +sv_workshop_enabled $global:workshop $global:sv_pure"
                                                                                                                           #start srcds.exe -usercon +maxplayers 24 +sv_lan 0 +map "bastogne offensive"              
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
    Get-SourceMetaModdoi
    Write-Host 'Entered Y'
    Get-Gamemodedoi
} else {
    Write-Host 'Entered N'
    Get-Gamemodedoi
}

}

Function Get-SourceMetaModdoi {
$start_time = Get-Date
Write-Host '*** Downloading Meta Mod *****' -ForegroundColor Magenta -BackgroundColor Black 
#(New-Object Net.WebClient).DownloadFile("$global:metamodurl", "$global:currentdir\metamod.zip")
#[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
Invoke-WebRequest -Uri $global:metamodurl -OutFile $global:currentdir\metamod.zip 
Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
Write-Host '*** Extracting Meta Mod *****' -ForegroundColor Magenta -BackgroundColor Black
Expand-Archive "$global:currentdir\metamod.zip" "$global:currentdir\metamod\" -Force
Write-Host '*** Copying/installing Meta Mod *****' -ForegroundColor Magenta -BackgroundColor Black 
Copy-Item -Path $global:currentdir\metamod\* -Destination $global:currentdir\$global:server\doi -Force -Recurse

$start_time = Get-Date
Write-Host '*** Downloading SourceMod *****' -ForegroundColor Magenta -BackgroundColor Black
#(New-Object Net.WebClient).DownloadFile("$global:sourcemodurl", "$global:currentdir\sourcemod.zip")
#[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
Invoke-WebRequest -Uri $global:sourcemodurl -OutFile $global:currentdir\sourcemod.zip 
Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
Write-Host '*** Extracting SourceMod *****' -ForegroundColor Magenta -BackgroundColor Black 
Expand-Archive "$global:currentdir\sourcemod.zip" "$global:currentdir\sourcemod\" -Force
Write-Host '*** Copying/installing SourceMod *****' -ForegroundColor Magenta -BackgroundColor Black
Copy-Item -Path $global:currentdir\sourcemod\* -Destination $global:currentdir\$global:server\doi -Force -Recurse

}
# not used in DOI 
#server.cfg		// this is your primary server config file containing global variables
#default_server_<mode>.cfg		// default file which contains settings for specific mode
#server_<mode>.cfg         // non-default config, overrides default, use this for custom servers
#server_<map>.cfg		// optional file for settings per-map
#server_<map>_<mode>.cfg		// optional file for settings per-map-gamemode
Function Get-Playlistdoi {
    Write-Host "Checking playlist" -ForegroundColor Yellow
    if($global:playlist -eq "coop_commando") {
        Write-Host "edit nwi/$global:playlist in server.cfg" -ForegroundColor Magenta
        ((Get-Content -path $global:currentdir\$global:server\doi\cfg\server.cfg -Raw) -replace "// Playlist","mapcyclefile `"mapcycle_coop.txt`"") | Set-Content -Path $global:currentdir\$global:server\doi\cfg\server.cfg
    }elseif($global:playlist -eq "coop") {
            Write-Host "edit nwi/$global:playlist in server.cfg" -ForegroundColor Magenta
            ((Get-Content -path $global:currentdir\$global:server\doi\cfg\server.cfg -Raw) -replace "// Playlist","mapcyclefile `"mapcycle_coop.txt`"") | Set-Content -Path $global:currentdir\$global:server\doi\cfg\server.cfg
    }elseif($global:playlist -eq "mp_battles") {
                Write-Host "edit nwi/$global:playlist in server.cfg" -ForegroundColor Magenta
                ((Get-Content -path $global:currentdir\$global:server\doi\cfg\server.cfg -Raw) -replace "// Playlist","mapcyclefile `"Mapcycle_mp_battles.txt`"") | Set-Content -Path $global:currentdir\$global:server\doi\cfg\server.cfg
    }elseif($global:playlist -eq "mp_casual_with_bots"){
                    Write-Host "edit nwi/$global:playlist in server.cfg" -ForegroundColor Magenta
                    ((Get-Content -path $global:currentdir\$global:server\doi\cfg\server.cfg -Raw) -replace "// Playlist","mapcyclefile `"Mapcycle_mp_casual_with_bots.txt`"") | Set-Content -Path $global:currentdir\$global:server\doi\cfg\server.cfg
    #}elseif($global:playlist -eq "mp_first_deployment"){
    #                    Write-Host "edit nwi/$global:playlist in server.cfg" -ForegroundColor Magenta
    #                    ((Get-Content -path $global:currentdir\$global:server\doi\cfg\server.cfg -Raw) -replace "// Playlist","mapcyclefile `"mapcycle.txt`"") | Set-Content -Path $global:currentdir\$global:server\doi\cfg\server.cfg
    }elseif($global:playlist -eq "mp_special_assignments"){
                            Write-Host "edit nwi/$global:playlist in server.cfg" -ForegroundColor Magenta
                            ((Get-Content -path $global:currentdir\$global:server\doi\cfg\server.cfg -Raw) -replace "// Playlist","mapcyclefile `"Mapcycle_mp_special_assignments.txt`"") | Set-Content -Path $global:currentdir\$global:server\doi\cfg\server.cfg
    #}elseif($global:playlist -eq "conquer"){
    #                            Write-Host "edit nwi/$global:playlist in server.cfg" -ForegroundColor Magenta
    #                            ((Get-Content -path $global:currentdir\$global:server\doi\cfg\server.cfg -Raw) -replace "//mapcyclefile `"mapcycle.txt`"","mapcyclefile `"mapcycle_conquer.txt`"") | Set-Content -Path $global:currentdir\$global:server\doi\cfg\server.cfg
    #}elseif($null -eq $global:playlist) {
    #                                Write-Host "entered blank or null" -ForegroundColor Red
    }
}
                

Function Set-Gamemodedoi 
{

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
        if(($global:playlist -eq "coop_commando") -or ($global:playlist -eq "coop") -or ($global:playlist -eq "mp_battles") -or ($global:playlist -eq "mp_casual_with_bots") -or ($global:playlist -eq "mp_special_assignments")) {
        Write-Host "Editing nwi/$global:playlist playlist in server.cfg" -ForegroundColor Magenta
        ((Get-Content -path $global:currentdir\$global:server\doi\cfg\server.cfg -Raw) -replace "`"sv_playlist`" 		  `"nwi/coop`"","sv_playlist `"nwi/$global:playlist`"") | Set-Content -Path $global:currentdir\$global:server\doi\cfg\server.cfg
        Get-Playlistdoi}else{
            Write-Host " listed modes does not exist" -ForegroundColor Yellow
            Set-Gamemodedoi 
        }
}
Function Get-Gamemodedoi {
    
    
    $title    = 'Set playlist and Mapcycles now?'
    $question = 'Set Gamemode (playlist will set Mapcycle) now?'

    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
    if ($decision -eq 0) {
        Set-Gamemodedoi
        new-mapcycles
        Write-Host 'Entered Y'
        } else {
        Write-Host 'Entered N'
    }



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
       Add-Content   $MapCyclePath\Mapcycle_mp_casual_with_bots.txt 
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