Function New-LaunchScriptInssserverPS {
        #----------   INS: Sandstorm Server CFG  -------------------
        $global:GAME="insurgencysandstorm"
        $global:PROCESS = "InsurgencyServer-Win64-Shipping"
        Get-StopServerInstall
        
        Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black 
        if(($global:SCENARIO = Read-Host -Prompt (Write-Host "Input Server Scenario, Press enter to accept default value [Scenario_Outskirts_Checkpoint_Security]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:SCENARIO="Scenario_Outskirts_Checkpoint_Security"}else{$global:SCENARIO}
        if(($global:MAP = Read-Host -Prompt (Write-Host "Input Server Map, Press enter to accept default value [Compound]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:MAP="Compound"}else{$global:MAP}
        if(($global:MAXPLAYERS = Read-Host -Prompt (Write-Host "Input Server Maxplayers, Press enter to accept default value [8]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:MAXPLAYERS="8"}else{$global:MAXPLAYERS}
        if(($global:PORT = Read-Host -Prompt (Write-Host "Input Server Port, Press enter to accept default value [27102]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:PORT="27102"}else{$global:PORT}
        if(($global:QUERYPORT = Read-Host -Prompt  (Write-Host "Input Server Query Port, Press enter to accept default value [27131]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:QUERYPORT="27131"}else{$global:QUERYPORT}
        if(($global:SERVERPASSWORD = Read-Host -Prompt (Write-Host "Input Server Password, Press enter to accept default value []: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:SERVERPASSWORD=""}else{$global:SERVERPASSWORD}
        Write-Host 'Input server hostname: ' -ForegroundColor Cyan -NoNewline
        $global:HOSTNAME = Read-host
        if(($global:RCONPORT = Read-Host -Prompt (Write-Host "Input Server Rcon Port,Press enter to accept default value [25575]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:RCONPORT="25575"}else{$global:RCONPORT}
        if(($global:RCONPASSWORD = Read-Host -Prompt (Write-Host "Input RCON password Alpha Numeric:, Press enter to accept Random String value [$global:RANDOMPASSWORD]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:RCONPASSWORD="$global:RANDOMPASSWORD"}else{$global:RCONPASSWORD}
        Write-Host "***  Creating Launch script  ***" -ForegroundColor Magenta -BackgroundColor Black
        New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\InsurgencyServer.exe $global:MAP`?Scenario=$global:SCENARIO`?MaxPlayers=$global:MAXPLAYERS`?password=$global:SERVERPASSWORD -Port=$global:PORT -QueryPort=$global:QUERYPORT -log -hostname='$global:HOSTNAME'"
        If ($global:SERVERPASSWORD -eq ""){((Get-Content -path $global:currentdir\$global:server\Launch-$global:server.ps1 -Raw) -replace "\?password=","") | Set-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1}
        mkdir $global:currentdir\$global:server\Insurgency\Config\Server   >$null 2>&1
        $MapCyclePath = "$global:currentdir\$global:server\Insurgency\Config\Server"  
        mkdir $global:currentdir\$global:server\Insurgency\Saved\Config\WindowsServer   >$null 2>&1
        $GamePath = "$global:currentdir\$global:server\Insurgency\Saved\Config\WindowsServer"
        Write-Host "Enter Admin Steam ID64  for admins.txt: " -ForegroundColor Cyan -BackgroundColor Black
        $steamID64= Read-Host
        Write-Host "***  Creating Admins.txt  ***" -ForegroundColor Magenta -BackgroundColor Black
        New-Item $MapCyclePath\Admins.txt -Force
        Add-Content  $MapCyclePath\Admins.txt $steamID64
        Write-Host "***  Creating Mapcycle.txt  ***" -ForegroundColor Magenta -BackgroundColor Black
        New-Item $MapCyclePath\Mapcycle.txt -Force
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
        Write-Host "***  Creating Game.ini  ***" -ForegroundColor Magenta -BackgroundColor Black
        New-Item $GamePath\Game.ini -Force
        Add-Content   $GamePath\Game.ini [Rcon]
        Add-Content   $GamePath\Game.ini bEnabled=True
        Add-Content   $GamePath\Game.ini Password=$global:RCONPASSWORD
        Add-Content   $GamePath\Game.ini ListenPort=$global:RCONPORT
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
}


