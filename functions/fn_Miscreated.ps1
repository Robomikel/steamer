Function New-LaunchScriptMiscreatedPS {
        #----------   Miscreated Server CFG  -------------------
        $global:MODDIR=""
        $global:EXEDIR=""
        $global:GAME = "protocol-valve"
        $global:PROCESS = "MiscreatedServer"
        $global:SERVERCFGDIR = ""
        
        Get-StopServerInstall
        $global:gamedirname=""
        $global:config1=""
        # Get-Servercfg
        # - - - - - - - - - - - - -

        Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
        Write-Host 'Input Server local IP: ' -ForegroundColor Cyan -NoNewline
        ${global:IP} = Read-host
        if(($global:PORT = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [64090]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:PORT="64090"}else{$global:PORT}
        Write-Host 'Input maxplayers: ' -ForegroundColor Cyan -NoNewline
        $global:MAXPLAYERS = Read-host 
        Write-Host 'Input Server name: ' -ForegroundColor Cyan -NoNewline
        $global:HOSTNAME = Read-host
        Write-Host '*** Creating Launch Script *****' -ForegroundColor Magenta -BackgroundColor Black  
        New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
        Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "start-process cmd `"/c $global:currentdir\$global:server\Bin64_dedicated\MiscreatedServer.exe  +sv_bind `${global:IP} +sv_maxplayers `$global:MAXPLAYERS +map islands -sv_port `$global:PORT +http_startserver -mis_gameserverid 100`" -Wait -NoNewWindow"
        if(($global:RCONPASSWORD = Read-Host -Prompt (Write-Host "Input Server Rcon Password,Press enter to accept default value [$global:RANDOMPASSWORD]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:RCONPASSWORD="$global:RANDOMPASSWORD"}else{$global:RCONPASSWORD}
        $global:RCONPORT="$global:PORT"
        Write-Host '*** Creating HOSTING.CFG *****' -ForegroundColor Magenta -BackgroundColor Black 
        New-Item $global:currentdir\$global:server\HOSTING.CFG -Force
        Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "sv_servername=`"$global:HOSTNAME`""
        Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "http_password=$global:RCONPASSWORD"
        Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value  "g_pinglimit=1000"
        Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "g_pingLimitTimer=15"
        Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "wm_timeScale=1"
        Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "wm_timeScaleWeather=1"
        Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "wm_timeScaleNight=4"
        Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "sv_noBannedAccounts=0 "
        Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "sv_maxuptime=24"
        Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "sv_motd=`"WELCOME!`""
        Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "sv_url=`"mywebsite.com`""
        Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "sv_msg_conn=0"
        Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "sv_msg_death=0"
        Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "g_playerHealthRegen=0.111"
        Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "g_playerFoodDecay=0.2777"
        Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "g_playerFoodDecaySprinting=0.34722"
        Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "g_playerWaterDecay=0.4861"
        Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "g_playerWaterDecaySprinting=0.607638"
        Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "g_playerInfiniteStamina=0"
        Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "g_craftingSpeedMultiplier=1"
        Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "asm_disable=0"
        Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "asm_percent=33"
        Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "asm_maxMultiplier=1"
        Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "asm_hordeCooldown=900"
        Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "pcs_maxCorpses=20"
        Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "pcs_maxCorpseTime=1200"
        Add-Content -Path $global:currentdir\$global:server\HOSTING.CFG -Value "steam_inventory_enable=1"
}