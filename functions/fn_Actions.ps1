# Version 2.5
# .::::::.::::::::::::.,::::::   :::.     .        :  .,:::::: :::::::..   
# ;;;`    `;;;;;;;;'''';;;;''''   ;;`;;    ;;,.    ;;; ;;;;'''' ;;;;``;;;;  
# '[==/[[[[,    [[      [[cccc   ,[[ '[[,  [[[[, ,[[[[, [[cccc   [[[,/[[['  
#   '''    $    $$      $$""""  c$$$cc$$$c $$$$$$$$"$$$ $$""""   $$$$$$c    
#  88b    dP    88,     888oo,__ 888   888,888 Y88" 888o888oo,__ 888b "88bo,
#   "YMmMY"     MMM     """"YUMMMYMM   ""` MMM  M'  "MMM""""YUMMMMMMM   "W" 
#----------      Core Functions    ----------------------
Function Set-SteamInfo {
    $title = 'Install Steam server with Anonymous login'
    $question = 'Use Anonymous Login?'
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    If ($decision -eq 1) {
        $global:ANON = "yes"
        #Install-Anonserver
        Install-ServerFiles
        Write-Host 'Entered Y'
    }
    Else {
        $global:ANON = "no"
        #Install-Anonserver
        Install-ServerFiles
        Write-Host 'Entered N'
    }
}
Function Install-ServerFiles {

    Set-Location $global:currentdir\steamcmd\
    If ($global:ANON -eq "yes") {
        .\steamCMD +@ShutdownOnFailedCommand 1 +@NoPromptForPassword 1 +login anonymous +force_install_dir $global:currentdir\$global:server +app_update $global:APPID $global:Branch +Exit
    }
    Else {
        Write-Host "Enter Username for Steam install" -F Cyan -B Black
        $global:username = Read-host
        .\steamCMD +@ShutdownOnFailedCommand 1 +login $global:username +force_install_dir $global:currentdir\$global:server +app_update $global:APPID $global:Branch +Exit
    }
    If (($?) -or ($LASTEXITCODE -eq 7)) {
        Write-Host "****   Downloading  Install server succeeded   ****" -F Y
        If ($global:command -ne "install") { 
            If ($global:DisableDiscordUpdate -eq "1") {
                New-DiscordAlert 
            }
        }
    }
    ElseIf (!$?) {
        Write-Host "****   Downloading  Install server Failed   ****" -F R
        New-TryagainNew 
    }

    Set-Location $global:currentdir
}
Function Install-Anonserver {
    If ($global:ANON -eq "no") {
        Write-Host "Enter Username for Steam install" -F Cyan -B Black
        $global:username = Read-host
    }
    Write-Host '****    Creating SteamCMD Run txt   *****' -F M -B Black 
    New-Item $global:currentdir\SteamCMD\Updates-$global:server.txt -Force
    Add-Content  $global:currentdir\SteamCMD\Updates-$global:server.txt  "@ShutdownOnFailedCommand 1"
    if ($global:ANON -ne "no") {
        Add-Content  $global:currentdir\SteamCMD\Updates-$global:server.txt  "@NoPromptForPassword 1"  
    }
 
    If ($global:ANON -eq "no") { 
        Add-Content  $global:currentdir\SteamCMD\Updates-$global:server.txt  "login $global:username" 
    }
    Else {
        Add-Content  $global:currentdir\SteamCMD\Updates-$global:server.txt  "login anonymous"
    }
    Add-Content  $global:currentdir\SteamCMD\Updates-$global:server.txt  "force_install_dir $global:currentdir\$global:server"
    Add-Content  $global:currentdir\SteamCMD\Updates-$global:server.txt  "app_update $global:APPID $global:Branch"
    Add-Content  $global:currentdir\SteamCMD\Updates-$global:server.txt  "Exit"
    New-Item  $global:currentdir\SteamCMD\Validate-$global:server.txt -Force
    Add-Content  $global:currentdir\SteamCMD\Validate-$global:server.txt  "@ShutdownOnFailedCommand 1"
    If ($global:ANON -ne "no") { 
        Add-Content  $global:currentdir\SteamCMD\Validate-$global:server.txt  "@NoPromptForPassword 1"
    }
    If ($global:ANON -eq "no") { 
        Add-Content  $global:currentdir\SteamCMD\Validate-$global:server.txt  "login $global:username" 
    }
    Else {
        Add-Content  $global:currentdir\SteamCMD\Validate-$global:server.txt  "login anonymous"
    }
    Add-Content  $global:currentdir\SteamCMD\Validate-$global:server.txt  "force_install_dir $global:currentdir\$global:server"
    Add-Content  $global:currentdir\SteamCMD\Validate-$global:server.txt  "app_update $global:APPID $global:Branch validate"
    Add-Content  $global:currentdir\SteamCMD\Validate-$global:server.txt  "Exit"
    New-Item  $global:currentdir\SteamCMD\Buildcheck-$global:server.txt -Force
    Add-Content  $global:currentdir\SteamCMD\Buildcheck-$global:server.txt  "app_info_update 1"
    Add-Content  $global:currentdir\SteamCMD\Buildcheck-$global:server.txt  "app_info_print $global:APPID"
    Add-Content  $global:currentdir\SteamCMD\Buildcheck-$global:server.txt  "quit"
    Get-UpdateServer
    
}
Function Get-CreatedVaribles {
    Write-Host "****   Getting Server Variables   *****" -F Y -B Black  
    .$global:currentdir\$global:server\Variables-$global:server.ps1
    Get-CheckForError
}
Function Get-ClearVariables {
    Write-Host "****   Clearing Variables   *****" -F Y -B Black
    $global:vars = "PROCESS", "IP", "PORT", "SOURCETVPORT", "CLIENTPORT", "MAP", "TICKRATE", "GSLT", "MAXPLAYERS", "WORKSHOP", "HOSTNAME", "QUERYPORT", "SAVES", "APPID", "RCONPORT", "RCONPASSWORD", "SV_PURE", "SCENARIO", "GAMETYPE", "GAMEMODE", "MAPGROUP", "WSCOLLECTIONID", "WSSTARTMAP", "WSAPIKEY", "WEBHOOK", "EXEDIR", "GAME", "SERVERCFGDIR", "gamedirname", "config1", "config2", "config3", "config4", "config5", "MODDIR", "status", "CpuCores", "cpu", "avmem", "totalmem", "mem", "backups", "backupssize", "stats", "gameresponse", "os", "results,", "disks", "computername", "ANON", "ALERT", "launchParams", "COOPPLAYERS", "SV_LAN", "DIFF", "GALAXYNAME", "ADMINPASSWORD", "username", "LOGDIR"
    Foreach ($global:vars in $global:vars) {
        Clear-Variable $global:vars -Scope Global -ea SilentlyContinue
        Remove-Variable $global:vars -Scope Global -ea SilentlyContinue
    }
}
Function Get-CheckServer {
    Write-Host '****   Check  Server process    *****' -F Y -B Black 
    If ($Null -eq (Get-Process "$global:PROCESS" -ea SilentlyContinue)) {
        Write-Host "----   NOT RUNNING   ----" -F R -B Black
    }
    Else { Write-Host "****   RUNNING   ****" -F Green -B Black ; ; Get-Process "$global:PROCESS" ; ; Get-ClearVariables ; ; Exit }
    Get-CheckForError
}
Function Get-StopServer {
    Write-Host '****   Stopping Server process   *****' -F M -B Black 
    If ($Null -eq (Get-Process "$global:PROCESS" -ea SilentlyContinue)) {
        Write-Host "----   NOT RUNNING   ----" -F R -B Black
    }
    Else { Stop-Process -Name "$global:PROCESS" -Force }
    Get-CheckForError
}
Function Get-StopServerInstall {
    Write-Host '****   Checking for Server process before install   ****' -F Y -B Black 
    If ($Null -eq (Get-Process "$global:PROCESS" -ea SilentlyContinue)) {
        Write-Host "****   No Process found   ****" -F Y -B Black
    }
    Else {
        Write-Host "****   Stopping Server Process   *****" -F M -B Black
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
    Write-Host "*************************************" -F Y
    Write-Host "***  Server $global:command is done!  $global:CHECKMARK ****" -F Y
    Write-Host "*************************************" -F Y
    Write-Host "  ./steamer start $global:server  "-F Black -B White
}
Function Get-TestInterger {
    If ( $global:APPID -notmatch '^[0-9]+$') { 
        Write-Host "$global:DIAMOND $global:DIAMOND Input App ID Valid Numbers only! $global:DIAMOND $global:DIAMOND" -F R -B Black
        pause
        Exit
    }
}
Function Get-TestString {
    If ( $global:server -notmatch "[a-z,A-Z]") { 
        Write-Host "$global:DIAMOND $global:DIAMOND Input Alpha Characters only! $global:DIAMOND $global:DIAMOND" -F R -B Black
        pause
        Exit
    }
}
Function Get-FolderNames {
    Write-Host "****   Checking Folder Names   ****" -F Y -B Black
    If (Test-Path "$global:currentdir\$global:server\") {
    }
    Else {
        New-ServerFolderq
    }
}
Function Get-ValidateServer {
    Set-Location $global:currentdir\SteamCMD\ >$null 2>&1
    #Get-Steamtxt
    Write-Host '****   Validate May Overwrite some config files   ****' -F R -B Black
    Write-Host '****   Run Install command again to update variables-$global:server.ps1  ****' -F Y -B Black
    Write-Host -NoNewLine 'Press any key to continue...';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    
    Write-Host '****   Validating Server   ****' -F M -B Black
    #.\steamcmd +runscript Validate-$global:server.txt
    If ($global:ANON -eq "yes") {
        .\steamCMD +@ShutdownOnFailedCommand 1 +@NoPromptForPassword 1 +login anonymous +force_install_dir $global:currentdir\$global:server +app_update $global:APPID $global:Branch validate +Exit
    }
    Else {
        .\steamCMD +@ShutdownOnFailedCommand 1 +login $global:username +force_install_dir $global:currentdir\$global:server +app_update $global:APPID $global:Branch validate +Exit
    }
    If ( !$? ) {
        Write-Host "****   Validating Server Failed   ****" -F R
        New-TryagainNew   
    }
    ElseIf ($?) {
        Write-Host "****   Validating Server succeeded   ****" -F Y
    }
    Set-Location $global:currentdir
}
Function Get-UpdateServer {
    if ($global:DisableDiscordBackup -eq "1") {
        Set-Location $global:currentdir\SteamCMD\ >$null 2>&1
        #Get-Steamtxt
        Write-Host '****   Updating Server   ****' -F M -B Black
        #.\steamcmd +runscript Updates-$global:server.txt
        If ($global:ANON -eq "yes") {
            .\steamCMD +@ShutdownOnFailedCommand 1 +@NoPromptForPassword 1 +login anonymous +force_install_dir $global:currentdir\$global:server +app_update $global:APPID $global:Branch +Exit
        }
        Else {
            .\steamCMD +@ShutdownOnFailedCommand 1 +login $global:username +force_install_dir $global:currentdir\$global:server +app_update $global:APPID $global:Branch +Exit
        }
    }
    If (($?) -or ($LASTEXITCODE -eq 7)) {
        Write-Host "****   Downloading  Install/update server succeeded   ****" -F Y
        If ($global:command -ne "install") { 
            If ($global:DisableDiscordUpdate -eq "1") {
                New-DiscordAlert 
            }
        }
    }
    ElseIf (!$?) {
        Write-Host "****   Downloading  Install/update server Failed   ****" -F R
        New-TryagainNew 
    }
    Set-Location $global:currentdir
}
Function Get-Steam {
    $start_time = Get-Date
    $path = "$global:currentdir\steamcmd\"
    $patha = "$global:currentdir\steamcmd\steamcmd.exe" 
    If ((Test-Path $path) -and (Test-Path $patha)) { 
        Write-Host '****   steamCMD already downloaded!   ****' -F Y -B Black
    } 
    Else {  
        #(New-Object Net.WebClient).DownloadFile("$global:steamurl", "steamcmd.zip")
        Write-Host '****   Downloading SteamCMD   ****' -F M -B Black
        #[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;  
        Invoke-WebRequest -Uri $global:steamurl -OutFile $global:steamoutput
        If (!$?) {
            Write-Host " ****   Downloading  SteamCMD Failed   ****" -F R -B Black 
            New-TryagainNew 
        }
        If ($?) { Write-Host " ****   Downloading  SteamCMD succeeded    ****" -F Y -B Black }
        Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -F Y -B Black
        Write-Host '***   Extracting SteamCMD *****' -F M -B Black 
        Expand-Archive "$global:currentdir\steamcmd.zip" "$global:currentdir\steamcmd\" -Force 
        If (!$?) {
            Write-Host " ****   Extracting SteamCMD Failed    ****" -F Y -B Black 
            New-TryagainNew 
        }
        If ($?) { Write-Host " ****   Extracting SteamCMD succeeded    ****" -F Y -B Black }
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
    #Get-Steamtxt
    Set-Location $global:currentdir\SteamCMD\ >$null 2>&1
    $search = "buildid"
    # public 
    #$remotebuild = Get-ServerBuild | select-string $search | Select-Object  -Index 0
    $remotebuild = .\steamCMD +app_info_update 1 +app_info_print $global:APPID +quit | select-string $search | Select-Object  -Index 0

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
        Write-Host "****   Avaiable Updates Server   ****" -F Y -B Black
        If ($global:AutoUpdate -eq "1") { Exit }
        Write-Host "****   Removing appmanifest_$global:APPID.acf   ****" -F M -B Black
        Remove-Item $global:currentdir\$global:server\steamapps\appmanifest_$global:APPID.acf -Force  >$null 2>&1
        Write-Host "****   Removing Multiple appmanifest_$global:APPID.acf    ****" -F M -B Black
        Remove-Item $global:currentdir\$global:server\steamapps\appmanifest_*.acf -Force  >$null 2>&1
        Get-StopServer
        Get-UpdateServer  
    }
    Else {
        Write-Host "****   No $global:server Updates found   ****" -F Y -B Black
    }
    Set-Location $global:currentdir
}
Function Get-Steamtxt {
    Write-Host "****   Check $global:server Steam runscripts txt   ****" -F Y -B Black
    $patha = "$global:currentdir\steamcmd\Validate-$global:server.txt"
    $pathb = "$global:currentdir\steamcmd\Updates-$global:server.txt"
    $pathc = "$global:currentdir\steamcmd\Buildcheck-$global:server.txt" 
    If ((Test-Path $patha) -and (Test-Path $pathb) -and (Test-Path $pathc)) {
        Write-Host '****   steamCMD Runscripts .txt Exist   ***' -F Y -B Black
    } 
    Else {  
        Write-Host "----------------------------------------------------------------------------" -F Y -B Black
        Write-Host "      $global:DIAMOND $global:DIAMOND Command $global:command Failed! $global:DIAMOND $global:DIAMOND" -F R -B Black
        Write-Host "***        Try install command again          ****  " -F Y -B Black
        Write-Host "----------------------------------------------------------------------------" -F Y -B Black
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
    Write-Host '****   Starting gamedig on Server   ****' -F M -B Black
    If (( $global:AppID -eq 581330) -or ($global:AppID -eq 376030) -or ($global:AppID -eq 443030)) {
        Write-Host '****   Using QUERYPORT    ****' -F Y -B Black
        If (($null -eq ${global:QUERYPORT} ) -or ("" -eq ${global:QUERYPORT} )) {
            Write-Host '****   Missing QUERYPORT Var!   ****' -F R -B Black
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
        Write-Host '****   Missing PORT Var!   ****' -F R -B Black
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
    $global:backups = (Get-Childitem  $global:currentdir\backups -recurse | Measure-Object) 
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
    Write-Host "    Process status    : "-NoNewline; ; If ($Null -eq (Get-Process "$global:PROCESS" -ea SilentlyContinue)) { $global:status = " ----NOT RUNNING----"; ; Write-Host $status -F R }Else { $global:status = " **** RUNNING ****"; ; Write-Host $status -F Green }
    Write-Host "    CPU Cores         : $CpuCores"
    Write-Host "    CPU %             : $cpu"
    Write-Host "    Total RAM         : $avmem    "
    Write-Host "    Total RAM Usage   : $totalmem"
    Write-Host "    Process RAM Usage : $mem"
    Write-Host "    Backups           : $backups"
    Write-Host "    Backups size GB   : $backupssize"
    Write-Host "    Status            : "-NoNewline; ; If ($Null -eq $global:stats) { $global:stats = "----Offline----"; ; Write-Host $stats -F R }Else { $global:stats = "**** Online ***"; ; Write-Host $stats -F Green }
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
    #$results | Export-Csv  .\disks.csv -NoTypeInformation -Encoding ASCII
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
        Write-Host "****   You Enter a null or Empty   ****" -F R -B Black
        Select-Steamer
    }
    ElseIf (($null -eq $global:APPID ) -or ($global:APPID -eq " ")) {
        Write-Host "****   You Enter a space or Empty   ****" -F R -B Black
        Select-Steamer
    }
    ElseIf (Test-Path "$global:currentdir\$global:server\" ) {
        Write-Host '****   Server Folder Already Created!   ****' -F Y -B Black
    }
    Else {
        Write-Host '****   Creating Server Folder   ****' -F M -B Black 
        New-Item  . -Name "$global:server" -ItemType "directory"
    }
}
Function Get-CheckForVars {
    Write-Host "****   Checking for Vars   ****" -F Y -B Black
    If ($global:command -eq "mcrcon") {
        $global:missingvars = $global:RCONPORT, $global:RCONPASSWORD
    }
    Else {
        $global:missingvars = ${global:QUERYPORT}, ${global:IP}, $global:APPID, $global:PROCESS, ${global:PORT}, $global:ANON
    }
    Foreach ($global:missingvars in $global:missingvars) {
        If ( "" -eq $global:missingvars) {
            Write-Host "----------------------------------------------------------------------------" -F Y -B Black
            Write-Host "$global:DIAMOND $global:DIAMOND Missing Vars ! $global:DIAMOND $global:DIAMOND" -F R -B Black
            Write-Host "Try install command again or check vars in Variables-$global:server.ps1" -F Y -B Black
            Write-Host "----------------------------------------------------------------------------" -F Y -B Black
            Exit
        }
    }
}
Function Get-CheckForError {
    If (!$?) {
        Write-Host "----------------------------------------------------------------------------" -F Y -B Black
        Write-Host "      $global:DIAMOND $global:DIAMOND Command $global:command Failed! $global:DIAMOND $global:DIAMOND" -F R -B Black
        Write-Host "***        Try install command again          ****  " -F Y -B Black
        Write-Host "----------------------------------------------------------------------------" -F Y -B Black
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
        Write-Host '****   mcrcon already downloaded!   ****' -F Y -B Black
    } 
    Else {  
        $start_time = Get-Date
        Write-Host '****   Downloading MCRCon from github   ****' -F M -B Black 
        #(New-Object Net.WebClient).DownloadFile("$global:metamodurl", "$global:currentdir\metamod.zip")
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
        Invoke-WebRequest -Uri $global:mcrconurl -OutFile $global:currentdir\mcrcon.zip
        If (!$?) {
            Write-Host "****   Downloading  MCRCon Failed   ****" -F R -B Black 
            New-TryagainNew 
        }
        If ($?) { 
            Write-Host "****   Downloading  MCRCon succeeded   ****" -F Y -B Black 
        }
        Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -F Y -B Black
        Write-Host '****   Extracting MCRCon from github   ****' -F M -B Black
        Expand-Archive "$global:currentdir\mcrcon.zip" "$global:currentdir\mcrcon\" -Force
        If (!$?) {
            Write-Host "****   Extracting MCRCon Failed   ****" -F Y -B Black 
            New-TryagainNew 
        }
        If ($?) { 
            Write-Host "****   Extracting MCRCon succeeded   ****" -F Y -B Black 
        }
    }
}
Function New-DiscordAlert {
    If ($global:DisableDiscordBackup -eq "1") {    
        If ( "" -eq $global:WEBHOOK) {
            Write-Host "$global:DIAMOND $global:DIAMOND Missing WEBHOOK ! $global:DIAMOND $global:DIAMOND"-F R -B Black
            Write-Host "****   Add Discord  WEBHOOK to $global:currentdir\$global:server\Variables-$global:server.ps1   ****" -F Y -B Black    
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
                # R
                $global:ALERTCOLOR = '16711680'
            }
            Write-Host '****   Sending Discord Alert   ****' -F M -B Black
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
Function Set-Steamer {
    If ($null -eq $global:command) {
        Select-Steamer 
    }
    else {
        Select-Steamer $global:command $global:server
    }
}
Function Get-AdminCheck {
    $user = "$env:COMPUTERNAME\$env:USERNAME"
    $group = 'Administrators'
    $isInGroup = (Get-LocalGroupMember $group).Name -contains $user
    If ($isInGroup -eq $true) {
        Write-Host "----------------------------------------------------------------------------" -F Y -B Black
        Write-Host "                 $global:DIAMOND $global:DIAMOND Do Not Run as an Admin account $global:DIAMOND $global:DIAMOND" -F R -B Black
        Write-Host "***  Please Create a Non Admin Account to run script and game server  ******" -F Y -B Black
        Write-Host "----------------------------------------------------------------------------" -F Y -B Black
    }
}
Function Get-UpdateSteamer {
    $start_time = Get-Date
    Write-Host '****   Downloading Steamer github files   ****' -F M -B Black 
    #(New-Object Net.WebClient).DownloadFile("$global:steamerurl", "$global:currentdir\steamer.zip")
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest -Uri $global:steamerurl -OutFile $global:currentdir\steamer.zip
    Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -F Y -B Black 
    Remove-Item  "$global:currentdir\steamer\*" -Recurse -Force -ea SilentlyContinue
    Expand-Archive "$global:currentdir\steamer.zip" "$global:currentdir\steamer" -Force
    Copy-Item  "$global:currentdir\steamer\steamer-*\*" -Destination "$global:currentdir\" -Recurse -Force
    Write-Host '****   Steamer github files Updated   ****' -F Y -B Black
    Write-Host '****   Press Enter to Close this session   ****' -F Y -B Black
    Pause  
    Stop-Process -Id $PID
}
Function Get-NodeJS {
    $path = "$global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64"
    $patha = "$global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64\node.exe"
    $pathb = "node-v$global:nodeversion-win-x64.zip"
    Write-Host "****   Checking for Nodejs   ****" -F M -B Black     
    If ((Test-Path $path) -and (Test-Path $pathb) -and (Test-Path $patha)) { 
        Write-Host '****   NodeJS already downloaded!   ****' -F Y -B Black
    }
    Else {
        Write-Host "****   NodeJS not found   ****" -F Y -B Black
        Add-NodeJS
    }
}
Function Add-NodeJS {
    $start_time = Get-Date
    Write-Host '****   Downloading  Nodejs   ****' -F M -B Black  
    #(New-Object Net.WebClient).DownloadFile("$global:nodejsurl", "$global:currentdir\node-v$global:nodeversion-win-x64.zip")
    #[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest -Uri $global:nodejsurl -OutFile $global:currentdir\node-v$global:nodeversion-win-x64.zip
    If (!$?) {
        Write-Host "****   Downloading  Nodejs Failed    ****" -F R -B Black 
        New-TryagainNew
    }
    If ($?) { 
        Write-Host "****   Downloading  Nodejs succeeded   ****" -F Y -B Black 
    }
    Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -F Y -B Black
    Write-Host '****   Extracting Nodejs   *****' -F M -B Black
    Expand-Archive "$global:currentdir\node-v$global:nodeversion-win-x64.zip" "$global:currentdir\node-v$global:nodeversion-win-x64\" -Force
    If (!$?) {
        Write-Host "****   Extracting Nodejs Failed   ****" -F Y -B Black 
        New-TryagainNew
    }
    If ($?) { 
        Write-Host "****   Extracting Nodejs succeeded   ****" -F Y -B Black 
    }
    Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64
    Write-Host '****   Installing gamedig in Nodejs   ****' -F M -B Black
    Write-Host '****   Do not stop or cancel! Will need to delete nodejs files and start over!   ****' -F Y -B Black 
    .\npm install gamedig
    .\npm install gamedig -g
    Set-Location $global:currentdir
}
Function Set-VariablesPS {
    Write-Host "***  Creating Variables and adding launch params  ***" -F M -B Black
    New-Item $global:currentdir\$global:server\Variables-$global:server.ps1 -Force
}
Function New-CreateVariables {
    Write-Host '*** Creating Variables Script ****' -F M -B Black
    New-Item $global:currentdir\$global:server\Variables-$global:server.ps1 -Force
    Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                     WEBHOOK HERE "
    Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:WEBHOOK      = `"$global:WEBHOOK`""
    If ($global:APPID) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                     App ID  "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:APPID        = `"$global:APPID`""
    }
    If ($global:Branch) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                     Branch   "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:Branch       = `"$global:Branch`""
    }
    If ($global:username) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                         Steam username "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:username         = $global:username"
    }
    If ($global:ANON) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                     Steam Anonymous user  "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:ANON         = `"$global:ANON`""
    }
    If ($global:MODDIR) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                     Mod dir "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:MODDIR       = `"$global:MODDIR`""
    }
    If ($global:EXE) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                     Exe "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:EXE          = `"$global:EXE`""
    }
    If ($global:EXEDIR) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                     Exe dir "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:EXEDIR       = `"$global:EXEDIR`""
    }
    If ($global:SERVERCFGDIR) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                             SERVERCFGDIR dir "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:SERVERCFGDIR         = `"$global:SERVERCFGDIR`""
    }
    If ($global:GAME) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                     Game name used by Gamedig "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:game         = `"$global:GAME`""
    }
    If ($global:PROCESS) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                     PROCESS name "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:PROCESS      = `"$global:PROCESS`""
    }
    If (${global:IP}) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                     Server IP "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`${global:IP}         = `"${global:IP}`""
    }
    If (${global:EXTIP}) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                     Server EXT IP "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`${global:EXTIP}      = `"${global:EXTIP}`""
    }
    If (${global:PORT}) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                     Server PORT "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`${global:PORT}       = `"${global:PORT}`""
    }
    If (${global:DIFF}) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                     Server Difficulty "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`${global:DIFF}       = `"${global:DIFF}`""
    }
    If ($global:SOURCETVPORT) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                             Server Source TV Port "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:SOURCETVPORT         = `"$global:SOURCETVPORT`""
    }
    If ($global:SV_LAN) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                     Server SV_LAN "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:SV_LAN       = `"$global:SV_LAN`""
    }
    If ($global:CLIENTPORT) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                         server client port"
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:CLIENTPORT       = `"$global:CLIENTPORT`""
    }
    If ($global:STEAMPORT) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                         server STEAMPORT port"
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:STEAMPORT        = `"$global:STEAMPORT`""
    }
    If ($global:steamID64) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                         server steamID64"
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:steamID64        = `"$global:steamID64`""
    }
    If ($global:MAP) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                 default Map"
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:MAP      = `"$global:MAP`""
    }
    If ($global:GALAXYNAME) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                         default GALAXYNAME"
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:GALAXYNAME       = `"$global:GALAXYNAME`""
    }
    If ($global:TICKRATE) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                         server tick rate "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:TICKRATE         = `"$global:TICKRATE`""
    } 
    If ($global:GSLT) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                     Gamer Server token "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:GSLT         = `"$global:GSLT`""
    }
    If ($global:MAXPLAYERS) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                         Max Players  "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:MAXPLAYERS       = `"$global:MAXPLAYERS`""
    }
    If ($global:COOPPLAYERS) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                         COOPPLAYERS Players  "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:COOPPLAYERS       = `"$global:COOPPLAYERS`""
    }
    If ($global:WORKSHOP) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                         Workshop 1/0 HERE "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:WORKSHOP         = `"$global:WORKSHOP`""
    }
    If ($global:HOSTNAME) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                         Server Name "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:HOSTNAME         = `"$global:HOSTNAME`""
    }
    If (${global:QUERYPORT}) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                         query port "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`${global:QUERYPORT}      = `"${global:QUERYPORT}`""
    }
    If ($global:SAVES) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                     local App Data SAVES folder "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:SAVES        = `"$global:SAVES`""
    }
    If ($global:RCONPORT) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                         Rcon Port  "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:RCONPORT         = `"$global:RCONPORT`""
    }
    If ($global:RCONPASSWORD) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                             Rcon Password HERE "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:RCONPASSWORD         = `"$global:RCONPASSWORD`""
    }
    If ($global:SV_PURE) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                         Extra Launch Parms "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:SV_PURE          = `"$global:SV_PURE`""
    }
    If ($global:SCENARIO) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                         Sandstorm SCENARIO   "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:SCENARIO         = `"$global:SCENARIO`""
    }
    If ($global:SAVEINTERVAL) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                         SAVEINTERVAL   "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:SAVEINTERVAL         = `"$global:SAVEINTERVAL`""
    }
    If ($global:WORLDSIZE) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                         WORLDSIZE  "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:WORLDSIZE         = `"$global:WORLDSIZE`""
    }
    If ($global:SEED) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                          SEED   "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:SEED         = `"$global:SEED`""
    }
    If ($global:RCONWEB) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                          RCONWEB   "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:RCONWEB         = `"$global:RCONWEB`""
    }
    If ($global:GAMETYPE) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                         CSGO Gametype   "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:GAMETYPE         = `"$global:GAMETYPE`""
    }
    If ($global:GAMEMODE) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                         CSGO Gamemode   "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:GAMEMODE         = `"$global:GAMEMODE`""
    }
    If ($global:MAPGROUP) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                         CSGO mapgroup   "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:MAPGROUP         = `"$global:MAPGROUP`""
    }
    If ($global:cluster) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                         cluster   "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:cluster         = `"$global:cluster`""
    }
    If ($global:shard) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                         shard   "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:shard         = `"$global:shard`""
    }
    If ($global:persistentstorageroot) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                          persistentstorageroot   "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:persistentstorageroot         = `"$global:persistentstorageroot`""
    }
    If ($global:gamedirname) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                          gamedirname   "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:gamedirname         = `"$global:gamedirname`""
    }
    If ($global:WSCOLLECTIONID) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                              WSCOLLECTIONID   "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:WSCOLLECTIONID       = `"$global:WSCOLLECTIONID`""
    }
    If ($global:WSSTARTMAP) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                          WSSTARTMAP  "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:WSSTARTMAP       = `"$global:WSSTARTMAP`""
    }
    If ($global:WSAPIKEY) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                         WSAPIKEY   "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:WSAPIKEY         = `"$global:WSAPIKEY`""
    }
    If ($global:LOGDIR) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                         LOGDIR   "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:LOGDIR         = `"$global:LOGDIR`""
    }
    If ($global:launchParams) {
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "#                             Server Launch Params "
        Add-Content  $global:currentdir\$global:server\Variables-$global:server.ps1  "`$global:launchParams         = $global:launchParams"
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
    Write-Host '****   Downloading Meta Mod   ****' -F M -B Black 
    #(New-Object Net.WebClient).DownloadFile("$global:metamodurl", "$global:currentdir\metamod.zip")
    #[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest -Uri $global:metamodurl -OutFile $global:currentdir\metamod.zip
    If (!$?) { 
        Write-Host "****   Downloading Meta Mod Failed !!   ****" -F R -B Black ; ; Exit 
    } 
    Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -F Y -B Black
    Write-Host '****   Extracting Meta Mod   ****' -F M -B Black
    Expand-Archive "$global:currentdir\metamod.zip" "$global:currentdir\metamod\" -Force
    If (!$?) { 
        Write-Host "****   Extracting Meta Mod Failed !!   ****" -F R -B Black ; ; Exit 
    }
    Write-Host '****   Copying/installing Meta Mod   ****' -F M -B Black 
    Copy-Item  $global:currentdir\metamod\* -Destination $global:currentdir\$global:server\$global:MODDIR -Force -Recurse
    If (!$?) { 
        Write-Host "****   Copying Meta Mod Failed !!   ****" -F R -B Black ; ; Exit 
    }
    $start_time = Get-Date
    Write-Host '****   Downloading SourceMod   ****' -F M -B Black
    #(New-Object Net.WebClient).DownloadFile("$global:sourcemodurl", "$global:currentdir\sourcemod.zip")
    #[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest -Uri $global:sourcemodurl -OutFile $global:currentdir\sourcemod.zip
    If (!$?) { 
        Write-Host "****   Downloading SourceMod Failed !!   ****" -F R -B Black ; ; Exit 
    } 
    Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -F Y -B Black
    Write-Host '****   Extracting SourceMod   ****' -F M -B Black 
    Expand-Archive "$global:currentdir\sourcemod.zip" "$global:currentdir\sourcemod\" -Force
    If (!$?) { 
        Write-Host "****   Extracting SourceMod Failed !!   ****" -F R -B Black ; ; Exit 
    }
    Write-Host '****   Copying/installing SourceMod   ****' -F M -B Black
    Copy-Item  $global:currentdir\sourcemod\* -Destination $global:currentdir\$global:server\$global:MODDIR -Force -Recurse
    If (!$?) { 
        Write-Host "****   Copying SourceMod Failed !!   ****" -F R -B Black ; ; Exit 
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
    Write-Host '****   Downloading Oxide   ****' -F M -B Black
    #(New-Object Net.WebClient).DownloadFile("$global:oxiderustlatestlink", "$global:currentdir\oxide.zip")
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest -Uri $global:oxiderustlatestlink -OutFile $global:currentdir\oxide.zip
    If (!$?) { 
        Write-Host "****   Downloading Oxide Failed !!   ****" -F R -B Black ; ; Exit 
    } 
    Write-Host "Download Time: $((Get-Date).Subtract($start_time).Seconds) second(s)" -F Y -B Black
    Write-Host '****   Extracting Oxide    ****' -F M -B Black
    Expand-Archive "$global:currentdir\oxide.zip" "$global:currentdir\oxide\" -Force
    If (!$?) { 
        Write-Host "****   Extracting Oxide Failed !!   ****" -F R -B Black ; ; Exit 
    }

    Write-Host '****   Copying Oxide *****' -F M -B Black
    Copy-Item  $global:currentdir\oxide\$global:MODDIR\* -Destination $global:currentdir\$global:server\$global:MODDIR\ -Force -Recurse
    If (!$?) { 
        Write-Host "****   Copying Oxide Failed !!   ****" -F R -B Black ; ; Exit 
    }
}
Function New-RestartJob {
    Write-Host "Run Task only when user is logged on"
    Write-Host "Input AutoRestart Time. ie 3am: " -F Cyan -NoNewline
    $restartTime = Read-Host
    $Action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "$global:currentdir\steamer.ps1 restart $global:server" -WorkingDirectory "$global:currentdir"
    #$Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).Date -RepetitionInterval (New-TimeSpan -Hours $restartTime)
    $Trigger = New-ScheduledTaskTrigger -Daily -At $restartTime
    $Settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit '00:00:00'
    $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings
    Write-Host "Creating Task........" -F M -B Black
    Register-ScheduledTask -TaskName "$global:server AutoRestart" -InputObject $Task
}
Function New-RestartJobBG {
    $UserName = "$env:COMPUTERNAME\$env:UserName"
    Write-Host "Run Task Whether user is logged on or not"
    Write-Host "Input AutoRestart Time. ie 3am: " -F Cyan -NoNewline
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
    Write-Host "Creating Task........" -F M -B Black
    Register-ScheduledTask -TaskName "$global:server AutoRestart" -InputObject $Task -User "$UserName" -Password "$Password"
}
Function New-MontiorJob {
    Write-Host "Run Task only when user is logged on"
    $Action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "`"If (!(Get-Process '$global:PROCESS')) {$global:currentdir\steamer.ps1 start $global:server ;; $global:currentdir\steamer.ps1 discord $global:server }`"" -WorkingDirectory "$global:currentdir"
    $Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).Date -RepetitionInterval (New-TimeSpan -Minutes 5) 
    $Settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit '00:00:00'
    $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings
    Write-Host "Creating Task........" -F M -B Black
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
    Write-Host "Creating Task........" -F M -B Black
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
        Write-Host '****   Unregistering scheduled task   ****' -F M -B Black
        Unregister-ScheduledTask -TaskName "$global:server $global:command" >$null 2>&1
    }
    If (!$?) {
        Write-Host "****   Scheduled Task does not exist   ****" -F Y -B Black
    }
}
Function Get-ChecktaskDisable {
    If ($global:DisableChecktask -eq "1") {
        Get-ScheduledTask -TaskName "$global:server monitor" >$null 2>&1
    }
    If ($?) {
        Write-Host '****   disabling scheduled task   ****' -F M -B Black
        Disable-ScheduledTask -TaskName "$global:server monitor" >$null 2>&1
    }
    If (!$?) {
        Write-Host "****   Scheduled Task does not exist   ****" -F Y -B Black
    }
}
Function Get-ChecktaskEnable {
    if ($global:DisableChecktask -eq "1") {
        Get-ScheduledTask -TaskName "$global:server monitor" >$null 2>&1
    }
    If ($?) {
        Write-Host '****   Enabling scheduled task   ****' -F M -B Black
        Enable-ScheduledTask -TaskName "$global:server monitor" >$null 2>&1
    }
    If (!$?) {
        Write-Host "****   Scheduled Task does not exist   ****" -F Y -B Black
    }
}
Function New-ServerLog {
    $logdirectory = "$global:currentdir\$global:server\$global:LOGDIR"
    If ($global:log -eq "1") { Copy-Item "$logdirectory\[cs]*.log" -Destination "$global:currentdir\log\$global:server-$global:date.log" -ea SilentlyContinue }
    Get-Childitem $global:currentdir\log\ -Recurse | where-object name -like Steamer-*.log | Sort-Object CreationTime -desc | Select-Object -Skip $global:logcount | Remove-Item -Force -ea SilentlyContinue
    Get-Childitem $global:currentdir\log\ -Recurse | where-object name -like $global:server-*.log | Sort-Object CreationTime -desc | Select-Object -Skip $global:logcount | Remove-Item -Force -ea SilentlyContinue
}
Function New-BackupFolder {
    $path = "$global:currentdir\backups" 
    If (Test-Path $path) { 
        Write-Host '****   Backup folder exists!   ****' -F Y -B Black
    } 
    Else {  
        Write-Host '****   Creating backup folder   ****' -F M -B Black
        New-Item  "$global:currentdir\" -Name "backups" -ItemType "directory"
    }
}
Function New-BackupServer {
    Write-Host '****   Server Backup Started!   ****' -F M -B Black
    Set-Location $global:currentdir\7za920\
    Get-Childitem $global:currentdir\backups\ -Recurse | where-object name -like Backup_$global:server-*.zip | Sort-Object CreationTime -desc | Select-Object -Skip $global:backupcount | Remove-Item -Force 
    #./7za a $global:currentdir\backups\Backup_$global:server-$BackupDate.zip $global:currentdir\$global:server\* -an > backup.log
    ./7za a $global:currentdir\backups\Backup_$global:server-$global:Date.zip $global:currentdir\$global:server\* > backup.log
    Write-Host '****   Server Backup is Done!   ****' -F Y -B Black
    Write-Host "****   Checking Save location(appData)   ****" -F Y -B Black
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
    Write-Host '****   Checking for 7ZIP   *****' -F Y -B Black   
    If ((Test-Path $path) -and (Test-Path $patha) -and (Test-Path $pathb)) { 
        Write-Host '****   7Zip already downloaded!   ****' -F Y -B Black
    }
    Else {
        Write-Host "****   7Zip not found!   ****" -F Y -B Black
        Add-Sevenzip
    }  
}
Function Add-Sevenzip {
    $start_time = Get-Date
    Write-Host '****   Downloading 7ZIP   ****' -F M -B Black 
    #(New-Object Net.WebClient).DownloadFile("$global:sevenzip", "$global:currentdir\7za920.zip")
    #[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest -Uri $global:sevenzip -OutFile $global:currentdir\7za920.zip
    If (!$?) {
        Write-Host "****   7Zip Download Failed   *****" -F Y -B Black
        New-TryagainNew 
    }
    If ($?) {
        Write-Host "****   7Zip  Download succeeded   ****" -F Y -B Black
    }
    Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -F Y -B Black
    Write-Host '****   Extracting 7ZIP   *****' -F M -B Black 
    Expand-Archive "$global:currentdir\7za920.zip" "$global:currentdir\7za920\" -Force
    If (!$?) {
        Write-Host "****   7Zip files did not Extract   ****" -F Y -B Black
        New-TryagainNew 
    }
    If ($?) {
        Write-Host "****   7Zip Extract succeeded   ****" -F Y -B Black
    }
}
Function New-backupAppdata {
    Write-Host '****   Server App Data Backup Started!   ****' -F M -B Black
    Set-Location $global:currentdir\7za920\ 
    ./7za a $global:currentdir\backups\AppDataBackup_$global:server-$global:Date.zip $env:APPDATA\$global:saves\* > AppDatabackup.log
    Write-Host '****   Server App Data Backup is Done!   ****' -F Y -B Black
    If ($global:appdatabackuplog -eq "1") { 
        .\AppDatabackup.log 
    }
}
Function Get-Savelocation {
    If (("" -eq $global:saves) -or ($null -eq $global:saves )) {
        Write-Host "****   No saves located in App Data   ****" -F Y -B Black 
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
    Write-Host "****   Retrieve Default Config   ****" -F Y -B Black
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
        Write-Host "****   Retrieve server config GSM   ****" -F M -B Black
        $WebResponse = Invoke-WebRequest "$global:githuburl/$global:gamedirname/$global:SERVERCFG"
        If (!$?) { 
            Write-Host "****   Array Failed !! Did NOT Retrieve server config   ****" -F R -B Black ; ; Exit 
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
    If ($global:log -eq "1") {New-ServerLog}
    Set-Location $global:currentdir\$global:server\
    If ($global:APPID -eq 343050) {Set-Location $global:currentdir\$global:server\$global:EXEDIR}
    #Start-Process -FilePath CMD -ArgumentList ("/c $global:launchParams") -NoNewWindow
    If (( $global:APPID -eq 258550 ) -or ($global:APPID -eq 294420 ) -or ($global:APPID -eq 302550)) {
        Start-Process CMD "/c start $global:launchParams"
    }
    Else {
        Start-Process CMD "/c start $global:launchParams"  -NoNewWindow
    }
    Set-Location $global:currentdir
}
Function Select-StartServer {
    Write-Host '****   Starting Server   *****' -F Y -B Black  
    Get-StartServer $global:launchParams
}
Function Select-StartServer {
    Write-Host '****   Starting Server   *****' -F Y -B Black  
    Get-StartServer $global:launchParams
}
Function Select-RenameSource {
    Write-Host "***  Renaming srcds.exe to $global:EXE to avoid conflict with local source Engine (srcds.exe) server  ***" -F M -B Black
    Rename-Item  "$global:currentdir\$global:server\$global:EXEDIR\srcds.exe" -NewName "$global:currentdir\$global:server\$global:EXEDIR\$global:EXE.exe" >$null 2>&1
    Rename-Item  "$global:currentdir\$global:server\$global:EXEDIR\srcds_x64.exe" -NewName "$global:currentdir\$global:server\$global:EXEDIR\$global:EXE-x64.exe" >$null 2>&1
}
Function Select-EditSourceCFG {
    Write-Host "***  Editing Default server.cfg  ***" -F M -B Black
    ((Get-Content  $global:currentdir\$global:server\$global:SERVERCFGDIR\$global:config1 -Raw) -replace "\bSERVERNAME\b", "$global:HOSTNAME") | Set-Content  $global:currentdir\$global:server\$global:SERVERCFGDIR\$global:config1
    ((Get-Content  $global:currentdir\$global:server\$global:SERVERCFGDIR\$global:config1 -Raw) -replace "\bADMINPASSWORD\b", "$global:RCONPASSWORD") | Set-Content  $global:currentdir\$global:server\$global:SERVERCFGDIR\$global:config1 -ea SilentlyContinue
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
        [parameter(Position = 9)]$parm9,
        [parameter(Position = 10)]$parm10,
        [parameter(Position = 11)]$parm11,
        [parameter(Position = 12)]$parm12,
        [parameter(Position = 13)]$parm13,
        [parameter(Position = 14)]$parm14,
        [parameter(Position = 15)]$parm15,
        [parameter(Position = 16)]$parm16,
        [parameter(Position = 17)]$parm17,
        [parameter(Position = 18)]$parm18,
        [parameter(Position = 19)]$parm19,
        [parameter(Position = 20)]$parm20,
        [parameter(Position = 21)]$parm21,
        [parameter(Position = 22)]$parm22,
        [parameter(Position = 23)]$parm23,
        [parameter(Position = 24)]$parm24,
        [parameter(Position = 25)]$parm25,
        [parameter(Position = 26)]$parm26,
        [parameter(Position = 27)]$parm27,
        [parameter(Position = 28)]$parm28)
    #Write-Host "$global:SMILEY_BLACK Press Enter to Accept default $global:SMILEY_BLACK" -F Y
    If ($parm0 -eq 1) {
        If ((${global:IP} = Read-Host -P(Write-Host "Enter Server IP, Press Enter to Accept default [$global:defaultIP]: "-F CY -N )) -eq '') { $global:IP = "$global:defaultIP" }Else { $global:IP }
    }
    If ($parm1 -eq 1) {
        If ((${global:PORT} = Read-Host -P(Write-Host "Enter Server PORT, Press Enter to Accept default [$global:defaultPORT]: "-F CY -N )) -eq '') { $global:PORT = "$global:defaultPORT" }Else { $global:PORT }
    }
    If ($parm2 -eq 1) {
        If ((${global:QUERYPORT} = Read-Host -P(Write-Host "Enter Server QUERY PORT, Press Enter to Accept default [$global:defaultQUERYPORT]: "-F CY -N )) -eq '') { $global:QUERYPORT = "$global:defaultQUERYPORT" }Else { $global:QUERYPORT }
    }
    If ($parm3 -eq 1) {
        If ((${global:RCONPORT} = Read-Host -P(Write-Host "Enter Server RCON PORT, Press Enter to Accept default [$global:defaultRCONPORT]: "-F CY -N )) -eq '') { $global:RCONPORT = "$global:defaultRCONPORT" }Else { $global:RCONPORT }
    }
    If ($parm4 -eq 1) {
        If ((${global:RCONPASSWORD} = Read-Host -P(Write-Host "Enter Server RCON PASSWORD, Press Enter to Accept default [$global:RANDOMPASSWORD]: "-F CY -N )) -eq '') { $global:RCONPASSWORD = "$global:RANDOMPASSWORD" }Else { $global:RCONPASSWORD }
    }
    If ($parm5 -eq 1) {
        If ((${global:HOSTNAME} = Read-Host -P(Write-Host "Enter Server HOSTNAME, Press Enter to Accept default [$env:USERNAME]: "-F CY -N )) -eq '') { $global:HOSTNAME = "$env:USERNAME" }Else { $global:HOSTNAME }
    }
    If ($parm6 -eq 1) {
        If ((${global:SERVERPASSWORD} = Read-Host -P(Write-Host "Enter Server SERVER PASSWORD, Press Enter to Accept default [$global:defaultSERVERPASSWORD]: "-F CY -N )) -eq '') { $global:SERVERPASSWORD = "$global:defaultSERVERPASSWORD" }Else { $global:SERVERPASSWORD }
    }
    If ($parm7 -eq 1) {
        If ((${global:MAXPLAYERS} = Read-Host -P(Write-Host "Enter Server MAX PLAYERS, Press Enter to Accept default [$global:defaultMAXPLAYERS]: "-F CY -N )) -eq '') { $global:MAXPLAYERS = "$global:defaultMAXPLAYERS" }Else { $global:MAXPLAYERS }
    }
    If ($parm8 -eq 1) {
        If ((${global:GSLT} = Read-Host -P(Write-Host "Enter Server GSLT, Press Enter to Accept default [$global:defaultGSLT]: "-F CY -N )) -eq '') { $global:GSLT = "$global:defaultGSLT" }Else { $global:GSLT }
    }
    If ($parm9 -eq 1) {
        If ((${global:MAP} = Read-Host -P(Write-Host "Enter Server MAP, Press Enter to Accept default [$global:defaultMAP]: "-F CY -N )) -eq '') { $global:MAP = "$global:defaultMAP" }Else { $global:MAP }
    }
    If ($parm10 -eq 1) {
        If ((${global:clientport} = Read-Host -P(Write-Host "Enter Server client port, Press Enter to Accept default [$global:defaultclientport]: "-F CY -N )) -eq '') { $global:clientport = "$global:defaultclientport" }Else { $global:clientport }
    }
    If ($parm11 -eq 1) {
        If ((${global:sourcetvport} = Read-Host -P(Write-Host "Enter Server source tv port, Press Enter to Accept default [$global:defaultsourcetvport]: "-F CY -N )) -eq '') { $global:sourcetvport = "$global:defaultsourcetvport" }Else { $global:sourcetvport }
    }
    If ($parm12 -eq 1) {
        If ((${global:GAMEMODE} = Read-Host -P(Write-Host "Enter Server GAME MODE, Press Enter to Accept default [$global:defaultGAMEMODE]: "-F CY -N )) -eq '') { $global:GAMEMODE = "$global:defaultGAMEMODE" }Else { $global:GAMEMODE }
    }
    If ($parm13 -eq 1) {
        If ((${global:DIFF} = Read-Host -P(Write-Host "Enter Server Difficulty, Press Enter to Accept default [$global:defaultDIFF]: "-F CY -N )) -eq '') { $global:DIFF = "$global:defaultDIFF" }Else { $global:DIFF }
    }
    If ($parm14 -eq 1) {
        If ((${global:ADMINPASSWORD} = Read-Host -P(Write-Host "Enter Server ADMIN PASSWORD, Press Enter to Accept default [$global:defaultADMINPASSWORD]: "-F CY -N )) -eq '') { $global:ADMINPASSWORD = "$global:defaultADMINPASSWORD" }Else { $global:ADMINPASSWORD }
    }
    If ($parm15 -eq 1) {
        If ((${global:TICKRATE} = Read-Host -P(Write-Host "Enter Server TICKRATE, Press Enter to Accept default [$global:TICKRATE]: "-F CY -N )) -eq '') { $global:TICKRATE = "$global:defaultTICKRATE" }Else { $global:TICKRATE }
    }
    If ($parm16 -eq 1) {
        If ((${global:SAVEINTERVAL} = Read-Host -P(Write-Host "Enter Server SAVEINTERVAL, Press Enter to Accept default [$global:SAVEINTERVAL]: "-F CY -N )) -eq '') { $global:SAVEINTERVAL = "$global:defaultSAVEINTERVAL" }Else { $global:SAVEINTERVAL }
    }
    If ($parm17 -eq 1) {
        If ((${global:WORLDSIZE} = Read-Host -P(Write-Host "Enter Server WORLDSIZE, Press Enter to Accept default [$global:WORLDSIZE]: "-F CY -N )) -eq '') { $global:WORLDSIZE = "$global:defaultWORLDSIZE" }Else { $global:WORLDSIZE }
    }
    If ($parm18 -eq 1) {
        If ((${global:SEED} = Read-Host -P(Write-Host "Enter Server SEED, Press Enter to Accept default [$global:SEED]: "-F CY -N )) -eq '') { $global:SEED = "$global:defaultSEED" }Else { $global:SEED }
    }
    If ($parm19 -eq 1) {
        If ((${global:RCONWEB} = Read-Host -P(Write-Host "Enter Server RCONWEB, Press Enter to Accept default [$global:RCONWEB]: "-F CY -N )) -eq '') { $global:RCONWEB = "$global:defaultRCONWEB" }Else { $global:RCONWEB }
    }
    If ($parm20 -eq 1) {
        If ((${global:steamID64} = Read-Host -P(Write-Host "Enter steamID64, Press Enter to Accept default [$global:steamID64]: "-F CY -N )) -eq '') { $global:steamID64 = "$global:defaultsteamID64" }Else { $global:steamID64 }
    }
    If ($parm21 -eq 1) {
        If ((${global:GALAXYNAME} = Read-Host -P(Write-Host "Enter GALAXYNAME, Press Enter to Accept default [$global:GALAXYNAME]: "-F CY -N )) -eq '') { $global:GALAXYNAME = "$global:defaultGALAXYNAME" }Else { $global:GALAXYNAME }
    }
    If ($parm22 -eq 1) {
        If ((${global:MAPGROUP} = Read-Host -P(Write-Host "Enter Server MAPGROUP, Press Enter to Accept default [$global:MAPGROUP]: "-F CY -N )) -eq '') { $global:MAPGROUP = "$global:defaultMAPGROUP" }Else { $global:MAPGROUP }
    }
    If ($parm23 -eq 1) {
        If ((${global:GAMETYPE} = Read-Host -P(Write-Host "Enter Server xx, Press Enter to Accept default [$global:GAMETYPE]: "-F CY -N )) -eq '') { $global:GAMETYPE = "$global:defaultGAMETYPE" }Else { $global:GAMETYPE }
    }
    If ($parm24 -eq 1) {
        If ((${global:COOPPLAYERS} = Read-Host -P(Write-Host "Enter Server COOPPLAYERS, Press Enter to Accept default [$global:COOPPLAYERS]: "-F CY -N )) -eq '') { $global:COOPPLAYERS = "$global:defaultCOOPPLAYERS" }Else { $global:COOPPLAYERS }
    }
    If ($parm25 -eq 1) {
        If ((${global:SV_LAN} = Read-Host -P(Write-Host "Enter Server SV_LAN, Press Enter to Accept default [$global:SV_LAN]: "-F CY -N )) -eq '') { $global:SV_LAN = "$global:defaultSV_LAN" }Else { $global:SV_LAN }
    }
    If ($parm26 -eq 1) {
        If ((${global:WORKSHOP} = Read-Host -P(Write-Host "Enter Server WORKSHOP, Press Enter to Accept default [$global:WORKSHOP]: "-F CY -N )) -eq '') { $global:WORKSHOP = "$global:defaultWORKSHOP" }Else { $global:WORKSHOP }
    }
    If ($parm27 -eq 1) {
        If ((${global:SV_PURE} = Read-Host -P(Write-Host "Enter Server SV_PURE, Press Enter to Accept default [$global:SV_PURE]: "-F CY -N )) -eq '') { $global:SV_PURE = "$global:defaultSV_PURE" }Else { $global:SV_PURE }
    }
    If ($parm28 -eq 1) {
        If ((${global:xx} = Read-Host -P(Write-Host "Enter Server xx, Press Enter to Accept default [$global:xx]: "-F CY -N )) -eq '') { $global:xx = "$global:xx" }Else { $global:xx }
    }
    If ($parm29 -eq 1) {
        If ((${global:xx} = Read-Host -P(Write-Host "Enter Server xx, Press Enter to Accept default [$global:xx]: "-F CY -N )) -eq '') { $global:xx = "$global:xx" }Else { $global:xx }
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
    ElseIf ($global:AppID -eq 582400) {
        Set-Console  >$null 2>&1
        New-LaunchScriptasrdserverPS
    }
    ElseIf ($global:AppID -eq 416880) {
        Set-Console  >$null 2>&1
        New-LaunchScriptBOserverPS
    }
    ElseIf ($global:AppID -eq 985050) {
        Set-Console  >$null 2>&1
        New-LaunchScriptAHL2serverPS
    }
    ElseIf ($global:AppID -eq 475370) {
        Set-Console  >$null 2>&1
        New-LaunchScriptBB2serverPS
    }
    ElseIf ($global:AppID -eq 232370) {
        Set-Console  >$null 2>&1
        New-LaunchScriptHL2DMserverPS
    }
    ElseIf ($global:AppID -eq 17585) {
        Set-Console  >$null 2>&1
        New-LaunchScriptDystopiaserverPS
    }
    ElseIf ($global:AppID -eq 346680) {
        Set-Console  >$null 2>&1
        New-LaunchScriptBlackMesaserverPS
    }
    ElseIf ($global:AppID -eq 232290) {
        Set-Console  >$null 2>&1
        New-LaunchScriptDODSserverPS
    }
    ElseIf ($global:AppID -eq 343050) {
        Set-Console  >$null 2>&1
        New-LaunchScriptDSTserverPS
    }
    ElseIf ($global:AppID -eq 4020) {
        Set-Console  >$null 2>&1
        New-LaunchScriptGMODserverPS
    }
    ElseIf ($global:AppID -eq 232250) {
        Set-Console  >$null 2>&1
        New-LaunchScriptTF2serverPS
    }
    ElseIf ($global:AppID -eq 317670) {
        Set-Console  >$null 2>&1
        New-LaunchScriptNMRIHserverPS
    }
    ElseIf ($global:AppID -eq 228780) {
        Set-Console  >$null 2>&1
        New-LaunchScriptbsserverPS
    }
    ElseIf ($global:AppID -eq 295230) {
        Set-Console  >$null 2>&1
        New-LaunchScriptFOFserverPS
    }
    ElseIf ($global:AppID -eq 380870) {
        Set-Console  >$null 2>&1
        New-LaunchScriptpzserverPS
    }
    ElseIf ($global:AppID -eq 276060) {
        Set-Console  >$null 2>&1
        New-LaunchScriptSvenCoopserverPS
    }
    #    ElseIf ($global:AppID -eq Template) {
    #        Set-Console  >$null 2>&1
    #        New-LaunchScriptTemplateserverPS
    #    }
    Else {
        Write-Host "No Launch Script Found for this server" -F Y -B Black
        Exit
    }
}