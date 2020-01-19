#:::::::::::::   CREATE LAUNCH SCRIPT FOR SERVER :::::::::::::::::::::::::
# check other Functions for other Games

Function New-LaunchScriptArma3serverPS {
        #----------   Arma3 Ask for input for server cfg  -------------------
        # requires https://www.microsoft.com/en-us/download/details.aspx?id=35 Direct x
        #$global:MODDIR=""
        $global:GAME = "arma3"
        $global:PROCESS = "arma3Server"
        #$global:servercfgdir=""
        Get-StopServerInstall
        
        ${gamedirname} = "Arma3"
        ${config1}="server.cfg"
        ${config2}="network.cfg"
        Write-Host "***  Copying Default server.cfg  ***" -ForegroundColor Magenta -BackgroundColor Black
        #(New-Object Net.WebClient).DownloadFile("$global:githuburl/${gamedirname}/${config1}", "$global:currentdir\$global:server\server.cfg")
        $arma3WebResponse=Invoke-WebRequest "$githuburl/${gamedirname}/${config1}"
        New-Item $global:currentdir\$global:server\server.cfg -Force
        Add-Content $global:currentdir\$global:server\server.cfg $arma3WebResponse
        Write-Host "***  Copying Default network.cfg  ***" -ForegroundColor Magenta -BackgroundColor Black
        #(New-Object Net.WebClient).DownloadFile("$global:githuburl/${gamedirname}/${config2}", "$global:currentdir\$global:server\network.cfg")
        $arma3nWebResponse=Invoke-WebRequest "$githuburl/${gamedirname}/${config2}"
        New-Item $global:currentdir\$global:server\network.cfg -Force
        Add-Content $global:currentdir\$global:server\network.cfg $arma3nWebResponse
        
        Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
        Write-Host "Input Server local IP: " -ForegroundColor Cyan -NoNewline
        ${global:IP} = Read-Host
        Write-Host "       default reserved ports are 2302 - 2306
                        gameports must be N+100
                        ie 2402-2406  " -ForegroundColor Yellow
        if(($global:PORT = Read-Host -Prompt (Write-Host "Input Server Port, Press enter to accept default value [2302]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:PORT="2302"}else{$global:PORT}
        Write-Host 'Input hostname: ' -ForegroundColor Cyan -NoNewline 
        $global:HOSTNAME = Read-host
        Write-Host 'Input maxplayers: ' -ForegroundColor Cyan -NoNewline
        $global:MAXPLAYERS = Read-host
        if(($global:SERVERPASSWORD = Read-Host -Prompt (Write-Host "Input Server Password, Press enter to accept default value []: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:SERVERPASSWORD=""}else{$global:SERVERPASSWORD}
        if(($global:ADMINPASSWORD = Read-Host -Prompt (Write-Host "Input ADMIN password Alpha Numeric:, Press enter to accept Random String value [$global:RANDOMPASSWORD]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:ADMINPASSWORD="$global:RANDOMPASSWORD"}else{$global:ADMINPASSWORD}
        if(($global:RCONPORT = Read-Host -Prompt (Write-Host "Input Server Rcon Port,Press enter to accept default value [2301]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:RCONPORT="2301"}else{$global:RCONPORT}
        if(($global:RCONPASSWORD = Read-Host -Prompt (Write-Host "Input RCON password Alpha Numeric:, Press enter to accept Random String value [$global:RANDOMPASSWORD]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:RCONPASSWORD="$global:RANDOMPASSWORD"}else{$global:RCONPASSWORD}
        Write-Host "***  Creating BEserver.cfg ***" -ForegroundColor Magenta -BackgroundColor Black
        New-Item $global:currentdir\$global:server\battleye\BEServer.cfg -Force
        Add-Content   $global:currentdir\$global:server\battleye\BEServer.cfg "RConPassword $global:RCONPASSWORD"
        Add-Content   $global:currentdir\$global:server\battleye\BEServer.cfg "RConIP 127.0.0.1"
        Add-Content   $global:currentdir\$global:server\battleye\BEServer.cfg "RConPort $global:RCONPORT"
        Write-Host "***  Editing server.cfg ***" -ForegroundColor Magenta -BackgroundColor Black
        ((Get-Content -path $global:currentdir\$global:server\server.cfg -Raw) -replace "\bSERVERNAME\b","$global:HOSTNAME") | Set-Content -Path $global:currentdir\$global:server\server.cfg
        ((Get-Content -path $global:currentdir\$global:server\server.cfg -Raw) -replace '\b32\b',"$global:MAXPLAYERS") | Set-Content -Path $global:currentdir\$global:server\server.cfg  
        ((Get-Content -path $global:currentdir\$global:server\server.cfg -Raw) -replace "\barma3pass\b","$global:SERVERPASSWORD") | Set-Content -Path $global:currentdir\$global:server\server.cfg
        ((Get-Content -path $global:currentdir\$global:server\server.cfg -Raw) -replace '\bADMINPASSWORD\b',"$global:ADMINPASSWORD") | Set-Content -Path $global:currentdir\$global:server\server.cfg  
        Write-Host "***  Creating Launch script ***" -ForegroundColor Magenta -BackgroundColor Black
        New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Start-process `"cmd`"  `"/c start $global:currentdir\$global:server\arma3server.exe -ip=`${global:IP} -port=`$global:PORT -cfg=$global:currentdir\$global:server\network.cfg -config=$global:currentdir\$global:server\server.cfg -mod= -servermod= -bepath=$global:currentdir\$global:server\battleye\ -profiles=SC -name=SC -autoinit -loadmissiontomemory && exit`""
}    
  
Function New-LaunchScriptSdtdserverPS {
        #----------   7Days2Die Ask for input for server cfg    -------------------
        #$global:MODDIR=""
        $global:GAME = "7d2d"
        $global:SAVES = "7DaysToDie"
        $global:process = "7daystodieserver"
        #$global:servercfgdir=""
        Get-StopServerInstall

        Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
        if(($global:PORT = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [26900]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:PORT="26900"}else{$global:PORT}
        Write-Host 'Input Server name: ' -ForegroundColor Cyan -NoNewline
        $global:HOSTNAME = Read-host
        ((Get-Content -path $global:currentdir\$global:server\serverconfig.xml -Raw) -replace "My Game Host","$global:HOSTNAME") | Set-Content -Path $global:currentdir\$global:server\serverconfig.xml 
        ((Get-Content -path $global:currentdir\$global:server\serverconfig.xml -Raw) -replace '26900',"$global:PORT") | Set-Content -Path $global:currentdir\$global:server\serverconfig.xml 
        ((Get-Content -path $global:currentdir\$global:server\startdedicated.bat -Raw) -replace 'pause','exit') | Set-Content -Path $global:currentdir\$global:server\startdedicated.bat        
        Write-Host "***  Creating Launch script ***" -ForegroundColor Magenta -BackgroundColor Black
        New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "start-process $global:currentdir\$global:server\startdedicated.bat"
}

Function New-LaunchScriptempserverPS {
        #$global:MODDIR=""
        $global:GAME = "empyrion"
        $global:PROCESS = "EmpyrionDedicated"
        #$global:servercfgdir=""
        Get-StopServerInstall

        Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
        if(($global:PORT = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [30000]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:PORT="30000"}else{$global:PORT}
        #if(($global:QUERYPORT = Read-Host -Prompt  (Write-Host "Input Server Query Port, Press enter to accept default value [27131]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:QUERYPORT="27131"}else{$global:QUERYPORT}
        Write-Host 'Input hostname: ' -ForegroundColor Cyan -NoNewline 
        $global:HOSTNAME = Read-host
        Write-Host "***  Editing Default dedicated.yaml  ***" -ForegroundColor Magenta -BackgroundColor Black
        ((Get-Content -path $global:currentdir\$global:server\dedicated.yaml -Raw) -replace "\bMy Server\b","$global:HOSTNAME") | Set-Content -Path $global:currentdir\$global:server\dedicated.yaml
        ((Get-Content -path $global:currentdir\$global:server\dedicated.yaml -Raw) -replace "\b30000\b","$global:PORT") | Set-Content -Path $global:currentdir\$global:server\dedicated.yaml
        Write-Host "***  Creating Launch script ***" -ForegroundColor Magenta -BackgroundColor Black
        New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value ".\EmpyrionLauncher -startDedi "
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "write-host `" `""
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "write-host `"Dedicated server was started as background PROCESS`" -ForegroundColor Yellow -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "write-host `"Enable Telnet (default port 30004) via dedicated.yaml and connect to it locally`" -ForegroundColor Yellow -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "write-host `"for configuration of the server (type 'help' for console commands)`" -ForegroundColor Yellow -BackgroundColor Black"
        #Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "timeout 10"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "set-location $global:currentdir\$global:server\DedicatedServer\EmpyrionAdminHelper\"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\DedicatedServer\EmpyrionAdminHelper\EAHStart.bat"
}

Function New-LaunchScriptceserverPS {
        #  http://cdn.funcom.com/downloads/exiles/DedicatedServerLauncher1044.exe
        #$global:MODDIR=""
        $global:GAME = "conanexiles"
        $global:PROCESS = "ConanSandboxServer-Win64-Test"
        $global:servercfgdir="ConanSandbox\Saved\Config\WindowsServer"
        Get-StopServerInstall

        Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
        Write-Host '*** N+1 PORTS 7777,27015 - 7778,27016 - etc.. *****' -ForegroundColor Yellow -BackgroundColor Black
        if(($global:PORT = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [7777]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:PORT="7777"}else{$global:PORT}
        if(($global:QUERYPORT = Read-Host -Prompt  (Write-Host "Input Server Query Port, Press enter to accept default value [27015]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:QUERYPORT="27015"}else{$global:QUERYPORT}
        Write-Host 'Input hostname: ' -ForegroundColor Cyan -NoNewline 
        $global:HOSTNAME = Read-host
        if(($global:MAXPLAYERS = Read-Host -Prompt (Write-Host "Input maxplayers, Press enter to accept default value [50]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:MAXPLAYERS="50"}else{$global:MAXPLAYERS}
        Write-Host 'Input SERVER PASSWORD: ' -ForegroundColor Cyan -NoNewline 
        $global:SERVERPASSWORD = Read-host
        if(($global:ADMINPASSWORD = Read-Host -Prompt (Write-Host "Input ADMIN password Alpha Numeric:, Press enter to accept Random String value [$global:RANDOMPASSWORD]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:ADMINPASSWORD="$global:RANDOMPASSWORD"}else{$global:ADMINPASSWORD}
        if(($global:RCONPORT = Read-Host -Prompt (Write-Host "Input Server Rcon Port,Press enter to accept default value [27103]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:RCONPORT="27103"}else{$global:RCONPORT}
        $global:RANDOMPASSWORD = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 11 | ForEach-Object {[char]$_})
        if(($global:RCONPASSWORD = Read-Host -Prompt (Write-Host "Input RCON password Alpha Numeric:, Press enter to accept Random String value [$global:RANDOMPASSWORD]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:RCONPASSWORD="$global:RANDOMPASSWORD"}else{$global:RCONPASSWORD}
        Write-Host "***  Editing Default Engine.ini   ***" -ForegroundColor Magenta -BackgroundColor Black
        Add-Content -Path $global:currentdir\$global:server\ConanSandbox\Saved\Config\WindowsServer\Engine.ini -Value "ServerPassword=$global:SERVERPASSWORD"
        Add-Content -Path $global:currentdir\$global:server\ConanSandbox\Saved\Config\WindowsServer\Engine.ini -Value "ServerName=$global:HOSTNAME"
        Write-Host "***  Editing Default ServerSettings.ini   ***" -ForegroundColor Magenta -BackgroundColor Black
        Add-Content -Path $global:currentdir\$global:server\ConanSandbox\Saved\Config\WindowsServer\ServerSettings.ini -Value "AdminPassword=$global:ADMINPASSWORD"
        Write-Host "***  Creating Launch script ***" -ForegroundColor Magenta -BackgroundColor Black
        New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value ".\ConanSandboxServer.exe -log  -MaxPlayers=`"`$global:MAXPLAYERS`" -Port=`"`$global:PORT`" -QueryPort=`"`$global:QUERYPORT`" -RconEnabled=1 -RconPassword=`"`$global:RCONPASSWORD`" -RconPort=`"`$global:RCONPORT`""
}

Function  New-LaunchScriptavserverPS {
        # Avorion Dedicated Server
        #$global:MODDIR=""
        $global:GAME = "protocol-valve"
        $global:SAVES = "Avorion"
        #$global:servercfgdir=""
        Get-StopServerInstall

        Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
        $global:PROCESS = "AvorionServer"
        Write-Host 'Input server name: ' -ForegroundColor Cyan -NoNewline 
        $global:HOSTNAME = Read-host
        Write-Host 'Input galaxy name: ' -ForegroundColor Cyan -NoNewline 
        $global:GALAXYNAME = Read-host
        Write-Host "Enter Admin Steam ID64  for admin: " -ForegroundColor Cyan -BackgroundColor Black
        $global:steamID64= Read-Host
        if(($global:DIFF = Read-Host -Prompt (Write-Host "Input Difficulty (-3 - 3), Press enter to accept default value [0]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:DIFF="0"}else{$global:DIFF}
        if(($global:MAXPLAYERS = Read-Host -Prompt (Write-Host "Input Server Maxplayers, Press enter to accept default value [10]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:MAXPLAYERS="10"}else{$global:MAXPLAYERS}
        Write-Host "***  Creating Launch script ***" -ForegroundColor Magenta -BackgroundColor Black
        New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "start-process `"cmd`" `"/c start bin\AvorionServer.exe --server-name $global:HOSTNAME --galaxy-name $global:GALAXYNAME --admin $global:steamID64 --difficulty $global:DIFF --max-players $global:MAXPLAYERS`""

}
   
Function New-LaunchScriptboundelserverPS {
        # Boundel Server
        #$global:MODDIR=""
        $global:GAME = "protocol-valve"
        $global:PROCESS = "world"
        #$global:servercfgdir=""
        Get-StopServerInstall

        # 454070
        Write-Host "***  Creating Launch script ***" -ForegroundColor Magenta -BackgroundColor Black
        New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\Datcha_Server"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "./world.exe -batchmode"
}


Function New-LaunchScriptforestserverPS {
        # The forest dedciated Server
        #$global:MODDIR=""
        $global:GAME = "forrest"
        $global:PROCESS = "TheForestDedicatedServer"
        $global:servercfgdir="SKS\TheForestDedicatedServer\ds\"
        Get-StopServerInstall
        
        # 556450
        $global:IP = ${global:IP}
        Write-Host "Input Server local IP: " -ForegroundColor Cyan -NoNewline
        ${global:IP} = Read-Host
        Write-Host 'Input server hostname: ' -ForegroundColor Cyan -NoNewline
        $global:HOSTNAME = Read-host
        #if((${global:IP} = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [$global:IP]: "-ForegroundColor Cyan -NoNewline)) -eq ''){${global:IP}="$global:IP"}else{$global:IP}
        if(($global:STEAMPORT = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [8766]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:STEAMPORT="8766"}else{$global:STEAMPORT}
        if(($global:PORT = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [27015]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:PORT="27015"}else{$global:PORT}
        if(($global:QUERYPORT = Read-Host -Prompt  (Write-Host "Input Server Query Port, Press enter to accept default value [27016]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:QUERYPORT="27016"}else{$global:QUERYPORT}
        if(($global:MAXPLAYERS = Read-Host -Prompt (Write-Host "Input Server Maxplayers, Press enter to accept default value [8]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:MAXPLAYERS="8"}else{$global:MAXPLAYERS}
        Write-Host "***  Creating Launch script ***" -ForegroundColor Magenta -BackgroundColor Black
        New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value ".\TheForestDedicatedServer.exe -serverip `$global:IP -serversteamport `$global:STEAMPORT -servergameport `$global:PORT -serverqueryport `$global:QUERYPORT -servername '`$global:HOSTNAME' -serverplayers `$global:MAXPLAYERS -difficulty Normal -configfilepath $global:currentdir\$global:server\SKS\TheForestDedicatedServer\ds\server.cfg -inittype Continue -slot 4 -batchmode -nographics" # -nosteamclient"
    #-serverip xxx.xxx.xxx.xxx -serversteamport 8766 -servergameport 27015 -serverqueryport 27016 -servername TheForestGameDS -serverplayers 8 -difficulty Normal -inittype Continue -slot 1
}

Function New-LaunchScriptAoCserverPS {
        # Age of Chivalry Dedicated Server
        # 17515	
        #$global:MODDIR=""
        $global:GAME = "ageofchivalry"
        $global:PROCESS = "aoc"
        $global:servercfgdir = "ageofchivalry\cfg"
        ${gamedirname}="AgeOfChivalry"
        ${config1}="server.cfg"

        Get-StopServerInstall

        Write-Host "***  Copying Default server.cfg  ***" -ForegroundColor Magenta -BackgroundColor Black
        #(New-Object Net.WebClient).DownloadFile("$githuburl/${gamedirname}/${config1}", "$global:currentdir\$global:server\$global:servercfgdir\${config1}")
        $aocWebResponse=Invoke-WebRequest "$githuburl/${gamedirname}/${config1}"
        New-Item $global:currentdir\$global:server\$global:servercfgdir\${config1} -Force
        Add-Content $global:currentdir\$global:server\$global:servercfgdir\${config1} $aocWebResponse

        if(($global:MAP = Read-Host -Prompt (Write-Host "Input Server Map,Press enter to accept default value [aoc_siege]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:MAP="aoc_siege"}else{$global:MAP}
        if(($global:MAXPLAYERS = Read-Host -Prompt (Write-Host "Input Server Maxplayers, Press enter to accept default value [32]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:MAXPLAYERS="32"}else{$global:MAXPLAYERS}
        Write-Host "Input Server local IP: " -ForegroundColor Cyan -NoNewline
        ${global:IP} = Read-Host
        if((${global:PORT} = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [27015]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:PORT="27015"}else{$global:PORT}

        Write-Host 'Input hostname: ' -ForegroundColor Cyan -NoNewline 
        $global:HOSTNAME = Read-host
        if(($global:RCONPASSWORD = Read-Host -Prompt (Write-Host "Input Server Rcon Password,Press enter to accept default value [$global:RANDOMPASSWORD]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:RCONPASSWORD="$global:RANDOMPASSWORD"}else{$global:RCONPASSWORD}
        $global:RCONPORT="${global:PORT}"

        Write-Host "***  Editing Default server.cfg  ***" -ForegroundColor Magenta -BackgroundColor Black
        ((Get-Content -path $global:currentdir\$global:server\$global:servercfgdir\${config1} -Raw) -replace "\bSERVERNAME\b","$global:HOSTNAME") | Set-Content -Path $global:currentdir\$global:server\$global:servercfgdir\${config1}
        ((Get-Content -path $global:currentdir\$global:server\$global:servercfgdir\${config1} -Raw) -replace "\bADMINPASSWORD\b","$global:RCONPASSWORD") | Set-Content -Path $global:currentdir\$global:server\$global:servercfgdir\${config1}

        Write-Host "***  Renaming srcds.exe to doi.exe to avoid conflict with local Source (srcds.exe) server  ***" -ForegroundColor Magenta -BackgroundColor Black
        Rename-Item -Path "$global:currentdir\$global:server\srcds.exe" -NewName "$global:currentdir\$global:server\aoc.exe" >$null 2>&1
        #Rename-Item -Path "$global:currentdir\$global:server\srcds_x64.exe" -NewName "$global:currentdir\$global:server\aoc_x64.exe" >$null 2>&1
    
        Write-Host "***  Creating Launch script ***" -ForegroundColor Magenta -BackgroundColor Black
        New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value ".\aoc.exe -console -game ageofchivalry -secure +map `$global:MAP -autoupdate +log on +maxplayers `$global:MAXPLAYERS -port `$global:PORT +ip `${global:IP} +exec server.cfg"
}


Function New-LaunchScriptacserverPS {
        # Assetto Corsa Dedicated Server
        # 	302550
        # https://www.assettocorsa.net/forum/index.php?faq/dedicated-server-manual.28/
        #$global:MODDIR="Assetto Corsa\Server"
        $global:GAME = "protocol-valve"
        $global:PROCESS = "acServer"
        #$global:servercfgdir = "/cfg/server_cfg.ini"
        #$global:servercfgdir = "/cfg/entry_list.ini"
        Get-StopServerInstall

        Write-Host "***  Creating Launch script ***" -ForegroundColor Magenta -BackgroundColor Black
        New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\Assetto Corsa\Server"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value ".\acServer.bat"
}

Function New-LaunchScriptasserverPS {
        # Alien Swarm Dedicated Server
        #       635
        # https://developer.valvesoftware.com/wiki/Alien_Swarm_Dedicated_Server
        #$global:MODDIR="swarm"
        $global:GAME="protocol-valve"
        $global:PROCESS = "asds"
        $global:servercfgdir = "swarm\cfg"
        Get-StopServerInstall

        Write-Host "***  Renaming srcds.exe to doi.exe to avoid conflict with local Insurgency (srcds.exe) server  ***" -ForegroundColor Magenta -BackgroundColor Black
        Rename-Item -Path "$global:currentdir\$global:server\srcds.exe" -NewName "$global:currentdir\$global:server\asds.exe" >$null 2>&1
        #Rename-Item -Path "$global:currentdir\$global:server\srcds_x64.exe" -NewName "$global:currentdir\$global:server\asds_x64.exe" >$null 2>&1

        Write-Host "***  Creating Launch script ***" -ForegroundColor Magenta -BackgroundColor Black
        New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\asds.exe -console -game swarm +map lobby -maxplayers 4 -autoupdate"
}

#Function New-LaunchScriptTEMPLATEserverPS {
        # TEMPLATE Server
        #       ADD ID #
        # WIKI
        #$global:MODDIR=""
        #$global:GAME="protocol-valve"
        #$global:PROCESS = ""
        #$global:servercfgdir = ""
        #$global:servercfg = "server.cfg"
        
        #Get-StopServerInstall
        #${gamedirname} = "temp"
        #${config1}="server.cfg"
        #${config2}="network.cfg"
        #Write-Host "***  Copying Default server.cfg  ***" -ForegroundColor Magenta -BackgroundColor Black
        ##(New-Object Net.WebClient).DownloadFile("$global:githuburl/${gamedirname}/${config1}", "$global:currentdir\$global:server\$global:servercfg")
        #$Webresponse=Invoke-WebRequest "$githuburl/${gamedirname}/${config1}"
        #New-Item $global:currentdir\$global:server\$global:servercfgdir\$global:servercfg -Force
        #Add-Content $global:currentdir\$global:server\$global:servercfgdir\$global:servercfg $Webresponse
        #Write-Host "***  Copying Default network.cfg  ***" -ForegroundColor Magenta -BackgroundColor Black
        ##(New-Object Net.WebClient).DownloadFile("$global:githuburl/${gamedirname}/${config2}", "$global:currentdir\$global:server\network.cfg")
        #$Webresponse=Invoke-WebRequest "$githuburl/${gamedirname}/${config2}"
        #New-Item $global:currentdir\$global:server\$global:servercfgdir\network.cfg -Force
        #Add-Content $global:currentdir\$global:server\$global:servercfgdir\network.cfg $Webresponse

        #Write-Host "***  Renaming srcds.exe to avoid conflict with local source (srcds.exe) server  ***" -ForegroundColor Magenta -BackgroundColor Black
        #Rename-Item -Path "$global:currentdir\$global:server\srcds.exe" -NewName "$global:currentdir\$global:server\TEMP.exe" >$null 2>&1
        #Rename-Item -Path "$global:currentdir\$global:server\srcds_x64.exe" -NewName "$global:currentdir\$global:server\TEMP_x64.exe" >$null 2>&1

        #Write-Host "***  Creating Launch script ***" -ForegroundColor Magenta -BackgroundColor Black
        #New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
        #Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
        #dd-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\"
        #Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\TEMP.exe -console -game swarm +map lobby -maxplayers 4 -autoupdate"
#}