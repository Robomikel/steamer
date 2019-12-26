
Function Get-UpdateSteamer {
    Write-Host '*** Downloading Steamer github files *****' -ForegroundColor Yellow -BackgroundColor Black 
    (New-Object Net.WebClient).DownloadFile("https://github.com/Robomikel/steamer/archive/master.zip", "steamer.zip")
    Expand-Archive ".\steamer.zip" ".\steamer" -Force
    Copy-Item -Path ".\steamer\steamer-master\*" -Destination ".\" -Recurse -Force
}
