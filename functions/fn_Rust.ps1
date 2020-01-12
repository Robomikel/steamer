Function New-LaunchScriptRustPS
    {
        #----------   Rust server CDF  -------------------
        $global:game="rust"
        $global:process = "RustDedicated"
        Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
        Write-Host 'Input Server local IP: ' -ForegroundColor Cyan -NoNewline
        ${global:IP} = Read-host
        if(($global:PORT = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [28015]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:PORT="28015"}else{$global:PORT}
        if(($global:RCONPORT = Read-Host -Prompt (Write-Host "Input Server Rcon Port,Press enter to accept default value [28016]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:RCONPORT="28016"}else{$global:RCONPORT}
        if(($global:RCONPASSWORD = Read-Host -Prompt (Write-Host "Input Server Rcon Password,Press enter to accept default value [CHANGEME]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:RCONPASSWORD="CHANGEME"}else{$global:RCONPASSWORD}
        if(($global:RCONWEB = Read-Host -Prompt (Write-Host "Input Server Rcon Web,Press enter to accept default value [1]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:RCONWEB="1"}else{$global:RCONWEB}
        Write-Host 'Input Server name: ' -ForegroundColor Cyan -NoNewline
        $global:HOSTNAME = Read-host
        Write-Host 'Input maxplayers: ' -ForegroundColor Cyan -NoNewline
        $global:MAXPLAYERS = Read-host
        if(($global:SEED = Read-Host -Prompt (Write-Host "Input Server seed,Press enter to accept default value [4125143]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:SEED="4125143"}else{$global:SEED}
        if(($global:WORLDSIZE = Read-Host -Prompt (Write-Host "Input Server WorldSize,Press enter to accept default value [3000]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:WORLDSIZE="3000"}else{$global:WORLDSIZE}
        if(($global:SAVEINTERVAL = Read-Host -Prompt (Write-Host "Input Server Save Interval,Press enter to accept default value [300]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:SAVEINTERVAL="300"}else{$global:SAVEINTERVAL}
        if(($global:TICKRATE = Read-Host -Prompt (Write-Host "Input Server Tickrate,Press enter to accept default value [30]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:TICKRATE="30"}else{$global:TICKRATE}
        Write-Host "***  Creating Launch script  ***" -ForegroundColor Magenta -BackgroundColor Black
        New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "if(`$Null -eq (get-process `"$global:process`" -ea SilentlyContinue)){"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-UpdateServer"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\ "
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Start-Process 'cmd'  '/c start RustDedicated.exe -batchmode +server.ip ${global:IP}  +server.port $global:PORT +server.tickrate $global:TICKRATE +server.hostname `"$global:HOSTNAME`" +server.maxplayers $global:MAXPLAYERS +server.worldsize $global:WORLDSIZE +server.saveinterval $global:SAVEINTERVAL +rcon.web $global:RCONWEB +rcon.ip 0.0.0.0 +rcon.port $global:RCONPORT +rcon.password `"$global:RCONPASSWORD`" -logfile `"$global:currentdir\$global:server\Serverlog.log`"'"

        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "}else{"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"Server Running`""
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-Process `"$global:process`"}"
        #Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\RustDedicated.exe -batchmode +server.ip ${global:IP}  +server.port $global:PORT +server.tickrate $global:TICKRATE +server.hostname \"$global:HOSTNAME\" +server.identity \"${selfname}\" ${conditionalseed} ${conditionalsalt} +server.maxplayers ${maxplayers} +server.worldsize ${worldsize} +server.saveinterval ${saveinterval} +rcon.web ${rconweb} +rcon.ip ${ip} +rcon.port ${rconport} +rcon.password \"${rconpassword}\" -logfile \"${gamelogdate}\""
        ${gamedirname}="Rust"
        ${config1}="server.cfg"
        Write-Host "***  Copying Default server.cfg  ***" -ForegroundColor Magenta -BackgroundColor Black
        #(New-Object Net.WebClient).DownloadFile("$githuburl/${gamedirname}/${config1}", "$global:currentdir\$global:server\server\my_server_identity\cfg\server.cfg")
        $RustWebResponse=Invoke-WebRequest "$githuburl/${gamedirname}/${config1}"
        #$RustWebResponse=$RustWebResponse.content    
        New-Item $global:currentdir\$global:server\server\my_server_identity\cfg\server.cfg -Force
        Add-Content $global:currentdir\$global:server\server\my_server_identity\cfg\server.cfg $RustWebResponse

        $title    = 'Download Oxide'
        $question = 'Download Oxide and install?'
        $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
        $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
        $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    
        $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
            if ($decision -eq 0) {
                Get-Oxide
                Write-Host 'Entered Y'
            } else {
        Write-Host 'Entered N'
    }
    
    }
    
    
    Function Get-Oxide {
        $start_time = Get-Date
        Write-Host '*** Downloading Oxide *****' -ForegroundColor Magenta -BackgroundColor Black
        #(New-Object Net.WebClient).DownloadFile("$global:oxiderustlatestlink", "$global:currentdir\oxide.zip")
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
        Invoke-WebRequest -Uri $global:oxiderustlatestlink -OutFile $global:currentdir\oxide.zip 
        Write-Host "Download Time: $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
        Write-Host '***Extracting Oxide *****' -ForegroundColor Magenta -BackgroundColor Black
        Expand-Archive "$global:currentdir\oxide.zip" "$global:currentdir\oxide\" -Force
        Write-Host '***Copying Oxide *****' -ForegroundColor Magenta -BackgroundColor Black
        Copy-Item -Path $global:currentdir\oxide\RustDedicated_Data\* -Destination $global:currentdir\$global:server\RustDedicated_Data\ -Force -Recurse
    }
  
    
    