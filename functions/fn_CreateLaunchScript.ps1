#:::::::::::::   CREATE LAUNCH SCRIPT FOR SERVER :::::::::::::::::::::::::
# check other Functions for other Games

Function New-LaunchScriptArma3serverPS {
        #----------   Arma3 Ask for input for server cfg  -------------------
        # requires https://www.microsoft.com/en-us/download/details.aspx?id=35 Direct x
        $global:game = "arma3"
        ${gamedirname} = "Arma3"
        ${config1}="server.cfg"
        ${config2}="network.cfg"
        $global:process = "arma3Server"
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
        Write-Host 'Input maxplayers: ' -ForegroundColor Cyan -NoNewline
        $global:MAXPLAYERS = Read-host
        if(($global:PORT = Read-Host "Input Server Port,Press enter to accept default value [2302]") -eq ''){$global:PORT="2302"}else{$global:PORT}
        Write-Host 'Input hostname: ' -ForegroundColor Cyan -NoNewline 
        $global:HOSTNAME = Read-host
        if(($global:SERVERPASSWORD = Read-Host -Prompt (Write-Host "Input Server Password, Press enter to accept default value []: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:SERVERPASSWORD=""}else{$global:SERVERPASSWORD}
        Write-Host  'Input server Adminpassword: ' -ForegroundColor Cyan -NoNewline 
        $global:SERVERADMINPASSWORD = Read-host
        ((Get-Content -path $global:currentdir\$global:server\server.cfg -Raw) -replace "\bSERVERNAME\b","$global:HOSTNAME") | Set-Content -Path $global:currentdir\$global:server\server.cfg
        ((Get-Content -path $global:currentdir\$global:server\server.cfg -Raw) -replace '\b32\b',"$global:MAXPLAYERS") | Set-Content -Path $global:currentdir\$global:server\server.cfg  
        ((Get-Content -path $global:currentdir\$global:server\server.cfg -Raw) -replace "\barma3pass\b","$global:SERVERPASSWORD") | Set-Content -Path $global:currentdir\$global:server\server.cfg
        ((Get-Content -path $global:currentdir\$global:server\server.cfg -Raw) -replace '\bADMINPASSWORD\b',"$global:SERVERADMINPASSWORD") | Set-Content -Path $global:currentdir\$global:server\server.cfg  
        Write-Host "***  Creating Launch script ***" -ForegroundColor Magenta -BackgroundColor Black
        New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Start-Process 'cmd'  '/c start $global:currentdir\$global:server\arma3server.exe -ip=${global:IP} -port=$global:PORT -cfg=$global:currentdir\$global:server\network.cfg -config=$global:currentdir\$global:server\server.cfg -mod= -servermod= -bepath= -profiles=SC -name=SC -autoinit -loadmissiontomemory && exit'"
}    
  
Function New-LaunchScriptSdtdserverPS {
        #----------   7Days2Die Ask for input for server cfg    -------------------
        $global:game = "7d2d"
        $global:saves = "7DaysToDie"
        $global:process = "7daystodieserver"
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
        $global:game = "empyrion"
        $global:process = "EmpyrionDedicated"
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
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "write-host `"Dedicated server was started as background process`" -ForegroundColor Yellow -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "write-host `"Enable Telnet (default port 30004) via dedicated.yaml and connect to it locally`" -ForegroundColor Yellow -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "write-host `"for configuration of the server (type 'help' for console commands)`" -ForegroundColor Yellow -BackgroundColor Black"
        #Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "timeout 10"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "set-location $global:currentdir\$global:server\DedicatedServer\EmpyrionAdminHelper\"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\DedicatedServer\EmpyrionAdminHelper\EAHStart.bat"
}

Function New-LaunchScriptceserverPS {
        #  http://cdn.funcom.com/downloads/exiles/DedicatedServerLauncher1044.exe
        $global:game = "conanexiles"
        $global:process = "ConanSandboxServer-Win64-Test"
        Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
        Write-Host '*** N+1 PORTS 7777,27015 - 7778,27016 - etc.. *****' -ForegroundColor Yellow -BackgroundColor Black
        if(($global:PORT = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [7777]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:PORT="7777"}else{$global:PORT}
        if(($global:QUERYPORT = Read-Host -Prompt  (Write-Host "Input Server Query Port, Press enter to accept default value [27015]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:QUERYPORT="27015"}else{$global:QUERYPORT}
        Write-Host 'Input hostname: ' -ForegroundColor Cyan -NoNewline 
        $global:HOSTNAME = Read-host
        if(($global:MAXPLAYERS = Read-Host -Prompt (Write-Host "Input maxplayers, Press enter to accept default value [50]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:MAXPLAYERS="50"}else{$global:MAXPLAYERS}
        Write-Host 'Input SERVER PASSWORD: ' -ForegroundColor Cyan -NoNewline 
        $global:SERVERPASSWORD = Read-host
        Write-Host 'Input ADMIN PASSWORD: ' -ForegroundColor Cyan -NoNewline 
        $global:ADMINPASSWORD = Read-host
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
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value ".\ConanSandboxServer.exe -log  -MaxPlayers=$global:MAXPLAYERS -Port=$global:PORT -QueryPort=$global:QUERYPORT -RconEnabled=1 -RconPassword=$global:RCONPASSWORD -RconPort=$global:RCONPORT"
}

Function  New-LaunchScriptavserverPS {
        # Avorion Dedicated Server
        $global:game = "protocol-valve"
        $global:saves = "Avorion"
        Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
        $global:process = "AvorionServer"
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
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "start-process 'cmd' '/c start bin\AvorionServer.exe --server-name $global:HOSTNAME --galaxy-name $global:GALAXYNAME --admin $global:steamID64 --difficulty $global:DIFF --max-players $global:MAXPLAYERS'"

}
   
Function New-LaunchScriptboundelserverPS {
        # Boundel Server
        #$global:game = "world"
        $global:process = "world"
        # 454070
        Write-Host "***  Creating Launch script ***" -ForegroundColor Magenta -BackgroundColor Black
        New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\Datcha_Server"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "./world.exe -batchmode"
}
Function New-LaunchScriptboundelserverPS {
        # Boundel Server
        #$global:game = "world"
        $global:process = "world"
        # 454070
        Write-Host "***  Creating Launch script ***" -ForegroundColor Magenta -BackgroundColor Black
        New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\Datcha_Server"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "./world.exe -batchmode"
}

Function New-LaunchScriptforestserverPS {
        # The forest dedciated Server
        $global:game = "forrest"
        $global:process = "TheForestDedicatedServer"
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
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value ".\TheForestDedicatedServer.exe -serverip $global:IP -serversteamport $global:STEAMPORT -servergameport $global:PORT -serverqueryport $global:QUERYPORT -servername '$global:HOSTNAME' -serverplayers $global:MAXPLAYERS -difficulty Normal -configfilepath $global:currentdir\$global:server\SKS\TheForestDedicatedServer\ds\server.cfg -inittype Continue -slot 4 -batchmode -nographics" # -nosteamclient"
    #-serverip xxx.xxx.xxx.xxx -serversteamport 8766 -servergameport 27015 -serverqueryport 27016 -servername TheForestGameDS -serverplayers 8 -difficulty Normal -inittype Continue -slot 1
}