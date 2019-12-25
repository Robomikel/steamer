Function Select-GameDigServer {
    & "$global:currentdir\$global:server\GameDig-*.ps1"
    Set-Location $global:currentdir
    Select-Steamer
}