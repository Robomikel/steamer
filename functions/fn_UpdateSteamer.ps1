#####  NOT FUNCTIONAL YET  ###################
$githuburl="https://github.com/Michaelawilliams28/steamer"
#(New-Object Net.WebClient).DownloadFile("https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/Michaelawilliams28/steamer", "$global:currentdir\steamer.zip")

Function Get-UpdateSteamer {
    (New-Object Net.WebClient).DownloadFile("https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/Michaelawilliams28/steamer", "$global:currentdir\steamer.zip")
    #(New-Object Net.WebClient).DownloadFile("https://raw.githubusercontent.com/Michaelawilliams28/steamer/functions", "$global:currentdir\functions")
}
