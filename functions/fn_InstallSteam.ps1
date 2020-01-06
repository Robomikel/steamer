



Function Get-Steam 
    {
        $start_time = Get-Date
        $path = "$global:currentdir\steamcmd\"
        $patha = "$global:currentdir\steamcmd\steamcmd.exe" 
    If((Test-Path $path) -and (Test-Path $patha)) 
    { 
        Write-Host 'steamCMD already downloaded!' -ForegroundColor Yellow -BackgroundColor Black
    } 
    Else 
    {  
        #(New-Object Net.WebClient).DownloadFile("$global:steamurl", "steamcmd.zip")
        Write-Host '*** Downloading SteamCMD *****' -ForegroundColor Magenta -BackgroundColor Black
        #[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;  
        Invoke-WebRequest -Uri $global:steamurl -OutFile $global:steamoutput
        Write-Host "Download Time:  $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Yellow -BackgroundColor Black
        Write-Host '***  Extracting SteamCMD *****' -ForegroundColor Magenta -BackgroundColor Black 
        Expand-Archive "$global:currentdir\steamcmd.zip" "$global:currentdir\steamcmd\"
    }
}

