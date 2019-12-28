Function Get-createdvaribles {
    Write-Host "*** Getting Server Varibles *****" -ForegroundColor Yellow -BackgroundColor Black  
    & "$global:currentdir\$global:server\Varibles-$global:server.ps1"
}
Function Get-CheckServer{
    Write-Host '*** Check servering*****' -ForegroundColor Yellow -BackgroundColor Black 
    if($Null -eq (get-process "$global:process" -ea SilentlyContinue)){
    Write-Host "----NOT RUNNING----" -ForegroundColor Red -BackgroundColor Black}else{Write-Host "**** RUNNING ***" -ForegroundColor Green -BackgroundColor Black ;; Get-Process "$global:process"}
}

Function Get-StopServer {
    Write-Host '*** Stopping Server Process *****' -ForegroundColor Yellow -BackgroundColor Black 
    if($Null -eq (get-process "$global:process" -ea SilentlyContinue)){
    Write-Host "Not Running" -ForegroundColor Red -BackgroundColor Black}else{stop-process -Name "$global:process" -Force}
}

Function Get-ValidateServer {
    
    Get-StopServer
    Write-Host '*** Validating Server *****' -ForegroundColor Yellow -BackgroundColor Black
     Set-Location $global:currentdir\SteamCMD\   
    .\steamcmd +runscript Validate-$global:server.txt
}



Function Get-GamedigServer {
    Write-Host '*** Starting gamedig on Server *****' -ForegroundColor Yellow -BackgroundColor Black
    Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64
    .\gamedig --type $global:game ${global:EXTIP}:${global:PORT} --pretty
    Set-Location $global:currentdir
}

Function Get-GamedigServerQ {
    Write-Host '*** Starting gamedig on Server *****' -ForegroundColor Yellow -BackgroundColor Black
    Set-Location $global:currentdir\node-v$global:nodeversion-win-x64\node-v$global:nodeversion-win-x64
    .\gamedig --type $global:game ${global:EXTIP}:${global:QUERYPORT} --pretty
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
    #Start-Sleep -Seconds 15
    Clear-host
    Start-Countdown -Seconds 10 -Message "Restarting server"
    & "$global:currentdir\$global:server\Launch-*.ps1"
    Set-Location $global:currentdir
    #Select-Steamer
}