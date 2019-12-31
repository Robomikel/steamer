Function New-LaunchScriptInsserverPS
{
    #----------   Insurgency Server CFG    -------------------
    ${gamedirname}="Insurgency"
    ${config1}="server.cfg"
    (New-Object Net.WebClient).DownloadFile("$githuburl/${gamedirname}/${config1}", "$global:currentdir\$global:server\insurgency\cfg\server.cfg")
    $global:process = "srcds"
    ${global:IP} = Read-host -Prompt 'Input Server local IP'
    if(($global:PORT = Read-Host "Input Server Port,Press enter to accept default value [27015]") -eq ''){$global:PORT="27015"}else{$global:PORT}
    if(($global:MAP = Read-Host "Input Server Map and Mode,Press enter to accept default value [buhriz_coop checkpoint]") -eq ''){$global:MAP="buhriz_coop checkpoint"}else{$global:MAP}
    $global:MAXPLAYERS = Read-host -Prompt 'Input maxplayers (lobby size [24-48])'
    $global:PLAYERS = Read-host -Prompt 'Input players  (mp_coop_lobbysize [1-8])'
    $global:HOSTNAME = Read-host -Prompt 'Input hostname'
    $global:RCONPASSORD = Read-host -Prompt 'Input rcon_password'
    if(($global:workshop = Read-Host "Input 1 to enable workshop, Press enter to accept default value [0]") -eq ''){$global:workshop="0"}else{$global:workshop}
    if(($global:sv_pure = Read-Host "Input addtional launch params ie. +sv_pure 0, Press enter to accept default value []") -eq ''){}else{$global:sv_pure}
    ((Get-Content -path $global:currentdir\$global:server\insurgency\cfg\server.cfg -Raw) -replace "\bSERVERNAME\b","$global:HOSTNAME") | Set-Content -Path $global:currentdir\$global:server\insurgency\cfg\server.cfg
    ((Get-Content -path $global:currentdir\$global:server\insurgency\cfg\server.cfg -Raw) -replace "\bADMINPASSWORD\b","$global:RCONPASSORD") | Set-Content -Path $global:currentdir\$global:server\insurgency\cfg\server.cfg
    #((Get-Content -path $global:currentdir\$global:server\insurgency\cfg\server.cfg -Raw) -replace "SERVERNAME","$global:HOSTNAME") | Set-Content -Path $global:currentdir\$global:server\insurgency\cfg\server.cfg

    New-Item $global:currentdir\$global:server\insurgency\subscribed_file_ids.txt -Force
    New-Item $global:currentdir\$global:server\insurgency\motd.txt -Force
    #Add-Content -Path $global:currentdir\$global:server\insurgency\cfg\server.cfg -Value "hostname '$global:HOSTNAME'"
    #Add-Content -Path $global:currentdir\$global:server\insurgency\cfg\server.cfg -Value "rcon_password '$global:RCONPASSORD'"
    #Add-Content -Path $global:currentdir\$global:server\insurgency\cfg\server.cfg -Value "mapcyclefile 'mapcycle_checkpoint.txt'"
    New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "if(`$Null -eq (get-process `"$global:process`" -ea SilentlyContinue)){"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-UpdateServer"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
    #Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-UpdateServer"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\srcds.exe -ip ${global:IP} -port $global:PORT +maxplayers $global:MAXPLAYERS +mp_coop_lobbysize $global:PLAYERS +map '$global:MAP' +sv_workshop_enabled $global:workshop $global:sv_pure"
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
    Get-SourceMetaMod
    Write-Host 'Entered Y'
    Get-Gamemode
} else {
    Write-Host 'Entered N'
    Get-Gamemode
    #Select-Steamer
}

}

Function Get-SourceMetaMod {

Write-Host '*** Downloading and Extracting Meta Mod *****' -ForegroundColor Magenta -BackgroundColor Black 
(New-Object Net.WebClient).DownloadFile("$global:metamodurl", "$global:currentdir\metamod.zip")
Expand-Archive "$global:currentdir\metamod.zip" "$global:currentdir\metamod\" -Force
#Move-Item -Path $global:currentdir\metamod\* -Destination 
Copy-Item -Path $global:currentdir\metamod\* -Destination $global:currentdir\$global:server\insurgency -Force -Recurse


Write-Host '*** Downloading and Extracting SourceMod *****' -ForegroundColor Magenta -BackgroundColor Black
(New-Object Net.WebClient).DownloadFile("$global:sourcemodurl", "$global:currentdir\sourcemod.zip") 
Expand-Archive "$global:currentdir\sourcemod.zip" "$global:currentdir\sourcemod\" -Force
Copy-Item -Path $global:currentdir\sourcemod\* -Destination $global:currentdir\$global:server\insurgency -Force -Recurse

}
  #  https://sm.alliedmods.net/smdrop/1.11/sourcemod-1.11.0-git6478-windows.zip
  #  https://mms.alliedmods.net/mmsdrop/1.11/mmsource-1.11.0-git1128-windows.zip
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
                #Add-Content -Path $global:currentdir\$global:server\insurgency\cfg\server.cfg -Value "//edited by steamer"
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
                                    Write-Host "entered blank or null" -ForegroundColor Magenta
                                    #
    }
}
                

Function Set-Gamemode 
{
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
        Get-Playlist
    }
}
Function Get-Gamemode {
    
    
    $title    = 'Set playlist and Mapcycle now?'
    $question = 'Set Gamemode (playlist) and Mapcycle now?'

    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
    if ($decision -eq 0) {
        #Get-SourceMetaMod
        Set-Gamemode
        Write-Host 'Entered Y'
        } else {
        Write-Host 'Entered N'
        #Select-Steamer
    }



}
