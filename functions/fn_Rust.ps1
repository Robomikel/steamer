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
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-UpdateServer"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\RustDedicated.exe -batchmode +server.ip ${global:IP}  +server.port $global:PORT +server.tickrate $global:TICKRATE +server.hostname `"$global:HOSTNAME`" +server.maxplayers $global:MAXPLAYERS +server.worldsize $global:WORLDSIZE +server.saveinterval $global:SAVEINTERVAL +rcon.web $global:RCONWEB +rcon.ip ${global:IP} +rcon.port $global:RCONPORT +rcon.password `"$global:RCONPASSWORD`" "
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "}else{"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"Server Running`""
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-Process `"$global:process`"}"
        #Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\RustDedicated.exe -batchmode +server.ip ${global:IP}  +server.port $global:PORT +server.tickrate $global:TICKRATE +server.hostname \"$global:HOSTNAME\" +server.identity \"${selfname}\" ${conditionalseed} ${conditionalsalt} +server.maxplayers ${maxplayers} +server.worldsize ${worldsize} +server.saveinterval ${saveinterval} +rcon.web ${rconweb} +rcon.ip ${ip} +rcon.port ${rconport} +rcon.password \"${rconpassword}\" -logfile \"${gamelogdate}\""
        ${gamedirname}="Rust"
        ${config1}="server.cfg"
        $#{config2}="network.cfg"
        (New-Object Net.WebClient).DownloadFile("$githuburl/${gamedirname}/${config1}", "$global:currentdir\$global:server\server\my_server_identity\server.cfg")
        #(New-Object Net.WebClient).DownloadFile("$githuburl/${gamedirname}/${config2}", "$global:currentdir\$global:server\network.cfg")


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
        #Select-Steamer
    }
    
    }
    
    
    Function Get-Oxide {


    Write-Host '*** Downloading and Extracting Oxide *****' -ForegroundColor Blue -BackgroundColor Black
    (New-Object Net.WebClient).DownloadFile("$global:oxiderustlatestlink", "$global:currentdir\oxide.zip")
    Expand-Archive "$global:currentdir\oxide.zip" "$global:currentdir\oxide\" -Force
    Copy-Item -Path $global:currentdir\oxide\RustDedicated_Data\* -Destination $global:currentdir\$global:server\RustDedicated_Data\ -Force -Recurse
    #oxiderustlatestlink="https://umod.org/games/rust/download/develop" # fix for linux build 06.09.2019
    #oxidehurtworldlatestlink=$(curl -sL https://api.github.com/repos/OxideMod/Oxide.Hurtworld/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep "Oxide.Hurtworld.zip")
    #oxidesdtdlatestlink=$(curl -sL https://api.github.com/repos/OxideMod/Oxide.SevenDaysToDie/releases/latest | grep browser_download_url | cut -d '"' -f 4)    
    

    }
  
    
    