



Function Get-Steam 
    {
        $start_time = Get-Date
        $path = "$global:currentdir\steamcmd\" 
    If(Test-Path $path) 
    { 
        Write-Host 'steamCMD already downloaded!' -ForegroundColor Yellow -BackgroundColor Black
    } 
    Else 
    {  
        #(New-Object Net.WebClient).DownloadFile("$global:steamurl", "steamcmd.zip")
        #####
        Write-Host '*** Downloading and Extracting SteamCMD *****' -ForegroundColor Blue -BackgroundColor Black  
        Invoke-WebRequest -Uri $global:steamurl -OutFile $global:steamoutput
        Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
        Expand-Archive "$global:currentdir\steamcmd.zip" "$global:currentdir\steamcmd\"
    }
}

