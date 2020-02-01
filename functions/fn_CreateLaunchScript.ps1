# Version 2.5
# .::::::.::::::::::::.,::::::   :::.     .        :  .,:::::: :::::::..   
# ;;;`    `;;;;;;;;'''';;;;''''   ;;`;;    ;;,.    ;;; ;;;;'''' ;;;;``;;;;  
# '[==/[[[[,    [[      [[cccc   ,[[ '[[,  [[[[, ,[[[[, [[cccc   [[[,/[[['  
#   '''    $    $$      $$""""  c$$$cc$$$c $$$$$$$$"$$$ $$""""   $$$$$$c    
#  88b    dP    88,     888oo,__ 888   888,888 Y88" 888o888oo,__ 888b "88bo,
#   "YMmMY"     MMM     """"YUMMMYMM   ""` MMM  M'  "MMM""""YUMMMMMMM   "W" 
#----------      Launch Functions + Server Vars   ----------------------
# check other Functions for other Games
Function New-LaunchScriptArma3serverPS {
        #----------   Arma3 Ask for input for server cfg  -------------------
        # APP ID # 233780
        # requires https://www.microsoft.com/en-us/download/details.aspx?id=35 Direct x
        $global:MODDIR = ""
        $global:EXE = "arma3server"
        $global:EXEDIR = ""
        $global:GAME = "arma3"
        $global:PROCESS = "arma3Server"
        $global:SERVERCFGDIR = "cfg"
        Get-StopServerInstall
        $global:gamedirname = "Arma3"
        $global:config1 = "server.cfg"
        $global:config2 = "network.cfg"
        Get-Servercfg
        # - - - - - - - - - - - - -     
        Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
        Write-Host "Input Server local IP: " -ForegroundColor Cyan -NoNewline
        ${global:IP} = Read-Host
        Write-Host "       default reserved ports are 2302 - 2306
                        gameports must be N+100
                        ie 2402-2406  " -ForegroundColor Yellow
        if (($global:PORT = Read-Host -Prompt (Write-Host "Input Server Port, Press enter to accept default value [2302]: " -ForegroundColor Cyan -NoNewline)) -eq '') { $global:PORT = "2302" }else { $global:PORT }
        Write-Host 'Input hostname: ' -ForegroundColor Cyan -NoNewline 
        $global:HOSTNAME = Read-host
        Write-Host 'Input maxplayers: ' -ForegroundColor Cyan -NoNewline
        $global:MAXPLAYERS = Read-host
        if (($global:SERVERPASSWORD = Read-Host -Prompt (Write-Host "Input Server Password, Press enter to accept default value []: " -ForegroundColor Cyan -NoNewline)) -eq '') { $global:SERVERPASSWORD = "" }else { $global:SERVERPASSWORD }
        if (($global:ADMINPASSWORD = Read-Host -Prompt (Write-Host "Input ADMIN password Alpha Numeric:, Press enter to accept Random String value [$global:RANDOMPASSWORD]: "-ForegroundColor Cyan -NoNewline)) -eq '') { $global:ADMINPASSWORD = "$global:RANDOMPASSWORD" }else { $global:ADMINPASSWORD }
        if (($global:RCONPORT = Read-Host -Prompt (Write-Host "Input Server Rcon Port,Press enter to accept default value [2301]: " -ForegroundColor Cyan -NoNewline)) -eq '') { $global:RCONPORT = "2301" }else { $global:RCONPORT }
        if (($global:RCONPASSWORD = Read-Host -Prompt (Write-Host "Input RCON password Alpha Numeric:, Press enter to accept Random String value [$global:RANDOMPASSWORD]: "-ForegroundColor Cyan -NoNewline)) -eq '') { $global:RCONPASSWORD = "$global:RANDOMPASSWORD" }else { $global:RCONPASSWORD }
        Write-Host "***  Creating BEserver.cfg ***" -ForegroundColor Magenta -BackgroundColor Black
        New-Item $global:currentdir\$global:server\battleye\BEServer.cfg -Force
        Add-Content   $global:currentdir\$global:server\battleye\BEServer.cfg "RConPassword $global:RCONPASSWORD"
        Add-Content   $global:currentdir\$global:server\battleye\BEServer.cfg "RConIP 127.0.0.1"
        Add-Content   $global:currentdir\$global:server\battleye\BEServer.cfg "RConPort $global:RCONPORT"
        Select-EditSourceCFG
        ((Get-Content -path $global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg -Raw) -replace '\b32\b', "$global:MAXPLAYERS") | Set-Content -Path $global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg  
        ((Get-Content -path $global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg -Raw) -replace "\barma3pass\b", "$global:SERVERPASSWORD") | Set-Content -Path $global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg
        # -autoinit only for presistant missions
        $global:launchParams = '@("$global:EXE -ip=${global:IP} -port=${global:PORT} -cfg=$global:currentdir\$global:server\$global:SERVERCFGDIR\network.cfg -config=$global:currentdir\$global:server\$global:SERVERCFGDIR\server.cfg -mod= -servermod= -bepath=$global:currentdir\$global:server\battleye\ -profiles=SC -name=SC -loadmissiontomemory")'

}
Function New-LaunchScriptKF2serverPS {
        # Killing Floor 2 Server
        # APP ID # 232130
        # Requiered Dont change 
        # # Version 2.0
        # $global:MODDIR=""
        $global:EXE = "KFServer"   
        $global:EXEDIR = "Binaries\Win64"
        $global:GAME = "killingfloor2"
        $global:PROCESS = "KFserver"
        $global:SERVERCFGDIR = "\KFGame\Config"
        Get-StopServerInstall
        $global:gamedirname = "KillingFloor2"
        $global:config1 = "KFWeb.ini"
        $global:config2 = "LinuxServer-KFEngine.ini"
        $global:config3 = "LinuxServer-KFGame.ini"
        $global:config4 = "LinuxServer-KFInput.ini"
        $global:config5 = "LinuxServer-KFSystemSettings.ini"
        Remove-item $global:currentdir\$global:server\$global:SERVERCFGDIR\PCServer-*.ini -Force  >$null 2>&1
        Get-Servercfg
        Set-Location $global:currentdir\$global:server\$global:SERVERCFGDIR
        Get-ChildItem -Filter "LinuxServer-*.ini" -Recurse | Rename-Item -NewName { $_.name -replace 'LinuxServer', 'PCServer' } -Force
        Set-Location $global:currentdir\$global:server
        #  First Run Vars \/ \/ Add Here
        $global:defaultPORT = "7777"
        $global:defaultQUERYPORT = "27015"
        $global:defaultMAP = "KF-BioticsLab"
        $global:defaultGAMEMODE = "KFGameContent.KFGameInfo_Endless"
        $global:defaultDIFF = "0"
        $global:defaultHOSTNAME = "PS Steamer"
        $global:defaultADMINPASSWORD = "$global:RANDOMPASSWORD"
        #  Edit Vars here     /\ /\ /\
        Get-UserInput 0 1 1 0 0 1 0 0 0 1 0 0 1 1 1 0
        # VERSION 2 Requieres  Vars
        Write-Host "***  starting Server before Setting PCServer-KFGame.ini Please Wait ***" -ForegroundColor Magenta -BackgroundColor Black
        .\KF2Server.bat
        timeout 5
        Write-Host "***  stopping Server before Setting PCServer-KFGame.ini Please Wait ***" -ForegroundColor Magenta -BackgroundColor Black
        Get-StopServer
        Write-Host "***  Editing Default Server Name PCServer-KFGame.ini ***" -ForegroundColor Magenta -BackgroundColor Black
        ((Get-Content -path $global:currentdir\$global:server\$global:SERVERCFGDIR\PCServer-KFGame.ini -Raw) -replace "\bKilling Floor 2 Server\b", "$global:HOSTNAME") | Set-Content -Path $global:currentdir\$global:server\KFGame\Config\PCServer-KFGame.ini
        Write-Host "***  Adding ADMIN PASSWORD PCServer-KFGame.ini ***" -ForegroundColor Magenta -BackgroundColor Black
        ((Get-Content -path $global:currentdir\$global:server\$global:SERVERCFGDIR\PCServer-KFGame.ini -Raw) -replace "AdminPassword=", "AdminPassword=$global:ADMINPASSWORD") | Set-Content -Path $global:currentdir\$global:server\KFGame\Config\PCServer-KFGame.ini
        Write-Host "***  Enabling Webmin in KFWeb.ini ***" -ForegroundColor Magenta -BackgroundColor Black
        ((Get-Content -path $global:currentdir\$global:server\$global:SERVERCFGDIR\KFWeb.ini -Raw) -replace "\bbEnabled=false\b", "bEnabled=true") | Set-Content -Path $global:currentdir\$global:server\KFGame\Config\KFWeb.ini
        Write-Host "***  Disabling Takeover PCServer-KFEngine.ini ***" -ForegroundColor Magenta -BackgroundColor Black
        ((Get-Content -path $global:currentdir\$global:server\$global:SERVERCFGDIR\PCServer-KFEngine.ini -Raw) -replace "\bbUsedForTakeover=TRUE\b", "bUsedForTakeover=FALSE") | Set-Content -Path $global:currentdir\$global:server\KFGame\Config\PCServer-KFEngine.ini
        $global:launchParams = '@("$global:EXEDIR\$global:EXE ${global:MAP}?Game=${global:GAMEMODE}?Difficulty=${global:DIFF}? -Port=${global:PORT} -QueryPort=${global:QUERYPORT}")'  
        Set-Location $global:currentdir
}
Function New-LaunchScriptLFD2serverPS {
        #----------   left4dead2 Server CFG    -------------------
        # APP ID # 222860
        # Steamer Vars Do Not Edit
        $global:MODDIR = "left4dead2"
        $global:EXEDIR = ""
        $global:EXE = "l4d2"
        $global:GAME = "left4dead2"
        $global:PROCESS = "l4d2"
        $global:SERVERCFGDIR = "left4dead2\cfg"
        Get-StopServerInstall
        # Game-Server-Configs
        $global:gamedirname = "Left4Dead2"
        $global:config1 = "server.cfg"
        Get-Servercfg
        $global:RCONPORT = "${global:PORT}"
        # - - - - - - - - - - - - -
        Select-RenameSource
        # Version 2.0
        #  First Run Vars \/ \/ Add Here
        ${global:defaultIP} = "${global:IP}"
        $global:defaultPORT = "27015"
        $global:defaultCLIENTPORT = "27005"
        $global:defaultMAP = "c1m1_hotel"
        $global:defaultMAXPLAYERS = "8"
        $global:defaultHOSTNAME = "PS Steamer"
        $global:defaultRCONPASSWORD = "$global:RANDOMPASSWORD"
        #  Edit Vars here     /\ /\ /\
        Get-UserInput 1 1 0 0 1 1 0 1 0 1 1
        #if(($global:workshop = Read-Host -Prompt (Write-Host "Input 1 to enable workshop, Press enter to accept default value [0]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:workshop="0"}else{$global:workshop}
        #if(($global:sv_pure = Read-Host -Prompt (Write-Host "Input addtional launch params ie. +sv_pure 0, Press enter to accept default value []: "-ForegroundColor Cyan -NoNewline)) -eq ''){}else{$global:sv_pure}
        Select-EditSourceCFG
        $global:launchParams = '@("$global:EXE -console -game left4dead2 -strictportbind -ip ${global:IP} -port ${global:PORT} +clientport ${global:CLIENTPORT} +hostip ${global:EXTIP} +maxplayers ${global:MAXPLAYERS} +map `"${global:MAP}`" -condebug ")'
        Get-SourceMetMod
}
    
Function New-LaunchScriptArkPS {
        # Ark: Survival Evolved Server
        # APP ID # 376030
        $global:MODDIR = ""
        $global:EXE = "ShooterGameServer"
        $global:EXEDIR = "ShooterGame\Binaries\Win64"
        $global:GAME = "arkse"
        $global:PROCESS = "ShooterGameServer"
        $global:SERVERCFGDIR = "ShooterGame\Saved\Config\WindowsServer"
        Get-StopServerInstall
        $global:gamedirname = "ARKSurvivalEvolved"
        $global:config1 = "GameUserSettings.ini"
        Get-Servercfg
        # Version 2.0
        #  First Run Vars \/ \/ Add Here
        ${global:defaultIP} = "${global:IP}"
        $global:defaultPORT = "7777"
        $global:defaultQUERYPORT = "27015"
        $global:defaultRCONPORT = "27020"
        $global:defaultRCONPASSWORD = "$global:RANDOMPASSWORD"
        $global:defaultMAP = "TheIsland"
        $global:defaultMAXPLAYERS = "70"
        $global:defaultHOSTNAME = "PS Steamer"
        #     Add here     /\ /\ /\
        Get-UserInput 1 1 1 1 1 1 0 1 0 1 0 0
        Select-EditSourceCFG
        # Version 2.0
        $global:launchParams = '@("$global:EXEDIR\$global:EXE ${global:MAP}?AltSaveDirectoryName=${global:MAP}?listen?MultiHome=${global:IP}?MaxPlayers=${global:MAXPLAYERS}?QueryPort=${global:QUERYPORT}?RCONEnabled=True?RCONPort=${global:RCONPORT}?ServerAdminPassword=${global:RCONPASSWORD}?Port=${global:PORT} -automanagedmods")'
}    
Function New-LaunchScriptSdtdserverPS {
        #----------   7Days2Die Ask for input for server cfg    -------------------
        # APP ID # 294420
        $global:MODDIR = ""
        $global:EXE = "startdedicated.bat"
        $global:EXEDIR = ""
        $global:GAME = "7d2d"
        $global:SAVES = "7DaysToDie"
        $global:PROCESS = "7daystodieserver"
        $global:SERVERCFGDIR = ""
        Get-StopServerInstall
        $global:gamedirname = ""
        $global:config1 = "serverconfig.xml"
        # Get-Servercfg
        # - - - - - - - - - - - - -
        Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
        if (($global:PORT = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [26900]: " -ForegroundColor Cyan -NoNewline)) -eq '') { $global:PORT = "26900" }else { $global:PORT }
        Write-Host 'Input Server name: ' -ForegroundColor Cyan -NoNewline
        $global:HOSTNAME = Read-host
        ((Get-Content -path $global:currentdir\$global:server\$global:config1 -Raw) -replace "My Game Host", "$global:HOSTNAME") | Set-Content -Path $global:currentdir\$global:server\$global:config1 
        ((Get-Content -path $global:currentdir\$global:server\$global:config1 -Raw) -replace '26900', "$global:PORT") | Set-Content -Path $global:currentdir\$global:server\$global:config1 
        ((Get-Content -path $global:currentdir\$global:server\startdedicated.bat -Raw) -replace 'pause', 'exit') | Set-Content -Path $global:currentdir\$global:server\startdedicated.bat        
        $global:launchParams = '@("$global:EXE")'

}

Function New-LaunchScriptempserverPS {
        #----------   Empyrion: Dedicated Server
        # APP ID # 530870
        $global:MODDIR = ""
        $global:EXE = "EmpyrionLauncher"
        $global:EXEDIR = ""
        $global:GAME = "empyrion"
        $global:PROCESS = "EmpyrionDedicated"
        $global:SERVERCFGDIR = ""
        Get-StopServerInstall
        $global:gamedirname = ""
        $global:config1 = "dedicated.yaml"
        # Get-Servercfg
        Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
        if (($global:PORT = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [30000]: " -ForegroundColor Cyan -NoNewline)) -eq '') { $global:PORT = "30000" }else { $global:PORT }
        #if(($global:QUERYPORT = Read-Host -Prompt  (Write-Host "Input Server Query Port, Press enter to accept default value [27131]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:QUERYPORT="27131"}else{$global:QUERYPORT}
        Write-Host 'Input hostname: ' -ForegroundColor Cyan -NoNewline
        $global:HOSTNAME = Read-host
        Write-Host "***  Editing Default dedicated.yaml  ***" -ForegroundColor Magenta -BackgroundColor Black
        ((Get-Content -path $global:currentdir\$global:server\$global:config1 -Raw) -replace "\bMy Server\b", "$global:HOSTNAME") | Set-Content -Path $global:currentdir\$global:server\$global:config1
        ((Get-Content -path $global:currentdir\$global:server\$global:config1 -Raw) -replace "\b30000\b", "$global:PORT") | Set-Content -Path $global:currentdir\$global:server\$global:config1
        $global:launchParams = '@("$global:EXE -startDedi")'
}

Function New-LaunchScriptceserverPS {
        # Conan: Exiles Dedicated server
        # APP ID # 443030        
        #  http://cdn.funcom.com/downloads/exiles/DedicatedServerLauncher1044.exe
        $global:MODDIR = ""
        $global:EXE = "ConanSandboxServer"
        $global:EXEDIR = ""
        $global:GAME = "conanexiles"
        $global:PROCESS = "ConanSandboxServer-Win64-Test"
        $global:SERVERCFGDIR = "ConanSandbox\Saved\Config\WindowsServer"
        Get-StopServerInstall
        Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
        Write-Host '*** N+1 PORTS 7777,27015 - 7778,27016 - etc.. *****' -ForegroundColor Yellow -BackgroundColor Black
        if (($global:PORT = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [7777]: " -ForegroundColor Cyan -NoNewline)) -eq '') { $global:PORT = "7777" }else { $global:PORT }
        if (($global:QUERYPORT = Read-Host -Prompt  (Write-Host "Input Server Query Port, Press enter to accept default value [27015]: " -ForegroundColor Cyan -NoNewline)) -eq '') { $global:QUERYPORT = "27015" }else { $global:QUERYPORT }
        Write-Host 'Input hostname: ' -ForegroundColor Cyan -NoNewline
        $global:HOSTNAME = Read-host
        if (($global:MAXPLAYERS = Read-Host -Prompt (Write-Host "Input maxplayers, Press enter to accept default value [50]: "-ForegroundColor Cyan -NoNewline)) -eq '') { $global:MAXPLAYERS = "50" }else { $global:MAXPLAYERS }
        Write-Host 'Input SERVER PASSWORD: ' -ForegroundColor Cyan -NoNewline
        $global:SERVERPASSWORD = Read-host
        if (($global:ADMINPASSWORD = Read-Host -Prompt (Write-Host "Input ADMIN password Alpha Numeric:, Press enter to accept Random String value [$global:RANDOMPASSWORD]: "-ForegroundColor Cyan -NoNewline)) -eq '') { $global:ADMINPASSWORD = "$global:RANDOMPASSWORD" }else { $global:ADMINPASSWORD }
        if (($global:RCONPORT = Read-Host -Prompt (Write-Host "Input Server Rcon Port,Press enter to accept default value [27103]: " -ForegroundColor Cyan -NoNewline)) -eq '') { $global:RCONPORT = "27103" }else { $global:RCONPORT }
        $global:RANDOMPASSWORD = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 11 | ForEach-Object { [char]$_ })
        if (($global:RCONPASSWORD = Read-Host -Prompt (Write-Host "Input RCON password Alpha Numeric:, Press enter to accept Random String value [$global:RANDOMPASSWORD]: "-ForegroundColor Cyan -NoNewline)) -eq '') { $global:RCONPASSWORD = "$global:RANDOMPASSWORD" }else { $global:RCONPASSWORD }
        Write-Host "***  Editing Default Engine.ini   ***" -ForegroundColor Magenta -BackgroundColor Black
        Add-Content -Path $global:currentdir\$global:server\$global:SERVERCFGDIR\Engine.ini -Value "ServerPassword=$global:SERVERPASSWORD"
        Add-Content -Path $global:currentdir\$global:server\$global:SERVERCFGDIR\Engine.ini -Value "ServerName=$global:HOSTNAME"
        Write-Host "***  Editing Default ServerSettings.ini   ***" -ForegroundColor Magenta -BackgroundColor Black
        Add-Content -Path $global:currentdir\$global:server\$global:SERVERCFGDIR\ServerSettings.ini -Value "AdminPassword=$global:ADMINPASSWORD"
        $global:launchParams = '@("$global:EXE -log  -MaxPlayers=${global:MAXPLAYERS} -Port=${global:PORT} -QueryPort=${global:QUERYPORT} -RconEnabled=1 -RconPassword=${global:RCONPASSWORD} -RconPort=${global:RCONPORT}")'
}

Function  New-LaunchScriptavserverPS {
        # Avorion Dedicated Server
        # APP ID # 565060  
        $global:MODDIR = ""
        $global:EXE = "AvorionServer"
        $global:EXEDIR = "bin"
        $global:GAME = "protocol-valve"
        $global:SAVES = "Avorion"
        $global:PROCESS = "AvorionServer"
        Get-StopServerInstall
        Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
        Write-Host 'Input server name: ' -ForegroundColor Cyan -NoNewline
        $global:HOSTNAME = Read-host
        Write-Host 'Input galaxy name: ' -ForegroundColor Cyan -NoNewline
        $global:GALAXYNAME = Read-host
        Write-Host "Enter Admin Steam ID64  for admin: " -ForegroundColor Cyan -BackgroundColor Black
        $global:steamID64 = Read-Host
        if (($global:DIFF = Read-Host -Prompt (Write-Host "Input Difficulty (-3 - 3), Press enter to accept default value [0]: "-ForegroundColor Cyan -NoNewline)) -eq '') { $global:DIFF = "0" }else { $global:DIFF }
        if (($global:MAXPLAYERS = Read-Host -Prompt (Write-Host "Input Server Maxplayers, Press enter to accept default value [10]: " -ForegroundColor Cyan -NoNewline)) -eq '') { $global:MAXPLAYERS = "10" }else { $global:MAXPLAYERS } 
        $global:launchParams = '@("$global:EXEDIR\$global:EXE --server-name `"${global:HOSTNAME}`" --galaxy-name ${global:GALAXYNAME} --difficulty ${global:DIFF} --max-players ${global:MAXPLAYERS}")'
}
   
Function New-LaunchScriptboundelserverPS {
        # Boundel Server
        # 454070
        $global:MODDIR = ""
        $global:EXE = "world"
        $global:EXEDIR = "Datcha_Server"
        $global:GAME = "protocol-valve"
        $global:PROCESS = "world"
        Get-StopServerInstall
        $global:launchParams = '@("$global:EXEDIR\$global:EXE -batchmode")'
}


Function New-LaunchScriptforestserverPS {
        # The forest dedciated Server
        # 556450
        $global:MODDIR = ""
        $global:EXE = "TheForestDedicatedServer"
        $global:EXEDIR = ""
        $global:GAME = "forrest"
        $global:PROCESS = "TheForestDedicatedServer"
        $global:SERVERCFGDIR = "SKS\TheForestDedicatedServer\ds"
        Get-StopServerInstall  
        # 556450
        $global:IP = ${global:IP}
        Write-Host "Input Server local IP: " -ForegroundColor Cyan -NoNewline
        ${global:IP} = Read-Host
        Write-Host 'Input server hostname: ' -ForegroundColor Cyan -NoNewline
        $global:HOSTNAME = Read-host
        #if((${global:IP} = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [$global:IP]: "-ForegroundColor Cyan -NoNewline)) -eq ''){${global:IP}="$global:IP"}else{$global:IP}
        if (($global:STEAMPORT = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [8766]: "-ForegroundColor Cyan -NoNewline)) -eq '') { $global:STEAMPORT = "8766" }else { $global:STEAMPORT }
        if (($global:PORT = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [27015]: "-ForegroundColor Cyan -NoNewline)) -eq '') { $global:PORT = "27015" }else { $global:PORT }
        if (($global:QUERYPORT = Read-Host -Prompt  (Write-Host "Input Server Query Port, Press enter to accept default value [27016]: " -ForegroundColor Cyan -NoNewline)) -eq '') { $global:QUERYPORT = "27016" }else { $global:QUERYPORT }
        if (($global:MAXPLAYERS = Read-Host -Prompt (Write-Host "Input Server Maxplayers, Press enter to accept default value [8]: " -ForegroundColor Cyan -NoNewline)) -eq '') { $global:MAXPLAYERS = "8" }else { $global:MAXPLAYERS }
        #-serverip xxx.xxx.xxx.xxx -serversteamport 8766 -servergameport 27015 -serverqueryport 27016 -servername TheForestGameDS -serverplayers 8 -difficulty Normal -inittype Continue -slot 1
        $global:launchParams = '@("$global:EXE -serverip ${global:IP} -serversteamport ${global:STEAMPORT} -servergameport ${global:PORT} -serverqueryport ${global:QUERYPORT} -servername `"${global:HOSTNAME}`" -serverplayers ${global:MAXPLAYERS} -difficulty Normal -configfilepath $global:currentdir\$global:server\SKS\TheForestDedicatedServer\ds\server.cfg -inittype Continue -slot 4 -batchmode -nographics")'
}

Function New-LaunchScriptAoCserverPS {
        # Age of Chivalry Dedicated Server
        # 17515
        $global:MODDIR = ""
        $global:EXE = "aoc"
        $global:EXEDIR = ""
        $global:GAME = "ageofchivalry"
        $global:SAVES = ""
        $global:PROCESS = "aoc"
        $global:SERVERCFGDIR = "ageofchivalry\cfg"
        $global:RCONPORT = "${global:PORT}"   
        Get-StopServerInstall
        $global:RCONPORT = "${global:PORT}"
        $global:gamedirname = "AgeOfChivalry"
        $global:config1 = "server.cfg"
        Get-Servercfg
        # - - - - - - - - - - - - -	
        Select-RenameSource
        if (($global:MAP = Read-Host -Prompt (Write-Host "Input Server Map,Press enter to accept default value [aoc_siege]: "-ForegroundColor Cyan -NoNewline)) -eq '') { $global:MAP = "aoc_siege" }else { $global:MAP }
        if (($global:MAXPLAYERS = Read-Host -Prompt (Write-Host "Input Server Maxplayers, Press enter to accept default value [32]: " -ForegroundColor Cyan -NoNewline)) -eq '') { $global:MAXPLAYERS = "32" }else { $global:MAXPLAYERS }
        Write-Host "Input Server local IP: " -ForegroundColor Cyan -NoNewline
        ${global:IP} = Read-Host
        if ((${global:PORT} = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [27015]: "-ForegroundColor Cyan -NoNewline)) -eq '') { $global:PORT = "27015" }else { $global:PORT }
        Write-Host 'Input hostname: ' -ForegroundColor Cyan -NoNewline 
        $global:HOSTNAME = Read-host
        if (($global:RCONPASSWORD = Read-Host -Prompt (Write-Host "Input Server Rcon Password,Press enter to accept default value [$global:RANDOMPASSWORD]: " -ForegroundColor Cyan -NoNewline)) -eq '') { $global:RCONPASSWORD = "$global:RANDOMPASSWORD" }else { $global:RCONPASSWORD }
        Select-EditSourceCFG
        $global:launchParams = '@("$global:EXE -console -game ageofchivalry -secure +map ${global:MAP} -autoupdate +log on +maxplayers ${global:MAXPLAYERS} -port ${global:PORT} +ip ${global:IP} +exec server.cfg")'
}


Function New-LaunchScriptacserverPS {
        # Assetto Corsa Dedicated Server
        # 	302550
        # https://www.assettocorsa.net/forum/index.php?faq/dedicated-server-manual.28/
        #$global:MODDIR="Assetto Corsa\Server"
        $global:MODDIR = ""
        $global:EXE = "acServer.bat"
        $global:EXEDIR = "Assetto Corsa\Server"
        $global:GAME = "protocol-valve"
        $global:PROCESS = "acServer"
        Get-StopServerInstall
        $global:launchParams = '@("$global:EXEDIR\$global:EXE")'
}
Function New-LaunchScriptswarmserverPS {
        # Alien Swarm Dedicated Server
        #       635
        # https://developer.valvesoftware.com/wiki/Alien_Swarm_Dedicated_Server
        $global:EXE = "swarm"
        $global:EXEDIR = ""
        $global:GAME = "protocol-valve"
        $global:PROCESS = "swarm"
        $global:SERVERCFGDIR = "swarm\cfg"
        Get-StopServerInstall
        # GSLT used for running a public server.
        #  First Run Vars \/ \/ Add Here
        $global:RCONPORT = "${global:PORT}"
        $global:defaultMAP = "lobby"
        $global:defaultMAXPLAYERS = "4"
        #     Add here     /\ /\ /\ 
        Get-UserInput 0 0 0 0 0 0 0 1 0 1
        Select-RenameSource
        $global:launchParams = '@("$global:EXE -console -game swarm +map ${global:MAP} -maxplayers ${global:MAXPLAYERS} -autoupdate")'
}
Function New-LaunchScriptBOserverPS {
        # Ballistic Overkill Dedicated Server
        # 416880
        # https://steamcommunity.com/app/296300/discussions/1/135508662495143639/
        # Requiered Dont change 
        # Version 2.0
        $global:MODDIR = ""
        $global:EXEDIR = ""
        $global:EXE = "BODS"
        $global:GAME = "protocol-valve"
        $global:SAVES = ""
        $global:PROCESS = "BODS"
        $global:SERVERCFGDIR = ""
        Get-StopServerInstall
        #Game-server-configs \/
        $global:gamedirname = "BallisticOverkill"
        $global:config1 = "config.txt"
        Get-Servercfg
        # GSLT used for running a public server.
        #  First Run Vars \/ \/ Add Here
        ${global:defaultIP} = "${global:IP}"
        $global:defaultGSLT = ""
        #     Add here     /\ /\ /\
        Get-UserInput 1 0 0 0 0 0 0 0 1
        # game config
        Select-EditSourceCFG
        $global:launchParams = '@("$global:EXE -batchmode -nographics -dedicated ")'
}
Function New-LaunchScriptAHL2serverPS {
        # Action: Source Dedicated Server
        # 985050
        # Requiere Steam Login
        # Requiered Dont change
        # Version 2.0
        $global:MODDIR = ""
        $global:EXEDIR = ""
        $global:EXE = "ahl2"
        $global:GAME = "protocol-valve"
        $global:SAVES = ""
        $global:PROCESS = "ahl2"
        $global:SERVERCFGDIR = "cfg"
        Get-StopServerInstall
        #Game-server-configs \/
        $global:gamedirname = "ActionSource"
        $global:config1 = "server.cfg"
        Get-Servercfg
        # GSLT used for running a public server.
        #  First Run Vars \/ \/ Add Here
        ${global:defaultIP} = "${global:IP}"
        ${global:defaultPORT} = "27015"
        $global:defaultCLIENTPORT = "27005"
        $global:defaultSOURCETVPORT = "27020"
        $global:defaultGSLT = ""
        $global:defaultMAP = "act_airport"
        $global:defaultMAXPLAYERS = "20"
        #     Add here     /\ /\ /\
        Get-UserInput 1 1 0 0 0 0 0 1 1 1 1 1
        Select-RenameSource
        # game config
        Select-EditSourceCFG
        $global:launchParams = '@("$global:EXE -console -game ahl2 -strictportbind -ip ${global:IP} -port ${global:PORT} +clientport ${global:CLIENTPORT} +tv_port ${global:SOURCETVPORT} +map ${global:MAP} -maxplayers ${global:MAXPLAYERS} ")'
}
Function New-LaunchScriptBB2serverPS {
        # BrainBread 2 Dedicated Server
        # 475370
        #
        # Requiered Dont change
        # Version 2.0
        $global:MODDIR = ""
        $global:EXEDIR = ""
        $global:EXE = "BB2"
        $global:GAME = "protocol-valve"
        $global:SAVES = ""
        $global:PROCESS = "BB2"
        $global:SERVERCFGDIR = "cfg"
        Get-StopServerInstall
        #Game-server-configs \/
        $global:gamedirname = "BrainBread2"
        $global:config1 = "server.cfg"
        Get-Servercfg
        $global:RCONPORT = "${global:PORT}"
        # GSLT used for running a public server.
        #  First Run Vars \/ \/ Add Here
        ${global:defaultIP} = "${global:IP}"
        ${global:defaultPORT} = "27015"
        $global:defaultCLIENTPORT = "27005"
        $global:defaultSOURCETVPORT = "27020"
        $global:defaultGSLT = ""
        $global:defaultMAP = "bba_barracks"
        $global:defaultMAXPLAYERS = "20"
        $global:defaultRCONPASSWORD = "$global:RANDOMPASSWORD"
        #     Add here     /\ /\ /\
        Get-UserInput 1 1 0 0 1 0 0 1 1 1
        Select-RenameSource
        # game config
        Select-EditSourceCFG
        $global:launchParams = '@("$global:EXE -console -game brainbread2 -strictportbind -ip ${global:IP} -port ${global:PORT} +clientport ${global:CLIENTPORT} +tv_port ${global:SOURCETVPORT} +map ${global:MAP} -maxplayers ${global:MAXPLAYERS} ")'
}
Function New-LaunchScriptHL2DMserverPS {
        #        * * Add to Read-AppID in fn_Actions.ps1 * *
        # Half-Life 2: Deathmatch Dedicated Server
        #      232370
        # https://kb.firedaemon.com/support/solutions/articles/4000086964-half-life-2-deathmatch
        # Requiered Dont change
        # Version 2.0
        # Requieres \/ \/ Get-SourceMetMod
        $global:MODDIR = "hl2mp"
        # Exe NOT in root server folder \/\/
        $global:EXEDIR = ""
        # rename srcds to this name \/\/
        $global:EXE = "HL2DM"
        # Requieres \/ \/ game dig
        $global:GAME = "hl2dm"
        # Requieres \/ \/ AppData Roaming save folder
        $global:SAVES = ""
        # Requieres \/ \/ maybe same as game
        $global:PROCESS = "hl2dm"
        #---game config folder \/\/
        $global:SERVERCFGDIR = "hl2mp\cfg"
        #---Stop existing process if running          
        Get-StopServerInstall
        # Game-server-manger folder \/
        $global:gamedirname = "HalfLife2Deathmatch"
        # Game-server-manger config name \/
        $global:config1 = "server.cfg"
        # Get game-server-config  \/\/
        Get-Servercfg
        # Default Vars
        $global:RCONPORT = "${global:PORT}"
        $global:defaultip = "${global:IP}"
        $global:defaultport = "27015"
        $global:defaultclientport = "27005"
        $global:defaultsourcetvport = "27020"
        $global:defaultmap = "dm_lockdown"
        $global:defaultmaxplayers = "16"
        # input questions \/\/
        Get-UserInput 1 1 0 0 1 1 0 1 1 1 1 1
        # rename srcds.exe \/\/
        Select-RenameSource
        #---- Edit game config \/ SERVERNAME ADMINPASSWORD
        Select-EditSourceCFG
        # VERSION 2 launch params exe in root \/\/
        $global:launchParams = '@("$global:EXE -console -game hl2mp -strictportbind -ip ${global:ip} -port ${global:port} +clientport ${global:clientport} +tv_port ${global:sourcetvport} +map ${global:map} +servercfgfile server.cfg -maxplayers ${global:maxplayers}")'
        # $global:launchParams = '@("$global:EXE -console -game "hl2dm" -secure +map dm_lockdown -autoupdate +log on +maxplayers 32 -port 27015 +ip 1.2.3.4 +exec server.cfg")'
        # OR EXE NOT In ROOT server folder add EXEDIR
        # $global:launchParams = '@("$global:EXEDIR\$global:EXE -< LAUNCH PARAMS HERE >-")'
}
Function New-LaunchScriptDystopiaserverPS {
        #        * * Add to Read-AppID in fn_Actions.ps1 * *
        # Dystopia Dedicated Server
        #      17585
        # https://steamdb.info/app/17585/
        # Requiered Dont change
        # Version 2.0
        # Requieres \/ \/ Get-SourceMetMod
        $global:MODDIR = ""
        # Exe NOT in root server folder \/\/
        $global:EXEDIR = "bin\win32"
        # rename srcds to this name \/\/
        $global:EXE = "Dystopia"
        # Requieres \/ \/ game dig
        $global:GAME = "protocol-valve"
        # Requieres \/ \/ AppData Roaming save folder
        $global:SAVES = ""
        # Requieres \/ \/ maybe same as game
        $global:PROCESS = "Dystopia"
        #---game config folder \/\/
        $global:SERVERCFGDIR = "dystopia\cfg"
        #---Stop existing process if running
        Get-StopServerInstall
        # Game-server-manger folder \/
        $global:gamedirname = "Dystopia"
        # Game-server-manger config name \/
        $global:config1 = "server.cfg"
        # Get game-server-config  \/\/
        Get-Servercfg
        # Default Vars
        $global:RCONPORT = "${global:PORT}"
        $global:defaultip = "${global:IP}"
        $global:defaultport = "27015"
        $global:defaultclientport = "27005"
        $global:defaultsourcetvport = "27020"
        $global:defaultmap = "dys_broadcast"
        $global:defaultmaxplayers = "16"
        # input questions \/\/
        Get-UserInput 1 1 0 0 1 1 0 1 1 1 1 1
        # rename srcds.exe \/\/
        Select-RenameSource
        #---- Edit game config \/ SERVERNAME ADMINPASSWORD
        Select-EditSourceCFG
        # VERSION 2 launch params exe in root \/\/
        #-game "${serverfiles}/dystopia" -strictportbind -ip ${ip} -port ${port} +clientport ${clientport} +tv_port ${sourcetvport} +map ${defaultmap} +sv_setsteamaccount ${gslt} +servercfgfile ${servercfg} -maxplayers ${maxplayers}
        # OR EXE NOT In ROOT server folder add EXEDIR
        $global:launchParams = '@("$global:EXEDIR\$global:EXE -console -game `"$global:currentdir\${global:server}\dystopia`" -strictportbind -ip ${global:ip} -port ${global:port} +clientport ${global:clientport} +tv_port ${global:sourcetvport} +map ${global:map} +sv_setsteamaccount ${global:gslt} +servercfgfile server.cfg -maxplayers ${global:maxplayers}")'      
}
Function New-LaunchScriptBlackMesaserverPS {
        #        * * Add to Read-AppID in fn_Actions.ps1 * *
        # Black Mesa: Deathmatch
        # APP ID # 346680
        # WIKI
        # Requiered Dont change
        # # Version 2.0
        #--->Requieres \/ \/ Get-SourceMetMod
        $global:MODDIR = ""
        #--->Exe NOT in root server folder \/\/
        $global:EXEDIR = ""
        #--->rename srcds to this name \/\/
        $global:EXE = "bmdm"
        #--->Requieres \/ \/ game dig
        $global:GAME = "protocol-valve"
        #--->Requieres \/ \/ AppData Roaming save
        $global:SAVES = ""
        #--->Requieres \/ \/ maybe same as game exe?
        $global:PROCESS = "bmdm"
        #--->game config folder
        $global:SERVERCFGDIR = "bms\cfg"
        #--->Stop existing process if running
        Get-StopServerInstall
        #--->Game-server-manger folder \/
        $global:gamedirname = "BlackMesa"
        #--->Game-server-manger config name \/
        $global:config1 = "server.cfg"
        #--->Get game-server-config \/\/
        Get-Servercfg
        #--->Default Vars
        $global:RCONPORT = "${global:PORT}"
        $global:defaultip = "${global:IP}"
        $global:defaultport = "27015"
        $global:defaultclientport = "27005"
        $global:defaultsourcetvport = "27020"
        $global:defaultmap = "dm_bounce"
        $global:defaultmaxplayers = "16"
        #--->input questions
        Get-UserInput 1 1 0 0 1 1 0 1 1 1 1 1 0 0 0 0
        #--->rename srcds.exe \/\/
        Select-RenameSource
        #--->Edit game config \/ SERVERNAME ADMINPASSWORD
        Select-EditSourceCFG
        # --->Launch
        $global:launchParams = '@("$global:EXE -console -game bms -strictportbind -ip ${global:ip} -port ${global:port} +clientport ${global:clientport} +tv_port ${global:sourcetvport} +sv_setsteamaccount ${global:gslt} +map ${global:defaultmap} +servercfgfile $server.cfg -maxplayers ${global:maxplayers}")'
        # OR    EXE NOT In server folder ROOT add EXEDIR \/ \/
        #$global:launchParams = '@("$global:EXEDIR\$global:EXE -< LAUNCH PARAMS HERE >-")'
}
Function New-LaunchScriptDODSserverPS {
        #* * Add to Read-AppID in fn_Actions.ps1 * *
        # Day of Defeat Source Dedicated Server
        # APP ID # 232290
        # https://kb.firedaemon.com/support/solutions/articles/4000086944-day-of-defeat-source
        # Requiered Dont change
        # # Version 2.0
        #--->Requieres \/ \/ Get-SourceMetMod
        $global:MODDIR = ""
        #--->Exe NOT in root server folder \/\/
        $global:EXEDIR = ""
        #--->rename srcds to this name \/\/
        $global:EXE = "dods"
        #--->Requieres \/ \/ game dig
        $global:GAME = "dods"
        #--->Requieres \/ \/ AppData Roaming save
        $global:SAVES = ""
        #--->Requieres \/ \/ maybe same as game exe?
        $global:PROCESS = "dods"
        #--->game config folder
        $global:SERVERCFGDIR = "dod\cfg"
        #--->Stop existing process if running 
        Get-StopServerInstall
        #--->Game-server-manger folder \/
        $global:gamedirname = "DayOfDefeat"
        #--->Game-server-manger config name \/
        $global:config1 = "server.cfg"
        #--->Get game-server-config \/\/
        Get-Servercfg
        #--->Default Vars
        $global:RCONPORT = "${global:PORT}"
        $global:defaultip = "${global:IP}"
        $global:defaultport = "27015"
        #$global:defaultclientport="27005"
        $global:defaultmap = "dod_Anzio"
        $global:defaultmaxplayers = "16"
        #--->input questions 1 1 0 0 0 0 0 1 0 1 1 0 0
        Get-UserInput 1 1 0 0 0 0 0 1 0 1 0 0 0
        #--->rename srcds.exe \/\/
        Select-RenameSource
        #--->Edit game config \/ SERVERNAME ADMINPASSWORD
        Select-EditSourceCFG
        # --->Launch 
        $global:launchParams = '@("$global:EXE -console -game `"dods`" -secure +map ${global:map} -autoupdate +log on +maxplayers ${global:maxplayers} -port ${global:port}  +ip ${global:ip} +exec server.cfg")'
        # $global:launchParams = '@("$global:EXE -console -game dod -strictportbind +ip ${ip} -port ${port} +clientport ${clientport} +map ${defaultmap} +servercfgfile server.cfg -maxplayers ${maxplayers}")'
        # OR    EXE NOT In server folder ROOT add EXEDIR \/ \/
        #$global:launchParams = '@("$global:EXEDIR\$global:EXE -< LAUNCH PARAMS HERE >-")'
}
Function New-LaunchScriptDSTserverPS {
        #* * Add to Read-AppID in fn_Actions.ps1 * *
        # Don't Starve Together Dedicated Server
        # APP ID # 343050
        # https://steamcommunity.com/sharedfiles/filedetails/?id=590681995
        # Requiered Dont change
        # # Version 2.0
        #--->Exe NOT in root server folder \/\/
        $global:EXEDIR = "bin"
        #--->rename srcds to this name \/\/
        $global:EXE = "dontstarve_dedicated_server_nullrenderer"
        #--->Requieres \/ \/ game dig
        $global:GAME = "protocol-valve"
        #--->Requieres \/ \/ maybe same as game exe?
        $global:PROCESS = "dontstarve_dedicated_server_nullrenderer"
        #--->game config folder
        #$global:SERVERCFGDIR = ""
        #--->Stop existing process if running
        Get-StopServerInstall
        #--->Game-server-manger folder \/
        $global:gamedirname = "DontStarveTogether"

        $shard = "Master"
        $shard2 = "Cave"
        $cluster = "Cluster_1"
        ${persistentstorageroot} = "C:\users\$env:USERNAME\Klei\$global:gamedirname "
        
        #--->Game-server-manger config name \/
        $global:SERVERCFGDIR = "$persistentstorageroot\$cluster\$shard\"
        $global:config1 = "server.ini"
        #--->Get game-server-config \/\/
        Get-Servercfg
        
        #--->Game-server-manger config name \/
        $global:SERVERCFGDIR = "$persistentstorageroot\$cluster"
        $global:config2 = "cluster.ini"
        #--->Get game-server-config \/\/
        Get-Servercfg
             
        #--->Default Vars
        $global:RCONPORT = "${global:PORT}"
        $global:defaultip = "${global:IP}"
        $global:defaultport = "10999"
        $global:defaultmaxplayers = "32"
  
        #--->input questions 1 1 0 0 0 0 0 1 0 1 1 0 0
        Get-UserInput 1 1 0 0 0 1 1 0 0 0 0 0

        #--->Edit game config \/ SERVERNAME ADMINPASSWORD
        Select-EditSourceCFG

        # BOTH CAVES AND MASTER
        # $global:launchParams = '@("$global:EXEDIR\$global:EXE -console -cluster ${cluster} -shard ${shard} -backup_logs ;; $global:EXEDIR\$global:EXE -console -cluster ${cluster} -shard ${shard2} -backup_logs")'
        # Master
        $global:launchParams = '@("$global:EXEDIR\$global:EXE -console -bind_ip ${global:ip} -port ${global:PORT} -players ${global:maxplayers} -persistent_storage_root ${persistentstorageroot} -conf_dir ${global:gamedirname} -cluster ${cluster} -shard ${shard} -backup_logs")'
        # Caves
        #$global:launchParams = '@("$global:EXEDIR\$global:EXE -console -bind_ip ${global:ip} -port ${global:PORT} -players ${global:maxplayers} -persistent_storage_root ${persistentstorageroot} -conf_dir ${global:gamedirname} -cluster ${cluster} -shard ${shard} -backup_logs")'
}
Function New-LaunchScriptGMODserverPS {
        #        * * Add to Read-AppID in fn_Actions.ps1 * *
        # Garry's Mod Dedicated Server
        # APP ID # 4020
        # WIKI
        # Requiered Dont change 
        # # Version 2.0
        #--->Requieres \/ \/ Get-SourceMetMod
        $global:MODDIR = "garrysmod"
        #--->Exe NOT in root server folder \/\/
        $global:EXEDIR = ""
        #--->rename srcds to this name \/\/
        $global:EXE = "gmod"
        #--->Requieres \/ \/ game dig 
        $global:GAME = "garrysmod"
        #--->Requieres \/ \/ AppData Roaming save
        $global:SAVES = ""
        #--->Requieres \/ \/ maybe same as game exe?
        $global:PROCESS = "gmod"
        #--->game config folder
        $global:SERVERCFGDIR = "garrysmod\cfg"
        #--->Stop existing process if running        
        Get-StopServerInstall
        #--->Game-server-manger folder \/
        $global:gamedirname = "GarrysMod"
        #--->Game-server-manger config name \/
        $global:config1 = "server.cfg"
        #--->Get game-server-config \/\/
        Get-Servercfg
        #--->Default Vars
        $global:RCONPORT = "${global:PORT}"
        $global:defaultip = "${global:IP}"
        $global:defaultport = "27015"
        $global:defaultclientport = "27005"
        $global:defaultsourcetvport = "27020"
        $global:defaultmap = "gm_construct"
        $global:defaultmaxplayers = "16"
        $global:defaultgamemode = "sandbox"     
        $global:tickrate = "66"
        # API key visit - https://steamcommunity.com/dev/apikey
        $wsapikey = ""
        $wscollectionid = ""
        # Custom Start Parameters
        $customparms = "-disableluarefresh"
        $gslt = ""
        #--->input questions
        Get-UserInput 1 1 0 0 1 1 0 1 1 1 1 1 1 
        #--->rename srcds.exe \/\/
        Select-RenameSource
        #--->Edit game config \/ SERVERNAME ADMINPASSWORD
        Select-EditSourceCFG
        # --->Launch 
        $global:launchParams = '@("$global:EXE -console -game garrysmod -strictportbind -ip ${global:ip} -port ${global:port} -tickrate ${global:tickrate} +host_workshop_collection ${wscollectionid} -authkey ${wsapikey} +clientport ${global:clientport} +tv_port ${global:sourcetvport} +gamemode ${global:gamemode} +map ${global:map} +sv_setsteamaccount ${global:gslt} +servercfgfile server.cfg -maxplayers ${global:maxplayers} ${customparms}")'
        # OR    EXE NOT In server folder ROOT add EXEDIR \/ \/
        #$global:launchParams = '@("$global:EXEDIR\$global:EXE -< LAUNCH PARAMS HERE >-")'
}
Function New-LaunchScriptTF2serverPS {
        #        * * Add to Read-AppID in fn_Actions.ps1 * *
        # Team Fortress 2 Dedicated Server
        # APP ID # 232250
        # WIKI
        # Requiered Dont change 
        # # Version 2.0
        #--->Requieres \/ \/ Get-SourceMetMod
        $global:MODDIR = ""
        #--->Exe NOT in root server folder \/\/
        $global:EXEDIR = ""
        #--->rename srcds to this name \/\/
        $global:EXE = "tf2"
        #--->Requieres \/ \/ game dig 
        $global:GAME = "tf2"
        #--->Requieres \/ \/ AppData Roaming save
        $global:SAVES = ""
        #--->Requieres \/ \/ maybe same as game exe?
        $global:PROCESS = "tf2"
        #--->game config folder
        $global:SERVERCFGDIR = "tf\cfg"
        #--->Stop existing process if running        
        Get-StopServerInstall
        #--->Game-server-manger folder \/
        $global:gamedirname = "TeamFortress2"
        #--->Game-server-manger config name \/
        $global:config1 = "server.cfg"
        #--->Get game-server-config \/\/
        Get-Servercfg
        #--->Default Vars
        $global:RCONPORT = "${global:PORT}"
        $global:defaultip = "${global:IP}"
        $global:defaultport = "27015"
        $global:defaultclientport = "27005"
        $global:defaultsourcetvport = "27020"
        $global:defaultmap = "cp_badlands"
        $global:defaultmaxplayers = "16"
        $global:gslt = ""
        #--->input questions 
        Get-UserInput 1 1 0 0 0 1 1 0 1 1 1 1 1
        #--->rename srcds.exe \/\/
        Select-RenameSource
        #--->Edit game config \/ SERVERNAME ADMINPASSWORD
        Select-EditSourceCFG
        # --->Launch 
        $global:launchParams = '@("$global:EXE -console -game tf -strictportbind -ip ${global:ip} -port ${global:port} +clientport ${global:clientport} +tv_port ${global:sourcetvport} +map ${global:map} +sv_setsteamaccount ${global:gslt} +servercfgfile server.cfg -maxplayers ${global:maxplayers}")'
        # OR    EXE NOT In server folder ROOT add EXEDIR \/ \/
        #$global:launchParams = '@("$global:EXEDIR\$global:EXE -< LAUNCH PARAMS HERE >-")'
}
Function New-LaunchScriptNMRIHserverPS {
        #        * * Add to Read-AppID in fn_Actions.ps1 * *
        # No More Room in Hell Dedicated Server
        # APP ID # 317670
        # WIKI
        # Requiered Dont change 
        # # Version 2.0
        #--->Requieres \/ \/ Get-SourceMetMod
        $global:MODDIR = ""
        #--->Exe NOT in root server folder \/\/
        $global:EXEDIR = ""
        #--->rename srcds to this name \/\/
        $global:EXE = "NMRIH"
        #--->Requieres \/ \/ game dig 
        $global:GAME = "nmrih"
        #--->Requieres \/ \/ AppData Roaming save
        $global:SAVES = ""
        #--->Requieres \/ \/ maybe same as game exe?
        $global:PROCESS = "NMRIH"
        #--->game config folder
        $global:SERVERCFGDIR = "nmrih\cfg"
        #--->Stop existing process if running        
        Get-StopServerInstall
        #--->Game-server-manger folder \/
        $global:gamedirname = "NoMoreRoominHell"
        #--->Game-server-manger config name \/
        $global:config1 = "server.cfg"
        #--->Get game-server-config \/\/
        Get-Servercfg
        #--->Default Vars
        $global:RCONPORT = "${global:PORT}"
        $global:defaultip = "${global:IP}"
        $global:defaultport = "27015"
        $global:defaultclientport = "27005"
        $global:defaultsourcetvport = "27020"
        $global:defaultmap = "nmo_broadway"
        $global:defaultmaxplayers = "8"
        #--->input questions 
        Get-UserInput 1 1 0 0 1 1 0 1 1 1 1 1 0
        #--->rename srcds.exe \/\/
        Select-RenameSource
        #--->Edit game config \/ SERVERNAME ADMINPASSWORD
        Select-EditSourceCFG
        # --->Launch 
        $global:launchParams = '@("$global:EXE -game nmrih -strictportbind -ip ${global:ip} -port ${global:port} +clientport ${global:clientport} +tv_port ${global:sourcetvport} +map ${global:map} +sv_setsteamaccount ${global:gslt} +servercfgfile server.cfg -maxplayers ${global:maxplayers}")'
        # OR    EXE NOT In server folder ROOT add EXEDIR \/ \/
        #$global:launchParams = '@("$global:EXEDIR\$global:EXE -< LAUNCH PARAMS HERE >-")'
}

#Function New-LaunchScriptTEMPLATEserverPS {
#        * * Add to Read-AppID in fn_Actions.ps1 * *
# TEMPLATE Dedicated Server
# APP ID #
# WIKI
# Requiered Dont change 
# # Version 2.0
#--->Requieres \/ \/ Get-SourceMetMod
# $global:MODDIR=""

#--->Exe NOT in root server folder \/\/
# $global:EXEDIR=""

#--->rename srcds to this name \/\/
# $global:EXE=""

#--->Requieres \/ \/ game dig 
# $global:GAME = ""

#--->Requieres \/ \/ AppData Roaming save
# $global:SAVES = ""
 
#--->Requieres \/ \/ maybe same as game exe?
# $global:PROCESS = ""

#--->game config folder
# $global:SERVERCFGDIR = ""

#--->Stop existing process if running        
# Get-StopServerInstall

#--->Game-server-manger folder \/
# $global:gamedirname=""

#--->Game-server-manger config name \/
# $global:config1=""

#--->Get game-server-config \/\/
# Get-Servercfg

#--->Default Vars
# $global:RCONPORT = "${global:PORT}"
# $global:ip="0.0.0.0"

#--->input questions 
# Get-UserInput 1 1 0

#--->rename srcds.exe \/\/
# Select-RenameSource

#--->Edit game config \/ SERVERNAME ADMINPASSWORD
#  Select-EditSourceCFG

# --->Launch 
#$global:launchParams = '@("$global:EXE -< LAUNCH PARAMS HERE >-")'
# OR    EXE NOT In server folder ROOT add EXEDIR \/ \/
#$global:launchParams = '@("$global:EXEDIR\$global:EXE -< LAUNCH PARAMS HERE >-")'
#}