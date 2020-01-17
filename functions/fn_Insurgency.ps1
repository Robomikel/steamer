Function New-LaunchScriptInsserverPS {
    #----------   Insurgency Server CFG    -------------------
    $global:EXEDIR="insurgency"
    $global:game="insurgency"
    ${gamedirname}="Insurgency"
    ${config1}="server.cfg"
    $global:process = "srcds"
    Write-Host "***  Copying Default server.cfg  ***" -ForegroundColor Magenta -BackgroundColor Black
    #(New-Object Net.WebClient).DownloadFile("$githuburl/${gamedirname}/${config1}", "$global:currentdir\$global:server\insurgency\cfg\server.cfg")
    $insWebResponse=Invoke-WebRequest "$githuburl/${gamedirname}/${config1}"
    New-Item $global:currentdir\$global:server\insurgency\cfg\server.cfg -Force
    Add-Content $global:currentdir\$global:server\insurgency\cfg\server.cfg $insWebResponse
    Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "Input Server local IP: " -ForegroundColor Cyan -NoNewline
    ${global:IP} = Read-Host
    if(($global:PORT = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [27015]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:PORT="27015"}else{$global:PORT}
    if(($global:MAP = Read-Host -Prompt (Write-Host "Input Server Map and Mode,Press enter to accept default value [buhriz_coop checkpoint]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:MAP="buhriz_coop checkpoint"}else{$global:MAP}
    Write-Host 'Input maxplayers (lobby size [24-48]): ' -ForegroundColor Cyan -NoNewline
    $global:MAXPLAYERS = Read-host 
    Write-Host 'Input players  (mp_coop_lobbysize [1-8]): ' -ForegroundColor Cyan -NoNewline  
    $global:PLAYERS = Read-host
    Write-Host 'Input hostname: ' -ForegroundColor Cyan -NoNewline 
    $global:HOSTNAME = Read-host
    if(($global:RCONPASSWORD = Read-Host -Prompt (Write-Host "Input Server Rcon Password,Press enter to accept default value [$global:RANDOMPASSWORD]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:RCONPASSWORD="$global:RANDOMPASSWORD"}else{$global:RCONPASSWORD}
    $global:RCONPORT="$global:PORT"
    if(($global:WORKSHOP = Read-Host -Prompt (Write-Host "Input 1 to enable workshop, Press enter to accept default value [0]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:WORKSHOP="0"}else{$global:WORKSHOP}
    if(($global:SV_PURE = Read-Host -Prompt (Write-Host "Input addtional launch params ie. +sv_pure 0, Press enter to accept default value []: "-ForegroundColor Cyan -NoNewline)) -eq ''){}else{$global:SV_PURE}
    Write-Host "***  Editing Default server.cfg  ***" -ForegroundColor Magenta -BackgroundColor Black
    ((Get-Content -path $global:currentdir\$global:server\insurgency\cfg\server.cfg -Raw) -replace "\bSERVERNAME\b","$global:HOSTNAME") | Set-Content -Path $global:currentdir\$global:server\insurgency\cfg\server.cfg
    ((Get-Content -path $global:currentdir\$global:server\insurgency\cfg\server.cfg -Raw) -replace "\bADMINPASSWORD\b","$global:RCONPASSWORD") | Set-Content -Path $global:currentdir\$global:server\insurgency\cfg\server.cfg
    Write-Host "***  Creating subscribed_file_ids.txt ***" -ForegroundColor Magenta -BackgroundColor Black
    New-Item $global:currentdir\$global:server\insurgency\subscribed_file_ids.txt -Force
    Write-Host "***  Creating motd.txt ***" -ForegroundColor Magenta -BackgroundColor Black
    New-Item $global:currentdir\$global:server\insurgency\motd.txt -Force
    Write-Host "***  Creating Launch script ***" -ForegroundColor Magenta -BackgroundColor Black
    New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\srcds.exe -ip ${global:IP} -port $global:PORT +maxplayers $global:MAXPLAYERS +mp_coop_lobbysize $global:PLAYERS +map '$global:MAP' +sv_workshop_enabled $global:WORKSHOP $global:SV_PURE"
    Get-SourceMetMod
    Get-Gamemode
}



Function Get-Playlist {
    Write-Host "Checking playlist" -ForegroundColor Yellow
    if($global:playlist -eq "comp") {
        Write-Host "edit nwi/$global:playlist in server.cfg" -ForegroundColor Magenta
        ((Get-Content -path $global:currentdir\$global:server\insurgency\cfg\server.cfg -Raw) -replace "//mapcyclefile `"mapcycle.txt`"","mapcyclefile `"mapcycle_comp.txt`"") | Set-Content -Path $global:currentdir\$global:server\insurgency\cfg\server.cfg
    }elseif($global:playlist -eq "coop") {
            Write-Host "edit nwi/$global:playlist in server.cfg" -ForegroundColor Magenta
            ((Get-Content -path $global:currentdir\$global:server\insurgency\cfg\server.cfg -Raw) -replace "//mapcyclefile `"mapcycle.txt`"","mapcyclefile `"mapcycle_cooperative.txt`"") | Set-Content -Path $global:currentdir\$global:server\insurgency\cfg\server.cfg
    }elseif($global:playlist -eq "coop_elite") {
                Write-Host "edit nwi/$global:playlist in server.cfg" -ForegroundColor Magenta
                ((Get-Content -path $global:currentdir\$global:server\insurgency\cfg\server.cfg -Raw) -replace "//mapcyclefile `"mapcycle.txt`"","mapcyclefile `"mapcycle_cooperative.txt`"") | Set-Content -Path $global:currentdir\$global:server\insurgency\cfg\server.cfg
    }elseif($global:playlist -eq "coop_hardcore"){
                    Write-Host "edit nwi/$global:playlist in server.cfg" -ForegroundColor Magenta
                    ((Get-Content -path $global:currentdir\$global:server\insurgency\cfg\server.cfg -Raw) -replace "//mapcyclefile `"mapcycle.txt`"","mapcyclefile `"mapcycle_cooperative.txt`"") | Set-Content -Path $global:currentdir\$global:server\insurgency\cfg\server.cfg
    }elseif($global:playlist -eq "pvp_sustained"){
                        Write-Host "edit nwi/$global:playlist in server.cfg" -ForegroundColor Magenta
                        ((Get-Content -path $global:currentdir\$global:server\insurgency\cfg\server.cfg -Raw) -replace "//mapcyclefile `"mapcycle.txt`"","mapcyclefile `"mapcycle_sustained_combat.txt`"") | Set-Content -Path $global:currentdir\$global:server\insurgency\cfg\server.cfg
    }elseif($global:playlist -eq "pvp_tactical"){
                            Write-Host "edit nwi/$global:playlist in server.cfg" -ForegroundColor Magenta
                            ((Get-Content -path $global:currentdir\$global:server\insurgency\cfg\server.cfg -Raw) -replace "//mapcyclefile `"mapcycle.txt`"","mapcyclefile `"mapcycle_tactical_operations.txt`"") | Set-Content -Path $global:currentdir\$global:server\insurgency\cfg\server.cfg
    }elseif($global:playlist -eq "conquer"){
                                Write-Host "edit nwi/$global:playlist in server.cfg" -ForegroundColor Magenta
                                ((Get-Content -path $global:currentdir\$global:server\insurgency\cfg\server.cfg -Raw) -replace "//mapcyclefile `"mapcycle.txt`"","mapcyclefile `"mapcycle_conquer.txt`"") | Set-Content -Path $global:currentdir\$global:server\insurgency\cfg\server.cfg
    }elseif($null -eq $global:playlist) {
                                    Write-Host "entered blank or null" -ForegroundColor Red
    }
}
                

Function Set-Gamemode {
    Write-Host "Enter one of the listed modes" -ForegroundColor Yellow
    Write-Host "comp" -ForegroundColor Yellow
    Write-Host "coop" -ForegroundColor Yellow
    Write-Host "coop_elite" -ForegroundColor Yellow
    Write-Host "coop_hardcore" -ForegroundColor Yellow
    Write-Host "pvp_sustained" -ForegroundColor Yellow
    Write-Host "pvp_tactical" -ForegroundColor Yellow
    Write-Host "conquer" -ForegroundColor Yellow
    $global:playlist = Read-Host "Enter mode, Will add Mapcycle per mode"
    if(($global:playlist -eq "comp") -or ($global:playlist -eq "coop") -or ($global:playlist -eq "coop_elite") -or ($global:playlist -eq "coop_hardcore") -or ($global:playlist -eq "pvp_sustained") -or ($global:playlist -eq "pvp_tactical")-or ($global:playlist -eq "conquer")) {
    Write-Host "Editing nwi/$global:playlist playlist in server.cfg" -ForegroundColor Magenta
    ((Get-Content -path $global:currentdir\$global:server\insurgency\cfg\server.cfg -Raw) -replace "sv_playlist `"nwi/coop`"","sv_playlist `"nwi/$global:playlist`"") | Set-Content -Path $global:currentdir\$global:server\insurgency\cfg\server.cfg
    Get-Playlist}
    else{
    Write-Host " listed modes does not exist" -ForegroundColor Yellow
    Set-Gamemode }
}
Function Get-Gamemode {
    $title    = 'Set playlist and Mapcycle now?'
    $question = 'Set Gamemode (playlist) and Mapcycle now?'
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
    if ($decision -eq 0) {
    Set-Gamemode
    Write-Host 'Entered Y'} 
    else{
    Write-Host 'Entered N'}
}
