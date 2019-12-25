#####  NOT FUNCTIONAL YET  ###################
#$githuburl="https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/Robomikel/steamer"
#(New-Object Net.WebClient).DownloadFile("https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/Michaelawilliams28/steamer", "$global:currentdir\steamer.zip")

Function Get-UpdateSteamer {
    (New-Object Net.WebClient).DownloadFile("https://github.com/Robomikel/steamer/archive/master.zip", "steamer.zip")
    Expand-Archive ".\steamer.zip" ".\steamer" -Force
    Get-ChildItem -Path ".\steamer\steamer-master" -Recurse | Copy-Item -Destination ".\" -Force
}
