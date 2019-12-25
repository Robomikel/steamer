Function Select-GameDigFullServer {
    & "$global:currentdir\$global:server\GameDigFull-*.ps1"
    set-location $global:currentdir
    Select-Steamer
}