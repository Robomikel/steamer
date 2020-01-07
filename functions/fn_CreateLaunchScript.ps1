#:::::::::::::   CREATE LAUNCH SCRIPT FOR SERVER :::::::::::::::::::::::::
# check other functions for other Games

Function New-LaunchScriptArma3serverPS
{
        #----------   Arma3 Ask for input for server cfg  -------------------
        # requires https://www.microsoft.com/en-us/download/details.aspx?id=35 Direct x
        ${gamedirname}="Arma3"
        ${config1}="server.cfg"
        ${config2}="network.cfg"
        Write-Host "***  Copying Default server.cfg  ***" -ForegroundColor Magenta -BackgroundColor Black
        #(New-Object Net.WebClient).DownloadFile("$global:githuburl/${gamedirname}/${config1}", "$global:currentdir\$global:server\server.cfg")
        $arma3WebResponse=Invoke-WebRequest "$githuburl/${gamedirname}/${config1}"
        $arma3WebResponse=$arma3WebResponse.content    
        New-Item $global:currentdir\$global:server\server.cfg -Force
        Add-Content $global:currentdir\$global:server\server.cfg $arma3WebResponse
        
        Write-Host "***  Copying Default network.cfg  ***" -ForegroundColor Magenta -BackgroundColor Black
        #(New-Object Net.WebClient).DownloadFile("$global:githuburl/${gamedirname}/${config2}", "$global:currentdir\$global:server\network.cfg")
        
        $arma3nWebResponse=Invoke-WebRequest "$githuburl/${gamedirname}/${config2}"
        $arma3nWebResponse=$arma3nWebResponse.content    
        New-Item $global:currentdir\$global:server\network.cfg -Force
        Add-Content $global:currentdir\$global:server\network.cfg $arma3nWebResponse
        
        $global:process = "arma3Server"
        Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
        ${global:IP} = Read-host -Prompt 'Input Server local IP'
        $global:MAXPLAYERS = Read-host -Prompt 'Input maxplayers'
        if(($global:PORT = Read-Host "Input Server Port,Press enter to accept default value [2302]") -eq ''){$global:PORT="2302"}else{$global:PORT}
        $global:HOSTNAME = Read-host -Prompt 'Input Server name'
        $global:SERVERPASSWORD = Read-host -Prompt 'Input server password'
        $global:SERVERADMINPASSWORD = Read-host -Prompt 'Input server Adminpassword'
        ((Get-Content -path $global:currentdir\$global:server\server.cfg -Raw) -replace "\bSERVERNAME\b","$global:HOSTNAME") | Set-Content -Path $global:currentdir\$global:server\server.cfg
        ((Get-Content -path $global:currentdir\$global:server\server.cfg -Raw) -replace '\b32\b',"$global:MAXPLAYERS") | Set-Content -Path $global:currentdir\$global:server\server.cfg  
        ((Get-Content -path $global:currentdir\$global:server\server.cfg -Raw) -replace "\barma3pass\b","$global:SERVERPASSWORD") | Set-Content -Path $global:currentdir\$global:server\server.cfg
        ((Get-Content -path $global:currentdir\$global:server\server.cfg -Raw) -replace '\bADMINPASSWORD\b',"$global:SERVERADMINPASSWORD") | Set-Content -Path $global:currentdir\$global:server\server.cfg  
        New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "if(`$Null -eq (get-process `"$global:process`" -ea SilentlyContinue)){"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-UpdateServer"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
        #Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-UpdateServer"
        #Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "start-process $global:currentdir\$global:server\Launch-$global:server.bat"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Start-Process 'cmd'  '/c start $global:currentdir\$global:server\arma3server.exe -ip=${global:IP} -port=$global:PORT -cfg=$global:currentdir\$global:server\network.cfg -config=$global:currentdir\$global:server\server.cfg -mod= -servermod= -bepath= -profiles=SC -name=SC -autoinit -loadmissiontomemory && exit'"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "}else{"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"Server Running`""
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-Process `"$global:process`"}"
        Set-Location $global:currentdir
    }    
  
    Function New-LaunchScriptSdtdserverPS
    {
        #----------   7Days2Die Ask for input for server cfg    -------------------
        $global:process = "7daystodieserver"
        Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
        if(($global:PORT = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [26900]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:PORT="26900"}else{$global:PORT}
        Write-Host 'Input Server name: ' -ForegroundColor Cyan -NoNewline
        $global:HOSTNAME = Read-host
        ((Get-Content -path $global:currentdir\$global:server\serverconfig.xml -Raw) -replace "My Game Host","$global:HOSTNAME") | Set-Content -Path $global:currentdir\$global:server\serverconfig.xml 
        ((Get-Content -path $global:currentdir\$global:server\serverconfig.xml -Raw) -replace '26900',"$global:PORT") | Set-Content -Path $global:currentdir\$global:server\serverconfig.xml 
        ((Get-Content -path $global:currentdir\$global:server\startdedicated.bat -Raw) -replace 'pause','exit') | Set-Content -Path $global:currentdir\$global:server\startdedicated.bat        
        New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "if(`$Null -eq (get-process `"$global:process`" -ea SilentlyContinue)){"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-UpdateServer"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
        #Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-UpdateServer"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "start-process $global:currentdir\$global:server\startdedicated.bat"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "}else{"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"Server Running`""
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-Process `"$global:process`"}"
    }

    Function New-LaunchScriptempserverPS {
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
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "if(`$Null -eq (get-process `"$global:process`" -ea SilentlyContinue)){"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-UpdateServer"
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
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "}else{"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"Server Running`""
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-Process `"$global:process`"}"
    }

    Function New-LaunchScriptceserverPS {
            #  http://cdn.funcom.com/downloads/exiles/DedicatedServerLauncher1044.exe

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

        Write-Host "***  Editing Default Engine.ini   ***" -ForegroundColor Magenta -BackgroundColor Black
        #((Get-Content -path $global:currentdir\$global:server\doi\cfg\server.cfg -Raw) -replace "\bSERVERNAME\b","$global:HOSTNAME") | Set-Content -Path $global:currentdir\$global:server\doi\cfg\server.cfg
        #((Get-Content -path $global:currentdir\$global:server\doi\cfg\server.cfg -Raw) -replace "\bADMINPASSWORD\b","$global:RCONPASSORD") | Set-Content -Path $global:currentdir\$global:server\doi\cfg\server.cfg
        #New-Item $global:currentdir\$global:server\ConanSandbox\Saved\Config\WindowsServer\Engine.ini -Force
        Add-Content -Path $global:currentdir\$global:server\ConanSandbox\Saved\Config\WindowsServer\Engine.ini -Value "ServerPassword=$global:SERVERPASSWORD"
        Add-Content -Path $global:currentdir\$global:server\ConanSandbox\Saved\Config\WindowsServer\Engine.ini -Value "ServerName=$global:HOSTNAME"
        
        Write-Host "***  Editing Default ServerSettings.ini   ***" -ForegroundColor Magenta -BackgroundColor Black
        #New-Item $global:currentdir\$global:server\ConanSandbox\Saved\Config\WindowsServer\ServerSettings.ini -Force
        Add-Content -Path $global:currentdir\$global:server\ConanSandbox\Saved\Config\WindowsServer\ServerSettings.ini -Value "AdminPassword=$global:ADMINPASSWORD"
        #((Get-Content -path $global:currentdir\$global:server\ConanSandbox\Saved\Config\WindowsServer\ServerSettings.ini -Raw) -replace "\bServerPassword=\b","ServerPassword=") | Set-Content -Path $global:currentdir\$global:server\ConanSandbox\Saved\Config\WindowsServer\ServerSettings.ini

        Write-Host "***  Creating Launch script ***" -ForegroundColor Magenta -BackgroundColor Black
        New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "if(`$Null -eq (get-process `"$global:process`" -ea SilentlyContinue)){"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-UpdateServer"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value ".\ConanSandboxServer.exe -log  -MaxPlayers=$global:MAXPLAYERS -Port=$global:PORT -QueryPort=$global:QUERYPORT"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "}else{"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"Server Running`""
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-Process `"$global:process`"}"
    }