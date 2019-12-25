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



Function select-RestartsServer {
    Write-Host '*** Stoping Server *****' -ForegroundColor Yellow -BackgroundColor Black  
    & "$global:currentdir\$global:server\Stops-*.ps1"
    #Start-Sleep -Seconds 15
    Clear-host
    Start-Countdown -Seconds 10 -Message "Restarting server"
    & "$global:currentdir\$global:server\Launch-*.ps1"
    Set-Location $global:currentdir
    Select-Steamer
}