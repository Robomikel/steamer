Function New-LaunchScriptKF2serverPS {
    # Killing Floor 2 Server
    # - - - - - - - - - - - -
    $global:EXEDIR="Binaries\Win64"
    $global:GAME = "killingfloor2"
    $global:PROCESS = "KFserver"
    $global:SERVERCFGDIR = "\KFGame\Config"

    Get-StopServerInstall
    
    $global:gamedirname="KillingFloor2"
    $global:config1="KFWeb.ini"
    $global:config2="LinuxServer-KFEngine.ini"
    $global:config3="LinuxServer-KFGame.ini"
    $global:config4="LinuxServer-KFInput.ini"
    $global:config5="LinuxServer-KFSystemSettings.ini"

    Remove-item $global:currentdir\$global:server\$global:SERVERCFGDIR\PCServer-*.ini -Force  >$null 2>&1
    Get-Servercfg
    Set-Location $global:currentdir\$global:server\$global:SERVERCFGDIR
    Get-ChildItem -Filter "LinuxServer-*.ini" -Recurse | Rename-Item -NewName {$_.name -replace 'LinuxServer','PCServer'} -Force
    # - - - - - - - - - - - - -
    Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
    #Write-Host "Input Server local IP: " -ForegroundColor Cyan -NoNewline
    #${global:IP} = Read-Host
    Write-Host "Changing the Port will change the query Port. N+? if not sure keep default" -ForegroundColor Yellow
    if(($global:PORT = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [7777]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:PORT="7777"}else{$global:PORT}
    if(($global:QUERYPORT = Read-Host -Prompt  (Write-Host "Input Server Query Port, Press enter to accept default value [27015]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:QUERYPORT="27015"}else{$global:QUERYPORT}
    if(($global:MAP = Read-Host -Prompt (Write-Host "Input Server Map, Press enter to accept default value [KF-BioticsLab]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:MAP="KF-BioticsLab"}else{$global:MAP}
    if(($global:GAMEMODE = Read-Host -Prompt (Write-Host "Input gamemode, Press enter to accept default value [KFGameContent.KFGameInfo_Endless]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:GAMEMODE="KFGameContent.KFGameInfo_Endless"}else{$global:GAMEMODE}
    if(($global:DIFF = Read-Host -Prompt (Write-Host "Input Difficulty (0-3), Press enter to accept default value [0]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:DIFF="0"}else{$global:DIFF}
    Write-Host 'Input Server Name: ' -ForegroundColor Cyan -NoNewline
    $global:HOSTNAME = Read-host
    if(($global:ADMINPASSWORD = Read-Host -Prompt (Write-Host "Input ADMIN password Alpha Numeric:, Press enter to accept Random String value [$global:RANDOMPASSWORD]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:ADMINPASSWORD="$global:RANDOMPASSWORD"}else{$global:ADMINPASSWORD}
    Write-Host "***  Creating Launch script ***" -ForegroundColor Magenta -BackgroundColor Black
    New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\Binaries\Win64"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "start-process cmd `"/c KFServer.exe `${global:MAP}?Game=`${global:GAMEMODE}?Difficulty=`${global:DIFF}? -Port=`${global:PORT} -QueryPort=`${global:QUERYPORT}`" -NoNewWindow"
    Write-Host "***  starting Server before Setting PCServer-KFGame.ini Please Wait ***" -ForegroundColor Magenta -BackgroundColor Black
    Select-launchServer
    timeout 5
    Write-Host "***  stopping Server before Setting PCServer-KFGame.ini Please Wait ***" -ForegroundColor Magenta -BackgroundColor Black
    Get-StopServer
    Write-Host "***  Editing Default Server Name PCServer-KFGame.ini ***" -ForegroundColor Magenta -BackgroundColor Black
    ((Get-Content -path $global:currentdir\$global:server\$global:SERVERCFGDIR\PCServer-KFGame.ini -Raw) -replace "\bKilling Floor 2 Server\b","$global:HOSTNAME") | Set-Content -Path $global:currentdir\$global:server\KFGame\Config\PCServer-KFGame.ini
    Write-Host "***  Adding ADMIN PASSWORD PCServer-KFGame.ini ***" -ForegroundColor Magenta -BackgroundColor Black
    ((Get-Content -path $global:currentdir\$global:server\$global:SERVERCFGDIR\PCServer-KFGame.ini -Raw) -replace "AdminPassword=","AdminPassword=$global:ADMINPASSWORD") | Set-Content -Path $global:currentdir\$global:server\KFGame\Config\PCServer-KFGame.ini
    Write-Host "***  Enabling Webmin in KFWeb.ini ***" -ForegroundColor Magenta -BackgroundColor Black
    ((Get-Content -path $global:currentdir\$global:server\$global:SERVERCFGDIR\KFWeb.ini -Raw) -replace "\bbEnabled=false\b","bEnabled=true") | Set-Content -Path $global:currentdir\$global:server\KFGame\Config\KFWeb.ini
    Write-Host "***  Disabling Takeover PCServer-KFEngine.ini ***" -ForegroundColor Magenta -BackgroundColor Black
    ((Get-Content -path $global:currentdir\$global:server\$global:SERVERCFGDIR\PCServer-KFEngine.ini -Raw) -replace "\bbUsedForTakeover=TRUE\b","bUsedForTakeover=FALSE") | Set-Content -Path $global:currentdir\$global:server\KFGame\Config\PCServer-KFEngine.ini
}