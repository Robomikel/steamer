# Version 2.0
Function New-LaunchScriptArkPS {
    # Ark: Survival Evolved Server
    # - - - - - - - - - - - -
    $global:MODDIR = ""
    $global:EXE = "ShooterGameServer.exe "
    $global:EXEDIR = "ShooterGame\Binaries\Win64"
    $global:GAME = "arkse"
    $global:PROCESS = "ShooterGameServer"
    $global:SERVERCFGDIR = "ShooterGame\Saved\Config\WindowsServer"
    
    Get-StopServerInstall
    $global:gamedirname = "ARKSurvivalEvolved"
    $global:config1 = "GameUserSettings.ini"
    Get-Servercfg

    # - - - - - - - - - - - - -

    If ( $global:Version -eq "1" ) {
        Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
        Write-Host 'Input Server local IP: ' -ForegroundColor Cyan -NoNewline
        ${global:IP} = Read-host
        if (($global:PORT = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [7777]: " -ForegroundColor Cyan -NoNewline)) -eq '') { $global:PORT = "7777" }else { $global:PORT }
        if (($global:QUERYPORT = Read-Host -Prompt  (Write-Host "Input Server Query Port, Press enter to accept default value [27015]: " -ForegroundColor Cyan -NoNewline)) -eq '') { $global:QUERYPORT = "27015" }else { $global:QUERYPORT }
        if (($global:RCONPORT = Read-Host -Prompt (Write-Host "Input Server Rcon Port,Press enter to accept default value [27020]: " -ForegroundColor Cyan -NoNewline)) -eq '') { $global:RCONPORT = "27020" }else { $global:RCONPORT }
        if (($global:RCONPASSWORD = Read-Host -Prompt (Write-Host "Input RCON password Alpha Numeric:, Press enter to accept Random String value [$global:RANDOMPASSWORD]: "-ForegroundColor Cyan -NoNewline)) -eq '') { $global:RCONPASSWORD = "$global:RANDOMPASSWORD" }else { $global:RCONPASSWORD }
        if (($global:MAP = Read-Host -Prompt (Write-Host "Input Server Map, Press enter to accept default value [TheIsland]: " -ForegroundColor Cyan -NoNewline)) -eq '') { $global:MAP = "TheIsland" }else { $global:MAP }
        if (($global:MAXPLAYERS = Read-Host -Prompt (Write-Host "Input Server Maxplayers, Press enter to accept default value [70]: " -ForegroundColor Cyan -NoNewline)) -eq '') { $global:MAXPLAYERS = "70" }else { $global:MAXPLAYERS }
        Write-Host 'Input server hostname: ' -ForegroundColor Cyan -NoNewline
        $global:HOSTNAME = Read-host
    }
    ElseIf ( $global:Version -eq "2" ) {
        # Version 2.0
        #  First Run Vars \/ \/ Add Here
        ${global:IP} = ""
        $global:PORT = ""
        $global:QUERYPORT = ""
        $global:RCONPORT = ""
        $global:RCONPASSWORD = ""
        $global:MAP = ""
        $global:MAXPLAYERS = ""
        $global:HOSTNAME = ""
    }
    ElseIf ( $global:Version -eq "0" ) {
        #     Get-UserInput 1 1 0
    }
    Select-EditSourceCFG


    # Version 2.0
    $global:launchParams = '@("$global:EXEDIR\$global:EXE ${global:MAP}?AltSaveDirectoryName=${global:MAP}?listen?MultiHome=${global:IP}?MaxPlayers=${global:MAXPLAYERS}?QueryPort=${global:QUERYPORT}?RCONEnabled=True?RCONPort=${global:RCONPORT}?ServerAdminPassword=${global:RCONPASSWORD}?Port=${global:PORT} -automanagedmods")'
}
