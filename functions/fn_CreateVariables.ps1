Function New-CreateVariables {
    Write-Host '*** Creating Variables Script ****' -ForegroundColor Magenta -BackgroundColor Black 
    New-Item $global:currentdir\$global:server\Varibles-$global:server.ps1 -Force
    Add-Content -Path $global:currentdir\$global:server\Varibles-$global:server.ps1 -Value "`$global:process=`"$global:process`""
    Add-Content -Path $global:currentdir\$global:server\Varibles-$global:server.ps1 -Value "`$global:HOSTNAME=`"$global:HOSTNAME`""
    Add-Content -Path $global:currentdir\$global:server\Varibles-$global:server.ps1 -Value "`${global:QUERYPORT}=`"${global:QUERYPORT}`""
    Add-Content -Path $global:currentdir\$global:server\Varibles-$global:server.ps1 -Value "`${global:PORT}=`"${global:PORT}`""
    Add-Content -Path $global:currentdir\$global:server\Varibles-$global:server.ps1 -Value "`$global:game=`"$global:game`""
    Add-Content -Path $global:currentdir\$global:server\Varibles-$global:server.ps1 -Value "`$global:saves=`"$global:saves`""
    Add-Content -Path $global:currentdir\$global:server\Varibles-$global:server.ps1 -Value "`${global:IP}=`"${global:IP}`""
}
    