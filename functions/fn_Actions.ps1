Function Get-createdvaribles {
    Write-Host "*** Getting Server Varibles *****" -ForegroundColor Yellow -BackgroundColor Black  
    & "$global:currentdir\$global:server\Varibles-$global:server.ps1"
}
Function Get-CheckServer {
    Write-Host '*** Check  Server Process *****' -ForegroundColor Yellow -BackgroundColor Black 
    if($Null -eq (get-process "$global:process" -ea SilentlyContinue)){
    Write-Host "----NOT RUNNING----" -ForegroundColor Red -BackgroundColor Black}else{Write-Host "**** RUNNING ***" -ForegroundColor Green -BackgroundColor Black ;; Get-Process "$global:process"}
}

Function Get-StopServer {
    Get-ChecktaskDisable 
    Write-Host '*** Stopping Server Process *****' -ForegroundColor Magenta -BackgroundColor Black 
    if($Null -eq (get-process "$global:process" -ea SilentlyContinue)){
    Write-Host "Not Running" -ForegroundColor Red -BackgroundColor Black}else{stop-process -Name "$global:process" -Force}
}

Function Get-ValidateServer {
    
    Get-StopServer
    Write-Host '*** Validating Server *****' -ForegroundColor Magenta -BackgroundColor Black
     Set-Location $global:currentdir\SteamCMD\   
    .\steamcmd +runscript Validate-$global:server.txt
    Get-ChecktaskEnable
    Set-Location $global:currentdir
}

Function Get-UpdateServer {
    
    Get-StopServer >$null 2>&1
    Write-Host '*** Updating Server *****' -ForegroundColor Magenta -BackgroundColor Black
     Set-Location $global:currentdir\SteamCMD\   
    .\steamcmd +runscript Updates-$global:server.txt
    Set-Location $global:currentdir
}


Function Get-GamedigServer {
    Write-Host '*** Starting gamedig on Server *****' -ForegroundColor Magenta -BackgroundColor Black
    Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64
    .\gamedig --type $global:game ${global:EXTIP}:${global:PORT} --pretty
    Set-Location $global:currentdir
}

Function Get-GamedigServerQ {
    Write-Host '*** Starting gamedig on Server *****' -ForegroundColor Magenta -BackgroundColor Black
    Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64
    .\gamedig --type $global:game ${global:EXTIP}:${global:QUERYPORT} --pretty
    Set-Location $global:currentdir
}
Function Get-GamedigServerPrivate {
    Write-Host '*** Starting gamedig using private IP on Server *****' -ForegroundColor Magenta -BackgroundColor Black
    Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64
    .\gamedig --type $global:game ${global:IP}:${global:PORT} --pretty
    Set-Location $global:currentdir
}

Function Get-GamedigServerQPrivate {
    Write-Host '*** Starting gamedig using private IP on Server *****' -ForegroundColor Magenta -BackgroundColor Black
    Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64
    .\gamedig --type $global:game ${global:IP}:${global:QUERYPORT} --pretty
    Set-Location $global:currentdir
}
Function Start-Countdown {
    Param(
    [Int32]$Seconds = 10,
    [string]$Message = "Restarting server in 10 seconds..."
)
ForEach ($Count in (1..$Seconds))
{   Write-Progress -Id 1 -Activity $Message -Status "Waiting for $Seconds seconds, $($Seconds - $Count) left" -PercentComplete (($Count / $Seconds) * 100)
    Start-Sleep -Seconds 1
}
Write-Progress -Id 1 -Activity $Message -Status "Completed" -PercentComplete 100 -Completed
}



Function Get-RestartsServer {
    Get-StopServer
    Clear-host
    Start-Countdown -Seconds 10 -Message "Restarting server"
    & "$global:currentdir\$global:server\Launch-*.ps1"
    Get-ChecktaskEnable
    Set-Location $global:currentdir
}

function Get-TestInterger {
    if( $global:AppID -match '^[0-9]+$') { 
    }else{ 
    Write-Host "Input Valid Numbers only! " -ForegroundColor Red -BackgroundColor Black
    pause
    exit
    }
}

function Get-TestString {
    
    if( $global:server -match "[a-z,A-Z]") { 
    }else{
    Write-Host "Input Alpha Characters only! " -ForegroundColor Red -BackgroundColor Black
    pause
    exit
    }
}

Function Get-FolderNames {
    if (Test-Path "$global:currentdir\$global:server\"){
    }else{
    New-ServerFolderq
    }
}
Function New-ServerFolderq {
    $title    = 'Server Folder Name does not exist!'
    $question = 'Would you like to to create new Server Folder Name?'

    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    if ($decision -eq 0) {
        Write-Host 'Entered Y'
        $global:command = "install"
        Select-Steamer $global:command $global:server
        
    } 
    else {
        Write-Host 'Entered N'
        exit}
}

Function set-connectMCRcon {
    if(("" -eq $global:AppID) -or ("" -eq $global:RCONPORT) -or ("" -eq $global:RANDOMPASSWORD)){
        Write-Host "Missing Vars" -ForegroundColor Red -BackgroundColor Black
        Write-Host "Try install again or adding Rcon vars to Varibles-$global:server.ps1" -ForegroundColor Yellow -BackgroundColor Black
    }else{
    #$global:RCONPASSWORDencrypted = Get-Content $global:currentdir\$global:server\encrypted_password.txt | ConvertTo-SecureString
    set-location $global:currentdir\mcrcon\mcrcon-0.7.1-windows-x86-32
    .\mcrcon.exe -t -H $global:EXTIP -P $global:RCONPORT -p $global:RCONPASSWORD
    #Start-Process powershell { .\mcrcon.exe -t -H $global:EXTIP -P $global:RCONPORT -p $global:RCONPASSWORD }
    set-location $global:currentdir
    }
}

Function Get-MCRcon 
{
    $start_time = Get-Date
    $path = "$global:currentdir\mcrcon\"
    $patha = "$global:currentdir\mcrcon\mcrcon-0.7.1-windows-x86-32\mcrcon.exe" 
    If((Test-Path $path) -and (Test-Path $patha)) 
    { 
    Write-Host 'mcrcon already downloaded!' -ForegroundColor Yellow -BackgroundColor Black
    } 
    Else 
    {  
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
    if ($?) {write-host "Extracting MCRCon succeeded" -ForegroundColor Yellow -BackgroundColor Black}
    }
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