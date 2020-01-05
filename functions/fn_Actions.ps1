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