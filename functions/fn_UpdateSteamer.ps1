
Function Get-UpdateSteamer {
    (New-Object Net.WebClient).DownloadFile("https://github.com/Robomikel/steamer/archive/master.zip", "steamer.zip")
    Expand-Archive ".\steamer.zip" ".\steamer" -Force
    Get-ChildItem -Path ".\steamer\steamer-master" -Recurse | Copy-Item -Destination ".\" -Force
}
