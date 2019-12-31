Function New-LaunchScriptInssserverPS 
    {
        #----------   INS: Sandstorm Server CFG  -------------------
        $global:process = "InsurgencyServer-Win64-Shipping" 
        if(($global:SCENARIO = Read-Host "Input Server Scenario, Press enter to accept default value [Scenario_Outskirts_Checkpoint_Security]") -eq ''){$global:SCENARIO="Scenario_Outskirts_Checkpoint_Security"}else{$global:SCENARIO}
        if(($global:MAP = Read-Host "Input Server Map, Press enter to accept default value [Compound]") -eq ''){$global:MAP="Compound"}else{$global:MAP}
        if(($global:MAXPLAYERS = Read-Host "Input Server Maxplayers, Press enter to accept default value [8]") -eq ''){$global:MAXPLAYERS="8"}else{$global:MAXPLAYERS}
        if(($global:PORT = Read-Host "Input Server Port, Press enter to accept default value [27102]") -eq ''){$global:PORT="27102"}else{$global:PORT}
        if(($global:QUERYPORT = Read-Host "Input Server Query Port, Press enter to accept default value [27131]") -eq ''){$global:QUERYPORT="27131"}else{$global:QUERYPORT}
        #$global:SERVERPASSWORD = Read-host -Prompt 'Input server password'
        if(($global:SERVERPASSWORD = Read-Host "Input Server Password, Press enter to accept default value []") -eq ''){$global:SERVERPASSWORD=""}else{$global:SERVERPASSWORD}
        $global:HOSTNAME = Read-host -Prompt 'Input server hostname'
        Write-Host "***  Creating Launch script  ***" -ForegroundColor Magenta -BackgroundColor Black
        New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "if(`$Null -eq (get-process `"$global:process`" -ea SilentlyContinue)){"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-UpdateServer"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"Server Starting`" -ForegroundColor Magenta -BackgroundColor Black"
        #Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-UpdateServer"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\InsurgencyServer.exe $global:MAP`?Scenario=$global:SCENARIO`?MaxPlayers=$global:MAXPLAYERS`?password=$global:SERVERPASSWORD -Port=$global:PORT -QueryPort=$global:QUERYPORT -log -hostname='$global:HOSTNAME'"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "}else{"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"Server Running`""
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-Process `"$global:process`"}"
        #if(($global:SERVERPASSWORD = Read-Host "Input Server Password, Press enter to accept default value []") -eq ''){$global:SERVERPASSWORD=""}else{$global:SERVERPASSWORD}
        If ($global:SERVERPASSWORD -eq ""){((Get-Content -path $global:currentdir\$global:server\Launch-$global:server.ps1 -Raw) -replace "\?password=","") | Set-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1}
        #Get-Content $global:currentdir\$global:server\Launch-$global:server.ps1  | ForEach-Object {$_ -replace '\?password=', ""}  | Set-Content "$global:currentdir\$global:server\Launch-$global:server.ps1"
   
  #     New-Item -Path "$global:currentdir\inssserver\Insurgency\Config\Server" -Name "logfiles" -ItemType "directory"
  #      New-Item -Path "$global:currentdir\inssserver\Insurgency\Saved\Config\WindowsServer" -Name "logfiles" -ItemType "directory"
  #      mkdir $global:currentdir\inssserver
        mkdir $global:currentdir\$global:server\Insurgency\Config\Server   >$null 2>&1
        $MapCyclePath = "$global:currentdir\$global:server\Insurgency\Config\Server"
        
        mkdir $global:currentdir\$global:server\Insurgency\Saved\Config\WindowsServer   >$null 2>&1
        $GamePath = "$global:currentdir\$global:server\Insurgency\Saved\Config\WindowsServer"

        New-Item $MapCyclePath\Mapcycle.txt -Force
        New-Item $GamePath\Game.ini -Force
        New-Item $MapCyclePath\Admins.txt -Force
        # - - - - - - MAPCYCLE.TXT - - - - - - # EDIT \/   \/   \/  \/  \/  \/ \/ \/ \/
        Add-Content   $MapCyclePath\Mapcycle.txt Scenario_Ministry_Checkpoint_Security
        Add-Content   $MapCyclePath\Mapcycle.txt Scenario_Outskirts_Checkpoint_Security
        Add-Content   $MapCyclePath\Mapcycle.txt Scenario_Summit_Checkpoint_Security
        Add-Content   $MapCyclePath\Mapcycle.txt Scenario_Crossing_Checkpoint_Security
        Add-Content   $MapCyclePath\Mapcycle.txt Scenario_Precinct_Checkpoint_Security
        Add-Content   $MapCyclePath\Mapcycle.txt Scenario_Refinery_Checkpoint_Security 
        Add-Content   $MapCyclePath\Mapcycle.txt Scenario_Farmhouse_Checkpoint_Security
        Add-Content   $MapCyclePath\Mapcycle.txt Scenario_Hideout_Checkpoint_Security 
        Add-Content   $MapCyclePath\Mapcycle.txt Scenario_Hillside_Checkpoint_Security
        Add-Content   $MapCyclePath\Mapcycle.txt Scenario_Outskirts_Checkpoint_Insurgents
        Add-Content   $MapCyclePath\Mapcycle.txt Scenario_Summit_Checkpoint_Insurgents
        Add-Content   $MapCyclePath\Mapcycle.txt Scenario_Crossing_Checkpoint_Insurgents
        Add-Content   $MapCyclePath\Mapcycle.txt Scenario_Precinct_Checkpoint_Insurgents
        Add-Content   $MapCyclePath\Mapcycle.txt Scenario_Refinery_Checkpoint_Insurgents 
        Add-Content   $MapCyclePath\Mapcycle.txt Scenario_Farmhouse_Checkpoint_Insurgents
        Add-Content   $MapCyclePath\Mapcycle.txt Scenario_Hideout_Checkpoint_Insurgents
        Add-Content   $MapCyclePath\Mapcycle.txt Scenario_Ministry_Checkpoint_Insurgents
        Add-Content   $MapCyclePath\Mapcycle.txt Scenario_Hillside_Checkpoint_Insurgents
        # - - - - - - GAME.INI - - - -##  EDIT \/   \/   \/  \/  \/  \/ \/ \/ \/
        Add-Content   $GamePath\Game.ini [Rcon]
        Add-Content   $GamePath\Game.ini bEnabled=False
        Add-Content   $GamePath\Game.ini Password=
        Add-Content   $GamePath\Game.ini ListenPort=27015
        Add-Content   $GamePath\Game.ini bUseBroadcastAddress=True
        Add-Content   $GamePath\Game.ini ListenAddressOverride=0.0.0.0
        Add-Content   $GamePath\Game.ini bAllowConsoleCommands=True
        Add-Content   $GamePath\Game.ini MaxPasswordAttempts=3
        Add-Content   $GamePath\Game.ini IncorrectPasswordBanTime=30
        Add-Content   $GamePath\Game.ini " "
        Add-Content   $GamePath\Game.ini [/script/insurgency.inscoopmode]
        Add-Content   $GamePath\Game.ini bUseVehicleInsertion=True
        Add-Content   $GamePath\Game.ini FriendlyBotQuota=4
        Add-Content   $GamePath\Game.ini MinimumEnemies=6
        Add-Content   $GamePath\Game.ini MaximumEnemies=12
        Add-Content   $GamePath\Game.ini " "
        Add-Content   $GamePath\Game.ini [/script/insurgency.insgamemode]
        Add-Content   $GamePath\Game.ini ServerHostname=
        Add-Content   $GamePath\Game.ini bKillFeed=False
        Add-Content   $GamePath\Game.ini bKillFeedSpectator=True
        Add-Content   $GamePath\Game.ini bKillerInfo=True
        Add-Content   $GamePath\Game.ini bKillerInfoRevealDistance=False
        Add-Content   $GamePath\Game.ini TeamKillLimit=3
        Add-Content   $GamePath\Game.ini TeamKillGrace=0.20
        Add-Content   $GamePath\Game.ini TeamKillReduceTime=90
        Add-Content   $GamePath\Game.ini bDeadSay=False
        Add-Content   $GamePath\Game.ini bDeadSayTeam=True
        Add-Content   $GamePath\Game.ini bVoiceAllowDeadChat=False
        Add-Content   $GamePath\Game.ini bVoiceEnemyHearsLocal=True
        Add-Content   $GamePath\Game.ini ObjectiveCaptureTime=30
        Add-Content   $GamePath\Game.ini ObjectiveResetTime=-1
        Add-Content   $GamePath\Game.ini ObjectiveSpeedup=0.25
        Add-Content   $GamePath\Game.ini ObjectiveMaxSpeedupPlayers=4
        Add-Content   $GamePath\Game.ini " "
        Add-Content   $GamePath\Game.ini [/script/insurgency.insmultiplayermode]
        Add-Content   $GamePath\Game.ini bAllowFriendlyFire=True
        Add-Content   $GamePath\Game.ini FriendlyFireModifier=0.20
        Add-Content   $GamePath\Game.ini FriendlyFireReflect=0.00
        Add-Content   $GamePath\Game.ini bMapVoting=False
        Add-Content   $GamePath\Game.ini bUseMapCycle=True
        Add-Content   $GamePath\Game.ini InitialSupply=15
        Add-Content   $GamePath\Game.ini MaximumSupply=15
        Add-Content   $GamePath\Game.ini bSupplyGainEnabled=False
        Add-Content   $GamePath\Game.ini bAwardSupplyInstantly=False
        Add-Content   $GamePath\Game.ini SupplyGainFrequency=150
        Add-Content   $GamePath\Game.ini " "
        Add-Content   $GamePath\Game.ini [/script/insurgency.inscheckpointgamemode]
        Add-Content   $GamePath\Game.ini DefendTimer=90
        Add-Content   $GamePath\Game.ini DefendTimerFinal=180
        Add-Content   $GamePath\Game.ini RetreatTimer=10
        Add-Content   $GamePath\Game.ini RespawnDPR=0.10
        Add-Content   $GamePath\Game.ini RespawnDelay=20
        Add-Content   $GamePath\Game.ini PostCaptureRushTimer=30
        Add-Content   $GamePath\Game.ini CounterAttackRespawnDPR=0.20
        Add-Content   $GamePath\Game.ini CounterAttackRespawnDelay=20
        Add-Content   $GamePath\Game.ini ObjectiveTotalEnemyRespawnMultiplierMin=1.00
        Add-Content   $GamePath\Game.ini ObjectiveTotalEnemyRespawnMultiplierMax=1.00
        Add-Content   $GamePath\Game.ini FinalCacheBotQuotaMultiplier=1.50
        Add-Content   $GamePath\Game.ini bCounterAttackReinforce=False
        Add-Content   $GamePath\Game.ini RoundTime=480

        $steamID64= Read-Host "Enter Admin Steam ID64  for admins.txt"
        
        Add-Content  $MapCyclePath\Admins.txt $steamID64

    
    }