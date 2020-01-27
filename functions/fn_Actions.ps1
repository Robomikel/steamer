# .::::::.::::::::::::.,::::::   :::.     .        :  .,:::::: :::::::..   
# ;;;`    `;;;;;;;;'''';;;;''''   ;;`;;    ;;,.    ;;; ;;;;'''' ;;;;``;;;;  
# '[==/[[[[,    [[      [[cccc   ,[[ '[[,  [[[[, ,[[[[, [[cccc   [[[,/[[['  
#   '''    $    $$      $$""""  c$$$cc$$$c $$$$$$$$"$$$ $$""""   $$$$$$c    
#  88b    dP    88,     888oo,__ 888   888,888 Y88" 888o888oo,__ 888b "88bo,
#   "YMmMY"     MMM     """"YUMMMYMM   ""` MMM  M'  "MMM""""YUMMMMMMM   "W" 
#----------      Install server as Anon     ----------------------
Function Set-SteamInfo {
    $title    = 'Install Steam server with Anonymous login'
    $question = 'Use Anonymous Login?'
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    if ($decision -eq 1) {
        $global:anon="yes"
    Install-Anonserver
    Write-Host 'Entered Y'
    }else{
        $global:anon="no"
    #Install-Server
    Install-Anonserver
    Write-Host 'Entered N'}
}
Function Install-Anonserver {
    if ($global:ANON-eq"no"){
        Write-Host "Enter Username for Steam install, Steam.exe will prompt for Password and Steam Gaurd" -ForegroundColor Cyan -BackgroundColor Black  
        $global:username = Read-host}Else{}
    Write-Host '****    Creating SteamCMD Run txt   *****' -ForegroundColor Magenta -BackgroundColor Black 
    New-Item $global:currentdir\SteamCMD\Updates-$global:server.txt -Force
    Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "@ShutdownOnFailedCommand 1"
    if ($global:ANON-eq"no"){}Else{Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "@NoPromptForPassword 1"}
    if ($global:ANON-eq"no"){Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "login $global:username"}Else{
    Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "login anonymous"}
    Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "force_install_dir $global:currentdir\$global:server"
    Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "app_update $global:APPID $global:Branch"
    Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "exit"
    
    New-Item -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Force
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "@ShutdownOnFailedCommand 1"
    if ($global:ANON-eq"no"){}Else{Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "@NoPromptForPassword 1"}
    if ($global:ANON-eq"no"){Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "login $global:username"}Else{
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "login anonymous"}
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "force_install_dir $global:currentdir\$global:server"
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "app_update $global:APPID $global:Branch validate"
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "exit"
    New-Item -Path $global:currentdir\SteamCMD\Buildcheck-$global:server.txt -Force
    Add-Content -Path $global:currentdir\SteamCMD\Buildcheck-$global:server.txt -Value "app_info_update 1"
    Add-Content -Path $global:currentdir\SteamCMD\Buildcheck-$global:server.txt -Value "app_info_print $global:APPID"
    Add-Content -Path $global:currentdir\SteamCMD\Buildcheck-$global:server.txt -Value "quit"
    Get-UpdateServer
    Set-Location $global:currentdir
}
Function Get-createdvaribles {
    Write-Host "****   Getting Server Variables   *****" -ForegroundColor Yellow -BackgroundColor Black  
    .$global:currentdir\$global:server\Variables-$global:server.ps1
    Get-CheckForError
}
Function Get-ClearVariables {
    Write-Host "****   Clearing Variables   *****" -ForegroundColor Yellow -BackgroundColor Black
    $global:vars = "PROCESS","IP","PORT","SOURCETVPORT","CLIENTPORT","MAP","TICKRATE","GSLT","MAXPLAYERS","WORKSHOP","HOSTNAME","QUERYPORT","SAVES","APPID","RCONPORT","RCONPASSWORD","SV_PURE","SCENARIO","GAMETYPE","GAMEMODE","MAPGROUP","WSCOLLECTIONID","WSSTARTMAP","WSAPIKEY","WEBHOOK","EXEDIR","GAME","SERVERCFGDIR","gamedirname","config1","config2","config3","config4","config5","MODDIR","status","CpuCores","cpu","avmem","totalmem","mem","backups","backupssize","stats","gameresponse","os","results,","disks","computername","ANON"
    Foreach($global:vars in $global:vars){
    Clear-Variable $global:vars -Scope Global -ErrorAction SilentlyContinue
    Remove-Variable $global:vars -Scope Global -ErrorAction SilentlyContinue}
}
Function Select-launchServer {
    Write-Host '****   Starting Launch script   *****' -ForegroundColor Yellow -BackgroundColor Black  
    & "$global:currentdir\$global:server\Launch-*.ps1"
    Get-CheckForError
    Set-Location $global:currentdir
}
Function Get-CheckServer {
    Write-Host '****   Check  Server process    *****' -ForegroundColor Yellow -BackgroundColor Black 
    if($Null -eq (get-process "$global:PROCESS" -ea SilentlyContinue)){
    Write-Host "----   NOT RUNNING   ----" -ForegroundColor Red -BackgroundColor Black}else{Write-Host "****   RUNNING   ****" -ForegroundColor Green -BackgroundColor Black ;; Get-process "$global:PROCESS" ;; Get-ClearVariables ;; exit}
    Get-CheckForError
}
Function Get-StopServer {
    Write-Host '****   Stopping Server process   *****' -ForegroundColor Magenta -BackgroundColor Black 
    if($Null -eq (get-process "$global:PROCESS" -ea SilentlyContinue)){
    Write-Host "----   NOT RUNNING   ----" -ForegroundColor Red -BackgroundColor Black}else{stop-process -Name "$global:PROCESS" -Force}
    Get-CheckForError
}
Function Get-StopServerInstall {
    Write-Host '****   Checking for Server process before install   ****' -ForegroundColor Yellow -BackgroundColor Black 
    if($Null -eq (get-process "$global:PROCESS" -ea SilentlyContinue)){
    Write-Host "****   No Process found   ****" -ForegroundColor Yellow -BackgroundColor Black}else{
    Write-Host "****   Stopping Server Process   *****" -ForegroundColor Magenta -BackgroundColor Black
    stop-process -Name "$global:PROCESS" -Force}
}
Function Get-RestartsServer {
    Clear-host
    Start-Countdown -Seconds 10 -Message "Restarting server"
    Get-logo
    & "$global:currentdir\$global:server\Launch-*.ps1"
    Get-CheckForError
    Set-Location $global:currentdir
}
Function Start-Countdown {
    Param(
    [Int32]$Seconds = 10,
    [string]$Message = "Restarting server in 10 seconds...")
    ForEach ($Count in (1..$Seconds))
    {Write-Progress -Id 1 -Activity $Message -Status "Waiting for $Seconds seconds, $($Seconds - $Count) left" -PercentComplete (($Count / $Seconds) * 100)
    Start-Sleep -Seconds 1}
    Write-Progress -Id 1 -Activity $Message -Status "Completed" -PercentComplete 100 -Completed
}
Function Get-Finished {
    Get-ClearVariables
    #Get-ClearVars
    write-Host "*************************************" -ForegroundColor Yellow
    write-Host "***  Server $global:command is done!  $global:CHECKMARK ****" -ForegroundColor Yellow
    write-Host "*************************************" -ForegroundColor Yellow
    write-Host "  ./steamer start $global:server  "-ForegroundColor Black -BackgroundColor White
}
Function Get-TestInterger {
    if( $global:APPID -match '^[0-9]+$') { 
    }else{ 
    Write-Host "$global:DIAMOND $global:DIAMOND Input App ID Valid Numbers only! $global:DIAMOND $global:DIAMOND" -ForegroundColor Red -BackgroundColor Black
    pause
    exit}
}
Function Get-TestString {
    if( $global:server -match "[a-z,A-Z]") { 
    }else{
    Write-Host "$global:DIAMOND $global:DIAMOND Input Alpha Characters only! $global:DIAMOND $global:DIAMOND" -ForegroundColor Red -BackgroundColor Black
    pause
    exit}
}
Function Get-FolderNames {
    Write-Host "****   Checking Folder Names   ****" -ForegroundColor Yellow -BackgroundColor Black
    if (Test-Path "$global:currentdir\$global:server\"){
    }else{
    New-ServerFolderq}
}
Function Get-ValidateServer {
    Set-Location $global:currentdir\SteamCMD\ >$null 2>&1
    Get-Steamtxt
    Write-Host '****   Validating Server   ****' -ForegroundColor Magenta -BackgroundColor Black
    .\steamcmd +runscript Validate-$global:server.txt
    if ( !$? ){
    Write-host "****   Validating Server Failed   ****" -ForegroundColor Red
    #New-Tryagainsteamcmd
    New-TryagainNew 
    Set-Location $global:currentdir
    }elseif($?){
    write-Host "****   Validating Server succeeded   ****" -ForegroundColor Yellow}
    Set-Location $global:currentdir
}
Function Get-UpdateServer {
    Set-Location $global:currentdir\SteamCMD\ >$null 2>&1
    Get-Steamtxt
    Write-Host '****   Updating Server   ****' -ForegroundColor Magenta -BackgroundColor Black
    .\steamcmd +runscript Updates-$global:server.txt
    if ( !$?){
    Write-host "****   Downloading  Install/update server Failed   ****" -ForegroundColor Red
    #New-Tryagainsteamcmd
    New-TryagainNew 
    Set-Location $global:currentdir
    }elseif($?){
    write-Host "****   Downloading  Install/update server succeeded   ****" -ForegroundColor Yellow}
    Set-Location $global:currentdir
}
Function Get-Steam {
    $start_time = Get-Date
    $path = "$global:currentdir\steamcmd\"
    $patha = "$global:currentdir\steamcmd\steamcmd.exe" 
    If((Test-Path $path) -and (Test-Path $patha)) { 
    Write-Host '****   steamCMD already downloaded!   ****' -ForegroundColor Yellow -BackgroundColor Black} 
    Else{  
    #(New-Object Net.WebClient).DownloadFile("$global:steamurl", "steamcmd.zip")
    Write-Host '****   Downloading SteamCMD   ****' -ForegroundColor Magenta -BackgroundColor Black
    #[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;  
    Invoke-WebRequest -Uri $global:steamurl -OutFile $global:steamoutput
    if (!$?) {write-host " ****   Downloading  SteamCMD Failed   ****" -ForegroundColor Red -BackgroundColor Black 
    #New-Tryagainsteamcmd
    New-TryagainNew }
    if ($?) {write-host " ****   Downloading  SteamCMD succeeded    ****" -ForegroundColor Yellow -BackgroundColor Black}
    Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host '***   Extracting SteamCMD *****' -ForegroundColor Magenta -BackgroundColor Black 
    Expand-Archive "$global:currentdir\steamcmd.zip" "$global:currentdir\steamcmd\" -Force 
    if (!$?) {write-host " ****   Extracting SteamCMD Failed    ****" -ForegroundColor Yellow -BackgroundColor Black 
    #New-Tryagainsteamcmd
    New-TryagainNew 
}
    if ($?) {write-host " ****   Extracting SteamCMD succeeded    ****" -ForegroundColor Yellow -BackgroundColor Black}}

}
Function New-TryagainNew {
    $title    = 'Try again?'
    $question = "$global:command $global:server?"
   $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
   $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
   $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
    if ($decision -eq 0) {
        Write-Host 'Entered Y'
        if (($global:command -eq "install") -or ($global:command -eq "update")){Get-UpdateServer}
        elseif ($global:command -eq "validate"){Get-ValidateServer}
        elseif($global:command -eq "gamedig"){add-nodejs}
        elseif($global:command -eq "mcrcon"){Get-MCRcon}
        elseif($global:command -eq "backup"){add-sevenzip}
    }else{
    Write-Host 'Entered N'
   exit}
}
Function Get-ServerBuildCheck {
    Get-Steam
    Get-Steamtxt
    Set-Location $global:currentdir\SteamCMD\ >$null 2>&1
    $search="buildid"
    # public 
    $remotebuild= .\steamcmd +runscript Buildcheck-$global:server.txt  | select-string $search | Select-Object  -Index 0
#    # dev
#    $remotebuild= .\steamcmd +runscript Buildcheck-$global:server.txt  | select-string $search | Select-Object  -Index 1
#    # experimental
#    $remotebuild= .\steamcmd +runscript Buildcheck-$global:server.txt  | select-string $search | Select-Object  -Index 2
#    # hosting
#    $remotebuild= .\steamcmd +runscript Buildcheck-$global:server.txt  | select-string $search | Select-Object  -Index 3
     $remotebuild = $remotebuild -replace '\s',''
#    #$remotebuild
#  $search="buildid"
    $localbuild= get-content $global:currentdir\$global:server\steamapps\appmanifest_$global:APPID.acf  | select-string $search
    $localbuild = $localbuild -replace '\s',''
    #$localbuild
    IF (Compare-Object $remotebuild.ToString() $localbuild.ToString()){
    Write-Host "****   Avaiable Updates Server   ****" -ForegroundColor Yellow -BackgroundColor Black
    if ($global:AutoUpdate  -eq "1") {Exit}
    Write-Host "****   Removing appmanifest_$global:APPID.acf   ****" -ForegroundColor Magenta -BackgroundColor Black
    remove-Item $global:currentdir\$global:server\steamapps\appmanifest_$global:APPID.acf -Force  >$null 2>&1
    Write-Host "****   Removing Multiple appmanifest_$global:APPID.acf    ****" -ForegroundColor Magenta -BackgroundColor Black
    Remove-Item $global:currentdir\$global:server\steamapps\appmanifest_*.acf -Force  >$null 2>&1
    Get-StopServer
    Get-UpdateServer  
    }ELSE{
    Write-Host "****   No $global:server Updates found   ****" -ForegroundColor Yellow -BackgroundColor Black}
    Set-Location $global:currentdir
}
Function Get-Steamtxt {
    Write-Host "****   Check $global:server Steam runscripts txt   ****" -ForegroundColor Yellow -BackgroundColor Black
    $patha = "$global:currentdir\steamcmd\Validate-$global:server.txt"
    $pathb = "$global:currentdir\steamcmd\Updates-$global:server.txt"
    $pathc = "$global:currentdir\steamcmd\Buildcheck-$global:server.txt" 
    If((Test-Path $patha) -and (Test-Path $pathb) -and (Test-Path $pathc)){
    Write-Host '****   steamCMD Runscripts .txt Exist   ***' -ForegroundColor Yellow -BackgroundColor Black} 
    Else{  
    Write-Host "----------------------------------------------------------------------------" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "      $global:DIAMOND $global:DIAMOND Command $global:command Failed! $global:DIAMOND $global:DIAMOND" -ForegroundColor Red -BackgroundColor Black
    Write-Host "***        Try install command again          ****  " -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "----------------------------------------------------------------------------" -ForegroundColor Yellow -BackgroundColor Black
    Set-Location $global:currentdir
    Exit}
}
Function Set-SteamInfoAppID {
    $title    = 'Launch Script create'
    $question = 'Create Launch Script?'
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
    if ($decision -eq 0) {
    Read-AppID
    Write-Host 'Entered Y'
    } else {
    Write-Host 'Entered N'}
}
Function Get-GamedigServerv2 {
    Write-Host '****   Starting gamedig on Server   ****' -ForegroundColor Magenta -BackgroundColor Black
    if(( $global:AppID -eq 581330) -or ($global:AppID -eq 376030) -or ($global:AppID -eq 443030)) {
        Write-Host '****   Using QUERYPORT    ****' -ForegroundColor Yellow -BackgroundColor Black
        # Executes when the Boolean expression 1 is true
        if(($null -eq ${global:QUERYPORT} ) -or ("" -eq ${global:QUERYPORT} )){
            Write-Host '****   Missing QUERYPORT Var!   ****' -ForegroundColor Red -BackgroundColor Black
            # Executes when the Boolean expression 2 is true
            }Elseif($global:command -eq "gamedig"){
            Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64
            .\gamedig --type $global:GAME ${global:EXTIP}:${global:QUERYPORT} --pretty
            Set-Location $global:currentdir
            }elseif($global:command -eq "gamedigprivate")  {
            Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64  
            .\gamedig --type $global:GAME ${global:IP}:${global:QUERYPORT} --pretty
            Set-Location $global:currentdir}
    }ElseIf(($null -eq ${global:PORT}) -or ("" -eq ${global:PORT} )){
    Write-Host '****   Missing PORT Var!   ****' -ForegroundColor Red -BackgroundColor Black
    }Elseif($global:command -eq "gamedigprivate"){
    Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64  
    .\gamedig --type $global:GAME ${global:IP}:${global:PORT} --pretty
    Set-Location $global:currentdir
    }else{
    Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64
    .\gamedig --type $global:GAME ${global:EXTIP}:${global:PORT} --pretty
    Set-Location $global:currentdir}
     
}
Function Get-details {
    $global:Cpu = (Get-WmiObject win32_processor | Measure-Object -property LoadPercentage -Average | Select-object Average ).Average
    $host.UI.RawUI.ForegroundColor = "Cyan"
    #$host.UI.RawUI.BackgroundColor = "Black"
    #$global:cpu = Get-WmiObject win32_processor
    $global:CpuCores = (Get-WMIObject Win32_ComputerSystem).NumberOfLogicalProcessors
    $global:avmem = (Get-WmiObject Win32_OperatingSystem | ForEach-Object {"{0:N2} GB" -f ($_.totalvisiblememorysize/ 1MB)})
    $global:totalmem = "{0:N2} GB" -f ((get-process | Measure-Object Workingset -sum).Sum /1GB)
    if($Null -ne (get-process "$global:PROCESS" -ea SilentlyContinue)){
    $global:mem = "{0:N2} GB" -f ((get-process $global:PROCESS | Measure-Object Workingset -sum).Sum /1GB) }
    $global:os = (Get-WMIObject win32_operatingsystem).caption
    #$global:osInfo = Get-CimInstance Win32_OperatingSystem | Select-Object Caption, Version, ServicePackMajorVersion, OSArchitecture, CSName, WindowsDirectory
    #$global:bit = (Get-WmiObject Win32_OperatingSystem).OSArchitecture
    $global:computername = (Get-WmiObject Win32_OperatingSystem).CSName
    Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64
    if($null -ne ${global:QUERYPORT}) {${global:PORT} = ${global:QUERYPORT}}
    $global:gameresponse = (.\gamedig --type $global:GAME ${global:EXTIP}:${global:PORT} --pretty | Select-String -Pattern 'game' -CaseSensitive -SimpleMatch)
    $global:stats = (.\gamedig --type $global:GAME ${global:EXTIP}:${global:PORT} --pretty | Select-String -Pattern 'ping' -CaseSensitive -SimpleMatch)
    Get-createdvaribles
    New-BackupFolder
    $global:backups = (get-childitem -Path $global:currentdir\backups -recurse | measure-Object) 
    $global:backups = $backups.count 
    $global:backupssize = "{0:N2} GB" -f ((Get-ChildItem $global:currentdir\backups | Measure-Object Length -s -ea silentlycontinue ).Sum /1GB) 
    if(($global:AppID -eq 302200)) {$global:gameresponse = "Not supported"}
    #Get-WmiObject -Class Win32_Product -Filter "Name LIKE '%Visual C++ 2010%'"
    Write-host "                                "
    Write-host "    Server Name       : $HOSTNAME"
    Write-host "    Public IP         : $EXTIP"
    Write-host "    IP                : $IP"
    Write-host "    Port              : $PORT"
    Write-host "    Query Port        : $QUERYPORT"
    Write-host "    Rcon Port         : $RCONPORT"
    Write-host "    App ID            : $APPID"
    Write-host "    Game Dig          : $GAME"
#    Write-host "    Webhook           : $WEBHOOK"
    Write-host "    Process           : $PROCESS"
    Write-host "    Process status    : "-NoNewline;;if($Null -eq (get-process "$global:PROCESS" -ea SilentlyContinue)){$global:status=" ----NOT RUNNING----";;Write-Host $status -F Red}else{$global:status=" **** RUNNING ****";;Write-Host $status -F Green}
    Write-host "    CPU Cores         : $CpuCores"
    Write-host "    CPU %             : $cpu"
    Write-host "    Total RAM         : $avmem    "
    Write-host "    Total RAM Usage   : $totalmem"
    Write-host "    Process RAM Usage : $mem"
    Write-host "    Backups           : $backups"
    Write-host "    Backups size GB   : $backupssize"
    Write-host "    Status            : "-NoNewline;;if($Null -eq $global:stats){$global:stats="----Offline----";;Write-Host $stats -F Red}else{$global:stats="**** Online ***";;Write-Host $stats -F Green}
    Write-host "    game replied      : $gameresponse"
    Write-host "    OS                : $os"
    Write-host "    hostname          : $computername"
}
function Get-DriveSpace {
    $global:disks = get-wmiobject -class "Win32_LogicalDisk" -namespace "root\CIMV2" -computername $env:COMPUTERNAME
    $global:results = foreach ($disk in $disks){
        if ($disk.Size -gt 0){
            $size = [math]::round($disk.Size/1GB, 0)
            $free = [math]::round($disk.FreeSpace/1GB, 0)
            [PSCustomObject]@{
                Drive = $disk.Name
                Name = $disk.VolumeName
                "Total Disk GB" = $size
                "Free Disk GB"  = "{0:N0} ({1:P0})" -f $free, ($free/$size)}
        }
    }
    #$results | Out-GridView
    $global:results | Format-Table -AutoSize
    Set-Location $global:currentdir
    #$results | Export-Csv -Path .\disks.csv -NoTypeInformation -Encoding ASCII
}
Function New-ServerFolderq {
    $title    = 'Server Folder Name does not exist!'
    $question = 'Would you like to to create new Server Folder Name?'
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
    if ($decision -eq 0) {
    Write-Host 'Entered Y'
    $global:command = "install"
    Select-Steamer $global:command $global:server}
    else {
    Write-Host 'Entered N'
    exit}
}
Function New-ServerFolder {   
    ##-- Create Folder for Server -- In current folder
   if((!$global:server) -or ($global:server -eq " ")){
   Write-Host "****   You Entered a null or Empty   ****" -ForegroundColor Red -BackgroundColor Black
   Select-Steamer
   }elseif (($null -eq $global:APPID ) -or ($global:APPID -eq " ")){
   Write-Host "****   You Entered a space or Empty   ****" -ForegroundColor Red -BackgroundColor Black
   Select-Steamer
   }elseif(Test-Path "$global:currentdir\$global:server\" ){
   Write-Host '****   Server Folder Already Created!   ****' -ForegroundColor Yellow -BackgroundColor Black
   }else{
   Write-Host '****   Creating Server Folder   ****' -ForegroundColor Magenta -BackgroundColor Black 
   New-Item -Path . -Name "$global:server" -ItemType "directory"}
}
Function Get-CheckForVars {
    Write-Host "****   Checking for Vars   ****" -ForegroundColor Yellow -BackgroundColor Black
    if(($global:command -eq "mcrcon") -or($global:command -eq "mcrconPrivate")){
    $global:missingvars = $global:RCONPORT,$global:RCONPASSWORD
    }else{
    $global:missingvars = ${global:QUERYPORT},${global:IP},$global:APPID,$global:PROCESS}
    foreach($global:missingvars in $global:missingvars){
    if ( "" -eq $global:missingvars){
    Write-Host "----------------------------------------------------------------------------" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "$global:DIAMOND $global:DIAMOND Missing Vars ! $global:DIAMOND $global:DIAMOND" -ForegroundColor Red -BackgroundColor Black
    Write-Host "Try install command again or check vars in Variables-$global:server.ps1" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "----------------------------------------------------------------------------" -ForegroundColor Yellow -BackgroundColor Black
    exit}
    }
}
Function Get-CheckForError {
    if (!$?) {
    Write-Host "----------------------------------------------------------------------------" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "      $global:DIAMOND $global:DIAMOND Command $global:command Failed! $global:DIAMOND $global:DIAMOND" -ForegroundColor Red -BackgroundColor Black
    Write-Host "***        Try install command again          ****  " -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "----------------------------------------------------------------------------" -ForegroundColor Yellow -BackgroundColor Black
    Exit}
}

Function set-connectMCRcon {
    set-location $global:currentdir\mcrcon\mcrcon-0.7.1-windows-x86-32
    .\mcrcon.exe -t -H $global:EXTIP -P $global:RCONPORT -p $global:RCONPASSWORD
    set-location $global:currentdir
}
Function set-connectMCRconP {
    set-location $global:currentdir\mcrcon\mcrcon-0.7.1-windows-x86-32
    .\mcrcon.exe -t -H $global:IP -P $global:RCONPORT -p $global:RCONPASSWORD
    set-location $global:currentdir
}
Function Get-MCRcon {
    $start_time = Get-Date
    $path = "$global:currentdir\mcrcon\"
    $patha = "$global:currentdir\mcrcon\mcrcon-0.7.1-windows-x86-32\mcrcon.exe" 
    If((Test-Path $path) -and (Test-Path $patha)){ 
    Write-Host '****   mcrcon already downloaded!   ****' -ForegroundColor Yellow -BackgroundColor Black} 
    Else{  
    $start_time = Get-Date
    Write-Host '****   Downloading MCRCon from github   ****' -ForegroundColor Magenta -BackgroundColor Black 
    #(New-Object Net.WebClient).DownloadFile("$global:metamodurl", "$global:currentdir\metamod.zip")
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest -Uri $global:mcrconurl -OutFile $global:currentdir\mcrcon.zip
    if (!$?) {write-host "****   Downloading  MCRCon Failed   ****" -ForegroundColor Red -BackgroundColor Black 
    #New-TryagainMC
    New-TryagainNew 
    }
    if ($?) {write-host "****   Downloading  MCRCon succeeded   ****" -ForegroundColor Yellow -BackgroundColor Black}
    Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host '****   Extracting MCRCon from github   ****' -ForegroundColor Magenta -BackgroundColor Black
    Expand-Archive "$global:currentdir\mcrcon.zip" "$global:currentdir\mcrcon\" -Force
    if (!$?) {write-host "****   Extracting MCRCon Failed   ****" -ForegroundColor Yellow -BackgroundColor Black 
    #New-TryagainMC
    New-TryagainNew 
}
    if ($?) {write-host "****   Extracting MCRCon succeeded   ****" -ForegroundColor Yellow -BackgroundColor Black}}
}

Function New-DiscordAlert {
    if ( "" -eq $global:WEBHOOK) {
    Write-Host "$global:DIAMOND $global:DIAMOND Missing WEBHOOK ! $global:DIAMOND $global:DIAMOND"-ForegroundColor Red -BackgroundColor Black
    Write-Host "****   Add Discord  WEBHOOK to $global:currentdir\$global:server\Variables-$global:server.ps1   ****" -ForegroundColor Yellow -BackgroundColor Black    
    }Else {
    Write-Host '****   Sending Discord Alert   ****' -ForegroundColor Magenta -BackgroundColor Black
    $webHookUrl     = "$global:WEBHOOK"
    [System.Collections.ArrayList]$embedArray = @()
    $title          = "$global:HOSTNAME"
    $description    = 'Server not Running, Starting Server!'
    $color          = '16711680'
    $embedObject    = [PSCustomObject]@{
    title           = $title       
    description     = $description  
    color           = $color}                              
    $embedArray.Add($embedObject) | Out-Null
    $payload        = [PSCustomObject]@{
    embeds          = $embedArray}                              
    Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json -Depth 4) -Method Post -ContentType 'application/json'}
}
Function Set-Console {
    clear-host
    $host.ui.RawUi.WindowTitle = "-------- STEAMER ------------"
    [console]::ForegroundColor="Green"
    [console]::BackgroundColor="Black"
    [console]::WindowWidth=150; [console]::WindowHeight=125; [console]::BufferWidth=[console]::WindowWidth
    #$host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size(200,5000)
    if ($global:admincheckmessage -eq "1") {
    Get-AdminCheck
    Get-logo
    }else{
    Get-logo}
}
Function Get-logo {
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
    if($isInGroup -eq $true){
    Write-Host "----------------------------------------------------------------------------" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "                 $global:DIAMOND $global:DIAMOND Do Not Run as an Admin account $global:DIAMOND $global:DIAMOND" -ForegroundColor Red -BackgroundColor Black
    Write-Host "***  Please Create a Non Admin Account to run script and game server  ******" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "----------------------------------------------------------------------------" -ForegroundColor Yellow -BackgroundColor Black}
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
    stop-PROCESS -Id $PID
}
Function Get-NodeJS {
    $path = "$global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64"
    $patha = "$global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64\node.exe"
    $pathb = "node-v$global:nodeversion-win-x64.zip"
    write-host "****   Checking for Nodejs   ****" -ForegroundColor Magenta -BackgroundColor Black     
    If((Test-Path $path) -and (Test-Path $pathb) -and (Test-Path $patha)){ 
    Write-Host '****   NodeJS already downloaded!   ****' -ForegroundColor Yellow -BackgroundColor Black
    }else {
    write-host "****   NodeJS not found   ****" -ForegroundColor Yellow -BackgroundColor Black
    add-nodejs}
}
Function add-nodejs {
    $start_time = Get-Date
    Write-Host '****   Downloading  Nodejs   ****' -ForegroundColor Magenta -BackgroundColor Black  
    #(New-Object Net.WebClient).DownloadFile("$global:nodejsurl", "$global:currentdir\node-v$global:nodeversion-win-x64.zip")
    #[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest -Uri $global:nodejsurl -OutFile $global:currentdir\node-v$global:nodeversion-win-x64.zip
    if (!$?) {write-host "****   Downloading  Nodejs Failed    ****" -ForegroundColor Red -BackgroundColor Black 
    #New-TryagainN
    New-TryagainNew}
    if ($?) {write-host "****   Downloading  Nodejs succeeded   ****" -ForegroundColor Yellow -BackgroundColor Black}
    Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host '****   Extracting Nodejs   *****' -ForegroundColor Magenta -BackgroundColor Black
    Expand-Archive "$global:currentdir\node-v$global:nodeversion-win-x64.zip" "$global:currentdir\node-v$global:nodeversion-win-x64\" -Force
    if (!$?) {write-host "****   Extracting Nodejs Failed   ****" -ForegroundColor Yellow -BackgroundColor Black 
    #New-TryagainN
    New-TryagainNew}
    if ($?) {write-host "****   Extracting Nodejs succeeded   ****" -ForegroundColor Yellow -BackgroundColor Black}
    Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64
    Write-Host '****   Installing gamedig in Nodejs   ****' -ForegroundColor Magenta -BackgroundColor Black
    Write-Host '****   Do not stop or cancel! Will need to delete nodejs files and start over!   ****' -ForegroundColor Yellow -BackgroundColor Black  
    .\npm install gamedig
    .\npm install gamedig -g
    Set-Location $global:currentdir
}
Function New-CreateVariables {
    Write-Host '*** Creating Variables Script ****' -ForegroundColor Magenta -BackgroundColor Black 
    New-Item $global:currentdir\$global:server\Variables-$global:server.ps1 -Force
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "# WEBHOOK HERE - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:WEBHOOK = `"$global:WEBHOOK`""
    if ($global:MODDIR) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Mod dir - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:MODDIR = `"$global:MODDIR`""}
    if ($global:EXEDIR) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  exe dir - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:MODDIR = `"$global:EXEDIR`""}
    if ($global:GAME) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Game name used by Gamedig - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:game = `"$global:GAME`""}
    if ($global:PROCESS) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  PROCESS name - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:PROCESS = `"$global:PROCESS`""}
    if (${global:IP}) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Server IP - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`${global:IP} = `"${global:IP}`""}
    if (${global:PORT}) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Server PORT - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`${global:PORT} = `"${global:PORT}`""}
    if ($global:SOURCETVPORT) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Server Source TV Port - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:SOURCETVPORT = `"$global:SOURCETVPORT`""}
    if ($global:CLIENTPORT) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  server client port- - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:CLIENTPORT = `"$global:CLIENTPORT`""}
    if ($global:MAP) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  default Map- - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:MAP = `"$global:MAP`""}
    if ($global:TICKRATE) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  server tick rate - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:TICKRATE = `"$global:TICKRATE`""} 
    if ($global:GSLT) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Gamer Server token - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:GSLT = `"$global:GSLT`""}
    if ($global:MAXPLAYERS) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Max Players  - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:MAXPLAYERS = `"$global:MAXPLAYERS`""}
    if ($global:WORKSHOP) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Workshop 1/0 HERE - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:WORKSHOP = `"$global:WORKSHOP`""}
    if ($global:HOSTNAME) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Server Name - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:HOSTNAME = `"$global:HOSTNAME`""}
    if (${global:QUERYPORT}) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  query port - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`${global:QUERYPORT} = `"${global:QUERYPORT}`""}
    if ($global:SAVES) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  local App Data SAVES folder - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:SAVES = `"$global:SAVES`""}
    if ($global:APPID) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  App ID  - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:APPID = `"$global:APPID`""}
    if ($global:RCONPORT) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Rcon Port  - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:RCONPORT = `"$global:RCONPORT`""}
    if ($global:RCONPASSWORD) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Rcon Password HERE - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:RCONPASSWORD = `"$global:RCONPASSWORD`""}
    if ($global:SV_PURE) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Extra Launch Parms - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:SV_PURE = `"$global:SV_PURE`""}
    if ($global:SCENARIO) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "# Sandstorm SCENARIO   - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:SCENARIO = `"$global:SCENARIO`""}
    if ($global:GAMETYPE) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "# CSGO Gametype   - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:GAMETYPE = `"$global:GAMETYPE`""}
    if ($global:GAMEMODE) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "# CSGO Gamemode   - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:GAMEMODE = `"$global:GAMEMODE`""}
    if ($global:MAPGROUP) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "# CSGO mapgroup   - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:MAPGROUP = `"$global:MAPGROUP`""}
    if ($global:AppID -eq 740) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "# CSGO WSCOLLECTIONID   - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:WSCOLLECTIONID = `"$global:WSCOLLECTIONID`""}
    if ($global:AppID -eq 740) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "# CSGO WSSTARTMAP  - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:WSSTARTMAP= `"$global:WSSTARTMAP`""}
    if ($global:AppID -eq 740) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "# CSGO WSAPIKEY   - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:WSAPIKEY = `"$global:WSAPIKEY`""}
}
Function Get-SourceMetMod {
    $title    = 'Download MetaMod and SourceMod'
    $question = 'Download MetaMod, SourceMod and install?'
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
    if ($decision -eq 0) {
    Get-SourceMetaMod
    Write-Host 'Entered Y'} 
    else {
    Write-Host 'Entered N'}
}
Function Get-SourceMetaMod {
    $start_time = Get-Date
    Write-Host '****   Downloading Meta Mod   ****' -ForegroundColor Magenta -BackgroundColor Black 
    #(New-Object Net.WebClient).DownloadFile("$global:metamodurl", "$global:currentdir\metamod.zip")
    #[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest -Uri $global:metamodurl -OutFile $global:currentdir\metamod.zip
    if (!$?) {write-host "****   Downloading Meta Mod Failed !!   ****" -ForegroundColor Red -BackgroundColor Black ;; Exit} 
    Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host '****   Extracting Meta Mod   ****' -ForegroundColor Magenta -BackgroundColor Black
    Expand-Archive "$global:currentdir\metamod.zip" "$global:currentdir\metamod\" -Force
    if (!$?) {write-host "****   Extracting Meta Mod Failed !!   ****" -ForegroundColor Red -BackgroundColor Black ;; Exit}
    Write-Host '****   Copying/installing Meta Mod   ****' -ForegroundColor Magenta -BackgroundColor Black 
    Copy-Item -Path $global:currentdir\metamod\* -Destination $global:currentdir\$global:server\$global:MODDIR -Force -Recurse
    if (!$?) {write-host "****   Copying Meta Mod Failed !!   ****" -ForegroundColor Red -BackgroundColor Black ;; Exit}
    $start_time = Get-Date
    Write-Host '****   Downloading SourceMod   ****' -ForegroundColor Magenta -BackgroundColor Black
    #(New-Object Net.WebClient).DownloadFile("$global:sourcemodurl", "$global:currentdir\sourcemod.zip")
    #[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest -Uri $global:sourcemodurl -OutFile $global:currentdir\sourcemod.zip
    if (!$?) {write-host "****   Downloading SourceMod Failed !!   ****" -ForegroundColor Red -BackgroundColor Black ;; Exit} 
    Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host '****   Extracting SourceMod   ****' -ForegroundColor Magenta -BackgroundColor Black 
    Expand-Archive "$global:currentdir\sourcemod.zip" "$global:currentdir\sourcemod\" -Force
    if (!$?) {write-host "****   Extracting SourceMod Failed !!   ****" -ForegroundColor Red -BackgroundColor Black ;; Exit}
    Write-Host '****   Copying/installing SourceMod   ****' -ForegroundColor Magenta -BackgroundColor Black
    Copy-Item -Path $global:currentdir\sourcemod\* -Destination $global:currentdir\$global:server\$global:MODDIR -Force -Recurse
    if (!$?) {write-host "****   Copying SourceMod Failed !!   ****" -ForegroundColor Red -BackgroundColor Black ;; Exit}
}
Function Get-OxideQ {
    $title    = 'Download Oxide'
    $question = 'Download Oxide and install?'
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
    if ($decision -eq 0) {
    Get-Oxide
    Write-Host 'Entered Y'} 
    else{
    Write-Host 'Entered N'}
}
Function Get-Oxide {
    $start_time = Get-Date
    Write-Host '****   Downloading Oxide   ****' -ForegroundColor Magenta -BackgroundColor Black
    #(New-Object Net.WebClient).DownloadFile("$global:oxiderustlatestlink", "$global:currentdir\oxide.zip")
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest -Uri $global:oxiderustlatestlink -OutFile $global:currentdir\oxide.zip
    if (!$?) {write-host "****   Downloading Oxide Failed !!   ****" -ForegroundColor Red -BackgroundColor Black ;; Exit} 
    Write-Host "Download Time: $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host '****   Extracting Oxide    ****' -ForegroundColor Magenta -BackgroundColor Black
    Expand-Archive "$global:currentdir\oxide.zip" "$global:currentdir\oxide\" -Force
    if (!$?) {write-host "****   Extracting Oxide Failed !!   ****" -ForegroundColor Red -BackgroundColor Black ;; Exit}
    Write-Host '****   Copying Oxide *****' -ForegroundColor Magenta -BackgroundColor Black
    Copy-Item -Path $global:currentdir\oxide\$global:MODDIR\* -Destination $global:currentdir\$global:server\$global:MODDIR\ -Force -Recurse
    if (!$?) {write-host "****   Copying Oxide Failed !!   ****" -ForegroundColor Red -BackgroundColor Black ;; Exit}
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
    $Action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "`"If (!(Get-PROCESS '$global:PROCESS')) {$global:currentdir\steamer.ps1 start $global:server ;; $global:currentdir\steamer.ps1 discord $global:server }`"" -WorkingDirectory "$global:currentdir"
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
    $Action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "`"If (!(Get-PROCESS '$global:PROCESS')) {$global:currentdir\steamer.ps1 start $global:server ;; $global:currentdir\steamer.ps1 discord $global:server }`"" -WorkingDirectory "$global:currentdir"
    $Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).Date -RepetitionInterval (New-TimeSpan -Minutes 5) 
    $Settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit '00:00:00'
    $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings
    Write-Host "Creating Task........" -ForegroundColor Magenta -BackgroundColor Black
    Register-ScheduledTask -TaskName "$global:server monitor" -InputObject $Task -User "$UserName" -Password "$Password"
}
Function Set-MonitorJob {
    $title    = 'Create Monitor Task Job'
    $question = 'Run Task Whether user is logged on or not?'
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    if ($decision -eq 0) {
    Write-Host 'Entered Y'
    Get-ChecktaskUnreg
    New-MontiorJobBG
    } else {
    Write-Host 'Entered N'
    Get-ChecktaskUnreg
    New-MontiorJob}
}
Function Set-RestartJob {
    $title    = 'Create Restart Task Job'
    $question = 'Run Task Whether user is logged on or not?'
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    if ($decision -eq 0) {
    Write-Host 'Entered Y'
    Get-ChecktaskUnreg
    New-RestartJobBG
    } else {
    Write-Host 'Entered N'
    Get-ChecktaskUnreg
    New-RestartJob}
} 
Function Get-ChecktaskUnreg {
    Get-ScheduledTask -TaskName "$global:server $global:command" >$null 2>&1
    if ($?) {
    Write-Host '****   Unregistering scheduled task   ****' -ForegroundColor Magenta -BackgroundColor Black
    Unregister-ScheduledTask -TaskName "$global:server $global:command" >$null 2>&1}
    if (!$?) {
    Write-Host "****   Scheduled Task does not exist   ****" -ForegroundColor Yellow -BackgroundColor Black}
}
Function Get-ChecktaskDisable {
    Get-ScheduledTask -TaskName "$global:server monitor" >$null 2>&1
    if ($?) {
    Write-Host '****   disabling scheduled task   ****' -ForegroundColor Magenta -BackgroundColor Black
    Disable-ScheduledTask -TaskName "$global:server monitor" >$null 2>&1}
    if (!$?) {
    Write-Host "****   Scheduled Task does not exist   ****" -ForegroundColor Yellow -BackgroundColor Black}
}
Function Get-ChecktaskEnable {
    Get-ScheduledTask -TaskName "$global:server monitor" >$null 2>&1
    if ($?) {
    Write-Host '****   Enabling scheduled task   ****' -ForegroundColor Magenta -BackgroundColor Black
    Enable-ScheduledTask -TaskName "$global:server monitor" >$null 2>&1}
    if (!$?) {
    write-host "****   Scheduled Task does not exist   ****" -ForegroundColor Yellow -BackgroundColor Black}
}
Function New-BackupFolder {
    $path = "$global:currentdir\backups" 
    If(Test-Path $path) { 
    Write-Host '****   Backup folder exists!   ****' -ForegroundColor Yellow -BackgroundColor Black} 
    Else {  
    Write-Host '****   Creating backup folder   ****' -ForegroundColor Magenta -BackgroundColor Black
    New-Item -Path "$global:currentdir\" -Name "backups" -ItemType "directory"}
}
Function New-BackupServer {
    Write-Host '****   Server Backup Started!   ****' -ForegroundColor Magenta -BackgroundColor Black
    Set-Location $global:currentdir\7za920\
    Get-ChildItem $global:currentdir\backups\ -Recurse | where-object name -like Backup_$global:server-*.zip | Sort-Object CreationTime -desc | Select-Object -Skip $global:backupcount | Remove-Item -Force 
    #Get-ChildItem $global:currentdir\backups\ -Recurse | where-object {-like Backup_$global:server-*.zip}| Sort-Object CreationTime -desc | Select-Object -Skip $global:backupcount | Remove-Item -Force
    #./7za a $global:currentdir\backups\Backup_$global:server-$BackupDate.zip $global:currentdir\$global:server\* -an > backup.log
    ./7za a $global:currentdir\backups\Backup_$global:server-$global:Date.zip $global:currentdir\$global:server\* > backup.log
    Write-Host '****   Server Backup is Done!   ****' -ForegroundColor Yellow -BackgroundColor Black
    write-host "****   Checking Save location(appData)   ****" -ForegroundColor Yellow -BackgroundColor Black
    if ($global:appdatabackup   -eq "1") {Get-savelocation}
    if ($global:backuplog   -eq "1") {.\backup.log}
    Set-Location $global:currentdir
}
Function Get-SevenZip {
    $path = "$global:currentdir\7za920\"
    $patha = "$global:currentdir\7za920\7za.exe"
    $pathb = "$global:currentdir\7za920.zip"
    Write-Host '****   Checking for 7ZIP   *****' -ForegroundColor Yellow -BackgroundColor Black   
    If((Test-Path $path) -and (Test-Path $patha) -and (Test-Path $pathb)) { 
    Write-Host '****   7Zip already downloaded!   ****' -ForegroundColor Yellow -BackgroundColor Black}
    else {
    write-host "****   7Zip not found!   ****" -ForegroundColor Yellow -BackgroundColor Black
    add-sevenzip}  
}
Function add-sevenzip {
    $start_time = Get-Date
    Write-Host '****   Downloading 7ZIP   ****' -ForegroundColor Magenta -BackgroundColor Black 
    #(New-Object Net.WebClient).DownloadFile("$global:sevenzip", "$global:currentdir\7za920.zip")
    #[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest -Uri $global:sevenzip -OutFile $global:currentdir\7za920.zip
    if (!$?) {
    write-host "****   7Zip Download Failed   *****" -ForegroundColor Yellow -BackgroundColor Black
    #New-Tryagain
    New-TryagainNew 
}
    if ($?) {
    write-host "****   7Zip  Download succeeded   ****" -ForegroundColor Yellow -BackgroundColor Black}
    Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host '****   Extracting 7ZIP   *****' -ForegroundColor Magenta -BackgroundColor Black 
    Expand-Archive "$global:currentdir\7za920.zip" "$global:currentdir\7za920\" -Force
    if (!$?) {
    write-host "****   7Zip files did not Extract   ****" -ForegroundColor Yellow -BackgroundColor Black
    #New-Tryagain
    New-TryagainNew 
}
    if ($?) {
    write-host "****   7Zip Extract succeeded   ****" -ForegroundColor Yellow -BackgroundColor Black}
}

Function New-backupAppdata {
    Write-Host '****   Server App Data Backup Started!   ****' -ForegroundColor Magenta -BackgroundColor Black
    Set-Location $global:currentdir\7za920\ 
    ./7za a $global:currentdir\backups\AppDataBackup_$global:server-$global:Date.zip $env:APPDATA\$global:saves\* > AppDatabackup.log
    Write-Host '****   Server App Data Backup is Done!   ****' -ForegroundColor Yellow -BackgroundColor Black
    if ($global:appdatabackuplog  -eq "1") {.\AppDatabackup.log}
}
Function Get-savelocation {
    if(("" -eq $global:saves) -or ($null -eq $global:saves )){
    Write-Host "****   No saves located in App Data   ****" -ForegroundColor Yellow -BackgroundColor Black 
    }else{
    New-AppDataSave}
}
Function New-AppDataSave {
    $title    = 'Game has Saves located in AppData'
    $question = 'Backup Appdata for server?'
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
    if ($decision -eq 0) {
    Write-Host 'Entered Y'
    New-backupAppdata} 
    else {
    Write-Host 'Entered N'
    exit}
}
Function Get-Servercfg {
    Write-Host "****   Retrieve Default Config   ****" -ForegroundColor Yellow -BackgroundColor Black
    #(New-Object Net.WebClient).DownloadFile("$global:githuburl/${gamedirname}/${config1}", "$global:currentdir\$global:server\csgo\cfg\server.cfg")
    if(("" -eq $global:SERVERCFGDIR) -or ("" -eq $global:config1)){Exit
    }Elseif($null-eq $global:config2){$global:SERVERCFG = "$global:config1"
    }Elseif($null-eq $global:config3){$global:SERVERCFG = "$global:config1","$global:config2"
    }Elseif($null-eq $global:config4){$global:SERVERCFG = "$global:config1","$global:config2","$global:config3"
    }Elseif($null-eq $global:config5){$global:SERVERCFG = "$global:config1","$global:config2","$global:config3","$global:config4"
    }Else{$global:SERVERCFG = "$global:config1","$global:config2","$global:config3","$global:config4","$global:config5"}
    foreach ($global:SERVERCFG in $global:SERVERCFG) {
    write-host "****   Retrieve server config GSM   ****" -ForegroundColor Magenta -BackgroundColor Black
    $WebResponse=Invoke-WebRequest "$global:githuburl/$global:gamedirname/$global:SERVERCFG"
    if (!$?) {write-host "****   Array Failed !! Did NOT Retrieve server config   ****" -ForegroundColor Red -BackgroundColor Black ;; Exit}
    New-Item $global:currentdir\$global:server\$global:SERVERCFGDIR\$global:SERVERCFG -Force
    Add-Content $global:currentdir\$global:server\$global:SERVERCFGDIR\$global:SERVERCFG $WebResponse}
}
Function Read-AppID {
    if($global:AppID -eq 302200){
    Set-Console  >$null 2>&1
    New-LaunchScriptMiscreatedPS
    } elseif($global:AppID -eq 294420){
    Set-Console  >$null 2>&1
    New-LaunchScriptSdtdserverPS
    } elseif($global:AppID -eq 237410){
    Set-Console  >$null 2>&1
    New-LaunchScriptInsserverPS
    } elseif($global:AppID -eq 581330){
    Set-Console  >$null 2>&1
    New-LaunchScriptInssserverPS
    } elseif($global:AppID -eq 233780){
    Set-Console  >$null 2>&1
    New-LaunchScriptArma3serverPS
    } elseif($global:AppID -eq 258550){
    Set-Console  >$null 2>&1
    New-LaunchScriptRustPS
    } elseif($global:AppID -eq 376030){
    Set-Console  >$null 2>&1
    New-LaunchScriptArkPS
    } elseif($global:AppID -eq 462310){
    Set-Console  >$null 2>&1
    New-LaunchScriptdoiserverPS
    } elseif($global:AppID -eq 740){
    Set-Console  >$null 2>&1
    New-LaunchScriptcsgoserverPS
    } elseif($global:AppID -eq 530870){
    Set-Console  >$null 2>&1
    New-LaunchScriptempserverPS
    } elseif($global:AppID -eq 443030){
    Set-Console  >$null 2>&1
    New-LaunchScriptceserverPS
    } elseif($global:AppID -eq 565060){
    Set-Console  >$null 2>&1
    New-LaunchScriptavserverPS
    } elseif($global:AppID -eq 232130){
    Set-Console  >$null 2>&1
    New-LaunchScriptKF2serverPS
    } elseif($global:AppID -eq 222860){
    Set-Console  >$null 2>&1
    New-LaunchScriptLFD2serverPS
    } elseif($global:AppID -eq 454070){
    Set-Console  >$null 2>&1
    New-LaunchScriptboundelserverPS
    } elseif($global:AppID -eq 556450){
    Set-Console  >$null 2>&1
    New-LaunchScriptforestserverPS
    } elseif($global:AppID -eq 17515){
    Set-Console  >$null 2>&1
    New-LaunchScriptAoCserverPS
    } elseif($global:AppID -eq 302550){
    Set-Console  >$null 2>&1
    New-LaunchScriptacserverPS
    } elseif($global:AppID -eq 635){
    Set-Console  >$null 2>&1
    New-LaunchScriptasserverPS
    } else {
    Write-Host "No Launch Script Found for this server" -ForegroundColor Yellow -BackgroundColor Black
    exit}
}