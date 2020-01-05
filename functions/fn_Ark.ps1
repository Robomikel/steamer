Function New-LaunchScriptArkPS {
    $global:process = "ShooterGameServer"
    Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
    Write-Host 'Input Server local IP: ' -ForegroundColor Cyan -NoNewline
    ${global:IP} = Read-host
    if(($global:PORT = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [7777]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:PORT="7777"}else{$global:PORT}
    if(($global:QUERYPORT = Read-Host -Prompt  (Write-Host "Input Server Query Port, Press enter to accept default value [27015]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:QUERYPORT="27015"}else{$global:QUERYPORT}
    if(($global:RCONPORT = Read-Host -Prompt (Write-Host "Input Server Rcon Port,Press enter to accept default value [27020]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:RCONPORT="27020"}else{$global:RCONPORT}
    if(($global:MAP = Read-Host -Prompt (Write-Host "Input Server Map, Press enter to accept default value [TheIsland]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:MAP="TheIsland"}else{$global:MAP}
    if(($global:MAXPLAYERS = Read-Host -Prompt (Write-Host "Input Server Maxplayers, Press enter to accept default value [70]: " -ForegroundColor Cyan -NoNewline)) -eq ''){$global:MAXPLAYERS="70"}else{$global:MAXPLAYERS}
    Write-Host 'Input server hostname: ' -ForegroundColor Cyan -NoNewline
    $global:HOSTNAME = Read-host

    ${gamedirname}="ARKSurvivalEvolved"
    ${config1}="GameUserSettings.ini"
    $ArkWebResponse=Invoke-WebRequest "$githuburl/${gamedirname}/${config1}"
    $ArkWebResponse=$ArkWebResponse.content
    Write-Host "***  Copying Default GameUserSettings.ini  ***" -ForegroundColor Magenta -BackgroundColor Black
    New-Item $global:currentdir\$global:server\ShooterGame\Saved\Config\WindowsServer\GameUserSettings.ini -Force
    Add-Content $global:currentdir\$global:server\ShooterGame\Saved\Config\WindowsServer\GameUserSettings.ini $ArkWebResponse
    Write-Host "***  Adding Server Name to Default GameUserSettings.ini  ***" -ForegroundColor Magenta -BackgroundColor Black
    ((Get-Content -path $global:currentdir\$global:server\ShooterGame\Saved\Config\WindowsServer\GameUserSettings.ini -Raw) -replace "\bSERVERNAME\b","$global:HOSTNAME") | Set-Content -Path $global:currentdir\$global:server\ShooterGame\Saved\Config\WindowsServer\GameUserSettings.ini

    Write-Host "***  Creating Launch script  ***" -ForegroundColor Magenta -BackgroundColor Black
    New-Item $global:currentdir\$global:server\Launch-$global:server.ps1 -Force
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "if(`$Null -eq (get-process `"$global:process`" -ea SilentlyContinue)){"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-UpdateServer"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"****   Server Starting  ****`" -ForegroundColor Magenta -BackgroundColor Black"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Set-Location $global:currentdir\$global:server\ShooterGame\Binaries\Win64\"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "$global:currentdir\$global:server\ShooterGame\Binaries\Win64\ShooterGameServer.exe $global:MAP`?AltSaveDirectoryName=$global:MAP`?listen`?MultiHome=${global:IP}`?MaxPlayers=$global:MAXPLAYERS`?QueryPort=$global:QUERYPORT`?RCONPort=$global:RCONPORT`?Port=$global:PORT -automanagedmods"
#    start ShooterGameServer "TheIsland?SessionName=GameServerSetup?QueryPort=27015?ServerPassword=MyPassword?ServerAdminPassword=MYPassword?Port=7777?listen"
#exit
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "}else{"
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Write-Host `"Server Running`""
    Add-Content -Path $global:currentdir\$global:server\Launch-$global:server.ps1 -Value "Get-Process `"$global:process`"}"
    
    

}