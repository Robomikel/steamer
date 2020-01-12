Function New-LaunchScriptKF2serverPS {
    # Killing Floor 2 Server
    ${gamedirname}="KillingFloor2"
    ${config1}="KFWeb.ini"
    ${config2}="LinuxServer-KFEngine.ini"
    ${config3}="LinuxServer-KFGame.ini"
    ${config4}="LinuxServer-KFInput.ini"
    ${config5}="LinuxServer-KFSystemSettings.ini"
    Write-Host "***  Copying Default KFWeb.ini ***" -ForegroundColor Magenta -BackgroundColor Black
    $kf2WebResponse=Invoke-WebRequest "$githuburl/${gamedirname}/${config1}"
    #$kf2WebResponse=$kf2WebResponse.content
    New-Item $global:currentdir\$global:server\KFGame\Config\KFWeb.ini -Force
    Add-Content $global:currentdir\$global:server\KFGame\Config\KFWeb.ini $kf2WebResponse
    
    Write-Host "***  Copying Default PCServer-KFEngine.ini ***" -ForegroundColor Magenta -BackgroundColor Black
    $kf2WebResponse=Invoke-WebRequest "$githuburl/${gamedirname}/${config2}"
    #$kf2WebResponse=$kf2WebResponse.content
    New-Item $global:currentdir\$global:server\KFGame\Config\PCServer-KFEngine.ini -Force
    Add-Content $global:currentdir\$global:server\KFGame\Config\PCServer-KFEngine.ini $kf2WebResponse
    
    Write-Host "***  Copying Default PCServer-KFGame.ini ***" -ForegroundColor Magenta -BackgroundColor Black
    $kf2WebResponse=Invoke-WebRequest "$githuburl/${gamedirname}/${config3}"
    #$kf2WebResponse=$kf2WebResponse.content
    New-Item $global:currentdir\$global:server\KFGame\Config\PCServer-KFGame.ini -Force
    Add-Content $global:currentdir\$global:server\KFGame\Config\PCServer-KFGame.ini $kf2WebResponse
    
    Write-Host "***  Copying Default PCServer-KFInput.ini ***" -ForegroundColor Magenta -BackgroundColor Black
    $kf2WebResponse=Invoke-WebRequest "$githuburl/${gamedirname}/${config4}"
    #$kf2WebResponse=$kf2WebResponse.content
    New-Item $global:currentdir\$global:server\KFGame\Config\PCServer-KFInput.ini -Force
    Add-Content $global:currentdir\$global:server\KFGame\Config\PCServer-KFInput.ini $kf2WebResponse
    
    Write-Host "***  Copying Default PCServer-KFSystemSettings.ini  ***" -ForegroundColor Magenta -BackgroundColor Black
    $kf2WebResponse=Invoke-WebRequest "$githuburl/${gamedirname}/${config5}"
    #$kf2WebResponse=$kf2WebResponse.content
    New-Item $global:currentdir\$global:server\KFGame\Config\PCServer-KFSystemSettings.ini -Force
    Add-Content $global:currentdir\$global:server\KFGame\Config\PCServer-KFSystemSettings.ini $kf2WebResponse

    $global:RANDOMPASSWORD = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 11 | ForEach-Object {[char]$_})

    
    $global:game = "killingfloor2"
    Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
    $global:process = "KFserver"
    #Write-Host "Input Server local IP: " -ForegroundColor Cyan -NoNewline
    #${global:IP} = Read-Host
    Write-Host "Changing the Port will change the query Port. N+? if not sure keep default" -ForegroundColor Yellow
    if(($global:PORT = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [7787]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:PORT="7787"}else{$global:PORT}
    if(($global:QUERYPORT = Read-Host -Prompt  (Write-Host "Input Server Query Port, Press enter to accept default value [27015]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:QUERYPORT="27015"}else{$global:QUERYPORT}
    if(($global:MAP = Read-Host -Prompt (Write-Host "Input Server Map, Press enter to accept default value [KF-BioticsLab]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:MAP="KF-BioticsLab"}else{$global:MAP}
    if(($global:GAMEMODE = Read-Host -Prompt (Write-Host "Input gamemode, Press enter to accept default value [KFGameContent.KFGameInfo_Endless]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:GAMEMODE="KFGameContent.KFGameInfo_Endless"}else{$global:GAMEMODE}
    if(($global:DIFF = Read-Host -Prompt (Write-Host "Input Difficulty (0-3), Press enter to accept default value [0]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:DIFF="0"}else{$global:DIFF}
    Write-Host 'Input Server Name: ' -ForegroundColor Cyan -NoNewline
    $global:HOSTNAME = Read-host
    #Write-Host 'Input ADMIN PASSWORD (Alpha Numeric only): ' -ForegroundColor Cyan -NoNewline
    #$global:ADMINPASSWORD = Read-host
    if(($global:ADMINPASSWORD = Read-Host -Prompt (Write-Host "Input ADMIN password Alpha Numeric:, Press enter to accept Random String value [$global:RANDOMPASSWORD]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:ADMINPASSWORD="$global:RANDOMPASSWORD"}else{$global:ADMINPASSWORD}

    Write-Host "***  Creating Launch script ***" -ForegroundColor Magenta -BackgroundColor Black
    New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "if(`$Null -eq (get-process `"$global:process`" -ea SilentlyContinue)){"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-UpdateServer"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\Binaries\Win64"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "./KFServer.exe $global:MAP`?Game=$global:GAMEMODE`?Difficulty=$global:DIFF`? -Port=$global:PORT -QueryPort=$global:QUERYPORT"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "}else{"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"Server Running`""
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-Process `"$global:process`"}"

    Write-Host "***  starting Server before Setting PCServer-KFGame.ini Please Wait ***" -ForegroundColor Magenta -BackgroundColor Black
    Select-launchServer
    timeout 5
    Write-Host "***  stopping Server before Setting PCServer-KFGame.ini Please Wait ***" -ForegroundColor Magenta -BackgroundColor Black
    Get-StopServer
    Write-Host "***  Editing Default Server Name PCServer-KFGame.ini ***" -ForegroundColor Magenta -BackgroundColor Black
    ((Get-Content -path $global:currentdir\$global:server\KFGame\Config\PCServer-KFGame.ini -Raw) -replace "\bKilling Floor 2 Server\b","$global:HOSTNAME") | Set-Content -Path $global:currentdir\$global:server\KFGame\Config\PCServer-KFGame.ini
    Write-Host "***  Adding ADMIN PASSWORD PCServer-KFGame.ini ***" -ForegroundColor Magenta -BackgroundColor Black
    ((Get-Content -path $global:currentdir\$global:server\KFGame\Config\PCServer-KFGame.ini -Raw) -replace "AdminPassword=","AdminPassword=$global:ADMINPASSWORD") | Set-Content -Path $global:currentdir\$global:server\KFGame\Config\PCServer-KFGame.ini
    Write-Host "***  Enabling Webmin in KFWeb.ini ***" -ForegroundColor Magenta -BackgroundColor Black
    ((Get-Content -path $global:currentdir\$global:server\KFGame\Config\KFWeb.ini -Raw) -replace "\bbEnabled=false\b","bEnabled=true") | Set-Content -Path $global:currentdir\$global:server\KFGame\Config\KFWeb.ini
    Write-Host "***  Disabling Takeover PCServer-KFEngine.ini ***" -ForegroundColor Magenta -BackgroundColor Black
    ((Get-Content -path $global:currentdir\$global:server\KFGame\Config\PCServer-KFEngine.ini -Raw) -replace "\bbUsedForTakeover=TRUE\b","bUsedForTakeover=FALSE") | Set-Content -Path $global:currentdir\$global:server\KFGame\Config\PCServer-KFEngine.ini

}