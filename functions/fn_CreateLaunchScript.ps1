#:::::::::::::   CREATE LAUNCH SCRIPT FOR SERVER :::::::::::::::::::::::::
$githuburl="https://raw.githubusercontent.com/GameServerManagers/Game-Server-Configs/master"


Function New-LaunchScriptRustPS
    {
        #----------   Ask For Folder Name and App ID   -------------------
        $global:process = "RustDedicated"
        ${global:IP} = Read-host -Prompt 'Input Server local IP'
        if(($global:PORT = Read-Host "Input Server Port,Press enter to accept default value [28015]") -eq ''){$global:PORT="28015"}else{$global:PORT}
        if(($global:RCONPORT = Read-Host "Input Server Rcon Port,Press enter to accept default value [28016]") -eq ''){$global:RCONPORT="28016"}else{$global:RCONPORT}
        if(($global:RCONPASSWORD = Read-Host "Input Server Rcon Password,Press enter to accept default value [CHANGEME]") -eq ''){$global:RCONPASSWORD="CHANGEME"}else{$global:RCONPASSWORD}
        if(($global:RCONWEB = Read-Host "Input Server Rcon Web,Press enter to accept default value [1]") -eq ''){$global:RCONWEB="1"}else{$global:RCONWEB}
        $global:HOSTNAME = Read-host -Prompt 'Input Server name'
        $global:MAXPLAYERS = Read-host -Prompt 'Input maxplayers'
        if(($global:SEED = Read-Host "Input Server seed,Press enter to accept default value [4125143]") -eq ''){$global:SEED="4125143"}else{$global:SEED}
        if(($global:WORLDSIZE = Read-Host "Input Server WorldSize,Press enter to accept default value [3000]") -eq ''){$global:WORLDSIZE="3000"}else{$global:WORLDSIZE}
        if(($global:SAVEINTERVAL = Read-Host "Input Server Save Interval,Press enter to accept default value [300]") -eq ''){$global:SAVEINTERVAL="300"}else{$global:SAVEINTERVAL}
        if(($global:TICKRATE = Read-Host "Input Server Tickrate,Press enter to accept default value [30]") -eq ''){$global:TICKRATE="30"}else{$global:TICKRATE}
        New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "if(`$Null -eq (get-process `"$global:process`" -ea SilentlyContinue)){"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"Server Starting`" -ForegroundColor Magenta -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\Update-$global:server.ps1"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\RustDedicated.exe -batchmode +server.ip ${global:IP}  +server.port $global:PORT +server.tickrate $global:TICKRATE +server.hostname `"$global:HOSTNAME`" +server.maxplayers $global:MAXPLAYERS +server.worldsize $global:WORLDSIZE +server.saveinterval $global:SAVEINTERVAL +rcon.web $global:RCONWEB +rcon.ip ${global:IP} +rcon.port $global:RCONPORT +rcon.password `"$global:RCONPASSWORD`" "
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "}else{"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"Server Running`""
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-Process `"$global:process`"}"
        #Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\RustDedicated.exe -batchmode +server.ip ${global:IP}  +server.port $global:PORT +server.tickrate $global:TICKRATE +server.hostname \"$global:HOSTNAME\" +server.identity \"${selfname}\" ${conditionalseed} ${conditionalsalt} +server.maxplayers ${maxplayers} +server.worldsize ${worldsize} +server.saveinterval ${saveinterval} +rcon.web ${rconweb} +rcon.ip ${ip} +rcon.port ${rconport} +rcon.password \"${rconpassword}\" -logfile \"${gamelogdate}\""

    }

Function New-LaunchScriptArma3serverPS
{
        #----------   Ask For Folder Name and App ID   -------------------
        # requires https://www.microsoft.com/en-us/download/details.aspx?id=35 Direct x
        ${gamedirname}="Arma3"
        ${config1}="server.cfg"
        ${config2}="network.cfg"
        (New-Object Net.WebClient).DownloadFile("$githuburl/${gamedirname}/${config1}", "$global:currentdir\$global:server\server.cfg")
        (New-Object Net.WebClient).DownloadFile("$githuburl/${gamedirname}/${config2}", "$global:currentdir\$global:server\network.cfg")
        $global:process = "arma3Server"
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
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"Server Starting`" -ForegroundColor Magenta -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\Update-$global:server.ps1"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "start-process $global:currentdir\$global:server\Launch-$global:server.bat"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "}else{"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"Server Running`""
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-Process `"$global:process`"}"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.bat -Value "start /min /wait $global:currentdir\$global:server\arma3server.exe -ip=${global:IP} -port=$global:PORT -cfg=$global:currentdir\$global:server\network.cfg -config=$global:currentdir\$global:server\server.cfg -mod= -servermod= -bepath= -profiles=SC -name=SC -autoinit -loadmissiontomemory"
        Set-Location $global:currentdir
    }    
#Function New-LaunchScriptMiscreatedPS
    #{
        #----------   Ask For Folder Name and App ID   -------------------
   #     $global:process = "MiscreatedServer"
   #     ${global:IP} = Read-host -Prompt 'Input Server local IP'
   #     $global:MAXPLAYERS = Read-host -Prompt 'Input maxplayers'
   #     if(($global:PORT = Read-Host "Input Server Port,Press enter to accept default value [64090]") -eq ''){$global:PORT="64090"}else{$global:PORT}
   #     $global:HOSTNAME = Read-host -Prompt 'Input Server name' 
   #     New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
   #     Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "if(`$Null -eq (get-process `"$global:process`" -ea SilentlyContinue)){"
   #     Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"Server Starting`" -ForegroundColor Magenta -BackgroundColor Black"
   #     Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\Update-$global:server.ps1"
   #     Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\Bin64_dedicated\MiscreatedServer.exe  +sv_bind ${global:IP} +sv_maxplayers $global:MAXPLAYERS +map islands -sv_port $global:PORT +http_startserver -mis_gameserverid 100 +sv_servername '$global:HOSTNAME'"
   #     Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "}else{"
   #     Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"Server Running`""
   ##     Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-Process `"$global:process`"}"
    #    $global:RCONPASSORD = Read-host -Prompt 'Input http_password (RCON)'
    #    New-Item $global:currentdir\$global:server\HOSTING.CFG -Force
    #    Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "http_password=$global:RCONPASSORD"
    #    Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "sv_maxuptime=24"
    #    Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "sv_motd=`"WELCOME!`""
    #    Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "sv_url=`"mywebsite.com`""
    #    Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "asm_maxMultiplier=1"
    #    Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "asm_percent=33"
    #    Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "pcs_maxCorpses=20"
    ##    Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "sv_msg_conn=0"
     #   Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "sv_msg_death=0"
     #   Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "wm_timeScale=1"
     #   Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "wm_timeScaleWeather=1"
     #   Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "wm_timeScaleNight=4"
     #   Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "sv_noBannedAccounts=0 "


    #}
#:::::::::::     
    Function New-LaunchScriptSdtdserverPS
    {
        #----------   Ask For Folder Name and App ID   -------------------
        $global:process = "7daystodieserver"
        if(($global:PORT = Read-Host "Input Server Port,Press enter to accept default value [26900]") -eq ''){$global:PORT="26900"}else{$global:PORT}
        $global:HOSTNAME = Read-host -Prompt 'Input Server name'
        ((Get-Content -path $global:currentdir\$global:server\serverconfig.xml -Raw) -replace "My Game Host","$global:HOSTNAME") | Set-Content -Path $global:currentdir\$global:server\serverconfig.xml 
        ((Get-Content -path $global:currentdir\$global:server\serverconfig.xml -Raw) -replace '26900',"$global:PORT") | Set-Content -Path $global:currentdir\$global:server\serverconfig.xml 
        ((Get-Content -path $global:currentdir\$global:server\startdedicated.bat -Raw) -replace 'pause','exit') | Set-Content -Path $global:currentdir\$global:server\startdedicated.bat        
        New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "if(`$Null -eq (get-process `"$global:process`" -ea SilentlyContinue)){"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"Server Starting`" -ForegroundColor Magenta -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\Update-$global:server.ps1"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "start-process $global:currentdir\$global:server\startdedicated.bat"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "}else{"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"Server Running`""
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-Process `"$global:process`"}"
    }

    Function New-LaunchScriptInsserverPS
    {
        #----------   Ask For Folder Name and App ID   -------------------
        ${gamedirname}="Insurgency"
        ${config1}="server.cfg"
        (New-Object Net.WebClient).DownloadFile("$githuburl/${gamedirname}/${config1}", "$global:currentdir\$global:server\insurgency\cfg\server.cfg")
        $global:process = "srcds"
        ${global:IP} = Read-host -Prompt 'Input Server local IP'
        if(($global:PORT = Read-Host "Input Server Port,Press enter to accept default value [27016]") -eq ''){$global:PORT="27016"}else{$global:PORT}
        if(($global:MAP = Read-Host "Input Server Map and Mode,Press enter to accept default value [buhriz_coop checkpoint]") -eq ''){$global:MAP="buhriz_coop checkpoint"}else{$global:MAP}
        $global:MAXPLAYERS = Read-host -Prompt 'Input maxplayers'
        $global:HOSTNAME = Read-host -Prompt 'Input hostname'
        $global:RCONPASSORD = Read-host -Prompt 'Input rcon_password'
        ((Get-Content -path $global:currentdir\$global:server\insurgency\cfg\server.cfg -Raw) -replace "\bSERVERNAME\b","$global:HOSTNAME") | Set-Content -Path $global:currentdir\$global:server\insurgency\cfg\server.cfg
        ((Get-Content -path $global:currentdir\$global:server\insurgency\cfg\server.cfg -Raw) -replace "\bADMINPASSWORD\b","$global:RCONPASSORD") | Set-Content -Path $global:currentdir\$global:server\insurgency\cfg\server.cfg
        #((Get-Content -path $global:currentdir\$global:server\insurgency\cfg\server.cfg -Raw) -replace "SERVERNAME","$global:HOSTNAME") | Set-Content -Path $global:currentdir\$global:server\insurgency\cfg\server.cfg

        #New-Item $global:currentdir\$global:server\insurgency\cfg\server.cfg -Force
        #Add-Content -Path $global:currentdir\$global:server\insurgency\cfg\server.cfg -Value "hostname '$global:HOSTNAME'"
        #Add-Content -Path $global:currentdir\$global:server\insurgency\cfg\server.cfg -Value "rcon_password '$global:RCONPASSORD'"
        #Add-Content -Path $global:currentdir\$global:server\insurgency\cfg\server.cfg -Value "mapcyclefile 'mapcycle_checkpoint.txt'"
        New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "if(`$Null -eq (get-process `"$global:process`" -ea SilentlyContinue)){"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"Server Starting`" -ForegroundColor Magenta -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\Update-$global:server.ps1"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\srcds.exe -ip ${global:IP} -port $global:PORT +maxplayers $global:MAXPLAYERS +map '$global:MAP'"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "}else{"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"Server Running`""
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-Process `"$global:process`"}"
    }
    
    Function New-LaunchScriptInssserverPS 
    {
        #----------   Ask For Folder Name and App ID   -------------------
        $global:process = "InsurgencyServer-Win64-Shipping" 
        if(($global:SCENARIO = Read-Host "Input Server Scenario, Press enter to accept default value [Scenario_Outskirts_Checkpoint_Security]") -eq ''){$global:SCENARIO="Scenario_Outskirts_Checkpoint_Security"}else{$global:SCENARIO}
        if(($global:MAP = Read-Host "Input Server Map, Press enter to accept default value [Compound]") -eq ''){$global:MAP="Compound"}else{$global:MAP}
        if(($global:MAXPLAYERS = Read-Host "Input Server Maxplayers, Press enter to accept default value [8]") -eq ''){$global:MAXPLAYERS="8"}else{$global:MAXPLAYERS}
        if(($global:PORT = Read-Host "Input Server Port, Press enter to accept default value [27102]") -eq ''){$global:PORT="27102"}else{$global:PORT}
        if(($global:QUERYPORT = Read-Host "Input Server Query Port, Press enter to accept default value [27131]") -eq ''){$global:QUERYPORT="27131"}else{$global:QUERYPORT}
        #$global:SERVERPASSWORD = Read-host -Prompt 'Input server password'
        if(($global:SERVERPASSWORD = Read-Host "Input Server Password, Press enter to accept default value []") -eq ''){$global:SERVERPASSWORD=""}else{$global:SERVERPASSWORD}
        $global:HOSTNAME = Read-host -Prompt 'Input server hostname'
        New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "if(`$Null -eq (get-process `"$global:process`" -ea SilentlyContinue)){"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"Server Starting`" -ForegroundColor Magenta -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\Update-$global:server.ps1"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\InsurgencyServer.exe $global:MAP`?Scenario=$global:SCENARIO`?MaxPlayers=$global:MAXPLAYERS`?password=$global:SERVERPASSWORD -Port=$global:PORT -QueryPort=$global:QUERYPORT -log -hostname='$global:HOSTNAME'"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "}else{"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"Server Running`""
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-Process `"$global:process`"}"
        #if(($global:SERVERPASSWORD = Read-Host "Input Server Password, Press enter to accept default value []") -eq ''){$global:SERVERPASSWORD=""}else{$global:SERVERPASSWORD}
        If ($global:SERVERPASSWORD -eq ""){((Get-Content -path $global:currentdir\$global:server\Launch-$global:server.ps1 -Raw) -replace "\?password=","") | Set-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1}
        #Get-Content $global:currentdir\$global:server\Launch-$global:server.ps1  | ForEach-Object {$_ -replace '\?password=', ""}  | Set-Content "$global:currentdir\$global:server\Launch-$global:server.ps1"
    }