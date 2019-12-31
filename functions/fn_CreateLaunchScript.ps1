#:::::::::::::   CREATE LAUNCH SCRIPT FOR SERVER :::::::::::::::::::::::::




#Function New-LaunchScriptRustPS
    {
        #----------   Rust Ask for input for server cfg    -------------------
#        $global:process = "RustDedicated"
#        ${global:IP} = Read-host -Prompt 'Input Server local IP'
#        if(($global:PORT = Read-Host "Input Server Port,Press enter to accept default value [28015]") -eq ''){$global:PORT="28015"}else{$global:PORT}
#        if(($global:RCONPORT = Read-Host "Input Server Rcon Port,Press enter to accept default value [28016]") -eq ''){$global:RCONPORT="28016"}else{$global:RCONPORT}
#        if(($global:RCONPASSWORD = Read-Host "Input Server Rcon Password,Press enter to accept default value [CHANGEME]") -eq ''){$global:RCONPASSWORD="CHANGEME"}else{$global:RCONPASSWORD}
#        if(($global:RCONWEB = Read-Host "Input Server Rcon Web,Press enter to accept default value [1]") -eq ''){$global:RCONWEB="1"}else{$global:RCONWEB}
#        $global:HOSTNAME = Read-host -Prompt 'Input Server name'
#        $global:MAXPLAYERS = Read-host -Prompt 'Input maxplayers'
#        if(($global:SEED = Read-Host "Input Server seed,Press enter to accept default value [4125143]") -eq ''){$global:SEED="4125143"}else{$global:SEED}
#        if(($global:WORLDSIZE = Read-Host "Input Server WorldSize,Press enter to accept default value [3000]") -eq ''){$global:WORLDSIZE="3000"}else{$global:WORLDSIZE}
#        if(($global:SAVEINTERVAL = Read-Host "Input Server Save Interval,Press enter to accept default value [300]") -eq ''){$global:SAVEINTERVAL="300"}else{$global:SAVEINTERVAL}
#        if(($global:TICKRATE = Read-Host "Input Server Tickrate,Press enter to accept default value [30]") -eq ''){$global:TICKRATE="30"}else{$global:TICKRATE}
#        New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
#        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "if(`$Null -eq (get-process `"$global:process`" -ea SilentlyContinue)){"
#        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
#        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-UpdateServer"
#        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\RustDedicated.exe -batchmode +server.ip ${global:IP}  +server.port $global:PORT +server.tickrate $global:TICKRATE +server.hostname `"$global:HOSTNAME`" +server.maxplayers $global:MAXPLAYERS +server.worldsize $global:WORLDSIZE +server.saveinterval $global:SAVEINTERVAL +rcon.web $global:RCONWEB +rcon.ip ${global:IP} +rcon.port $global:RCONPORT +rcon.password `"$global:RCONPASSWORD`" "
#        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "}else{"
#        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"Server Running`""
#        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-Process `"$global:process`"}"
        #Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\RustDedicated.exe -batchmode +server.ip ${global:IP}  +server.port $global:PORT +server.tickrate $global:TICKRATE +server.hostname \"$global:HOSTNAME\" +server.identity \"${selfname}\" ${conditionalseed} ${conditionalsalt} +server.maxplayers ${maxplayers} +server.worldsize ${worldsize} +server.saveinterval ${saveinterval} +rcon.web ${rconweb} +rcon.ip ${ip} +rcon.port ${rconport} +rcon.password \"${rconpassword}\" -logfile \"${gamelogdate}\""
   }

Function New-LaunchScriptArma3serverPS
{
        #----------   Arma3 Ask for input for server cfg  -------------------
        # requires https://www.microsoft.com/en-us/download/details.aspx?id=35 Direct x
        ${gamedirname}="Arma3"
        ${config1}="server.cfg"
        ${config2}="network.cfg"
        (New-Object Net.WebClient).DownloadFile("$global:githuburl/${gamedirname}/${config1}", "$global:currentdir\$global:server\server.cfg")
        (New-Object Net.WebClient).DownloadFile("$global:githuburl/${gamedirname}/${config2}", "$global:currentdir\$global:server\network.cfg")
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
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-UpdateServer"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
        #Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-UpdateServer"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "start-process $global:currentdir\$global:server\Launch-$global:server.bat"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "}else{"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"Server Running`""
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-Process `"$global:process`"}"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.bat -Value "start /min /wait $global:currentdir\$global:server\arma3server.exe -ip=${global:IP} -port=$global:PORT -cfg=$global:currentdir\$global:server\network.cfg -config=$global:currentdir\$global:server\server.cfg -mod= -servermod= -bepath= -profiles=SC -name=SC -autoinit -loadmissiontomemory"
        Set-Location $global:currentdir
    }    
  
    Function New-LaunchScriptSdtdserverPS
    {
        #----------   7Days2Die Ask for input for server cfg    -------------------
        $global:process = "7daystodieserver"
        if(($global:PORT = Read-Host "Input Server Port,Press enter to accept default value [26900]") -eq ''){$global:PORT="26900"}else{$global:PORT}
        $global:HOSTNAME = Read-host -Prompt 'Input Server name'
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
