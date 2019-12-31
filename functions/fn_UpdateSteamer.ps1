
Function Get-UpdateSteamer {

    Write-Host '*** Downloading Steamer github files *****' -ForegroundColor Magenta -BackgroundColor Black 
    #(New-Object Net.WebClient).DownloadFile("$global:steamerurl", "$global:currentdir\steamer.zip")
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest -Uri $global:steamerurl -OutFile $global:currentdir\steamer.zip 
    Expand-Archive "$global:currentdir\steamer.zip" "$global:currentdir\steamer" -Force
    Copy-Item -Path "$global:currentdir\steamer\steamer-master\*" -Destination "$global:currentdir\" -Recurse -Force
    Write-Host '*** Steamer github files Updated *****' -ForegroundColor Yellow -BackgroundColor Black
    Write-Host '*** Press Enter to Close this session *****' -ForegroundColor Yellow -BackgroundColor Black
    Pause  
    stop-process -Id $PID
}
