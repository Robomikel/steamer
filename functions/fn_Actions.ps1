#----------      Install server as Anon     ----------------------
Function Install-Anonserver {
    Write-Host '*** Creating SteamCMD Run txt *****' -ForegroundColor Magenta -BackgroundColor Black 
    New-Item $global:currentdir\SteamCMD\Updates-$global:server.txt -Force
    Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "@ShutdownOnFailedCommand 1"
    Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "@NoPromptForPassword 1"
    Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "login anonymous"
    Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "force_install_dir $global:currentdir\$global:server"
    Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "app_update $global:APPID $global:Branch"
    Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "exit"
    New-Item -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Force
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "@ShutdownOnFailedCommand 1"
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "@NoPromptForPassword 1"
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "login anonymous"
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "force_install_dir $global:currentdir\$global:server"
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "app_update $global:APPID $global:Branch validate"
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "exit"
    Get-UpdateServer
    Set-Location $global:currentdir
}
#--------- Install server as User  -----------------
Function Install-Server {
    Write-Host "Enter Username for Steam install, Steam.exe will prompt for Password and Steam Gaurd" -ForegroundColor Cyan -BackgroundColor Black  
    $global:username = Read-host
    Write-Host '*** Creating SteamCMD Run txt *****' -ForegroundColor Magenta -BackgroundColor Black 
    New-Item $global:currentdir\SteamCMD\Updates-$global:server.txt -Force
    Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "@ShutdownOnFailedCommand 1"
    Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "login $global:username"
    Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "force_install_dir $global:currentdir\$global:server"
    Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "app_update $global:APPID $global:Branch"
    Add-Content -Path $global:currentdir\SteamCMD\Updates-$global:server.txt -Value "exit"
    New-Item -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Force
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "@ShutdownOnFailedCommand 1"
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "login $global:username"
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "force_install_dir $global:currentdir\$global:server"
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "app_update $global:APPID $global:Branch validate"
    Add-Content -Path $global:currentdir\SteamCMD\Validate-$global:server.txt -Value "exit"
    Get-UpdateServer
    Set-Location $global:currentdir     
}

Function Get-createdvaribles {
    Write-Host "*** Getting Server Variables *****" -ForegroundColor Yellow -BackgroundColor Black  
    .$global:currentdir\$global:server\Variables-$global:server.ps1
    Get-CheckForError
}

Function Get-ClearVars {
    Write-Host "*** Clearing Variables *****" -ForegroundColor Yellow -BackgroundColor Black 
    #Remove-Variable * -ErrorAction SilentlyContinue
    #Remove-Variable * -ErrorAction SilentlyContinue
    Clear-Variable W* -ErrorAction SilentlyContinue
    Clear-Variable E* -ErrorAction SilentlyContinue
    Clear-Variable G* -ErrorAction SilentlyContinue
    Clear-Variable P* -ErrorAction SilentlyContinue
    Clear-Variable I* -ErrorAction SilentlyContinue
    Clear-Variable S* -ErrorAction SilentlyContinue
    Clear-Variable C* -ErrorAction SilentlyContinue
    Clear-Variable M* -ErrorAction SilentlyContinue
    Clear-Variable T* -ErrorAction SilentlyContinue
    Clear-Variable H* -ErrorAction SilentlyContinue
    Clear-Variable Q* -ErrorAction SilentlyContinue
    Clear-Variable A* -ErrorAction SilentlyContinue
    Clear-Variable R* -ErrorAction SilentlyContinue
    
    Remove-Variable W* -ErrorAction SilentlyContinue
    Remove-Variable E* -ErrorAction SilentlyContinue
    Remove-Variable G* -ErrorAction SilentlyContinue
    Remove-Variable P* -ErrorAction SilentlyContinue
    Remove-Variable I* -ErrorAction SilentlyContinue
    Remove-Variable S* -ErrorAction SilentlyContinue
    Remove-Variable C* -ErrorAction SilentlyContinue
    Remove-Variable M* -ErrorAction SilentlyContinue
    Remove-Variable T* -ErrorAction SilentlyContinue
    Remove-Variable H* -ErrorAction SilentlyContinue
    Remove-Variable Q* -ErrorAction SilentlyContinue
    Remove-Variable A* -ErrorAction SilentlyContinue
    Remove-Variable R* -ErrorAction SilentlyContinue
}
Function Select-launchServer {
    Write-Host '*** Starting Launch script *****' -ForegroundColor Yellow -BackgroundColor Black  
    & "$global:currentdir\$global:server\Launch-*.ps1"
    Get-CheckForError
    Set-Location $global:currentdir
}

Function Get-CheckServer {
    Write-Host '*** Check  Server PROCESS *****' -ForegroundColor Yellow -BackgroundColor Black 
    if($Null -eq (get-PROCESS "$global:PROCESS" -ea SilentlyContinue)){
    Write-Host "----NOT RUNNING----" -ForegroundColor Red -BackgroundColor Black}else{Write-Host "**** RUNNING ***" -ForegroundColor Green -BackgroundColor Black ;; Get-PROCESS "$global:PROCESS" ;; exit}
    Get-CheckForError
}

Function Get-StopServer {
    Write-Host '*** Stopping Server PROCESS *****' -ForegroundColor Magenta -BackgroundColor Black 
    if($Null -eq (get-PROCESS "$global:PROCESS" -ea SilentlyContinue)){
    Write-Host "----NOT RUNNING----" -ForegroundColor Red -BackgroundColor Black}else{stop-PROCESS -Name "$global:PROCESS" -Force}
    Get-CheckForError
}

Function Get-ValidateServer {
    Write-Host '*** Validating Server *****' -ForegroundColor Magenta -BackgroundColor Black
     Set-Location $global:currentdir\SteamCMD\   
    .\steamcmd +runscript Validate-$global:server.txt
    Set-Location $global:currentdir
}

Function Get-UpdateServer {
    Write-Host '*** Updating Server *****' -ForegroundColor Magenta -BackgroundColor Black
     Set-Location $global:currentdir\SteamCMD\   
    .\steamcmd +runscript Updates-$global:server.txt
    Set-Location $global:currentdir
}


Function Get-GamedigServer {
    Write-Host '*** Starting gamedig on Server *****' -ForegroundColor Magenta -BackgroundColor Black
    Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64
    .\gamedig --type $global:GAME ${global:EXTIP}:${global:PORT} --pretty
    Set-Location $global:currentdir
}

Function Get-GamedigServerQ {
    Write-Host '*** Starting gamedig on Server *****' -ForegroundColor Magenta -BackgroundColor Black
    Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64
    .\gamedig --type $global:GAME ${global:EXTIP}:${global:QUERYPORT} --pretty
    Set-Location $global:currentdir
}
Function Get-GamedigServerPrivate {
    Write-Host '*** Starting gamedig using private IP on Server *****' -ForegroundColor Magenta -BackgroundColor Black
    Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64
    .\gamedig --type $global:GAME ${global:IP}:${global:PORT} --pretty
    Set-Location $global:currentdir
}

Function Get-GamedigServerQPrivate {
    Write-Host '*** Starting gamedig using private IP on Server *****' -ForegroundColor Magenta -BackgroundColor Black
    Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64
    .\gamedig --type $global:GAME ${global:IP}:${global:QUERYPORT} --pretty
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



Function Get-RestartsServer {
    Clear-host
    Start-Countdown -Seconds 10 -Message "Restarting server"
    Get-logo
    & "$global:currentdir\$global:server\Launch-*.ps1"
    Get-CheckForError
    Set-Location $global:currentdir
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
    Write-Host "*** Checking Folder Names ****" -ForegroundColor Yellow -BackgroundColor Black
    if (Test-Path "$global:currentdir\$global:server\"){
    }else{
    New-ServerFolderq}
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

Function Get-CheckForError {
    if (!$?) {
    Write-Host "----------------------------------------------------------------------------" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "      $global:DIAMOND $global:DIAMOND Command $global:command Failed! $global:DIAMOND $global:DIAMOND" -ForegroundColor Red -BackgroundColor Black
    Write-Host "***        Try install command again          ****  " -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "----------------------------------------------------------------------------" -ForegroundColor Yellow -BackgroundColor Black
    Exit}
}

Function Get-CheckForVars {
    Write-Host "*** Checking for Vars ****" -ForegroundColor Yellow -BackgroundColor Black
    if(( "" -eq $global:APPID) -or ( "" -eq $global:PROCESS)){
    Write-Host "----------------------------------------------------------------------------" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "$global:DIAMOND $global:DIAMOND Missing Vars ! $global:DIAMOND $global:DIAMOND" -ForegroundColor Red -BackgroundColor Black
    Write-Host "Try install command again or check vars in Variables-$global:server.ps1" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "----------------------------------------------------------------------------" -ForegroundColor Yellow -BackgroundColor Black
    exit}
}

Function set-connectMCRcon {
    if(( "" -eq $global:RCONPORT) -or ( "" -eq $global:RANDOMPASSWORD)){
    Write-Host "----------------------------------------------------------------------------" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "$global:DIAMOND $global:DIAMOND Missing Vars ! $global:DIAMOND $global:DIAMOND" -ForegroundColor Red -BackgroundColor Black
    Write-Host "Try install command again or adding Rcon vars to Variables-$global:server.ps1" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "----------------------------------------------------------------------------" -ForegroundColor Yellow -BackgroundColor Black
    }else{
    set-location $global:currentdir\mcrcon\mcrcon-0.7.1-windows-x86-32
    .\mcrcon.exe -t -H $global:EXTIP -P $global:RCONPORT -p $global:RCONPASSWORD
    set-location $global:currentdir}
}

Function set-connectMCRconP {
    if(( "" -eq $global:RCONPORT) -or ( "" -eq $global:RANDOMPASSWORD)){
    Write-Host "----------------------------------------------------------------------------" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "$global:DIAMOND $global:DIAMOND Missing Vars ! $global:DIAMOND $global:DIAMOND" -ForegroundColor Red -BackgroundColor Black
    Write-Host "Try install command again or adding Rcon vars to Variables-$global:server.ps1" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "----------------------------------------------------------------------------" -ForegroundColor Yellow -BackgroundColor Black
    }else{
    set-location $global:currentdir\mcrcon\mcrcon-0.7.1-windows-x86-32
    .\mcrcon.exe -t -H $global:IP -P $global:RCONPORT -p $global:RCONPASSWORD
    set-location $global:currentdir}
}

Function Get-MCRcon {
    $start_time = Get-Date
    $path = "$global:currentdir\mcrcon\"
    $patha = "$global:currentdir\mcrcon\mcrcon-0.7.1-windows-x86-32\mcrcon.exe" 
    If((Test-Path $path) -and (Test-Path $patha)){ 
    Write-Host 'mcrcon already downloaded!' -ForegroundColor Yellow -BackgroundColor Black} 
    Else{  
    $start_time = Get-Date
    Write-Host '*** Downloading MCRCon from github *****' -ForegroundColor Magenta -BackgroundColor Black 
    #(New-Object Net.WebClient).DownloadFile("$global:metamodurl", "$global:currentdir\metamod.zip")
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest -Uri $global:mcrconurl -OutFile $global:currentdir\mcrcon.zip
    if (!$?) {write-host "Downloading  MCRCon Failed" -ForegroundColor Red -BackgroundColor Black 
    New-TryagainMC}
    if ($?) {write-host "Downloading  MCRCon succeeded" -ForegroundColor Yellow -BackgroundColor Black}
    Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host '*** Extracting MCRCon from github *****' -ForegroundColor Magenta -BackgroundColor Black
    Expand-Archive "$global:currentdir\mcrcon.zip" "$global:currentdir\mcrcon\" -Force
    if (!$?) {write-host "Extracting MCRCon Failed" -ForegroundColor Yellow -BackgroundColor Black 
    New-TryagainMC}
    if ($?) {write-host "Extracting MCRCon succeeded" -ForegroundColor Yellow -BackgroundColor Black}}
}
Function New-TryagainMC {
    $title    = 'Try again?'
    $question = 'Download and Extract MCRCon?'
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
    if ($decision -eq 0) {
    Write-Host 'Entered Y'
    Get-MCRcon} 
    else {
    Write-Host 'Entered N'
    exit}
}


Function New-DiscordAlert {
    if ( "" -eq $global:WEBHOOK) {
    Write-Host "$global:DIAMOND $global:DIAMOND Missing WEBHOOK ! $global:DIAMOND $global:DIAMOND"-ForegroundColor Red -BackgroundColor Black
    Write-Host "***  Add Discord  WEBHOOK to $global:currentdir\$global:server\Variables-$global:server.ps1 ****" -ForegroundColor Yellow -BackgroundColor Black    
    }Else {
    Write-Host '*** Sending Discord Alert *****' -ForegroundColor Magenta -BackgroundColor Black
    $webHookUrl = "$global:WEBHOOK"
    [System.Collections.ArrayList]$embedArray = @()
    $title       = "$global:HOSTNAME"
    $description = 'Server not Running, Starting Server!'
    $color       = '16711680'
    $embedObject = [PSCustomObject]@{
    title       = $title       
    description = $description  
    color       = $color}                              
    $embedArray.Add($embedObject) | Out-Null
    $payload = [PSCustomObject]@{
    embeds = $embedArray}                              
    Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json -Depth 4) -Method Post -ContentType 'application/json'}
}

Function Set-SteamInfo {
    $title    = 'Install Steam server with Anonymous login'
    $question = 'Use Anonymous Login?'
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    if ($decision -eq 1) {
    Install-Anonserver
    Write-Host 'Entered Y'
    } else {
    Install-Server
    Write-Host 'Entered N'}
}

Function Set-Console {
    clear-host
    $host.ui.RawUi.WindowTitle = "-------- STEAMER ------------"
    [console]::ForegroundColor="Green"
    [console]::BackgroundColor="Black"
    $host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size(160,5000)
    Get-logo
}

Function Get-Steam {
    $start_time = Get-Date
    $path = "$global:currentdir\steamcmd\"
    $patha = "$global:currentdir\steamcmd\steamcmd.exe" 
    If((Test-Path $path) -and (Test-Path $patha)) { 
    Write-Host 'steamCMD already downloaded!' -ForegroundColor Yellow -BackgroundColor Black} 
    Else{  
    #(New-Object Net.WebClient).DownloadFile("$global:steamurl", "steamcmd.zip")
    Write-Host '*** Downloading SteamCMD *****' -ForegroundColor Magenta -BackgroundColor Black
    #[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;  
    Invoke-WebRequest -Uri $global:steamurl -OutFile $global:steamoutput
    Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host '***  Extracting SteamCMD *****' -ForegroundColor Magenta -BackgroundColor Black 
    Expand-Archive "$global:currentdir\steamcmd.zip" "$global:currentdir\steamcmd\"}
}


Function New-ServerFolder {   
     ##-- Create Folder for Server -- In current folder
    if((!$global:server) -or ($global:server -eq " ")){
    Write-Host "*** You Entered a null or Empty ****" -ForegroundColor Red -BackgroundColor Black
    Select-Steamer
    }elseif (($null -eq $global:APPID ) -or ($global:APPID -eq " ")){
    Write-Host "*** You Entered a space or Empty ****" -ForegroundColor Red -BackgroundColor Black
    Select-Steamer
    }elseif(Test-Path "$global:currentdir\$global:server\" ){
    Write-Host '*** Server Folder Already Created! ****' -ForegroundColor Yellow -BackgroundColor Black
    }else{
    Write-Host '*** Creating Server Folder *****' -ForegroundColor Magenta -BackgroundColor Black 
    New-Item -Path . -Name "$global:server" -ItemType "directory"}
}


Function Get-UpdateSteamer {
    $start_time = Get-Date
    Write-Host '*** Downloading Steamer github files *****' -ForegroundColor Magenta -BackgroundColor Black 
    #(New-Object Net.WebClient).DownloadFile("$global:steamerurl", "$global:currentdir\steamer.zip")
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest -Uri $global:steamerurl -OutFile $global:currentdir\steamer.zip
    Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black 
    Expand-Archive "$global:currentdir\steamer.zip" "$global:currentdir\steamer" -Force
    #Copy-Item -Path "$global:currentdir\steamer\steamer-master\*" -Destination "$global:currentdir\" -Recurse -Force
    Copy-Item -Path "$global:currentdir\steamer\steamer-*\*" -Destination "$global:currentdir\" -Recurse -Force
    Write-Host '*** Steamer github files Updated *****' -ForegroundColor Yellow -BackgroundColor Black
    Write-Host '*** Press Enter to Close this session *****' -ForegroundColor Yellow -BackgroundColor Black
    Pause  
    stop-PROCESS -Id $PID
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


Function Get-NodeJS {
    $path = "$global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64"
    $patha = "$global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64\node.exe"
    $pathb = "node-v$global:nodeversion-win-x64.zip"
    write-host "*** Checking for Nodejs ****" -ForegroundColor Magenta -BackgroundColor Black     
    If((Test-Path $path) -and (Test-Path $pathb) -and (Test-Path $patha)){ 
    Write-Host 'NodeJS already downloaded!' -ForegroundColor Yellow -BackgroundColor Black
    }else {
    write-host "NodeJS not found" -ForegroundColor Yellow -BackgroundColor Black
    add-nodejs}
}

Function add-nodejs {
    $start_time = Get-Date
    Write-Host '*** Downloading  Nodejs *****' -ForegroundColor Magenta -BackgroundColor Black  
    #(New-Object Net.WebClient).DownloadFile("$global:nodejsurl", "$global:currentdir\node-v$global:nodeversion-win-x64.zip")
    #[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest -Uri $global:nodejsurl -OutFile $global:currentdir\node-v$global:nodeversion-win-x64.zip
    if (!$?) {write-host "Downloading  Nodejs Failed" -ForegroundColor Red -BackgroundColor Black 
    New-TryagainN}
    if ($?) {write-host "Downloading  Nodejs succeeded" -ForegroundColor Yellow -BackgroundColor Black}
    Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host '***  Extracting Nodejs *****' -ForegroundColor Magenta -BackgroundColor Black
    Expand-Archive "$global:currentdir\node-v$global:nodeversion-win-x64.zip" "$global:currentdir\node-v$global:nodeversion-win-x64\" -Force
    if (!$?) {write-host "Extracting Nodejs Failed" -ForegroundColor Yellow -BackgroundColor Black 
    New-TryagainN}
    if ($?) {write-host "Extracting Nodejs succeeded" -ForegroundColor Yellow -BackgroundColor Black}
    Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64
    Write-Host '*** Installing gamedig in Nodejs *****' -ForegroundColor Magenta -BackgroundColor Black
    Write-Host '*** Do not stop or cancel! Will need to delete nodejs files and start over! *****' -ForegroundColor Yellow -BackgroundColor Black  
    .\npm install gamedig
    .\npm install gamedig -g
    Set-Location $global:currentdir
}

Function New-TryagainN {
    $title    = 'Try again?'
    $question = 'Download and Extract NodeJS?'
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
    if ($decision -eq 0) {
    Write-Host 'Entered Y'
    add-nodejs} 
    else {
    Write-Host 'Entered N'
    exit}
}


Function Get-Finished {
    Get-ClearVars
    write-Host "*************************************" -ForegroundColor Yellow
    write-Host "***  Server $global:command is done!  $global:CHECKMARK ****" -ForegroundColor Yellow
    write-Host "*************************************" -ForegroundColor Yellow
    write-Host "  ./steamer start $global:server  "-ForegroundColor Black -BackgroundColor White
}

Function New-CreateVariables {
    Write-Host '*** Creating Variables Script ****' -ForegroundColor Magenta -BackgroundColor Black 
    New-Item $global:currentdir\$global:server\Variables-$global:server.ps1 -Force
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "# WEBHOOK HERE - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:WEBHOOK = `"$global:WEBHOOK`""
    if ($global:EXEDIR) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "#  Exe dir - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:EXEDIR = `"$global:EXEDIR`""}
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
    if ($global:WSCOLLECTIONID) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "# CSGO WSCOLLECTIONID   - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:WSCOLLECTIONID = `"$global:WSCOLLECTIONID`""}
    if ($global:WSSTARTMAP) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "# CSGO WSSTARTMAP  - - \/  \/  \/"
    Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "`$global:WSSTARTMAP= `"$global:WSSTARTMAP`""}
    if ($global:WSAPIKEY) {Add-Content -Path $global:currentdir\$global:server\Variables-$global:server.ps1 -Value "# CSGO WSAPIKEY   - - \/  \/  \/"
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
    Write-Host '*** Downloading Meta Mod *****' -ForegroundColor Magenta -BackgroundColor Black 
    #(New-Object Net.WebClient).DownloadFile("$global:metamodurl", "$global:currentdir\metamod.zip")
    #[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest -Uri $global:metamodurl -OutFile $global:currentdir\metamod.zip
    Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host '*** Extracting Meta Mod *****' -ForegroundColor Magenta -BackgroundColor Black
    Expand-Archive "$global:currentdir\metamod.zip" "$global:currentdir\metamod\" -Force
    Write-Host '*** Copying/installing Meta Mod *****' -ForegroundColor Magenta -BackgroundColor Black 
    Copy-Item -Path $global:currentdir\metamod\* -Destination $global:currentdir\$global:server\$global:EXEDIR -Force -Recurse
    $start_time = Get-Date
    Write-Host '*** Downloading SourceMod *****' -ForegroundColor Magenta -BackgroundColor Black
    #(New-Object Net.WebClient).DownloadFile("$global:sourcemodurl", "$global:currentdir\sourcemod.zip")
    #[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest -Uri $global:sourcemodurl -OutFile $global:currentdir\sourcemod.zip
    Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host '*** Extracting SourceMod *****' -ForegroundColor Magenta -BackgroundColor Black 
    Expand-Archive "$global:currentdir\sourcemod.zip" "$global:currentdir\sourcemod\" -Force
    Write-Host '*** Copying/installing SourceMod *****' -ForegroundColor Magenta -BackgroundColor Black
    Copy-Item -Path $global:currentdir\sourcemod\* -Destination $global:currentdir\$global:server\$global:EXEDIR -Force -Recurse
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
    Write-Host '*** Downloading Oxide *****' -ForegroundColor Magenta -BackgroundColor Black
    #(New-Object Net.WebClient).DownloadFile("$global:oxiderustlatestlink", "$global:currentdir\oxide.zip")
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest -Uri $global:oxiderustlatestlink -OutFile $global:currentdir\oxide.zip 
    Write-Host "Download Time: $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host '***Extracting Oxide *****' -ForegroundColor Magenta -BackgroundColor Black
    Expand-Archive "$global:currentdir\oxide.zip" "$global:currentdir\oxide\" -Force
    Write-Host '***Copying Oxide *****' -ForegroundColor Magenta -BackgroundColor Black
    Copy-Item -Path $global:currentdir\oxide\$global:EXEDIR\* -Destination $global:currentdir\$global:server\$global:EXEDIR\ -Force -Recurse
}
