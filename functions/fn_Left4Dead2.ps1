# Version 2.0
Function New-LaunchScriptLFD2serverPS {
    #----------   left4dead2 Server CFG    -------------------
    # Steamer Vars Do Not Edit
    $global:MODDIR = "left4dead2"
    $global:EXEDIR = ""
    $global:EXE = "l4d2"
    $global:GAME = "left4dead2"
    $global:PROCESS = "l4d2"
    $global:SERVERCFGDIR = "left4dead2\cfg"
    
    Get-StopServerInstall
    # Game-Server-Configs
    $global:gamedirname = "Left4Dead2"
    $global:config1 = "server.cfg"
    Get-Servercfg
    # - - - - - - - - - - - - -
    Select-RenameSource
    If ( $global:Version -eq "1" ) {
        Write-Host '*** Configure Instance *****' -ForegroundColor Yellow -BackgroundColor Black
        Write-Host "Input Server local IP: " -ForegroundColor Cyan -NoNewline
        ${global:IP} = Read-Host
        if (($global:PORT = Read-Host -Prompt (Write-Host "Input Server Port,Press enter to accept default value [27015]: "-ForegroundColor Cyan -NoNewline)) -eq '') { $global:PORT = "27015" }else { $global:PORT }
        if (($global:CLIENTPORT = Read-Host -Prompt (Write-Host "Input Server Client Port, Press enter to accept default value [27005]: "-ForegroundColor Cyan -NoNewline)) -eq '') { $global:CLIENTPORT = "27005" }else { $global:CLIENTPORT }
        if (($global:MAP = Read-Host -Prompt (Write-Host "Input Server Map and Mode,Press enter to accept default value [c1m1_hotel]: "-ForegroundColor Cyan -NoNewline)) -eq '') { $global:MAP = "c1m1_hotel" }else { $global:MAP }
        Write-Host 'Input maxplayers[1-8]: ' -ForegroundColor Cyan -NoNewline
        $global:MAXPLAYERS = Read-host 
        Write-Host 'Input hostname: ' -ForegroundColor Cyan -NoNewline 
        $global:HOSTNAME = Read-host
        if (($global:RCONPASSWORD = Read-Host -Prompt (Write-Host "Input Server Rcon Password,Press enter to accept default value [$global:RANDOMPASSWORD]: " -ForegroundColor Cyan -NoNewline)) -eq '') { $global:RCONPASSWORD = "$global:RANDOMPASSWORD" }else { $global:RCONPASSWORD }
        $global:RCONPORT = "$global:PORT"
    }
    ElseIf ( $global:Version -eq "2" ) {
        # Version 2.0
        #  First Run Vars \/ \/ Add Here
        ${global:IP} = ""
        $global:PORT = ""
        $global:CLIENTPORT = ""
        $global:MAP = ""
        $global:MAXPLAYERS = ""
        $global:HOSTNAME = ""
        $global:RCONPASSWORD = ""
        $global:RCONPORT = "$global:PORT"
    }
    ElseIf ( $global:Version -eq "0" ) {
        #     Get-UserInput 1 1 0
    }  
    #if(($global:workshop = Read-Host -Prompt (Write-Host "Input 1 to enable workshop, Press enter to accept default value [0]: "-ForegroundColor Cyan -NoNewline)) -eq ''){$global:workshop="0"}else{$global:workshop}
    #if(($global:sv_pure = Read-Host -Prompt (Write-Host "Input addtional launch params ie. +sv_pure 0, Press enter to accept default value []: "-ForegroundColor Cyan -NoNewline)) -eq ''){}else{$global:sv_pure}
    Select-EditSourceCFG
    $global:launchParams = '@("$global:EXE -console -game left4dead2 -strictportbind -ip ${global:IP} -port ${global:PORT} +clientport ${global:CLIENTPORT} +hostip ${global:EXTIP} +maxplayers ${global:MAXPLAYERS} +map `"${global:MAP}`" -condebug ")'
    Get-SourceMetMod
}
