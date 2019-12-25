$url = "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip"
$output = "steamcmd.zip"
$start_time = Get-Date


Function Get-Steam 
    {
        $path = ".\steamcmd\" 
    If(Test-Path $path) 
    { 
        Write-Host 'steamCMD already downloaded!' -ForegroundColor Yellow -BackgroundColor Black
    } 
    Else 
    {  
        #(New-Object Net.WebClient).DownloadFile("https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip", "steamcmd.zip")
        #####
        Write-Host '*** Downloading and Extracting SteamCMD *****' -ForegroundColor Blue -BackgroundColor Black  
        Invoke-WebRequest -Uri $url -OutFile $output
        Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
        Expand-Archive ".\steamcmd.zip" ".\steamcmd\"
    }
}

