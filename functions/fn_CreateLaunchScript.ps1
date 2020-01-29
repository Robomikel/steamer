# Version 2.0
#:::::::::::::   CREATE LAUNCH SCRIPT FOR SERVER :::::::::::::::::::::::::
# check other Functions for other Games
Function New-LaunchScriptArma3serverPS {
        #----------   Arma3 Ask for input for server cfg  -------------------
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
  
Function New-LaunchScriptSdtdserverPS {
        #----------   7Days2Die Ask for input for server cfg    -------------------
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
  
        $global:launchParams = '@("$global:EXEDIR\$global:EXE --server-name ${global:HOSTNAME} --galaxy-name ${global:GALAXYNAME} --admin ${global:steamID64} --difficulty ${global:DIFF} --max-players ${global:MAXPLAYERS}")'
}
   
Function New-LaunchScriptboundelserverPS {
        # Boundel Server
        $global:MODDIR = ""
        $global:EXE = "world"
        $global:EXEDIR = "Datcha_Server"
        $global:GAME = "protocol-valve"
        $global:PROCESS = "world"

        Get-StopServerInstall

        # 454070
 
        $global:launchParams = '@("$global:EXEDIR\$global:EXE -batchmode")'
}


Function New-LaunchScriptforestserverPS {
        # The forest dedciated Server
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
        
        Get-StopServerInstall
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
        $global:RCONPORT = "${global:PORT}"

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

Function New-LaunchScriptasserverPS {
        # Alien Swarm Dedicated Server
        #       635
        # https://developer.valvesoftware.com/wiki/Alien_Swarm_Dedicated_Server
        $global:EXE = "asds"
        $global:EXEDIR = ""
        $global:GAME = "protocol-valve"
        $global:PROCESS = "asds"
        $global:SERVERCFGDIR = "swarm\cfg"

        Get-StopServerInstall

        Select-RenameSource
 
        $global:launchParams = '@("$global:EXE -console -game swarm +map lobby -maxplayers 4 -autoupdate")'
}
#Function New-LaunchScriptTEMPLATEserverPS {
# TEMPLATE Server
#       ADD ID #
# WIKI
# Requiered Dont change 
# # Version 2.0
# $global:MODDIR=""
# $global:EXEDIR=""
# $global:EXE=""
# $global:GAME = ""
# $global:SAVES = ""
# $global:PROCESS = ""
# $global:SERVERCFGDIR = ""        
# Get-StopServerInstall
# Game-server-configs \/
# $global:gamedirname=""
# $global:config1=""
# Get-Servercfg
# - - - - - - - - - - - - -
# Rename source exe       
#Write-Host "***  Renaming srcds.exe to avoid conflict with local source (srcds.exe) server  ***" -ForegroundColor Magenta -BackgroundColor Black
#Rename-Item -Path "$global:currentdir\$global:server\srcds.exe" -NewName "$global:currentdir\$global:server\TEMP.exe" >$null 2>&1
#Rename-Item -Path "start-process cmd `"/c srcds_x64.exe" -NewName "$global:currentdir\$global:server\TEMP_x64.exe`"" >$null 2>&1
# game config
#Write-Host "***  Editing Default server.cfg  ***" -ForegroundColor Magenta -BackgroundColor Black
#((Get-Content -path $global:currentdir\$global:server\$global:SERVERCFGDIR\${config1} -Raw) -replace "\bSERVERNAME\b", "$global:HOSTNAME") | Set-Content -Path $global:currentdir\$global:server\$global:SERVERCFGDIR\${config1}
#((Get-Content -path $global:currentdir\$global:server\$global:SERVERCFGDIR\${config1} -Raw) -replace "\bADMINPASSWORD\b", "$global:RCONPASSWORD") | Set-Content -Path $global:currentdir\$global:server\$global:SERVERCFGDIR\${config1}

# VERSION 1 Requieres  Input
#If ( $global:Version -eq "2" ) {
#Write-Host "***  Creating Launch script ***" -ForegroundColor Magenta -BackgroundColor Black
#New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
#Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
#dd-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\"
#Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Start-Process -FilePath cmd.exe -ArgumentList (`"/c temp.exe -some launch params`") -NoNewWindow"
#}

# VERSION 2 Requieres  Vars
#$global:launchParams = '@("$global:EXE -< LAUNCH PARAMS HERE >-")'
#}

