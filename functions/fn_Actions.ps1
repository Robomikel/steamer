# Version 2.0
# .::::::.::::::::::::.,::::::   :::.     .        :  .,:::::: :::::::..   
# ;;;`    `;;;;;;;;'''';;;;''''   ;;`;;    ;;,.    ;;; ;;;;'''' ;;;;``;;;;  
# '[==/[[[[,    [[      [[cccc   ,[[ '[[,  [[[[, ,[[[[, [[cccc   [[[,/[[['  
#   '''    $    $$      $$""""  c$$$cc$$$c $$$$$$$$"$$$ $$""""   $$$$$$c    
#  88b    dP    88,     888oo,__ 888   888,888 Y88" 888o888oo,__ 888b "88bo,
#   "YMmMY"     MMM     """"YUMMMYMM   ""` MMM  M'  "MMM""""YUMMMMMMM   "W" 
#----------      Install server    ----------------------
Function Set-SteamInfo {
    $title = 'Install Steam server with Anonymous login'
    $question = 'Use Anonymous Login?'
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    If ($decision -eq 1) {
        $global:ANON = "yes"
        Install-Anonserver
        Write-Host 'Entered Y'
    }
    Else {
        $global:ANON = "no"
        Install-Anonserver
        Write-Host 'Entered N'
    }
}
Function Install-Anonserver {
    If ($global:ANON -eq "no") {
        Write-Host "Enter Username for Steam install, Steam.exe will prompt for Password and Steam Gaurd" -ForegroundColor Cyan -BackgroundColor Black  
        $global:username = Read-host
    }
    Write-Host '****    Creating SteamCMD Run txt   *****' -ForegroundColor Magenta -BackgroundColor Black 
    New-Item $global:currentdir\SteamCMD\Updates-$global:server.txt -Force
    Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "@ShutdownOnFailedCommand 1"
    if ($global:ANON -ne "no") {
        Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "@NoPromptForPassword 1"  
    }
 
    If ($global:ANON -eq "no") { 
        Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "login $global:username" 
    }
    Else {
        Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "login anonymous"
    }
    Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "force_install_dir $global:currentdir\$global:server"
    Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "app_update $global:APPID $global:Branch"
    Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "Exit"
    New-Item -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Force
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "@ShutdownOnFailedCommand 1"
    If ($global:ANON -ne "no") { 
        Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "@NoPromptForPassword 1"
    }
    If ($global:ANON -eq "no") { 
        Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "login $global:username" 
    }
    Else {
        Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "login anonymous"
    }
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "force_install_dir $global:currentdir\$global:server"
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "app_update $global:APPID $global:Branch validate"
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "Exit"
    New-Item -Path $global:currentdir\SteamCMD\Buildcheck-$global:server.txt -Force
    Add-Content -Path $global:currentdir\SteamCMD\Buildcheck-$global:server.txt -Value "app_info_update 1"
    Add-Content -Path $global:currentdir\SteamCMD\Buildcheck-$global:server.txt -Value "app_info_print $global:APPID"
    Add-Content -Path $global:currentdir\SteamCMD\Buildcheck-$global:server.txt -Value "quit"
    Get-UpdateServer
    
}
Function Get-CreatedVaribles {
    Write-Host "****   Getting Server Variables   *****" -ForegroundColor Yellow -BackgroundColor Black  
    .$global:currentdir\$global:server\Variables-$global:server.ps1
    Get-CheckForError
}
Function Get-ClearVariables {
    Write-Host "****   Clearing Variables   *****" -ForegroundColor Yellow -BackgroundColor Black
    $global:vars = "PROCESS", "IP", "PORT", "SOURCETVPORT", "CLIENTPORT", "MAP", "TICKRATE", "GSLT", "MAXPLAYERS", "WORKSHOP", "HOSTNAME", "QUERYPORT", "SAVES", "APPID", "RCONPORT", "RCONPASSWORD", "SV_PURE", "SCENARIO", "GAMETYPE", "GAMEMODE", "MAPGROUP", "WSCOLLECTIONID", "WSSTARTMAP", "WSAPIKEY", "WEBHOOK", "EXEDIR", "GAME", "SERVERCFGDIR", "gamedirname", "config1", "config2", "config3", "config4", "config5", "MODDIR", "status", "CpuCores", "cpu", "avmem", "totalmem", "mem", "backups", "backupssize", "stats", "gameresponse", "os", "results,", "disks", "computername", "ANON", "ALERT", "launchParams","COOPPLAYERS"
    Foreach ($global:vars in $global:vars) {
        Clear-Variable $global:vars -Scope Global -ErrorAction SilentlyContinue
        Remove-Variable $global:vars -Scope Global -ErrorAction SilentlyContinue
    }
}
Function Get-CheckServer {
    Write-Host '****   Check  Server process    *****' -ForegroundColor Yellow -BackgroundColor Black 
    If ($Null -eq (Get-Process "$global:PROCESS" -ea SilentlyContinue)) {
        Write-Host "----   NOT RUNNING   ----" -ForegroundColor Red -BackgroundColor Black
    }
    Else { Write-Host "****   RUNNING   ****" -ForegroundColor Green -BackgroundColor Black ; ; Get-Process "$global:PROCESS" ; ; Get-ClearVariables ; ; Exit }
    Get-CheckForError
}
Function Get-StopServer {
    Write-Host '****   Stopping Server process   *****' -ForegroundColor Magenta -BackgroundColor Black 
    If ($Null -eq (Get-Process "$global:PROCESS" -ea SilentlyContinue)) {
        Write-Host "----   NOT RUNNING   ----" -ForegroundColor Red -BackgroundColor Black
    }
    Else { Stop-Process -Name "$global:PROCESS" -Force }
    Get-CheckForError
}
Function Get-StopServerInstall {
    Write-Host '****   Checking for Server process before install   ****' -ForegroundColor Yellow -BackgroundColor Black 
    If ($Null -eq (Get-Process "$global:PROCESS" -ea SilentlyContinue)) {
        Write-Host "****   No Process found   ****" -ForegroundColor Yellow -BackgroundColor Black
    }
    Else {
        Write-Host "****   Stopping Server Process   *****" -ForegroundColor Magenta -BackgroundColor Black
        Stop-Process -Name "$global:PROCESS" -Force
    }
}
Function Get-RestartsServer {
    Clear-Host
    Start-Countdown -Seconds 10 -Message "Restarting server"
    Get-Logo
    Select-StartServer
    Get-CheckForError
}
Function Start-Countdown {
    Param(
        [Int32]$Seconds = 10,
        [string]$Message = "Restarting server in 10 seconds...")
    Foreach ($Count in (1..$Seconds)) {
        Write-Progress -Id 1 -Activity $Message -Status "Waiting for $Seconds seconds, $($Seconds - $Count) left" -PercentComplete (($Count / $Seconds) * 100)
        Start-Sleep -Seconds 1
    }
    Write-Progress -Id 1 -Activity $Message -Status "Completed" -PercentComplete 100 -Completed
}
Function Get-Finished {
    Get-ClearVariables
    Write-Host "*************************************" -ForegroundColor Yellow
    Write-Host "***  Server $global:command is done!  $global:CHECKMARK ****" -ForegroundColor Yellow
    Write-Host "*************************************" -ForegroundColor Yellow
    Write-Host "  ./steamer start $global:server  "-ForegroundColor Black -BackgroundColor White
}
Function Get-TestInterger {
    If ( $global:APPID -notmatch '^[0-9]+$') { 
        Write-Host "$global:DIAMOND $global:DIAMOND Input App ID Valid Numbers only! $global:DIAMOND $global:DIAMOND" -ForegroundColor Red -BackgroundColor Black
        pause
        Exit
    }
}
Function Get-TestString {
    If ( $global:server -notmatch "[a-z,A-Z]") { 
        Write-Host "$global:DIAMOND $global:DIAMOND Input Alpha Characters only! $global:DIAMOND $global:DIAMOND" -ForegroundColor Red -BackgroundColor Black
        pause
        Exit
    }
}
Function Get-FolderNames {
    Write-Host "****   Checking Folder Names   ****" -ForegroundColor Yellow -BackgroundColor Black
    If (Test-Path "$global:currentdir\$global:server\") {
    }
    Else {
        New-ServerFolderq
    }
}
Function Get-ValidateServer {
    Set-Location $global:currentdir\SteamCMD\ >$null 2>&1
    Get-Steamtxt
    Write-Host '****   Validating Server   ****' -ForegroundColor Magenta -BackgroundColor Black
    .\steamcmd +runscript Validate-$global:server.txt
    If ( !$? ) {
        Write-Host "****   Validating Server Failed   ****" -ForegroundColor Red
        New-TryagainNew   
    }
    ElseIf ($?) {
        Write-Host "****   Validating Server succeeded   ****" -ForegroundColor Yellow
    }
    Set-Location $global:currentdir
}
Function Get-UpdateServer {
    Set-Location $global:currentdir\SteamCMD\ >$null 2>&1
    Get-Steamtxt
    Write-Host '****   Updating Server   ****' -ForegroundColor Magenta -BackgroundColor Black
    .\steamcmd +runscript Updates-$global:server.txt
    If (($?) -or ($LASTEXITCODE -eq 7)) {
        Write-Host "****   Downloading  Install/update server succeeded   ****" -ForegroundColor Yellow
        If ($global:command -ne "install") { 
            If ($global:DisableDiscordUpdate -eq "1"){
            New-DiscordAlert 
            }
        }
    }
    ElseIf (!$?) {
        Write-Host "****   Downloading  Install/update server Failed   ****" -ForegroundColor Red
        New-TryagainNew 
    }
    Set-Location $global:currentdir
}
Function Get-Steam {
    $start_time = Get-Date
    $path = "$global:currentdir\steamcmd\"
    $patha = "$global:currentdir\steamcmd\steamcmd.exe" 
    If ((Test-Path $path) -and (Test-Path $patha)) { 
        Write-Host '****   steamCMD already downloaded!   ****' -ForegroundColor Yellow -BackgroundColor Black
    } 
    Else {  
        #(New-Object Net.WebClient).DownloadFile("$global:steamurl", "steamcmd.zip")
        Write-Host '****   Downloading SteamCMD   ****' -ForegroundColor Magenta -BackgroundColor Black
        #[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;  
        Invoke-WebRequest -Uri $global:steamurl -OutFile $global:steamoutput
        If (!$?) {
            Write-Host " ****   Downloading  SteamCMD Failed   ****" -ForegroundColor Red -BackgroundColor Black 
            New-TryagainNew 
        }
        If ($?) { Write-Host " ****   Downloading  SteamCMD succeeded    ****" -ForegroundColor Yellow -BackgroundColor Black }
        Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
        Write-Host '***   Extracting SteamCMD *****' -ForegroundColor Magenta -BackgroundColor Black 
        Expand-Archive "$global:currentdir\steamcmd.zip" "$global:currentdir\steamcmd\" -Force 
        If (!$?) {
            Write-Host " ****   Extracting SteamCMD Failed    ****" -ForegroundColor Yellow -BackgroundColor Black 
            New-TryagainNew 
        }
        If ($?) { Write-Host " ****   Extracting SteamCMD succeeded    ****" -ForegroundColor Yellow -BackgroundColor Black }
    }

}
Function New-TryagainNew {
    $title = 'Try again?'
    $question = "$global:command $global:server?"
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
    If ($decision -eq 0) {
        Write-Host 'Entered Y'
        Select-Steamer $global:command $global:server
    }
    Else {
        Write-Host 'Entered N'
        Exit
    }
}
Function Get-ServerBuildCheck {
    Get-Steam
    Get-Steamtxt
    Set-Location $global:currentdir\SteamCMD\ >$null 2>&1
    $search = "buildid"
    # public 
    $remotebuild = .\steamcmd +runscript Buildcheck-$global:server.txt | select-string $search | Select-Object  -Index 0
    #    # dev
    #    $remotebuild= .\steamcmd +runscript Buildcheck-$global:server.txt  | select-string $search | Select-Object  -Index 1
    #    # experimental
    #    $remotebuild= .\steamcmd +runscript Buildcheck-$global:server.txt  | select-string $search | Select-Object  -Index 2
    #    # hosting
    #    $remotebuild= .\steamcmd +runscript Buildcheck-$global:server.txt  | select-string $search | Select-Object  -Index 3
    $remotebuild = $remotebuild -replace '\s', ''
    #    #$remotebuild
    #  $search="buildid"
    $localbuild = get-content $global:currentdir\$global:server\steamapps\appmanIfest_$global:APPID.acf | select-string $search
    $localbuild = $localbuild -replace '\s', ''
    #$localbuild
    If (Compare-Object $remotebuild.ToString() $localbuild.ToString()) {
        Write-Host "****   Avaiable Updates Server   ****" -ForegroundColor Yellow -BackgroundColor Black
        If ($global:AutoUpdate -eq "1") { Exit }
        Write-Host "****   Removing appmanifest_$global:APPID.acf   ****" -ForegroundColor Magenta -BackgroundColor Black
        Remove-Item $global:currentdir\$global:server\steamapps\appmanifest_$global:APPID.acf -Force  >$null 2>&1
        Write-Host "****   Removing Multiple appmanifest_$global:APPID.acf    ****" -ForegroundColor Magenta -BackgroundColor Black
        Remove-Item $global:currentdir\$global:server\steamapps\appmanifest_*.acf -Force  >$null 2>&1
        Get-StopServer
        Get-UpdateServer  
    }
    Else {
        Write-Host "****   No $global:server Updates found   ****" -ForegroundColor Yellow -BackgroundColor Black
    }
    Set-Location $global:currentdir
}
Function Get-Steamtxt {
    Write-Host "****   Check $global:server Steam runscripts txt   ****" -ForegroundColor Yellow -BackgroundColor Black
    $patha = "$global:currentdir\steamcmd\Validate-$global:server.txt"
    $pathb = "$global:currentdir\steamcmd\Updates-$global:server.txt"
    $pathc = "$global:currentdir\steamcmd\Buildcheck-$global:server.txt" 
    If ((Test-Path $patha) -and (Test-Path $pathb) -and (Test-Path $pathc)) {
        Write-Host '****   steamCMD Runscripts .txt Exist   ***' -ForegroundColor Yellow -BackgroundColor Black
    } 
    Else {  
        Write-Host "----------------------------------------------------------------------------" -ForegroundColor Yellow -BackgroundColor Black
        Write-Host "      $global:DIAMOND $global:DIAMOND Command $global:command Failed! $global:DIAMOND $global:DIAMOND" -ForegroundColor Red -BackgroundColor Black
        Write-Host "***        Try install command again          ****  " -ForegroundColor Yellow -BackgroundColor Black
        Write-Host "----------------------------------------------------------------------------" -ForegroundColor Yellow -BackgroundColor Black
        Exit
    }
}
Function Set-SteamInfoAppID {
    $title = 'Launch Script create'
    $question = 'Create Launch Script?'
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
    If ($decision -eq 0) {
        Set-VariablesPS
        Read-AppID
        Write-Host 'Entered Y'
    }
    Else {
        Write-Host 'Entered N'
    }
}
Function Get-GamedigServerv2 {
    Write-Host '****   Starting gamedig on Server   ****' -ForegroundColor Magenta -BackgroundColor Black
    If (( $global:AppID -eq 581330) -or ($global:AppID -eq 376030) -or ($global:AppID -eq 443030)) {
        Write-Host '****   Using QUERYPORT    ****' -ForegroundColor Yellow -BackgroundColor Black
        If (($null -eq ${global:QUERYPORT} ) -or ("" -eq ${global:QUERYPORT} )) {
            Write-Host '****   Missing QUERYPORT Var!   ****' -ForegroundColor Red -BackgroundColor Black
        }
        ElseIf ($global:command -eq "gamedig") {
            Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64
            .\gamedig --type $global:GAME ${global:EXTIP}:${global:QUERYPORT} --pretty
            Set-Location $global:currentdir
        }
        ElseIf ($global:Useprivate -eq "1") {
            Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64  
            .\gamedig --type $global:GAME ${global:IP}:${global:QUERYPORT} --pretty
            Set-Location $global:currentdir
        }
    }
    ElseIf (($null -eq ${global:PORT}) -or ("" -eq ${global:PORT} )) {
        Write-Host '****   Missing PORT Var!   ****' -ForegroundColor Red -BackgroundColor Black
    }
    ElseIf ($global:Useprivate -eq "1") {
        Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64  
        .\gamedig --type $global:GAME ${global:IP}:${global:PORT} --pretty
        Set-Location $global:currentdir
    }
    Else {
        Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64
        .\gamedig --type $global:GAME ${global:EXTIP}:${global:PORT} --pretty
        Set-Location $global:currentdir
    }
     
}
Function Get-Details {
    $global:Cpu = (Get-WMIObject win32_processor | Measure-Object -property LoadPercentage -Average | Select-Object Average ).Average
    $host.UI.RawUI.ForegroundColor = "Cyan"
    #$host.UI.RawUI.BackgroundColor = "Black"
    $global:CpuCores = (Get-WMIObject Win32_ComputerSystem).NumberOfLogicalProcessors
    $global:avmem = (Get-WMIObject Win32_OperatingSystem | Foreach-Object { "{0:N2} GB" -f ($_.totalvisiblememorysize / 1MB) })
    $global:totalmem = "{0:N2} GB" -f ((Get-Process | Measure-Object Workingset -sum).Sum / 1GB)
    If ($Null -ne (Get-Process "$global:PROCESS" -ea SilentlyContinue)) {
        $global:mem = "{0:N2} GB" -f ((Get-Process $global:PROCESS | Measure-Object Workingset -sum).Sum / 1GB) 
    }
    $global:os = (Get-WMIObject win32_operatingsystem).caption
    $global:computername = (Get-WMIObject Win32_OperatingSystem).CSName
    Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64
    If ($null -ne ${global:QUERYPORT}) { 
        ${global:PORT} = ${global:QUERYPORT} 
    }
    If ($global:Useprivate -eq "0") {
        $global:gameresponse = (.\gamedig --type $global:GAME ${global:EXTIP}:${global:PORT} --pretty | Select-String -Pattern 'game' -CaseSensitive -SimpleMatch)
        $global:stats = (.\gamedig --type $global:GAME ${global:EXTIP}:${global:PORT} --pretty | Select-String -Pattern 'ping' -CaseSensitive -SimpleMatch)
    }
    Else {
        $global:gameresponse = (.\gamedig --type $global:GAME ${global:IP}:${global:PORT} --pretty | Select-String -Pattern 'game' -CaseSensitive -SimpleMatch)
        $global:stats = (.\gamedig --type $global:GAME ${global:IP}:${global:PORT} --pretty | Select-String -Pattern 'ping' -CaseSensitive -SimpleMatch)    
    }
    
    Get-CreatedVaribles
    New-BackupFolder
    $global:backups = (Get-Childitem -Path $global:currentdir\backups -recurse | Measure-Object) 
    $global:backups = $backups.count 
    $global:backupssize = "{0:N2} GB" -f ((Get-Childitem $global:currentdir\backups | Measure-Object Length -s -ea silentlycontinue ).Sum / 1GB) 
    If (($global:AppID -eq 302200)) { 
        $global:gameresponse = "Not supported" 
    }
    #Get-WMIObject -Class Win32_Product -Filter "Name LIKE '%Visual C++ 2010%'"
    Write-Host "                                "
    Write-Host "    Server Name       : $HOSTNAME"
    Write-Host "    Public IP         : $EXTIP"
    Write-Host "    IP                : $IP"
    Write-Host "    Port              : $PORT"
    Write-Host "    Query Port        : $QUERYPORT"
    Write-Host "    Rcon Port         : $RCONPORT"
    Write-Host "    App ID            : $APPID"
    Write-Host "    Game Dig          : $GAME"
    #    Write-Host "    Webhook           : $WEBHOOK"
    Write-Host "    Process           : $PROCESS"
    Write-Host "    Process status    : "-NoNewline; ; If ($Null -eq (Get-Process "$global:PROCESS" -ea SilentlyContinue)) { $global:status = " ----NOT RUNNING----"; ; Write-Host $status -F Red }Else { $global:status = " **** RUNNING ****"; ; Write-Host $status -F Green }
    Write-Host "    CPU Cores         : $CpuCores"
    Write-Host "    CPU %             : $cpu"
    Write-Host "    Total RAM         : $avmem    "
    Write-Host "    Total RAM Usage   : $totalmem"
    Write-Host "    Process RAM Usage : $mem"
    Write-Host "    Backups           : $backups"
    Write-Host "    Backups size GB   : $backupssize"
    Write-Host "    Status            : "-NoNewline; ; If ($Null -eq $global:stats) { $global:stats = "----Offline----"; ; Write-Host $stats -F Red }Else { $global:stats = "**** Online ***"; ; Write-Host $stats -F Green }
    Write-Host "    game replied      : $gameresponse"
    Write-Host "    OS                : $os"
    Write-Host "    hostname          : $computername"
    Set-Location $global:currentdir
}
Function Get-DriveSpace {
    $global:disks = Get-WMIObject -class "Win32_LogicalDisk" -namespace "root\CIMV2" -computername $env:COMPUTERNAME
    $global:results = Foreach ($disk in $disks) {
        If ($disk.Size -gt 0) {
            $size = [math]::round($disk.Size / 1GB, 0)
            $free = [math]::round($disk.FreeSpace / 1GB, 0)
            [PSCustomObject]@{
                Drive           = $disk.Name
                Name            = $disk.VolumeName
                "Total Disk GB" = $size
                "Free Disk GB"  = "{0:N0} ({1:P0})" -f $free, ($free / $size)
            }
        }
    }
    #$results | Out-GridView
    $global:results | Format-Table -AutoSize
    #$results | Export-Csv -Path .\disks.csv -NoTypeInformation -Encoding ASCII
}
Function New-ServerFolderq {
    $title = 'Server Folder Name does not exist!'
    $question = 'Would you like to to create new Server Folder Name?'
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
    If ($decision -eq 0) {
        Write-Host 'Entered Y'
        $global:command = "install"
        Select-Steamer $global:command $global:server
    }
    Else {
        Write-Host 'Entered N'
        Exit
    }
}
Function New-ServerFolder {   
    ##-- Create Folder for Server -- In current folder
    If ((!$global:server) -or ($global:server -eq " ")) {
        Write-Host "****   You Entered a null or Empty   ****" -ForegroundColor Red -BackgroundColor Black
        Select-Steamer
    }
    ElseIf (($null -eq $global:APPID ) -or ($global:APPID -eq " ")) {
        Write-Host "****   You Entered a space or Empty   ****" -ForegroundColor Red -BackgroundColor Black
        Select-Steamer
    }
    ElseIf (Test-Path "$global:currentdir\$global:server\" ) {
        Write-Host '****   Server Folder Already Created!   ****' -ForegroundColor Yellow -BackgroundColor Black
    }
    Else {
        Write-Host '****   Creating Server Folder   ****' -ForegroundColor Magenta -BackgroundColor Black 
        New-Item -Path . -Name "$global:server" -ItemType "directory"
    }
}
Function Get-CheckForVars {
    Write-Host "****   Checking for Vars   ****" -ForegroundColor Yellow -BackgroundColor Black
    If ($global:command -eq "mcrcon") {
        $global:missingvars = $global:RCONPORT, $global:RCONPASSWORD
    }
    Else {
        $global:missingvars = ${global:QUERYPORT}, ${global:IP}, $global:APPID, $global:PROCESS
    }
    Foreach ($global:missingvars in $global:missingvars) {
        If ( "" -eq $global:missingvars) {
            Write-Host "----------------------------------------------------------------------------" -ForegroundColor Yellow -BackgroundColor Black
            Write-Host "$global:DIAMOND $global:DIAMOND Missing Vars ! $global:DIAMOND $global:DIAMOND" -ForegroundColor Red -BackgroundColor Black
            Write-Host "Try install command again or check vars in Variables-$global:server.ps1" -ForegroundColor Yellow -BackgroundColor Black
            Write-Host "----------------------------------------------------------------------------" -ForegroundColor Yellow -BackgroundColor Black
            Exit
        }
    }
}
Function Get-CheckForError {
    If (!$?) {
        Write-Host "----------------------------------------------------------------------------" -ForegroundColor Yellow -BackgroundColor Black
        Write-Host "      $global:DIAMOND $global:DIAMOND Command $global:command Failed! $global:DIAMOND $global:DIAMOND" -ForegroundColor Red -BackgroundColor Black
        Write-Host "***        Try install command again          ****  " -ForegroundColor Yellow -BackgroundColor Black
        Write-Host "----------------------------------------------------------------------------" -ForegroundColor Yellow -BackgroundColor Black
        Exit
    }
}

Function Set-ConnectMCRcon {
    If ($global:Useprivate -eq "0") {
        set-location $global:currentdir\mcrcon\mcrcon-0.7.1-windows-x86-32
        .\mcrcon.exe -t -H $global:EXTIP -P $global:RCONPORT -p $global:RCONPASSWORD
        set-location $global:currentdir
    }
    Else {
        set-location $global:currentdir\mcrcon\mcrcon-0.7.1-windows-x86-32
        .\mcrcon.exe -t -H $global:IP -P $global:RCONPORT -p $global:RCONPASSWORD
        set-location $global:currentdir
    }
}
Function Get-MCRcon {
    $start_time = Get-Date
    $path = "$global:currentdir\mcrcon\"
    $patha = "$global:currentdir\mcrcon\mcrcon-0.7.1-windows-x86-32\mcrcon.exe" 
    If ((Test-Path $path) -and (Test-Path $patha)) { 
        Write-Host '****   mcrcon already downloaded!   ****' -ForegroundColor Yellow -BackgroundColor Black
    } 
    Else {  
        $start_time = Get-Date
        Write-Host '****   Downloading MCRCon from github   ****' -ForegroundColor Magenta -BackgroundColor Black 
        #(New-Object Net.WebClient).DownloadFile("$global:metamodurl", "$global:currentdir\metamod.zip")
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
        Invoke-WebRequest -Uri $global:mcrconurl -OutFile $global:currentdir\mcrcon.zip
        If (!$?) {
            Write-Host "****   Downloading  MCRCon Failed   ****" -ForegroundColor Red -BackgroundColor Black 
            New-TryagainNew 
        }
        If ($?) { 
            Write-Host "****   Downloading  MCRCon succeeded   ****" -ForegroundColor Yellow -BackgroundColor Black 
        }
        Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
        Write-Host '****   Extracting MCRCon from github   ****' -ForegroundColor Magenta -BackgroundColor Black
        Expand-Archive "$global:currentdir\mcrcon.zip" "$global:currentdir\mcrcon\" -Force
        If (!$?) {
            Write-Host "****   Extracting MCRCon Failed   ****" -ForegroundColor Yellow -BackgroundColor Black 
            New-TryagainNew 
        }
        If ($?) { 
            Write-Host "****   Extracting MCRCon succeeded   ****" -ForegroundColor Yellow -BackgroundColor Black 
        }
    }
}

Function New-DiscordAlert {
    If ( "" -eq $global:WEBHOOK) {
        Write-Host "$global:DIAMOND $global:DIAMOND Missing WEBHOOK ! $global:DIAMOND $global:DIAMOND"-ForegroundColor Red -BackgroundColor Black
        Write-Host "****   Add Discord  WEBHOOK to $global:currentdir\$global:server\Variables-$global:server.ps1   ****" -ForegroundColor Yellow -BackgroundColor Black    
    }
    Else {
        If ($global:command -eq "Backup") {
            # BACKUP
            $global:ALERT = ' Server Backed UP'
            # GREEN
            $global:ALERTCOLOR = '3334680'
        }
        ElseIf ($global:command -eq "update") {
            # UDPATE
            $global:ALERT = ' Server Updated '
            # BLUE
            $global:ALERTCOLOR = '385734'
        }
        Else {
            # RESTART
            $global:ALERT = " Server not Running, Starting Server "
            # RED
            $global:ALERTCOLOR = '16711680'
        }
        Write-Host '****   Sending Discord Alert   ****' -ForegroundColor Magenta -BackgroundColor Black
        $webHookUrl = "$global:WEBHOOK"
        [System.Collections.ArrayList]$embedArray = @()
        $title = "$global:HOSTNAME"
        $description = "$global:ALERT"
        $color = "$global:ALERTCOLOR"
        $embedObject = [PSCustomObject]@{
            title       = $title       
            description = $description  
            color       = $color
        }                              
        $embedArray.Add($embedObject) | Out-Null
        $payload = [PSCustomObject]@{
            embeds = $embedArray
        }                              
        Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json -Depth 4) -Method Post -ContentType 'application/json'
    }
}
Function Set-Console {
    Clear-Host
    $host.ui.RawUi.WindowTitle = "-------- STEAMER ------------"
    [console]::ForegroundColor = "Green"
    [console]::BackgroundColor = "Black"
    [console]::WindowWidth = 150; [console]::WindowHeight = 125; [console]::BufferWidth = [console]::WindowWidth
    #$host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size(200,5000)
    If ($global:admincheckmessage -eq "1") {
        Get-AdminCheck
        Get-Logo
    }
    Else {
        Get-Logo
    }
}
Function Get-Logo {
    Write-Host " 
    _________  __                                           
   /   _____/_/  |_   ____  _____     _____    ____ _______ 
   \_____  \ \   __\_/ __ \ \__  \   /     \ _/ __ \\_  __ \
   /        \ |  |  \  ___/  / __ \_|  Y Y  \\  ___/ |  | \/
  /_______  / |__|   \___  >(____  /|__|_|  / \___  >|__|   
          \/             \/      \/       \/      \/        
"
}
Function Get-AdminCheck {
    $user = "$env:COMPUTERNAME\$env:USERNAME"
    $group = 'Administrators'
    $isInGroup = (Get-LocalGroupMember $group).Name -contains $user
    If ($isInGroup -eq $true) {
        Write-Host "----------------------------------------------------------------------------" -ForegroundColor Yellow -BackgroundColor Black
        Write-Host "                 $global:DIAMOND $global:DIAMOND Do Not Run as an Admin account $global:DIAMOND $global:DIAMOND" -ForegroundColor Red -BackgroundColor Black
        Write-Host "***  Please Create a Non Admin Account to run script and game server  ******" -ForegroundColor Yellow -BackgroundColor Black
        Write-Host "----------------------------------------------------------------------------" -ForegroundColor Yellow -BackgroundColor Black
    }
}
Function Get-UpdateSteamer {
    $start_time = Get-Date
    Write-Host '****   Downloading Steamer github files   ****' -ForegroundColor Magenta -BackgroundColor Black 
    #(New-Object Net.WebClient).DownloadFile("$global:steamerurl", "$global:currentdir\steamer.zip")
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest -Uri $global:steamerurl -OutFile $global:currentdir\steamer.zip
    Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black 
    Remove-Item -Path "$global:currentdir\steamer\*" -Recurse -Force -ea SilentlyContinue
    Expand-Archive "$global:currentdir\steamer.zip" "$global:currentdir\steamer" -Force
    Copy-Item -Path "$global:currentdir\steamer\steamer-*\*" -Destination "$global:currentdir\" -Recurse -Force
    Write-Host '****   Steamer github files Updated   ****' -ForegroundColor Yellow -BackgroundColor Black
    Write-Host '****   Press Enter to Close this session   ****' -ForegroundColor Yellow -BackgroundColor Black
    Pause  
    Stop-Process -Id $PID
}
Function Get-NodeJS {
    $path = "$global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64"
    $patha = "$global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64\node.exe"
    $pathb = "node-v$global:nodeversion-win-x64.zip"
    Write-Host "****   Checking for Nodejs   ****" -ForegroundColor Magenta -BackgroundColor Black     
    If ((Test-Path $path) -and (Test-Path $pathb) -and (Test-Path $patha)) { 
        Write-Host '****   NodeJS already downloaded!   ****' -ForegroundColor Yellow -BackgroundColor Black
    }
    Else {
        Write-Host "****   NodeJS not found   ****" -ForegroundColor Yellow -BackgroundColor Black
        Add-NodeJS
    }
}
Function Add-NodeJS {
    $start_time = Get-Date
    Write-Host '****   Downloading  Nodejs   ****' -ForegroundColor Magenta -BackgroundColor Black  
    #(New-Object Net.WebClient).DownloadFile("$global:nodejsurl", "$global:currentdir\node-v$global:nodeversion-win-x64.zip")
    #[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest -Uri $global:nodejsurl -OutFile $global:currentdir\node-v$global:nodeversion-win-x64.zip
    If (!$?) {
        Write-Host "****   Downloading  Nodejs Failed    ****" -ForegroundColor Red -BackgroundColor Black 
        New-TryagainNew
    }
    If ($?) { 
        Write-Host "****   Downloading  Nodejs succeeded   ****" -ForegroundColor Yellow -BackgroundColor Black 
    }
    Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host '****   Extracting Nodejs   *****' -ForegroundColor Magenta -BackgroundColor Black
    Expand-Archive "$global:currentdir\node-v$global:nodeversion-win-x64.zip" "$global:currentdir\node-v$global:nodeversion-win-x64\" -Force
    If (!$?) {
        Write-Host "****   Extracting Nodejs Failed   ****" -ForegroundColor Yellow -BackgroundColor Black 
        New-TryagainNew
    }
    If ($?) { 
        Write-Host "****   Extracting Nodejs succeeded   ****" -ForegroundColor Yellow -BackgroundColor Black 
    }
    Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64
    Write-Host '****   Installing gamedig in Nodejs   ****' -ForegroundColor Magenta -BackgroundColor Black
    Write-Host '****   Do not stop or cancel! Will need to delete nodejs files and start over!   ****' -ForegroundColor Yellow -BackgroundColor Black  
    .\npm install gamedig
    .\npm install gamedig -g
    Set-Location $global:currentdir
}
Function Set-VariablesPS {
    Write-Host "***  Creating Variables and adding launch params  ***" -ForegroundColor Magenta -BackgroundColor Black
    New-Item $global:currentdir\$global:server\Variables-$global:server.ps1 -Force
}
Function New-CreateVariables {
    Write-Host '*** Creating Variables Script ****' -ForegroundColor Magenta -BackgroundColor Black 
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "# WEBHOOK HERE - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:WEBHOOK = `"$global:WEBHOOK`""
    If ($global:MODDIR) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Mod dir - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:MODDIR = `"$global:MODDIR`""
    }
    If ($global:EXE) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Exe - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:EXE = `"$global:EXE`""
    }
    If ($global:EXEDIR) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Exe dir - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:EXEDIR = `"$global:EXEDIR`""
    }
    If ($global:GAME) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Game name used by Gamedig - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:game = `"$global:GAME`""
    }
    If ($global:PROCESS) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  PROCESS name - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:PROCESS = `"$global:PROCESS`""
    }
    If (${global:IP}) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Server IP - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`${global:IP} = `"${global:IP}`""
    }
    If (${global:EXTIP}) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Server EXT IP - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`${global:EXTIP} = `"${global:EXTIP}`""
    }
    If (${global:PORT}) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Server PORT - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`${global:PORT} = `"${global:PORT}`""
    }
    If ($global:SOURCETVPORT) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Server Source TV Port - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:SOURCETVPORT = `"$global:SOURCETVPORT`""
    }
    If ($global:SV_LAN) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Server SV_LAN - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:SV_LAN = `"$global:SV_LAN`""
    }
    If ($global:CLIENTPORT) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  server client port- - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:CLIENTPORT = `"$global:CLIENTPORT`""
    }
    If ($global:MAP) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  default Map- - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:MAP = `"$global:MAP`""
    }
    If ($global:TICKRATE) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  server tick rate - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:TICKRATE = `"$global:TICKRATE`""
    } 
    If ($global:GSLT) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Gamer Server token - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:GSLT = `"$global:GSLT`""
    }
    If ($global:MAXPLAYERS) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Max Players  - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:MAXPLAYERS = `"$global:MAXPLAYERS`""
    }
    If ($global:WORKSHOP) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Workshop 1/0 HERE - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:WORKSHOP = `"$global:WORKSHOP`""
    }
    If ($global:HOSTNAME) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Server Name - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:HOSTNAME = `"$global:HOSTNAME`""
    }
    If (${global:QUERYPORT}) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  query port - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`${global:QUERYPORT} = `"${global:QUERYPORT}`""
    }
    If ($global:SAVES) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  local App Data SAVES folder - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:SAVES = `"$global:SAVES`""
    }
    If ($global:APPID) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  App ID  - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:APPID = `"$global:APPID`""
    }
    If ($global:RCONPORT) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Rcon Port  - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:RCONPORT = `"$global:RCONPORT`""
    }
    If ($global:RCONPASSWORD) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Rcon Password HERE - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:RCONPASSWORD = `"$global:RCONPASSWORD`""
    }
    If ($global:SV_PURE) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Extra Launch Parms - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:SV_PURE = `"$global:SV_PURE`""
    }
    If ($global:SCENARIO) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "# Sandstorm SCENARIO   - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:SCENARIO = `"$global:SCENARIO`""
    }
    If ($global:GAMETYPE) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "# CSGO Gametype   - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:GAMETYPE = `"$global:GAMETYPE`""
    }
    If ($global:GAMEMODE) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "# CSGO Gamemode   - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:GAMEMODE = `"$global:GAMEMODE`""
    }
    If ($global:MAPGROUP) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "# CSGO mapgroup   - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:MAPGROUP = `"$global:MAPGROUP`""
    }
    If ($global:AppID -eq 740) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "# CSGO WSCOLLECTIONID   - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:WSCOLLECTIONID = `"$global:WSCOLLECTIONID`""
    }
    If ($global:AppID -eq 740) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "# CSGO WSSTARTMAP  - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:WSSTARTMAP= `"$global:WSSTARTMAP`""
    }
    If ($global:AppID -eq 740) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "# CSGO WSAPIKEY   - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:WSAPIKEY = `"$global:WSAPIKEY`""
    }
    If ($global:launchParams) {
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Server Launch Params - - \/  \/  \/"
        Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:launchParams = $global:launchParams"
    }
}
Function Get-SourceMetMod {
    $title = 'Download MetaMod and SourceMod'
    $question = 'Download MetaMod, SourceMod and install?'
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
    If ($decision -eq 0) {
        Get-SourceMetaMod
        Write-Host 'Entered Y'
    } 
    Else {
        Write-Host 'Entered N'
    }
}
Function Get-SourceMetaMod {
    $start_time = Get-Date
    Write-Host '****   Downloading Meta Mod   ****' -ForegroundColor Magenta -BackgroundColor Black 
    #(New-Object Net.WebClient).DownloadFile("$global:metamodurl", "$global:currentdir\metamod.zip")
    #[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest -Uri $global:metamodurl -OutFile $global:currentdir\metamod.zip
    If (!$?) { 
        Write-Host "****   Downloading Meta Mod Failed !!   ****" -ForegroundColor Red -BackgroundColor Black ; ; Exit 
    } 
    Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host '****   Extracting Meta Mod   ****' -ForegroundColor Magenta -BackgroundColor Black
    Expand-Archive "$global:currentdir\metamod.zip" "$global:currentdir\metamod\" -Force
    If (!$?) { 
        Write-Host "****   Extracting Meta Mod Failed !!   ****" -ForegroundColor Red -BackgroundColor Black ; ; Exit 
    }
    Write-Host '****   Copying/installing Meta Mod   ****' -ForegroundColor Magenta -BackgroundColor Black 
    Copy-Item -Path $global:currentdir\metamod\* -Destination $global:currentdir\$global:server\$global:MODDIR -Force -Recurse
    If (!$?) { 
        Write-Host "****   Copying Meta Mod Failed !!   ****" -ForegroundColor Red -BackgroundColor Black ; ; Exit 
    }
    $start_time = Get-Date
    Write-Host '****   Downloading SourceMod   ****' -ForegroundColor Magenta -BackgroundColor Black
    #(New-Object Net.WebClient).DownloadFile("$global:sourcemodurl", "$global:currentdir\sourcemod.zip")
    #[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest -Uri $global:sourcemodurl -OutFile $global:currentdir\sourcemod.zip
    If (!$?) { 
        Write-Host "****   Downloading SourceMod Failed !!   ****" -ForegroundColor Red -BackgroundColor Black ; ; Exit 
    } 
    Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host '****   Extracting SourceMod   ****' -ForegroundColor Magenta -BackgroundColor Black 
    Expand-Archive "$global:currentdir\sourcemod.zip" "$global:currentdir\sourcemod\" -Force
    If (!$?) { 
        Write-Host "****   Extracting SourceMod Failed !!   ****" -ForegroundColor Red -BackgroundColor Black ; ; Exit 
    }
    Write-Host '****   Copying/installing SourceMod   ****' -ForegroundColor Magenta -BackgroundColor Black
    Copy-Item -Path $global:currentdir\sourcemod\* -Destination $global:currentdir\$global:server\$global:MODDIR -Force -Recurse
    If (!$?) { 
        Write-Host "****   Copying SourceMod Failed !!   ****" -ForegroundColor Red -BackgroundColor Black ; ; Exit 
    }
}
Function Get-OxideQ {
    $title = 'Download Oxide'
    $question = 'Download Oxide and install?'
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
    If ($decision -eq 0) {
        Get-Oxide
        Write-Host 'Entered Y'
    } 
    Else {
        Write-Host 'Entered N'
    }
}
Function Get-Oxide {
    $start_time = Get-Date
    Write-Host '****   Downloading Oxide   ****' -ForegroundColor Magenta -BackgroundColor Black
    #(New-Object Net.WebClient).DownloadFile("$global:oxiderustlatestlink", "$global:currentdir\oxide.zip")
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest -Uri $global:oxiderustlatestlink -OutFile $global:currentdir\oxide.zip
    If (!$?) { 
        Write-Host "****   Downloading Oxide Failed !!   ****" -ForegroundColor Red -BackgroundColor Black ; ; Exit 
    } 
    Write-Host "Download Time: $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host '****   Extracting Oxide    ****' -ForegroundColor Magenta -BackgroundColor Black
    Expand-Archive "$global:currentdir\oxide.zip" "$global:currentdir\oxide\" -Force
    If (!$?) { 
        Write-Host "****   Extracting Oxide Failed !!   ****" -ForegroundColor Red -BackgroundColor Black ; ; Exit 
    }

    Write-Host '****   Copying Oxide *****' -ForegroundColor Magenta -BackgroundColor Black
    Copy-Item -Path $global:currentdir\oxide\$global:MODDIR\* -Destination $global:currentdir\$global:server\$global:MODDIR\ -Force -Recurse
    If (!$?) { 
        Write-Host "****   Copying Oxide Failed !!   ****" -ForegroundColor Red -BackgroundColor Black ; ; Exit 
    }
}
Function New-RestartJob {
    Write-Host "Run Task only when user is logged on"
    Write-Host "Input AutoRestart Time. ie 3am: " -ForegroundColor Cyan -NoNewline
    $restartTime = Read-Host
    $Action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "$global:currentdir\steamer.ps1 restart $global:server" -WorkingDirectory "$global:currentdir"
    #$Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).Date -RepetitionInterval (New-TimeSpan -Hours $restartTime)
    $Trigger = New-ScheduledTaskTrigger -Daily -At $restartTime
    $Settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit '00:00:00'
    $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings
    Write-Host "Creating Task........" -ForegroundColor Magenta -BackgroundColor Black
    Register-ScheduledTask -TaskName "$global:server AutoRestart" -InputObject $Task
}
Function New-RestartJobBG {
    $UserName = "$env:COMPUTERNAME\$env:UserName"
    Write-Host "Run Task Whether user is logged on or not"
    Write-Host "Input AutoRestart Time. ie 3am: " -ForegroundColor Cyan -NoNewline
    $restartTime = Read-Host
    Write-Host "Username: $env:COMPUTERNAME\$env:UserName"
    $SecurePassword = $password = Read-Host "Password:" -AsSecureString
    $Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList $UserName, $SecurePassword
    $Password = $Credentials.GetNetworkCredential().Password  
    $Action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "$global:currentdir\steamer.ps1 restart $global:server" -WorkingDirectory "$global:currentdir"
    #$Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).Date -RepetitionInterval (New-TimeSpan -Minutes $restartTime)
    $Trigger = New-ScheduledTaskTrigger -Daily -At $restartTime
    $Settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit '00:00:00'
    $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings
    Write-Host "Creating Task........" -ForegroundColor Magenta -BackgroundColor Black
    Register-ScheduledTask -TaskName "$global:server AutoRestart" -InputObject $Task -User "$UserName" -Password "$Password"
}
Function New-MontiorJob {
    Write-Host "Run Task only when user is logged on"
    $Action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "`"If (!(Get-Process '$global:PROCESS')) {$global:currentdir\steamer.ps1 start $global:server ;; $global:currentdir\steamer.ps1 discord $global:server }`"" -WorkingDirectory "$global:currentdir"
    $Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).Date -RepetitionInterval (New-TimeSpan -Minutes 5) 
    $Settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit '00:00:00'
    $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings
    Write-Host "Creating Task........" -ForegroundColor Magenta -BackgroundColor Black
    Register-ScheduledTask -TaskName "$global:server monitor" -InputObject $Task
}
Function New-MontiorJobBG {  
    $UserName = "$env:COMPUTERNAME\$env:UserName"
    Write-Host "Run Task Whether user is logged on or not"
    Write-Host "Username: $env:COMPUTERNAME\$env:UserName"
    $SecurePassword = $password = Read-Host "Password:" -AsSecureString
    $Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList $UserName, $SecurePassword
    $Password = $Credentials.GetNetworkCredential().Password 
    $Action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "`"If (!(Get-Process '$global:PROCESS')) {$global:currentdir\steamer.ps1 start $global:server ;; $global:currentdir\steamer.ps1 discord $global:server }`"" -WorkingDirectory "$global:currentdir"
    $Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).Date -RepetitionInterval (New-TimeSpan -Minutes 5) 
    $Settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit '00:00:00'
    $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings
    Write-Host "Creating Task........" -ForegroundColor Magenta -BackgroundColor Black
    Register-ScheduledTask -TaskName "$global:server monitor" -InputObject $Task -User "$UserName" -Password "$Password"
}
Function Set-MonitorJob {
    $title = 'Create Monitor Task Job'
    $question = 'Run Task Whether user is logged on or not?'
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    If ($decision -eq 0) {
        Write-Host 'Entered Y'
        Get-ChecktaskUnreg
        New-MontiorJobBG
    }
    Else {
        Write-Host 'Entered N'
        Get-ChecktaskUnreg
        New-MontiorJob
    }
}
Function Set-RestartJob {
    $title = 'Create Restart Task Job'
    $question = 'Run Task Whether user is logged on or not?'
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    If ($decision -eq 0) {
        Write-Host 'Entered Y'
        Get-ChecktaskUnreg
        New-RestartJobBG
    }
    Else {
        Write-Host 'Entered N'
        Get-ChecktaskUnreg
        New-RestartJob
    }
} 
Function Get-ChecktaskUnreg {
    Get-ScheduledTask -TaskName "$global:server $global:command" >$null 2>&1
    If ($?) {
        Write-Host '****   Unregistering scheduled task   ****' -ForegroundColor Magenta -BackgroundColor Black
        Unregister-ScheduledTask -TaskName "$global:server $global:command" >$null 2>&1
    }
    If (!$?) {
        Write-Host "****   Scheduled Task does not exist   ****" -ForegroundColor Yellow -BackgroundColor Black
    }
}
Function Get-ChecktaskDisable {
    Get-ScheduledTask -TaskName "$global:server monitor" >$null 2>&1
    If ($?) {
        Write-Host '****   disabling scheduled task   ****' -ForegroundColor Magenta -BackgroundColor Black
        Disable-ScheduledTask -TaskName "$global:server monitor" >$null 2>&1
    }
    If (!$?) {
        Write-Host "****   Scheduled Task does not exist   ****" -ForegroundColor Yellow -BackgroundColor Black
    }
}
Function Get-ChecktaskEnable {
    Get-ScheduledTask -TaskName "$global:server monitor" >$null 2>&1
    If ($?) {
        Write-Host '****   Enabling scheduled task   ****' -ForegroundColor Magenta -BackgroundColor Black
        Enable-ScheduledTask -TaskName "$global:server monitor" >$null 2>&1
    }
    If (!$?) {
        Write-Host "****   Scheduled Task does not exist   ****" -ForegroundColor Yellow -BackgroundColor Black
    }
}
Function New-BackupFolder {
    $path = "$global:currentdir\backups" 
    If (Test-Path $path) { 
        Write-Host '****   Backup folder exists!   ****' -ForegroundColor Yellow -BackgroundColor Black
    } 
    Else {  
        Write-Host '****   Creating backup folder   ****' -ForegroundColor Magenta -BackgroundColor Black
        New-Item -Path "$global:currentdir\" -Name "backups" -ItemType "directory"
    }
}
Function New-BackupServer {
    Write-Host '****   Server Backup Started!   ****' -ForegroundColor Magenta -BackgroundColor Black
    Set-Location $global:currentdir\7za920\
    Get-Childitem $global:currentdir\backups\ -Recurse | where-object name -like Backup_$global:server-*.zip | Sort-Object CreationTime -desc | Select-Object -Skip $global:backupcount | Remove-Item -Force 
    #Get-Childitem $global:currentdir\backups\ -Recurse | where-object {-like Backup_$global:server-*.zip}| Sort-Object CreationTime -desc | Select-Object -Skip $global:backupcount | Remove-Item -Force
    #./7za a $global:currentdir\backups\Backup_$global:server-$BackupDate.zip $global:currentdir\$global:server\* -an > backup.log
    ./7za a $global:currentdir\backups\Backup_$global:server-$global:Date.zip $global:currentdir\$global:server\* > backup.log
    Write-Host '****   Server Backup is Done!   ****' -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "****   Checking Save location(appData)   ****" -ForegroundColor Yellow -BackgroundColor Black
    If ($global:appdatabackup -eq "1") { 
        Get-Savelocation 
    }
    If ($global:backuplog -eq "1") { 
        .\backup.log 
    }
    Set-Location $global:currentdir
}
Function Get-SevenZip {
    $path = "$global:currentdir\7za920\"
    $patha = "$global:currentdir\7za920\7za.exe"
    $pathb = "$global:currentdir\7za920.zip"
    Write-Host '****   Checking for 7ZIP   *****' -ForegroundColor Yellow -BackgroundColor Black   
    If ((Test-Path $path) -and (Test-Path $patha) -and (Test-Path $pathb)) { 
        Write-Host '****   7Zip already downloaded!   ****' -ForegroundColor Yellow -BackgroundColor Black
    }
    Else {
        Write-Host "****   7Zip not found!   ****" -ForegroundColor Yellow -BackgroundColor Black
        Add-Sevenzip
    }  
}
Function Add-Sevenzip {
    $start_time = Get-Date
    Write-Host '****   Downloading 7ZIP   ****' -ForegroundColor Magenta -BackgroundColor Black 
    #(New-Object Net.WebClient).DownloadFile("$global:sevenzip", "$global:currentdir\7za920.zip")
    #[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest -Uri $global:sevenzip -OutFile $global:currentdir\7za920.zip
    If (!$?) {
        Write-Host "****   7Zip Download Failed   *****" -ForegroundColor Yellow -BackgroundColor Black
        New-TryagainNew 
    }
    If ($?) {
        Write-Host "****   7Zip  Download succeeded   ****" -ForegroundColor Yellow -BackgroundColor Black
    }
    Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host '****   Extracting 7ZIP   *****' -ForegroundColor Magenta -BackgroundColor Black 
    Expand-Archive "$global:currentdir\7za920.zip" "$global:currentdir\7za920\" -Force
    If (!$?) {
        Write-Host "****   7Zip files did not Extract   ****" -ForegroundColor Yellow -BackgroundColor Black
        New-TryagainNew 
    }
    If ($?) {
        Write-Host "****   7Zip Extract succeeded   ****" -ForegroundColor Yellow -BackgroundColor Black
    }
}
Function New-backupAppdata {
    Write-Host '****   Server App Data Backup Started!   ****' -ForegroundColor Magenta -BackgroundColor Black
    Set-Location $global:currentdir\7za920\ 
    ./7za a $global:currentdir\backups\AppDataBackup_$global:server-$global:Date.zip $env:APPDATA\$global:saves\* > AppDatabackup.log
    Write-Host '****   Server App Data Backup is Done!   ****' -ForegroundColor Yellow -BackgroundColor Black
    If ($global:appdatabackuplog -eq "1") { 
        .\AppDatabackup.log 
    }
    Set-Location $global:currentdir
}
Function Get-Savelocation {
    If (("" -eq $global:saves) -or ($null -eq $global:saves )) {
        Write-Host "****   No saves located in App Data   ****" -ForegroundColor Yellow -BackgroundColor Black 
    }
    Else {
        New-AppDataSave
    }
}
Function New-AppDataSave {
    $title = 'Game has Saves located in AppData'
    $question = 'Backup Appdata for server?'
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
    If ($decision -eq 0) {
        Write-Host 'Entered Y'
        New-backupAppdata
    } 
    Else {
        Write-Host 'Entered N'
        Exit
    }
}
Function Get-Servercfg {
    Write-Host "****   Retrieve Default Config   ****" -ForegroundColor Yellow -BackgroundColor Black
    #(New-Object Net.WebClient).DownloadFile("$global:githuburl/${gamedirname}/${config1}", "$global:currentdir\$global:server\csgo\cfg\server.cfg")
    If (("" -eq $global:SERVERCFGDIR) -or ("" -eq $global:config1)) {
        Exit
    }
    ElseIf ($null -eq $global:config2) {
        $global:SERVERCFG = "$global:config1"
    }
    ElseIf ($null -eq $global:config3) {
        $global:SERVERCFG = "$global:config1", "$global:config2"
    }
    ElseIf ($null -eq $global:config4) {
        $global:SERVERCFG = "$global:config1", "$global:config2", "$global:config3"
    }
    ElseIf ($null -eq $global:config5) {
        $global:SERVERCFG = "$global:config1", "$global:config2", "$global:config3", "$global:config4"
    }
    Else { $global:SERVERCFG = "$global:config1", "$global:config2", "$global:config3", "$global:config4", "$global:config5" }
    Foreach ($global:SERVERCFG in $global:SERVERCFG) {
        Write-Host "****   Retrieve server config GSM   ****" -ForegroundColor Magenta -BackgroundColor Black
        $WebResponse = Invoke-WebRequest "$global:githuburl/$global:gamedirname/$global:SERVERCFG"
        If (!$?) { 
            Write-Host "****   Array Failed !! Did NOT Retrieve server config   ****" -ForegroundColor Red -BackgroundColor Black ; ; Exit 
        }
        New-Item $global:currentdir\$global:server\$global:SERVERCFGDIR\$global:SERVERCFG -Force
        Add-Content $global:currentdir\$global:server\$global:SERVERCFGDIR\$global:SERVERCFG $WebResponse
    }
}
Function Get-StartServer {
    param(
        # [string]
        [Parameter(Mandatory = $true, Position = 0)]
        # [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)] 
        $global:launchParams
    )
    Set-Location $global:currentdir\$global:server\
    #Start-Process -FilePath CMD -ArgumentList ("/c $global:launchParams") -NoNewWindow
    If  (( $global:APPID -eq 258550 ) -or ($global:APPID -eq 294420 ) -or ($global:APPID -eq 302550))  {
        Start-Process CMD "/c $global:launchParams"
    }
    Else {
        Start-Process CMD "/c $global:launchParams"  -NoNewWindow
    }
    Set-Location $global:currentdir
}
Function Select-StartServer {
    Write-Host '****   Starting Server   *****' -ForegroundColor Yellow -BackgroundColor Black  
    Get-StartServer $global:launchParams
    #& "$global:currentdir\$global:server\Launch-*.ps1"
    #Get-CheckForError
    #Set-Location $global:currentdir
}
Function Select-RenameSource {
    Write-Host "***  Renaming srcds.exe to $global:EXE to avoid conflict with local source Engine (srcds.exe) server  ***" -ForegroundColor Magenta -BackgroundColor Black
    Rename-Item -Path "$global:currentdir\$global:server\srcds.exe" -NewName "$global:currentdir\$global:server\$global:EXE.exe" >$null 2>&1
    Rename-Item -Path "$global:currentdir\$global:server\srcds_x64.exe" -NewName "$global:currentdir\$global:server\$global:EXE-x64.exe" >$null 2>&1
}
Function Select-EditSourceCFG {
    Write-Host "***  Editing Default server.cfg  ***" -ForegroundColor Magenta -BackgroundColor Black
    ((Get-Content -path $global:currentdir\$global:server\$global:SERVERCFGDIR\$global:config1 -Raw) -replace "\bSERVERNAME\b", "$global:HOSTNAME") | Set-Content -Path $global:currentdir\$global:server\$global:SERVERCFGDIR\$global:config1
    ((Get-Content -path $global:currentdir\$global:server\$global:SERVERCFGDIR\$global:config1 -Raw) -replace "\bADMINPASSWORD\b", "$global:RCONPASSWORD") | Set-Content -Path $global:currentdir\$global:server\$global:SERVERCFGDIR\$global:config1 -ErrorAction SilentlyContinue
}
Function Get-UserInput {
    Param([parameter(Position = 0)]$parm0,
        [parameter(Position = 1)]$parm1,
        [parameter(Position = 2)]$parm2,
        [parameter(Position = 3)]$parm3,
        [parameter(Position = 4)]$parm4,
        [parameter(Position = 5)]$parm5,
        [parameter(Position = 6)]$parm6,
        [parameter(Position = 7)]$parm7,
        [parameter(Position = 8)]$parm8,
        [parameter(Position = 9)]$parm9)
    If ($parm0 -eq 1) {
        Write-Host  "Enter IP" -F Cyan
        $global:IP = Read-Host
    }
    If ($parm1 -eq 1) {
        Write-Host "Enter PORT" -F Cyan
        $global:PORT = Read-Host 
    }
    If ($parm2 -eq 1) {
        Write-Host "Enter QUERYPORT" -F Cyan
        $global:QUERYPORT = Read-Host
    }
    If ($parm3 -eq 1) {
        Write-Host "Enter RCONPORT" -F Cyan
        $global:RCONPORT = Read-Host
    }
    If ($parm4 -eq 1) {
        Write-Host "Enter RCONPASSWORD" -F Cyan
        $global:RCONPASSWORD = Read-Host
    }
    If ($parm5 -eq 1) {
        Write-Host "Enter HOSTNAME" -F Cyan
        $global:HOSTNAME = Read-Host
    }
    If ($parm6 -eq 1) {
        Write-Host "Enter SERVERPASSWORD" -F Cyan
        $global:SERVERPASSWORD = Read-Host
    }
    If ($parm7 -eq 1) {
        Write-Host "Enter MAXPLAYERS" -F Cyan
        $global:MAXPLAYERS = Read-Host
    }

}
Function Read-AppID {
    If ($global:AppID -eq 302200) {
        Set-Console  >$null 2>&1
        New-LaunchScriptMiscreatedPS
    }
    ElseIf ($global:AppID -eq 294420) {
        Set-Console  >$null 2>&1
        New-LaunchScriptSdtdserverPS
    }
    ElseIf ($global:AppID -eq 237410) {
        Set-Console  >$null 2>&1
        New-LaunchScriptInsserverPS
    }
    ElseIf ($global:AppID -eq 581330) {
        Set-Console  >$null 2>&1
        New-LaunchScriptInssserverPS
    }
    ElseIf ($global:AppID -eq 233780) {
        Set-Console  >$null 2>&1
        New-LaunchScriptArma3serverPS
    }
    ElseIf ($global:AppID -eq 258550) {
        Set-Console  >$null 2>&1
        New-LaunchScriptRustPS
    }
    ElseIf ($global:AppID -eq 376030) {
        Set-Console  >$null 2>&1
        New-LaunchScriptArkPS
    }
    ElseIf ($global:AppID -eq 462310) {
        Set-Console  >$null 2>&1
        New-LaunchScriptdoiserverPS
    }
    ElseIf ($global:AppID -eq 740) {
        Set-Console  >$null 2>&1
        New-LaunchScriptcsgoserverPS
    }
    ElseIf ($global:AppID -eq 530870) {
        Set-Console  >$null 2>&1
        New-LaunchScriptempserverPS
    }
    ElseIf ($global:AppID -eq 443030) {
        Set-Console  >$null 2>&1
        New-LaunchScriptceserverPS
    }
    ElseIf ($global:AppID -eq 565060) {
        Set-Console  >$null 2>&1
        New-LaunchScriptavserverPS
    }
    ElseIf ($global:AppID -eq 232130) {
        Set-Console  >$null 2>&1
        New-LaunchScriptKF2serverPS
    }
    ElseIf ($global:AppID -eq 222860) {
        Set-Console  >$null 2>&1
        New-LaunchScriptLFD2serverPS
    }
    ElseIf ($global:AppID -eq 454070) {
        Set-Console  >$null 2>&1
        New-LaunchScriptboundElserverPS
    }
    ElseIf ($global:AppID -eq 556450) {
        Set-Console  >$null 2>&1
        New-LaunchScriptforestserverPS
    }
    ElseIf ($global:AppID -eq 17515) {
        Set-Console  >$null 2>&1
        New-LaunchScriptAoCserverPS
    }
    ElseIf ($global:AppID -eq 302550) {
        Set-Console  >$null 2>&1
        New-LaunchScriptacserverPS
    }
    ElseIf ($global:AppID -eq 635) {
        Set-Console  >$null 2>&1
        New-LaunchScriptasserverPS
    }
    Else {
        Write-Host "No Launch Script Found for this server" -ForegroundColor Yellow -BackgroundColor Black
        Exit
    }
}