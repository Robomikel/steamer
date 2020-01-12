Function New-LaunchScriptLFD2serverPS {
    #----------   left4dead2 Server CFG    -------------------
            # Left 4 Dead 2 Server
            $global:game="left4dead2"
    ${gamedirname}="Left4Dead2"
    ${config1}="server.cfg"
    Write-Host "***  Copying Default server.cfg  ***" -ForegroundColor Magenta -BackgroundColor Black
    #(New-Object Net.WebClient).DownloadFile("$githuburl/${gamedirname}/${config1}", "$global:currentdir\$global:server\insurgency\cfg\server.cfg")
    $insWebResponse=Invoke-WebRequest "$githuburl/${gamedirname}/${config1}"
    $insWebResponse=$insWebResponse.content
    New-Item $global:currentdir\$global:server\left4dead2\cfg\server.cfg -Force
    Add-Content $global:currentdir\$global:server\left4dead2\cfg\server.cfg $insWebResponse
    
    Write-Host "***  Renaming srcds.exe to l4d2.exe to avoid conflict with local source Engine (srcds.exe) server  ***" -ForegroundColor Magenta -BackgroundColor Black
    Rename-Item -Path "$global:currentdir\$global:server\srcds.exe" -NewName "$global:currentdir\$global:server\l4d2.exe" >$null 2>&1
    Rename-Item -Path "$global:currentdir\$global:server\srcds_x64.exe" -NewName "$global:currentdir\$global:server\l4d2_x64.exe" >$null 2>&1
    
    Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
    $global:process = "l4d2"
    Write-Host "Input Server local IP: " -ForegroundColor Cyan -NoNewline
    ${global:IP} = Read-Host
    if(($global:PORT = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [27015]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:PORT="27015"}else{$global:PORT}
    if(($global:CLIENTPORT = Read-Host -Prompt (Write-Host "Input Server Client Port, Press enter to accept default value [27005]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:CLIENTPORT="27005"}else{$global:CLIENTPORT}
    if(($global:MAP = Read-Host -Prompt (Write-Host "Input Server Map and Mode,Press enter to accept default value [c1m1_hotel]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:MAP="c1m1_hotel"}else{$global:MAP}
    Write-Host 'Input maxplayers[1-8]: ' -ForegroundColor Cyan -NoNewline
    $global:MAXPLAYERS = Read-host 
    #Write-Host 'Input players  (mp_coop_lobbysize [1-8]): ' -ForegroundColor Cyan -NoNewline  
    #$global:PLAYERS = Read-host
    Write-Host 'Input hostname: ' -ForegroundColor Cyan -NoNewline 
    $global:HOSTNAME = Read-host
    Write-Host 'Input rcon_password: ' -ForegroundColor Cyan -NoNewline
    $global:RCONPASSWORD = Read-host
    $global:RCONPORT="$global:PORT"
    #if(($global:workshop = Read-Host -Prompt (Write-Host "Input 1 to enable workshop, Press enter to accept default value [0]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:workshop="0"}else{$global:workshop}
    #if(($global:sv_pure = Read-Host -Prompt (Write-Host "Input addtional launch params ie. +sv_pure 0, Press enter to accept default value []: "-ForegroundColor Cyan -NoNewline)) -eq ''){}else{$global:sv_pure}
    Write-Host "***  Editing Default server.cfg  ***" -ForegroundColor Magenta -BackgroundColor Black
    ((Get-Content -path $global:currentdir\$global:server\left4dead2\cfg\server.cfg -Raw) -replace "\bSERVERNAME\b","$global:HOSTNAME") | Set-Content -Path $global:currentdir\$global:server\left4dead2\cfg\server.cfg
    ((Get-Content -path $global:currentdir\$global:server\left4dead2\cfg\server.cfg -Raw) -replace "\bADMINPASSWORD\b","$global:RCONPASSWORD") | Set-Content -Path $global:currentdir\$global:server\left4dead2\cfg\server.cfg
    #Write-Host "***  Creating subscribed_file_ids.txt ***" -ForegroundColor Magenta -BackgroundColor Black
    #New-Item $global:currentdir\$global:server\insurgency\subscribed_file_ids.txt -Force
    #Write-Host "***  Creating motd.txt ***" -ForegroundColor Magenta -BackgroundColor Black
    #New-Item $global:currentdir\$global:server\insurgency\motd.txt -Force
    Write-Host "***  Creating Launch script ***" -ForegroundColor Magenta -BackgroundColor Black
    New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "if(`$Null -eq (get-process `"$global:process`" -ea SilentlyContinue)){"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-UpdateServer"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\l4d2.exe -console -game left4dead2 -strictportbind -ip ${global:IP} +port $global:PORT +clientport $global:CLIENTPORT +hostip ${global:EXTIP} +maxplayers $global:MAXPLAYERS +map '$global:MAP'"# +sv_workshop_enabled $global:workshop $global:sv_pure
    #A:\L4D2\srcds.exe -console -game left4dead2 -ip 10.0.0.2 +port 27020 +hostip YOURDEDIIP +maxplayers 8 +exec server.cfg +map c2m1_highway
    # -game left4dead2 -strictportbind -ip ${ip} -port ${port} +clientport ${clientport} +map ${defaultmap} +servercfgfile ${servercfg} -maxplayers ${maxplayers}
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
    Get-SourceMetaModl4d2
    Write-Host 'Entered Y'
    #Get-Gamemode
  } else {
    Write-Host 'Entered N'
    #Get-Gamemode
  }
  
  }
  
  Function Get-SourceMetaModl4d2 {
  $start_time = Get-Date
  Write-Host '*** Downloading Meta Mod *****' -ForegroundColor Magenta -BackgroundColor Black 
  #(New-Object Net.WebClient).DownloadFile("$global:metamodurl", "$global:currentdir\metamod.zip")
  #[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
  Invoke-WebRequest -Uri $global:metamodurl -OutFile $global:currentdir\metamod.zip
  Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
  Write-Host '*** Extracting Meta Mod *****' -ForegroundColor Magenta -BackgroundColor Black
  Expand-Archive "$global:currentdir\metamod.zip" "$global:currentdir\metamod\" -Force
  Write-Host '*** Copying/installing Meta Mod *****' -ForegroundColor Magenta -BackgroundColor Black 
  Copy-Item -Path $global:currentdir\metamod\* -Destination $global:currentdir\$global:server\left4dead2 -Force -Recurse
  
  $start_time = Get-Date
  Write-Host '*** Downloading SourceMod *****' -ForegroundColor Magenta -BackgroundColor Black
  #(New-Object Net.WebClient).DownloadFile("$global:sourcemodurl", "$global:currentdir\sourcemod.zip")
  #[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
  Invoke-WebRequest -Uri $global:sourcemodurl -OutFile $global:currentdir\sourcemod.zip
  Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
  Write-Host '*** Extracting SourceMod *****' -ForegroundColor Magenta -BackgroundColor Black 
  Expand-Archive "$global:currentdir\sourcemod.zip" "$global:currentdir\sourcemod\" -Force
  Write-Host '*** Copying/installing SourceMod *****' -ForegroundColor Magenta -BackgroundColor Black
  Copy-Item -Path $global:currentdir\sourcemod\* -Destination $global:currentdir\$global:server\left4dead2 -Force -Recurse
  
  }