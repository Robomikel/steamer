
Function Get-UpdateSteamer {

    Write-Host '*** Downloading Steamer github files *****' -ForegroundColor Yellow -BackgroundColor Black 
    (New-Object Net.WebClient).DownloadFile("$global:steamerurl", "$global:currentdir\steamer.zip")
    Expand-Archive "$global:currentdir\steamer.zip" "$global:currentdir\steamer" -Force
    Copy-Item -Path "$global:currentdir\steamer\steamer-master\*" -Destination "$global:currentdir\" -Recurse -Force
}
